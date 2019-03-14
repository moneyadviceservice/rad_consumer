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

    def initialize(object)
      @object = object

      DIRECTLY_MAPPED_FIELDS.each do |field|
        instance_variable_set("@#{field}", object[field.to_s])
      end
    end

    def location
      Location.new(*object['_geoloc'].values)
    end

    private

    attr_reader :object
  end
end
