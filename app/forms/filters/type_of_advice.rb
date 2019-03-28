module Filters
  module TypeOfAdvice
    TYPES_OF_ADVICE = %i[
      pension_transfer_flag
      retirement_income_products_flag
      long_term_care_flag
      equity_release_flag
      inheritance_tax_and_estate_planning_flag
      wills_and_probate_flag
    ].freeze

    attr_accessor(*TYPES_OF_ADVICE)

    def types_of_advice
      selected_checkbox_attributes TYPES_OF_ADVICE
    end

    def types_of_advice?
      types_of_advice.any?
    end

    def retirement_income_products_flag?
      retirement_income_products_flag == '1'
    end
  end
end
