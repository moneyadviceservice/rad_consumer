class SearchForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  include ::Filters::AdviceMethod
  include ::Filters::TypeOfAdvice
  include ::Filters::PensionPot
  include ::Filters::QualificationOrAccreditation
  include ::Filters::Language

  OTHER_SERVICES = [:ethical_investing_flag, :sharia_investing_flag, :non_uk_residents_flag]
  WORKPLACE_SERVICES = [:setting_up_workplace_pension_flag,
                        :existing_workplace_pension_flag,
                        :advice_for_employees_flag]

  attr_accessor :checkbox,
                :firm_id,
                :random_search_seed,
                *OTHER_SERVICES,
                *WORKPLACE_SERVICES

  before_validation :upcase_postcode, if: :face_to_face?
  validates :advice_method, presence: true
  validate :geocode_postcode, if: :face_to_face?

  def services
    result = selected_checkbox_attributes(OTHER_SERVICES)
    result += [:workplace_financial_advice_flag] if selected_checkbox_attributes(WORKPLACE_SERVICES).present?
    result
  end

  def services?
    services.any?
  end

  def to_query
    SearchFormSerializer.new(self).to_json
  end

  private

  def selected_checkbox_attributes(attribute_names)
    attribute_names.select { |type| public_send(type) == '1' }
  end
end
