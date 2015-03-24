class InPersonSection < SitePrism::Section
  element :postcode, '.t-postcode'
  element :search, '.button--primary'

  element :pension_pot, '.t-retirement-income-products'
  element :pension_pot_size, '.t-pension-pot-size'
  element :pension_pot_transfer, '.t-pension-transfer'

  element :options_when_paying_for_care, '.t-options_when_paying_for_care'
  element :equity_release, '.t-equity_release'
  element :inheritance_tax_planning, '.t-inheritance_tax_planning'
  element :wills_and_probate, '.t-wills_and_probate'

  def invalid_postcode?
    has_css?('.field_with_errors .t-postcode')
  end
end
