class FirmSection < SitePrism::Section
  elements :qualifications, '.t-qualification'
  elements :accreditations, '.t-accreditation'

  element :free_initial_meeting, '.t-free-initial-meeting'
  element :adviser_distance, '.t-adviser-distance'
  element :qualifications_heading, '.t-qualifications-heading'

  def name
    root_element.find('.t-name').text
  end

  def address_line_one
    root_element.find('.line-one').text
  end

  def address_line_two
    root_element.find('.line-two').text
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

  def minimum_fixed_fee
    root_element.find('.t-minimum-fixed-fee').text
  end

  def minimum_pot_size
    root_element.find('.t-minimum-pot-size').text
  end
end
