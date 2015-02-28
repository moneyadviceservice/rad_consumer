class LandingPage < SitePrism::Page
  set_url '/en'
  set_url_matcher %r{/(en|cy)}

  section :in_person, InPersonSection, '.t-in-person'
end
