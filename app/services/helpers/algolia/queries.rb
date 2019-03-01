module Helpers::Algolia
  module Queries # rubocop:disable Metrics/ModuleLength
    include Pagination

    BROWSE_QUERY_ATTRIBUTES = {
      geolocation: %w[_geoloc name travel_distance firm.id],
      randomisation: %w[firm.id]
    }.freeze

    FIRST_PAGE = 0
    MAX_HITS_TOTAL = 1_000
    MAX_HITS_PER_PAGE = 10
    MAX_SEARCH_RADIUS = 1_207_008 # 750miles

    def browse_query_for(purpose, source_query:)
      BROWSE_QUERY_ATTRIBUTES.include?(purpose) || raise(NotImplementedError)

      browse_query(
        query: source_query,
        retrieve_attributes: BROWSE_QUERY_ATTRIBUTES[purpose]
      )
    end

    def face_to_face_query(params)
      query_for(
        :advisers,
        [
          '',
          paginate(
            {
              aroundLatLng: params.coordinates,
              aroundRadius: MAX_SEARCH_RADIUS,
              attributesToRetrieve: ['firm'],
              distinct: true,
              facetFilters: ['firm.postcode_searchable:true'],
              getRankingInfo: true
            }, page: params.page
          )
        ]
      )
    end

    def phone_or_online_query(*_params)
      query_for(
        :advisers,
        [
          '',
          paginate(
            attributesToRetrieve: ['firm'],
            distinct: true,
            facetFilters: [
              [
                'firm.other_advice_methods:1',
                'firm.other_advice_methods:2'
              ],
              'firm.in_person_advice_methods:-1',
              'firm.in_person_advice_methods:-2',
              'firm.in_person_advice_methods:-3'
            ]
          )
        ]
      )
    end

    def by_firm_name_query(params)
      query_for(
        :advisers,
        [
          params.name,
          paginate(
            attributesToRetrieve: ['firm'],
            distinct: true
          )
        ]
      )
    end

    def firm_advisers_query(params)
      query_for(
        :advisers,
        [
          '',
          paginate(
            {
              aroundLatLng: params.coordinates,
              distinct: false,
              getRankingInfo: params.coordinates.present?,
              facetFilters: ["firm.id:#{params.id}"]
            }, hits_per_page: MAX_HITS_TOTAL
          )
        ]
      )
    end

    def firm_offices_query(params)
      query_for(
        :offices,
        [
          '',
          paginate(
            {
              aroundLatLng: params.coordinates,
              getRankingInfo: params.coordinates.present?,
              facetFilters: ["firm_id:#{params.id}"]
            }, hits_per_page: MAX_HITS_TOTAL
          )
        ]
      )
    end

    private

    def query_for(index, query)
      { index: index, value: query }
    end

    def browse_query(query:, retrieve_attributes: [])
      new_query = query.deep_dup
      new_query.tap do |q|
        params = q[:value].last
        params[:attributesToRetrieve] = retrieve_attributes
        params[:hitsPerPage] = MAX_HITS_TOTAL
        params[:page] = FIRST_PAGE
      end
    end
  end
end
