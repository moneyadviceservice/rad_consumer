module Filters
  module InvestmentSize
    ANY_SIZE_VALUE = 'any'.freeze

    attr_accessor :investment_sizes

    def options_for_investment_sizes
      I18n.t('investment_size.ordinal').map do |id, name|
        [name, id.to_s]
      end.unshift(
        [I18n.t('search_filter.investment_size.any_size_option'), ANY_SIZE_VALUE]
      )
    end
  end
end
