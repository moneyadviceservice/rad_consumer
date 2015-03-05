class RemoteSearchController < ApplicationController
  def show
    @remote_form = RemoteSearchForm.new(params[:remote_search_form])

    @result = FirmRepository.new.search(@remote_form.to_query, page: page)

    render 'landing_page/search'
  end

  private

  def page
    params[:page].try(:to_i) || 1
  end
end
