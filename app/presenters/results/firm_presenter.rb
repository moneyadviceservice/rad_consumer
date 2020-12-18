module Results
  class FirmPresenter
    LESS_THAN_FIFTY_K_ID = 1

    DIRECTLY_MAPPED_FIELDS = %i[
      id
      registered_name
      telephone_number
      website_address
      email_address
      free_initial_meeting
      minimum_fixed_fee
      other_advice_methods
      in_person_advice_methods
      investment_sizes
      adviser_accreditation_ids
      adviser_qualification_ids
      ethical_investing_flag
      sharia_investing_flag
      workplace_financial_advice_flag
      non_uk_residents_flag
      languages
      total_advisers
      total_offices
    ].freeze

    TYPES_OF_ADVICE_FIELDS = %i[
      retirement_income_products_flag
      pension_transfer_flag
      long_term_care_flag
      equity_release_flag
      inheritance_tax_and_estate_planning_flag
      wills_and_probate_flag
    ].freeze

    MAPPED_FIELDS = (DIRECTLY_MAPPED_FIELDS + TYPES_OF_ADVICE_FIELDS).freeze

    OTHER_FIELDS = %i[
      offices
      advisers
      closest_adviser_distance
    ].freeze

    attr_reader(*MAPPED_FIELDS)
    attr_accessor(*OTHER_FIELDS)

    def initialize(firm)
      @firm = firm

      MAPPED_FIELDS.each do |field|
        instance_variable_set("@#{field}", firm[field.to_s])
      end
    end

    alias name registered_name
    alias free_initial_meeting? free_initial_meeting

    def includes_advice_type?(advice_type)
      public_send(advice_type)
    end

    def type_of_advice_method
      return :face_to_face if in_person_advice_methods.present?

      :remote
    end

    def minimum_fixed_fee?
      minimum_fixed_fee.present? && minimum_fixed_fee.nonzero?
    end

    def minimum_pot_size_id
      investment_sizes.first
    end

    def minimum_pot_size?
      minimum_pot_size_id > LESS_THAN_FIFTY_K_ID
    end

    private

    attr_reader :firm
  end
end
