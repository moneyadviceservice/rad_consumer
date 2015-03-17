class SearchCriteriaSection < SitePrism::Section
  element :postcode, '#search_form_postcode'
  element :pension_pot, '#search_form_pension_pot'
  element :pension_pot_size, '#search_form_pension_pot_size'
  element :pension_pot_transfer, '#search_form_pension_pot_transfer'

  element :options_when_paying_for_care, '#search_form_options_when_paying_for_care'
  element :equity_release, '#search_form_equity_release'
  element :inheritance_tax_planning, '#search_form_inheritance_tax_planning'
  element :wills_and_probate, '#search_form_wills_and_probate'

  element :by_phone, '.t-advice-method-1'
  element :online, '.t-advice-method-2'

  element :search, '.button--primary'
end
