class SearchController < ApplicationController
  def index
    @form = SearchForm.new(params[:search_form])

    if @form.valid?
      @result = FirmRepository.new.search(@form.to_query, page: page)
    else
      if params[:origin] == 'results'
        render 'search/index'
      else
        render 'landing_page/show'
      end
    end
  end

  def search_filter_options_description?
    false
  end

  helper_method :search_filter_options_description?
end
