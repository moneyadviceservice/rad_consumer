class RemoteSection < SitePrism::Section
  element :by_phone, '.t-advice-method-1'
  element :online, '.t-advice-method-2'
  element :search, '.button--primary'

  element :pension_pot, '.t-retirement-income-products'
  element :pension_pot_size, '.t-pension-pot-size'
  element :pension_pot_transfer, '.t-pension-transfer'

  element :options_when_paying_for_care, '.t-options-when-paying-for-care'
  element :equity_release, '.t-equity-release'
  element :inheritance_tax_planning, '.t-inheritance-tax-planning'
  element :wills_and_probate, '.t-wills-and-probate'

  def invalid_advice_methods?
    has_css?('.field_with_errors .t-advice_methods')
  end
end
