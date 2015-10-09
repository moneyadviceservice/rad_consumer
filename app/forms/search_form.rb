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
                :firm_id,
                *TYPES_OF_ADVICE

  before_validation :upcase_postcode, if: :face_to_face?

  validates :advice_method, presence: true

  validate :geocode_postcode, if: :face_to_face?

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

  def pension_transfer
    retirement_income_products? ? @pension_transfer : '0'
  end

  def types_of_advice
    TYPES_OF_ADVICE.select { |type| public_send(type) == '1' }
  end

  def types_of_advice?
    types_of_advice.any?
  end

  def remote_advice_method_ids
    if phone_or_online?
      OtherAdviceMethod.all.map(&:id)
    else
      []
    end
  end

  def postcode
    @postcode if face_to_face?
  end

  def to_query
    SearchFormSerializer.new(self).to_json
  end

  private

  def geocode_postcode
    return if postcode =~ /\A[A-Z\d]{1,4} ?[A-Z\d]{1,3}\z/ && coordinates
    errors.add(:postcode, I18n.t('search.errors.geocode_failure'))
  end

  def upcase_postcode
    postcode.try(:upcase!)
  end
end
