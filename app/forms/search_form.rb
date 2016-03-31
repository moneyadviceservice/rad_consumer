class SearchForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  include ::Filters::PensionPot
  include ::Filters::QualificationOrAccreditation
  include ::Filters::Language

  ADVICE_METHOD_FACE_TO_FACE = 'face_to_face'
  ADVICE_METHOD_PHONE_OR_ONLINE = 'phone_or_online'

  TYPES_OF_ADVICE = [
    :pension_transfer,
    :retirement_income_products,
    :options_when_paying_for_care,
    :equity_release,
    :inheritance_tax_planning,
    :wills_and_probate
  ]

  OTHER_SERVICES = [:ethical_investing_flag, :sharia_investing_flag, :non_uk_residents_flag]
  WORKPLACE_SERVICES = [:setting_up_workplace_pension_flag,
                        :existing_workplace_pension_flag,
                        :advice_for_employees_flag]

  attr_accessor :checkbox,
                :advice_method,
                :postcode,
                :coordinates,
                :firm_id,
                :random_search_seed,
                *TYPES_OF_ADVICE,
                *OTHER_SERVICES,
                *WORKPLACE_SERVICES

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

  def retirement_income_products?
    retirement_income_products == '1'
  end

  def types_of_advice
    selected_checkbox_attributes TYPES_OF_ADVICE
  end

  def types_of_advice?
    types_of_advice.any?
  end

  def services
    result = selected_checkbox_attributes(OTHER_SERVICES)
    result += [:workplace_financial_advice_flag] if selected_checkbox_attributes(WORKPLACE_SERVICES).present?
    result
  end

  def services?
    services.any?
  end

  def remote_advice_method_ids
    phone_or_online? ? OtherAdviceMethod.all.map(&:id) : []
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

  def selected_checkbox_attributes(attribute_names)
    attribute_names.select { |type| public_send(type) == '1' }
  end
end
