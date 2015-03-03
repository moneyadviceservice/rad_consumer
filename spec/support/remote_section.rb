class RemoteSection < SitePrism::Section
  element :by_phone_checkbox, '#remote_search_form_by_phone_checkbox'
  element :online_checkbox, '#remote_search_form_online_checkbox'
  element :search, '.button--primary'
end
