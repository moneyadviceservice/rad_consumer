class SearchForm
  include ActiveModel::Model

  attr_accessor :postcode, :checkbox

  validate :geocode_postcode

  def geocode_postcode
    unless postcode =~ /\A[A-Z\d]{1,4} [A-Z\d]{1,3}\z/ && Geocode.call(postcode)
      errors.add(:postcode, I18n.t('search.errors.geocode_failure'))
    end
  end
end
