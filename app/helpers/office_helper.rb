module OfficeHelper
  def office_address(office)
    [
      office.address_line_one,
      office.address_line_two,
      office.address_town,
      office.address_county,
      office.address_postcode
    ].join(', ')
  end
end
