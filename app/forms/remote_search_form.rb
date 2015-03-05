class RemoteSearchForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  attr_accessor :online_checkbox, :by_phone_checkbox,
    :pension_transfer,
    :checkbox,
    *SearchForm::TYPES_OF_ADVICE

  def to_query
    RemoteSearchFormSerializer.new(self).to_json
  end
end
