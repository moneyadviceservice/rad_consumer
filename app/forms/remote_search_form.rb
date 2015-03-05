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

  def coordinates
    @coordinates ||= Geocode.call(postcode)
  end

  private

  def geocode_postcode
    unless postcode =~ /\A[A-Z\d]{1,4} [A-Z\d]{1,3}\z/ && coordinates
      errors.add(:postcode, I18n.t('search.errors.geocode_failure'))
    end
  end

  def upcase_postcode
    self.postcode.try(:upcase!)
  end
end
