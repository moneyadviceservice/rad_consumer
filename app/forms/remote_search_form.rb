class RemoteSearchForm
  include ActiveModel::Model
  include SearchFormFilters

  attr_accessor :advice_methods

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
