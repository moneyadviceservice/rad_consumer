class FirmNameSearchSection < SitePrism::Section
  element :firm_name_option, "input#search_form_advice_method_firm_name_search"
  element :search_field, "input[name='search_form[firm_name]']"
end
