class SearchForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  attr_accessor :postcode, :checkbox

  before_validation :upcase_postcode

  validate :geocode_postcode

  private

  def geocode_postcode
    unless postcode =~ /\A[A-Z\d]{1,4} [A-Z\d]{1,3}\z/ && Geocode.call(postcode)
      errors.add(:postcode, I18n.t('search.errors.geocode_failure'))
    end
  end

  def upcase_postcode
    self.postcode.try(:upcase!)
  end
end
