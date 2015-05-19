class SearchCriteriaSection < SitePrism::Section
  element :postcode, '#desktop_search_form_postcode'
  element :pension_pot, '#desktop_search_form_pension_pot'
  element :pension_pot_size, '#desktop_search_form_pension_pot_size'
  element :pension_pot_transfer, '#desktop_search_form_pension_pot_transfer'

  element :options_when_paying_for_care, '#desktop_search_form_options_when_paying_for_care'
  element :equity_release, '#desktop_search_form_equity_release'
  element :inheritance_tax_planning, '#desktop_search_form_inheritance_tax_planning'
  element :wills_and_probate, '#desktop_search_form_wills_and_probate'

  element :by_phone, '.t-advice-method-1'
  element :online, '.t-advice-method-2'

  element :search, '.button--primary'
  element :in_person_advice, '.t-face_to_face_advice'
  element :remote_advice, '.t-phone_or_online'
end
