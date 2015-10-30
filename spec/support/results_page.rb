require_relative 'firm_section'
require_relative 'search_criteria_section'
require_relative 'search_form_section'

class ResultsPage < SitePrism::Page
  set_url '/en/search{?params*}'
  set_url_matcher %r{/(en|cy)/search}

  section :search_form, SearchFormSection, '.t-search-result-form .form'
  section :criteria, SearchCriteriaSection, '.t-search-result-form .t-criteria'
  sections :firms, FirmSection, 'li.t-firm'

  element :summary, '.t-results-summary-text'

  element :errors, '.l-landing-page__validation'
  element :incorrect_criteria_message, '.t-incorrect-criteria'

  def next_page
    first("a[rel='next']").click
  end

  def showing_firms?(first, to:, of:)
    summary.text == "Showing #{first}-#{to} of #{of} advisers"
  end

  def firm_names
    firms.collect(&:name)
  end
end
