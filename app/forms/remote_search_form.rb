class RemoteSearchForm
  include ActiveModel::Model

  attr_accessor :advice_methods,
    :pension_transfer,
    :checkbox,
    *SearchForm::TYPES_OF_ADVICE

  def to_query
    RemoteSearchFormSerializer.new(self).to_json
  end
end
