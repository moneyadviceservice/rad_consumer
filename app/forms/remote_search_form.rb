class RemoteSearchForm
  include ActiveModel::Model

  attr_accessor :advice_methods,
    :pension_transfer,
    :checkbox,
    *SearchForm::TYPES_OF_ADVICE

  def to_query
    RemoteSearchFormSerializer.new(self).to_json
  end

  def remote_advice_method_ids
    advice_methods.select(&:present?)
  end
end
