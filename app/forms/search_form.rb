class SearchForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  include SearchFormFilters

  ADVICE_METHOD_FACE_TO_FACE = 'face_to_face'
  ADVICE_METHOD_PHONE_OR_ONLINE = 'phone_or_online'

  attr_accessor :advice_method, :postcode, :coordinates

  before_validation :upcase_postcode

  validate :geocode_postcode

  def face_to_face?
    advice_method == ADVICE_METHOD_FACE_TO_FACE
  end

  def phone_or_online?
    advice_method == ADVICE_METHOD_PHONE_OR_ONLINE
  end

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
