class FirmsController < ApplicationController
  def show
    @search_form = SearchForm.new(params[:search_form].merge(firm_id: params[:id]))
    result = FirmRepository.new.search(@search_form.to_query)

    @firm  = result.firms.first
    @offices = Geosort.by_distance(@search_form.coordinates, @firm.offices)

    @latitude, @longitude = @search_form.coordinates
  end
end
