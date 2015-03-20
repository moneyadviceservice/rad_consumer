class FirmSection < SitePrism::Section
  elements :in_person_advice_methods, '.t-in-person-advice-method'
  elements :other_advice_methods, '.t-other-advice-method'

  def name
    root_element.find('.t-name').text
  end

  def address_line_one
    root_element.find('.street-address').text
  end

  def address_town
    root_element.find('.locality').text
  end

  def address_county
    root_element.find('.region').text
  end

  def address_postcode
    root_element.find('.post-code').text
  end

  def telephone_number
    root_element.find('.phone span.value').text
  end

  def website_address
    root_element.find('.url')
  end

  def email_address
    root_element.find('.email')
  end
end
