class InPersonSection < SitePrism::Section
  element :face_to_face, '.t-face_to_face_advice'
  element :postcode, '.t-postcode'
  element :search, '.button--primary'

  element :retirement_income_products, '.t-retirement_income_products'
  element :pension_transfer, '.t-pension_transfer'
  element :options_when_paying_for_care, '.t-options_when_paying_for_care'
  element :equity_release, '.t-equity_release'
  element :inheritance_tax_planning, '.t-inheritance_tax_planning'
  element :wills_and_probate, '.t-wills_and_probate'

  def invalid_postcode?
    has_css?('.field_with_errors .t-postcode')
  end
end
