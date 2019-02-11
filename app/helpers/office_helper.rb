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
    (office.website.presence || firm.website_address).to_s
  end

  def website_url(office, firm)
    user_uri = URI(display_website(office, firm).strip)

    case user_uri
    when ->(uri) { uri.to_s.blank? } then nil
    when ->(uri) { uri.scheme.present? } then user_uri.to_s
    else "#{SCHEME}#{user_uri}"
    end
  end
end
