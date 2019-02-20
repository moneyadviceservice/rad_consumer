module Helpers
  module SearchController
    MAX_RANDOM_SEED_VALUE = 1024

    def search_filter_options_description?
      false
    end

    private

    def searchable_view
      from_results? ? 'search/index' : 'landing_page/show'
    end

    def from_results?
      params.key?(:origin)
    end

    def random_search_seed
      session[:random_search_seed] ||= rand(MAX_RANDOM_SEED_VALUE)
    end

    def set_last_visited_page
      session[:last_visited_page] = params[:page] || 1
    end

    def search_form_params
      params.require(:search_form).merge(random_search_seed: random_search_seed)
    end
  end
end
