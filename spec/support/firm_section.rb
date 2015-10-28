class FirmSection < SitePrism::Section
  elements :qualifications, '.t-qualification'
  elements :accreditations, '.t-accreditation'

  element :free_initial_meeting, '.t-free-initial-meeting'
  element :adviser_distance, '.t-adviser-distance'

  def name
    root_element.find('.t-name').text
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

  def distance_to_the_nearest_adviser
    root_element.find('.t-distance_to_the_nearest_adviser').text
  end

  def number_of_advisers_message
    root_element.find('.t-number_of_advisers_message').text
  end

  def minimum_pot_size
    root_element.find('.t-minimum-pot-size').text
  end
end
