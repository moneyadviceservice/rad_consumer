module Helpers::Algolia
  module Pagination
    class PageRangeError < StandardError; end

    FIXED_PAGE = 1
    MAX_HITS_PER_PAGE = 10
    MAX_PAGE_LIMIT = 1_000

    def paginate(**hash, page: FIXED_PAGE, hits_per_page: MAX_HITS_PER_PAGE)
      hash.merge(pagination(page, hits_per_page))
    end

    private

    def pagination(page, hits_per_page)
      valid_page?(page) || raise(PageRangeError)

      {
        page: page - 1,
        hitsPerPage: hits_per_page
      }
    end

    def valid_page?(page)
      page > 0 && page <= MAX_PAGE_LIMIT
    end
  end
end
