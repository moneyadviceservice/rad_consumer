class RemoteSearchForm
  include ActiveModel::Model

  TYPES_OF_ADVICE = [
    :options_when_paying_for_care,
    :equity_release,
    :inheritance_tax_planning,
    :wills_and_probate
  ]

  attr_accessor :advice_methods,
    :pension_transfer,
    :checkbox,
    *TYPES_OF_ADVICE

  validate :advice_methods_present

  def to_query
    RemoteSearchFormSerializer.new(self).to_json
  end

  def remote_advice_method_ids
    advice_methods.select(&:present?)
  end

  def advice_methods_present
    if remote_advice_method_ids.empty?
      errors.add(:advice_methods, I18n.t('search.errors.missing_advice_method'))
    end
  end

  def types_of_advice
    TYPES_OF_ADVICE.select { |type| public_send(type) == '1' }
  end
end
