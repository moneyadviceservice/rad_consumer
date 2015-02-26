class ResultsPage < SitePrism::Page
  set_url '/en/search'
  set_url_matcher %r{/(en|cy)/search}

  sections :firms, FirmSection, 'li .t-firm'
end
