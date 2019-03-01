class SearchFormSection < SitePrism::Section
  element :in_person_search_option, '#search_form_advice_method_face_to_face'
  element :phone_or_online_search_option, '#search_form_advice_method_phone_or_online'
  element :firm_by_name_search_option, '#search_form_advice_method_firm_name_search'

  element :postcode_field, '#search_form_postcode'
  element :firm_name_field, '#search_form_firm_name'

  element :search, '.search-filter__button'
end
