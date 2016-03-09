class FirmsController < ApplicationController
  def show
    @search_form = SearchForm.new(params[:search_form].merge(firm_id: params[:id]))
    result = FirmRepository.new.search(@search_form.to_query)

    @firm  = result.firms.first
    @offices = Geosort.by_distance(@search_form.coordinates, @firm.offices)
    @advisers = Geosort.by_distance(@search_form.coordinates, @firm.advisers)

    @latitude, @longitude = @search_form.coordinates

    store_recently_visited_firm
  end

  private

  def store_recently_visited_firm
    visited_firms = RecentlyVisitedFirms.new(session)
    visited_firms.store(@firm, request.original_url)
  end
end
