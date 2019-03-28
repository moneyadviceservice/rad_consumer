class SearchFormSection < SitePrism::Section
  element :in_person_search_option, '#search_form_advice_method_face_to_face'
  element :phone_or_online_search_option, '#search_form_advice_method_phone_or_online'
  element :firm_by_name_search_option, '#search_form_advice_method_firm_name_search'

  element :postcode_field, '#search_form_postcode'
  element :firm_name_field, '#search_form_firm_name'

  element :search, '.button--primary'

  element :pension_pot_other_savings_or_investments, '.t-retirement_income_products_flag'
  element :pension_transfer, '.t-pension_transfer_flag'
  element :options_when_paying_for_care, '.t-long_term_care_flag'
  element :equity_release, '.t-equity_release_flag'
  element :inheritance_tax_planning, '.t-inheritance_tax_and_estate_planning_flag'
  element :wills_and_probate, '.t-wills_and_probate_flag'
  element :sharia_investing, '.t-sharia_investing_flag'
  element :ethical_investing, '.t-ethical_investing_flag'

  element :investment_sizes, '.t-pension-pot-size'
  element :accreditation_or_qualification, '.t-qualifications-and-accreditations'
  element :languages, '.t-languages'

  element :setting_up_a_workplace_pension_scheme, '.t-setting_up_workplace_pension'
  element :financial_advice_for_my_employees, '.t-advice_for_employees_flag'
end
