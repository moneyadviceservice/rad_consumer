require_relative 'firm_section'
require_relative 'search_criteria_section'
require_relative 'search_form_section'

class ResultsPage < SitePrism::Page
  set_url '/en/search{?params*}'
  set_url_matcher %r{/(en|cy)/search}

  section :search_form, SearchFormSection, '.t-search-result-form .form'
  section :criteria, SearchCriteriaSection, '.t-search-result-form .t-criteria'
  sections :firms, FirmSection, 'li.t-firm'

  element :first_record, '.t-first-record'
  element :last_record, '.t-last-record'
  element :total_records, '.t-total-records'

  element :errors, '.l-landing-page__validation'
  element :incorrect_criteria_message, '.t-incorrect-criteria'

  def next_page
    first("a[rel='next']").click
  end

  def showing_firms?(first, to:, of:)
    first?(first) && last?(to) && total?(of)
  end

  def first?(n)
    first_record.text == n.to_s
  end

  def last?(n)
    last_record.text == n.to_s
  end

  def total?(n)
    total_records.text == n.to_s
  end

  def firm_names
    firms.collect(&:name)
  end
end
