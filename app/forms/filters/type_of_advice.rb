module Filters
  module TypeOfAdvice
    TYPES_OF_ADVICE = [
      :pension_transfer,
      :retirement_income_products,
      :options_when_paying_for_care,
      :equity_release,
      :inheritance_tax_planning,
      :wills_and_probate
    ]

    attr_accessor(*TYPES_OF_ADVICE)

    def types_of_advice
      selected_checkbox_attributes TYPES_OF_ADVICE
    end

    def types_of_advice?
      types_of_advice.any?
    end

    def retirement_income_products?
      retirement_income_products == '1'
    end
  end
end
