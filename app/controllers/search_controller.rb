class SearchController < ApplicationController
  def index
    @form = SearchForm.new(params[:search_form])

    if @form.valid?
      @result = FirmRepository.new.search(@form.to_query, page: page)
    else
      render :show
    end
  end

  private

  def page
    params[:page].try(:to_i) || 1
  end
end
