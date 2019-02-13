class SearchController < ApplicationController
  include Helpers::SearchController

  def index
    @form = SearchForm.new(search_form_params)

    if @form.valid?
      @result = FirmRepository.new.search(@form.to_query, page: page)

      return render not_found if @result.total_pages < page

      set_last_visited_page
    else
      render searchable_view
    end
  end

  helper_method :search_filter_options_description?
end
