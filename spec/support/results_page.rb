require_relative 'firm_section'

class ResultsPage < SitePrism::Page
  set_url '/en/search'
  set_url_matcher %r{/(en|cy)/search}

  sections :firms, FirmSection, 'li.t-firm'

  element :first_record, '.t-first-record'
  element :last_record, '.t-last-record'
  element :total_records, '.t-total-records'

  def showing_firms?(first, to:, of:)
    first_record.text == first && last_record.text == to && total_records.text == of
  end
end
