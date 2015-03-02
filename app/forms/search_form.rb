class SearchForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  attr_accessor :postcode,
    :checkbox,
    :coordinates,
    :pension_transfer,
    :options_when_paying_for_care,
    :equity_release,
    :inheritance_tax_planning,
    :wills_and_probate

  before_validation :upcase_postcode

  validate :geocode_postcode

  def to_query
    SearchFormSerializer.new(self).to_json
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
