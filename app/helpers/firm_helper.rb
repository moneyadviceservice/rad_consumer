module FirmHelper
  def firm_has_investing_types?(firm)
    firm.ethical_investing_flag || firm.sharia_investing_flag
  end

  def firm_language_list(language_codes)
    language_codes
      .map(&LanguageList::LanguageInfo.method(:find))
      .map(&:common_name)
      .sort
  end

  def type_of_advice_list_item(firm, type, style_classes)
    return unless firm.includes_advice_type? type
    content_tag :li,
                I18n.t("firms.show.panels.firm.services.types_of_advice.#{type}"),
                class: style_classes
  end

  def closest_adviser_text(distance)
    I18n.t('search.result.miles_away', distance: format('%.1f', distance.to_f))
  end

  def minimum_pot_size_text(firm_result)
    record = InvestmentSize.find(firm_result.investment_sizes.first)

    return I18n.t('investment_size.no_minimum') if record.lowest?
    record.friendly_name
  end

  def minimum_fixed_fee(firm_result)
    number_to_currency firm_result.minimum_fixed_fee, unit: '£', precision: 0
  end

  def ensure_external_link_has_protocol(link)
    if link =~ /^https?/
      link
    else
      "http://#{link}"
    end
  end

  def recently_visited_firms
    session[:recently_visited_firms]
  end
end
