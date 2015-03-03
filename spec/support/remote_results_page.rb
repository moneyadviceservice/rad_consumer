class RemoteResultsPage < SitePrism::Page
  set_url '/en/remote-help-search'
  set_url_matcher %r{/(en|cy)/remote-help-search}

  sections :firms, FirmSection, 'li.t-firm'
end
