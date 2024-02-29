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
      base_filters = ['firm.postcode_searchable:true']
      query_for(
        :advisers,
        [
          '',
          paginate(
            page: params.page,
            aroundLatLng: params.coordinates,
            aroundRadius: MAX_SEARCH_RADIUS,
            attributesToRetrieve: ['firm'],
            distinct: true,
            facetFilters: build_filters(base_filters, params.filters),
            getRankingInfo: true
          )
        ]
      )
    end

    def phone_or_online_query(params)
      base_filters = [
        [
          'firm.other_advice_methods:1',
          'firm.other_advice_methods:2'
        ],
        'firm.in_person_advice_methods:-1',
        'firm.in_person_advice_methods:-2',
        'firm.in_person_advice_methods:-3'
      ]
      query_for(
        :advisers,
        [
          '',
          paginate(
            attributesToRetrieve: ['firm'],
            distinct: true,
            facetFilters: build_filters(base_filters, params.filters)
          )
        ]
      )
    end

    def by_firm_name_query(params)
      base_filters = []
      query_for(
        :advisers,
        [
          params.name,
          paginate(
            attributesToRetrieve: ['firm'],
            distinct: true,
            facetFilters: build_filters(base_filters, params.filters)
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
            aroundLatLng: params.coordinates,
            distinct: false,
            facetFilters: ["firm.id:#{params.id}"],
            getRankingInfo: params.coordinates.present?,
            hits_per_page: MAX_HITS_TOTAL
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
            aroundLatLng: params.coordinates,
            facetFilters: ["firm_id:#{params.id}"],
            getRankingInfo: params.coordinates.present?,
            hits_per_page: MAX_HITS_TOTAL
          )
        ]
      )
    end

    private

    def query_for(index, query)
      { index: index, value: query }
    end

    def build_filters(base_filters, params_filters)
      params_filters.each do |key, value|
        if key.end_with?('_flag')
          next unless value == '1'

          value = true
        end

        next if value == 'any'

        base_filters.push("firm.#{key}:#{value}")
      end
      base_filters
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
