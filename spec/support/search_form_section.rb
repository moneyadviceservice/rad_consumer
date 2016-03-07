class SearchFormSection < SitePrism::Section
  element :search, '.button--primary'
  element :face_to_face, '.t-face_to_face_advice'
  element :phone_or_online, '.t-phone_or_online'

  element :postcode, '.t-postcode'
  element :phone, '.t-advice-method-1'
  element :online, '.t-advice-method-2'

  element :retirement_income_products, '.t-retirement_income_products'
  element :pension_pot_size, '.t-pension-pot-size'
  element :pension_transfer, '.t-pension_transfer'
  element :options_when_paying_for_care, '.t-options_when_paying_for_care'
  element :equity_release, '.t-equity_release'
  element :inheritance_tax_planning, '.t-inheritance_tax_planning'
  element :wills_and_probate, '.t-wills_and_probate'
  element :qualifications_and_accreditations, '.t-qualifications-and-accreditations'

  element :sharia_investing, '.t-sharia_investing_flag'
  element :ethical_investing, '.t-ethical_investing_flag'

  def qualifications_and_accreditations_option_names
    qualifications_and_accreditations.all('option').map(&:text)
  end
end
