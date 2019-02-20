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
    telephone_number
    total_advisers
    total_offices
  ].freeze

  TYPES_OF_ADVICE_FIELDS = %i[
    retirement_income_products
    pension_transfer
    options_when_paying_for_care
    equity_release
    inheritance_tax_planning
    wills_and_probate
  ].freeze

  MAPPED_FIELDS = (DIRECTLY_MAPPED_FIELDS + TYPES_OF_ADVICE_FIELDS).freeze

  UNMAPPED_FIELDS = %i[
    offices
    advisers
    closest_adviser_distance
  ].freeze

  attr_reader(*MAPPED_FIELDS)
  attr_accessor(*UNMAPPED_FIELDS)

  def initialize(object)
    @object = object

    MAPPED_FIELDS.each do |field|
      instance_variable_set("@#{field}", object[field.to_s])
    end
  end

  alias name registered_name

  def includes_advice_type?(advice_type)
    public_send(advice_type)
  end

  def types_of_advice
    TYPES_OF_ADVICE_FIELDS.select { |field| public_send(field).nonzero? }
  end

  def minimum_fixed_fee?
    minimum_fixed_fee && minimum_fixed_fee.nonzero?
  end

  def minimum_pot_size_id
    investment_sizes.first
  end

  def minimum_pot_size?
    minimum_pot_size_id > LESS_THAN_FIFTY_K_ID
  end

  alias free_initial_meeting? free_initial_meeting

  private

  attr_reader :object
end
