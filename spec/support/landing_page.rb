class LandingPage < SitePrism::Page
  set_url '/'

  section :in_person, InPersonSection, '.t-in-person'
end
