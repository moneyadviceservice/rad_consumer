module SearchFormFilters
  ANY_SIZE_VALUE = 'any'

  TYPES_OF_ADVICE = [
    :pension_transfer,
    :options_when_paying_for_care,
    :equity_release,
    :inheritance_tax_planning,
    :wills_and_probate
  ]

  attr_accessor :checkbox,
    :pension_pot,
    :pension_pot_size,
    :pension_pot_transfer,
    *TYPES_OF_ADVICE

  alias :pension_transfer :pension_pot

  def pension_pot?
    pension_pot == '1'
  end

  def pension_pot_sizes
    InvestmentSize.all.map do |investment_size|
      [investment_size.localized_name, investment_size.id]
    end << [I18n.t('search_filter.pension_pot.any_size_option'), ANY_SIZE_VALUE]
  end

  def any_pension_pot_size?
    pension_pot_size && pension_pot_size == ANY_SIZE_VALUE
  end

  def pension_pot_transfer?
    pension_pot_transfer == '1'
  end

  def types_of_advice
    TYPES_OF_ADVICE.select { |type| public_send(type) == '1' }
  end
end
