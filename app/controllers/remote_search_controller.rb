class RemoteSearchController < ApplicationController
  def show
    @remote_form = RemoteSearchForm.new(params[:remote_search_form])

    if @remote_form.valid?
      @result = FirmRepository.new.search(@remote_form.to_query, page: page)

      render 'search/index'
    else
      @form = SearchForm.new(params[:search_form])

      render 'landing_page/show'
    end
  end
end
