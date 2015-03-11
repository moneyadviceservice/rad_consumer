class RemoteSearchForm
  include ActiveModel::Model

  attr_accessor :advice_methods,
    :pension_transfer,
    :checkbox,
    *SearchForm::TYPES_OF_ADVICE

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
end
