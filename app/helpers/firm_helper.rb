module FirmHelper
  def type_of_advice_list_item(firm, type)
    return unless firm.includes_advice_type? type
    content_tag :li,
                I18n.t("firms.show.panels.firm.services.types_of_advice.#{type}"),
                class: 'types-of-advice__list-item'
  end

  def closest_adviser_text(firm_result)
    I18n.t('search.result.miles_away', distance: format('%.1f', firm_result.closest_adviser.to_f))
  end

  def minimum_pot_size_text(firm_result)
    record = InvestmentSize.find(firm_result.investment_sizes.first)

    return I18n.t('investment_size.no_minimum') if record.lowest?
    record.friendly_name
  end
end
