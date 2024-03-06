class SearchFirms
  include Helpers::ParamsParser
  include Helpers::Algolia::Geolocation
  include Helpers::Algolia::Index
  include Helpers::Algolia::Queries
  include Helpers::Algolia::Randomisation

  def initialize(params, **args)
    @raw_params = params.merge(page: args[:page])
    @page = args[:page]
    @session = args[:session]
  end

  def call
    query = build_query

    update_session

    response = search(query:)
    return response unless randomised_firm_ids&.any?

    randomise(response:, ids: randomised_firm_ids, page:)
  end

  private

  attr_reader :raw_params, :session, :page, :randomised_firm_ids

  def params
    @params ||= parse(**raw_params, strategy: :search_firms)
  end

  def build_query
    case params.advice_method
    when 'face_to_face'
      with_geolocation { face_to_face_query(params) }
    when 'phone_or_online'
      with_randomisation { phone_or_online_query(params) }
    when 'firm_name_search'
      with_randomisation { by_firm_name_query(params) }
    else
      raise NotImplementedError
    end
  end

  def with_geolocation
    query = yield

    browse_query = browse_query_for(:geolocation, source_query: query)
    in_range_ids = fetch_in_consumer_range_firm_ids(query: browse_query)

    filter_query_by_firm_ids!(query:, ids: in_range_ids)
  end

  def with_randomisation
    query = yield

    @randomised_firm_ids =
      if session_jar.already_stored_search?(raw_params, page_sensitive: false)
        session_jar.last_search_randomised_firm_ids
      else
        browse_query = browse_query_for(:randomisation, source_query: query)
        calculate_random_firm_ids(
          query: browse_query,
          seed: session[:random_search_seed]
        )
      end

    page_random_ids = randomised_firm_ids.fetch(params.page - 1, [])

    filter_query_by_firm_ids!(query:, ids: page_random_ids)
  end

  def filter_query_by_firm_ids!(query:, ids:)
    firm_ids_filter = ids.sort.reduce([]) { |acc, id| acc << "firm.id:#{id}" }
    return query if firm_ids_filter.blank?

    query.tap do |q|
      query = q[:value].last
      query[:facetFilters] = query.fetch(:facetFilters, []) + [firm_ids_filter]
    end
  end

  def session_jar
    @session_jar ||= SessionJar.new(session)
  end

  def update_session
    session_jar.update_most_recent_search(raw_params, randomised_firm_ids)
  end
end
