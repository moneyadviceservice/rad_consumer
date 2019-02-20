module Helpers::Algolia
  module Index
    include Pagination

    class UnvailableIndexError < StandardError; end

    INDECES = {
      advisers: 'firm-advisers',
      offices: 'firm-offices'
    }.freeze
    MAX_BROWSABLE_PAGES = 10
    MAX_BROWSABLE_HITS_PER_PAGE = 1000

    def search(query:)
      post(query)
    end

    # Please note: this is a recursive function, use with caution as it
    # can perform up to MAX_BROWSABLE_PAGES requests in a row with up to
    # MAX_BROWSABLE_HITS_PER_PAGE records per page.
    def browse(query: nil, page: 0, pages: 0, hits: [])
      return hits unless keep_browsing?(page, pages)

      response = post(query)
      pages = response['nbPages']
      hits += response['hits']
      page += 1

      offset_query!(query, page)

      browse(query: query, page: page, pages: pages, hits: hits)
    end

    private

    def post(query)
      INDECES.key?(query[:index]) || raise(UnvailableIndexError)

      ::Algolia::Index.new(INDECES[query[:index]]).search(*query[:value])
    end

    def keep_browsing?(page, pages)
      page.zero? || page < pages && page < MAX_BROWSABLE_PAGES
    end

    def offset_query!(query, page)
      query.tap do |q|
        query = q[:value].last
        query.merge!(
          paginate(
            query,
            page: page + 1,
            hits_per_page: MAX_BROWSABLE_HITS_PER_PAGE
          )
        )
      end
    end
  end
end
