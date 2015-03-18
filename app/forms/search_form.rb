class SearchForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  ADVICE_METHOD_FACE_TO_FACE = 'face_to_face'
  ADVICE_METHOD_PHONE_OR_ONLINE = 'phone_or_online'

  ANY_SIZE_VALUE = 'any'

  TYPES_OF_ADVICE = [
    :pension_transfer,
    :retirement_income_products,
    :options_when_paying_for_care,
    :equity_release,
    :inheritance_tax_planning,
    :wills_and_probate
  ]

  attr_accessor :checkbox,
    :advice_method,
    :postcode,
    :coordinates,
    :pension_pot_size,
    :advice_methods,
    *TYPES_OF_ADVICE

  before_validation :upcase_postcode, if: :face_to_face?

  validates :advice_method, presence: true

  validate :geocode_postcode, if: :face_to_face?

  validate :advice_methods_present, if: :phone_or_online?

  def face_to_face?
    advice_method == ADVICE_METHOD_FACE_TO_FACE
  end

  def phone_or_online?
    advice_method == ADVICE_METHOD_PHONE_OR_ONLINE
  end

  def coordinates
    @coordinates ||= Geocode.call(postcode)
  end

  def pension_pot_sizes
    InvestmentSize.all.map do |investment_size|
      [investment_size.localized_name, investment_size.id]
    end << [I18n.t('search_filter.pension_pot.any_size_option'), ANY_SIZE_VALUE]
  end

  def any_pension_pot_size?
    pension_pot_size && pension_pot_size == ANY_SIZE_VALUE
  end

  def retirement_income_products?
    retirement_income_products == '1'
  end

  def types_of_advice
    TYPES_OF_ADVICE.select { |type| public_send(type) == '1' }
  end

  def remote_advice_method_ids
    advice_methods.select(&:present?)
  end

  def advice_methods
    Array(@advice_methods).select(&:present?).map(&:to_i)
  end

  def advice_methods_present
    if remote_advice_method_ids.empty?
      errors.add(:advice_methods, I18n.t('search.errors.missing_advice_method'))
    end
  end

  def to_query
    SearchFormSerializer.new(self).to_json
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
