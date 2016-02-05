class SearchController < ApplicationController
  MAX_RANDOM_SEED_VALUE = 1024

  def index
    @form = SearchForm.new(search_form_params)

    if @form.valid?
      @result = FirmRepository.new.search(@form.to_query, page: page)
    else
      render searchable_view
    end
  end

  def search_filter_options_description?
    false
  end

  helper_method :search_filter_options_description?

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

  def search_form_params
    params.require(:search_form).merge(random_search_seed: random_search_seed)
  end
end
