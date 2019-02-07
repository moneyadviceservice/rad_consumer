module OfficeHelper
  SCHEME = 'https://'.freeze

  def office_address(office)
    [
      office.address_line_one,
      office.address_line_two,
      office.address_town,
      office.address_county,
      office.address_postcode
    ].join(', ')
  end

  def display_website(office, firm)
    user_uri = office.website.present? ? office.website : firm.website_address
    uri = URI(user_uri.strip)
    "#{uri.host}#{uri.path}"
  end

  def website_url(office, firm)
    "#{SCHEME}#{display_website(office, firm)}"
  end
end
