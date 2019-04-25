require_relative 'search_form_section'

class LandingPage < SitePrism::Page
  set_url '/en'
  set_url_matcher %r{/(en|cy)}

  section :search_form, SearchFormSection, '#new_search_form'

  element :errors, '.l-landing-page__validation'
end
