class SearchController < ApplicationController
  def index
    @form = SearchForm.new(params[:search_form])

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
end
