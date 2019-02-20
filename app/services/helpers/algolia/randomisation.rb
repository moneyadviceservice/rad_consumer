module Helpers::Algolia
  module Randomisation
    include Pagination

    def calculate_random_firm_ids(query:, seed:)
      browse(query: query)
        .map { |hit| hit['firm']['id'] }
        .shuffle(random: Random.new(seed))
        .each_slice(MAX_HITS_PER_PAGE)
        .to_a
    end

    def randomise(response:, ids:, page:)
      response.tap do |res|
        page_randomised_firm_ids = ids.fetch(page - 1, [])
        res['nbHits'] = ids.flatten.count
        res['hits'].sort_by! do |hit|
          page_randomised_firm_ids.index(hit['firm']['id'])
        end
      end
    end
  end
end
