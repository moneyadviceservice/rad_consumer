class RemoteSearchController < ApplicationController
  def index
    @form        = SearchForm.new(params[:search_form])
    @remote_form = RemoteSearchForm.new(params[:remote_search_form])

    if @remote_form.valid?
      @result = FirmRepository.new.search(@remote_form.to_query, page: page)

      render 'search/index'
    else
      render 'landing_page/show'
    end
  end
end
