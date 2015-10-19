module FirmHelper
  def type_of_advice_list_item(firm, type)
    return unless firm.includes_advice_type? type
    content_tag :li,
                I18n.t("firms.show.panels.firm.services.types_of_advice.#{type}"),
                class: 'types-of-advice__list-item'
  end
end
