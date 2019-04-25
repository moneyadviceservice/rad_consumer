module Results
  class AdviserPresenter
    DIRECTLY_MAPPED_FIELDS = %i[
      name
      postcode
      range
      qualification_ids
      accreditation_ids
      firm
    ].freeze
    OTHER_FIELDS = %i[distance].freeze

    attr_reader(*DIRECTLY_MAPPED_FIELDS)
    attr_accessor(*OTHER_FIELDS)

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
