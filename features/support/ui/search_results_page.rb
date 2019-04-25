require_relative 'search_form_section'

class FirmSection < SitePrism::Section
  element :view_profile, '.t-view-profile'

  def name
    root_element.find('.t-name').text
  end

  def distance_to_the_nearest_adviser_message
    root_element.find('.t-distance_to_the_nearest_adviser').text
  end

  def number_of_offices_and_advisers_message
    root_element.find('.t-number_of_advisers_message').text
  end
end

class SearchResultsPage < SitePrism::Page
  set_url '/en/search{?params*}'
  set_url_matcher %r{/(en|cy)/search}

  section :search_form, SearchFormSection, '#new_search_form'
  sections :firms, ::FirmSection, 'li.t-firm'

  element :errors, '.l-landing-page__validation'
end
