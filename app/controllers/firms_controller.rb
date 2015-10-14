class FirmsController < ApplicationController
  def show
    @search_form = SearchForm.new(params[:search_form].merge(firm_id: params[:id]))
    result = FirmRepository.new.search(@search_form.to_query)

    @firm  = result.firms.first
    @latitude, @longitude = @search_form.coordinates
  end
end
