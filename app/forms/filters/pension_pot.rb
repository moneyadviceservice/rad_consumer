module Filters
  module PensionPot
    ANY_SIZE_VALUE = 'any'

    attr_accessor :pension_pot_size

    def options_for_pension_pot_sizes
      InvestmentSize.all.map do |investment_size|
        [investment_size.localized_name, investment_size.id]
      end << [I18n.t('search_filter.pension_pot.any_size_option'), ANY_SIZE_VALUE]
    end

    def any_pension_pot_size?
      pension_pot_size && pension_pot_size == ANY_SIZE_VALUE
    end
  end
end
