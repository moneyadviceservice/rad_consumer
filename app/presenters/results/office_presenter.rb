module Results
  class OfficePresenter
    DIRECTLY_MAPPED_FIELDS = %i[
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

    attr_reader(*DIRECTLY_MAPPED_FIELDS)

    def initialize(office)
      @office = office

      DIRECTLY_MAPPED_FIELDS.each do |field|
        instance_variable_set("@#{field}", office[field.to_s])
      end
    end

    def location
      Location.new(*office['_geoloc'].values)
    end

    private

    attr_reader :office
  end
end
