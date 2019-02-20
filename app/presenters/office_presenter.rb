class OfficePresenter
  MAPPED_FIELDS = %i[
    id
    address_line_one
    address_line_two
    address_town
    address_county
    address_postcode
    email_address
    telephone_number
    disabled_access
    website
  ].freeze

  attr_reader(*MAPPED_FIELDS)

  def initialize(object)
    @object = object

    MAPPED_FIELDS.each do |field|
      instance_variable_set("@#{field}", object[field.to_s])
    end
  end

  def location
    Location.new(*object['_geoloc'].values)
  end

  private

  attr_reader :object
end
