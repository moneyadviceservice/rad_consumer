class FirmsController < ApplicationController
  def show
    @search_form = SearchForm.new(firm_search_params)
    @firm = FirmResult.new(firm_repository)
    @offices = Geosort.by_distance(@search_form.coordinates, @firm.offices)
    @advisers = sort_advisers(@search_form, @firm.advisers)
    @firm.closest_adviser = closest_adviser
    @latitude, @longitude = @search_form.coordinates
    @firm_profile_presenter = FirmProfilePresenter.new(@firm)
    store_recently_visited_firm
  end

  private

  def firm_repository
    FirmRepository.new.find(Firm.find(params[:id]))
  end

  def firm_search_params
    (params[:search_form] || {}).merge(firm_id: params[:id])
  end

  def closest_adviser
    @advisers.first.try(:distance)
  end

  def rad_consumer_session
    @rad_consumer_session ||= RadConsumerSession.new(session)
  end

  def store_recently_visited_firm
    rad_consumer_session.store(@firm, params)
  end

  def sort_advisers(search_form, advisers)
    if search_form.face_to_face?
      Geosort.by_distance(search_form.coordinates, advisers)
    else
      advisers.sort { |a1, a2| a1.name <=> a2.name }
    end
  end
end
