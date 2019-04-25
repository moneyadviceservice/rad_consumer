class FirmsController < ApplicationController
  def show
    json = FetchFirmProfile.call(params: profile_params)

    @firm = FirmProfilePresenter.new(json).firm
    return render not_found unless @firm

    @advisers = @firm.advisers
    @offices = @firm.offices
    @latitude, @longitude = map_center_coordinates

    store_recently_visited_firm
  end

  private

  def profile_params
    params.permit(:id, :postcode, :locale).merge!(coordinates: coordinates)
  end

  def coordinates
    @coordinates ||= begin
      Geocode.call(params[:postcode]) if params[:postcode].present?
    end
  end

  def map_center_coordinates
    return coordinates if coordinates

    location = @firm.advisers.first.location
    [location.latitude, location.longitude]
  end

  def session_jar
    @session_jar ||= SessionJar.new(session)
  end

  def store_recently_visited_firm
    session_jar.update_recently_visited_firms(@firm, params)
  end
end
