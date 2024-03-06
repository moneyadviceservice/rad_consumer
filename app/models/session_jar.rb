class SessionJar
  include Rails.application.routes.url_helpers

  def initialize(session)
    @session = session
    @session[:recently_visited_firms] ||= []
    @session[:last_search] ||= { params: {}, randomised_firm_ids: [] }
  end

  def recently_visited_firms
    @session[:recently_visited_firms]
  end

  def last_search
    @session[:last_search]
  end

  def last_search_url(locale)
    return if last_search[:params].blank?

    search_path_for(last_search[:params], locale)
  end

  def last_search_randomised_firm_ids
    @session[:last_search][:randomised_firm_ids]
  end

  def already_stored_search?(params, page_sensitive: true)
    return false if last_search&.fetch(:params, nil).blank?

    last_params = last_search[:params].except(page_sensitive || :page)
    last_params == params.except(page_sensitive || :page)
  end

  def update_most_recent_search(params, randomised_firm_ids = [])
    return if already_stored_search?(params)

    @session[:last_search][:params] = params
    @session[:last_search][:randomised_firm_ids] = randomised_firm_ids
  end

  def update_recently_visited_firms(firm_result, params)
    return if firm_already_present?(firm_result)

    recently_visited_firms.pop if recently_visited_firms.length >= 3
    recently_visited_firms.unshift(
      id: firm_result.id,
      name: firm_result.name,
      closest_adviser_distance: firm_result.closest_adviser_distance,
      face_to_face?: firm_result.in_person_advice_methods.present?,
      profile_path: locale_to_profile_path_mappings(params)
    )
  end

  private

  def firm_already_present?(firm_result)
    recently_visited_firms.any? { |firm_hash| firm_result.id == firm_hash[:id] }
  end

  def search_path_for(params, locale = :en)
    search_path(
      page: params[:page],
      search_form: params.except(:page),
      locale:
    )
  end

  def locale_to_profile_path_mappings(params)
    {
      en: firm_path(params[:id], postcode: params[:postcode], locale: :en),
      cy: firm_path(params[:id], postcode: params[:postcode], locale: :cy)
    }
  end
end
