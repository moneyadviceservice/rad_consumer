class FirmSection < SitePrism::Section
  def name
    root_element.find('.t-name').text
  end
end
