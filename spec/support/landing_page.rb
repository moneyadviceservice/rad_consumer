require_relative 'in_person_section'
require_relative 'remote_section'
require_relative 'firm_name_search_section'
require_relative 'search_form_section'
require_relative 'firm_section'

class LandingPage < SitePrism::Page
  set_url '/en'
  set_url_matcher %r{/(en|cy)}

  section :in_person, InPersonSection, '.t-in-person'
  section :remote, RemoteSection, '.t-remote'
  section :firm_search, FirmNameSearchSection, 'section#search_firm_name'
  section :search_filter, SearchFormSection, '.t-search-filter'

  element :search, '.button--primary'
  element :errors, '.l-landing-page__validation'
  sections :firms, FirmSection, 'li.t-firm'

  def invalid_parameters?
    has_css?('.field_with_errors')
  end
end
