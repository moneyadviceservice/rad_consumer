class SearchController < ApplicationController
  include Helpers::SearchController

  def index
    @form = SearchForm.new(search_form_params)

    if @form.valid?
      json = SearchFirms.new(
        @form.as_json,
        page: page,
        session: session
      ).call
      @results = SearchResultsPresenter.new(json, page: page)
      return render not_found if @results.total_pages < page
    else
      render searchable_view
    end
  end

  helper_method :search_filter_options_description?
end
