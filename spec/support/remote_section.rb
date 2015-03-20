class RemoteSection < SitePrism::Section
  element :by_phone, '.t-advice-method-1'
  element :online, '.t-advice-method-2'
  element :search, '.button--primary'

  element :pension_pot, '#remote_search_form_retirement_income_products'
  element :pension_pot_size, '#remote_search_form_pension_pot_size'
  element :pension_pot_transfer, '#remote_search_form_pension_transfer'

  element :options_when_paying_for_care, '#remote_search_form_options_when_paying_for_care'
  element :equity_release, '#remote_search_form_equity_release'
  element :inheritance_tax_planning, '#remote_search_form_inheritance_tax_planning'
  element :wills_and_probate, '#remote_search_form_wills_and_probate'

  def invalid_advice_methods?
    has_css?('.field_with_errors .t-advice_methods')
  end
end
