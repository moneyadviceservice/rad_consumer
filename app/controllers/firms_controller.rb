class FirmsController < ApplicationController
  def show
    @search_form = SearchForm.new(params[:search_form].merge(firm_id: params[:id]))
    result = FirmRepository.new.search(@search_form.to_query)

    @firm  = result.firms.first
    @offices = Geosort.by_distance(@search_form.coordinates, @firm.offices)
    @advisers = sort_advisers(@search_form, @firm.advisers)

    @latitude, @longitude = @search_form.coordinates

    store_recently_visited_firm
  end

  private

  def rad_consumer_session
    @rad_consumer_session ||= RadConsumerSession.new(session)
  end

  def store_recently_visited_firm
    english_search = search_path(search_form: params[:search_form], locale: 'en')
    welsh_search = search_path(search_form: params[:search_form], locale: 'cy')

    rad_consumer_session.store(@firm, request.original_url, english_search, welsh_search)
  end

  def sort_advisers(search_form, advisers)
    if search_form.face_to_face?
      Geosort.by_distance(search_form.coordinates, advisers)
    else
      advisers.sort { |a1, a2| a1.name <=> a2.name }
    end
  end
end
