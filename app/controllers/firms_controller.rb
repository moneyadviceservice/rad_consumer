class FirmsController < ApplicationController
  def show
    json = FetchFirmProfile.new(**profile_params).call

    @firm = FirmProfilePresenter.new(json).firm
    return render not_found unless @firm

    store_recently_visited_firm
  end

  private

  def profile_params
    params.permit(:id, :postcode, :locale).merge!(coordinates:)
  end

  def coordinates
    @coordinates ||= (Geocode.call(params[:postcode]) if params[:postcode].present?)
  end

  def map_center_coordinates
    return Location.new(*coordinates) if coordinates

    @firm.advisers.first.location
  end
  helper_method :map_center_coordinates

  def session_jar
    @session_jar ||= SessionJar.new(session)
  end

  def store_recently_visited_firm
    session_jar.update_recently_visited_firms(@firm, params)
  end
end
