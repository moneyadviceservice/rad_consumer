class RemoteSection < SitePrism::Section
  element :by_phone, '#remote_search_form_advice_methods_1'
  element :online, '#remote_search_form_advice_methods_2'
  element :search, '.button--primary'
end
