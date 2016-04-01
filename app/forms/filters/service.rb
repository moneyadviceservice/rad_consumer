module Filters
  module Service
    OTHER_SERVICES = [:ethical_investing_flag, :sharia_investing_flag, :non_uk_residents_flag]
    WORKPLACE_SERVICES = [:setting_up_workplace_pension_flag,
                          :existing_workplace_pension_flag,
                          :advice_for_employees_flag]

    attr_accessor(*OTHER_SERVICES)
    attr_accessor(*WORKPLACE_SERVICES)

    def services
      result = selected_checkbox_attributes(OTHER_SERVICES)
      result += [:workplace_financial_advice_flag] if selected_checkbox_attributes(WORKPLACE_SERVICES).present?
      result
    end

    def services?
      services.any?
    end
  end
end
