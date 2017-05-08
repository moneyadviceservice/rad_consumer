class ProfilePage < SitePrism::Page
  set_url_matcher %r{/(en|cy)/firms}

  sections :offices, OfficeSection, '.t-office'
  sections :advisers, AdviserSection, '.t-adviser'

  # the dough component re-writes the DOM so we can't attach a test class
  element :office_tab, '[data-dough-tab-selector-trigger="2"]'
  element :adviser_tab, '[data-dough-tab-selector-trigger="3"]'
  element :telephone, '.t-telephone'
  element :email, '.t-email'
  element :website, '.t-website'
end
