class FirmsController < ApplicationController
  def show
    form   = SearchForm.new(params[:search_form].merge(firm_id: params[:id]))
    result = FirmRepository.new.search(form.to_query)

    @firm  = result.firms.first
    @latitude, @longitude = form.coordinates
  end
end
