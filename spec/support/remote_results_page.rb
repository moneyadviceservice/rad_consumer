require_relative 'firm_section'

class RemoteResultsPage < SitePrism::Page
  set_url '/en/remote-help-search'
  set_url_matcher %r{/(en|cy)/remote-help-search}

  sections :firms, FirmSection, 'li.t-firm'

  def firm_names
    firms.collect(&:name)
  end
end
