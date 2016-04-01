class SearchForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  include ::Filters::AdviceMethod
  include ::Filters::TypeOfAdvice
  include ::Filters::PensionPot
  include ::Filters::QualificationOrAccreditation
  include ::Filters::Language
  include ::Filters::Service

  attr_accessor :checkbox,
                :firm_id,
                :random_search_seed

  before_validation :upcase_postcode, if: :face_to_face?
  validates :advice_method, presence: true
  validate :geocode_postcode, if: :face_to_face?

  def to_query
    SearchFormSerializer.new(self).to_json
  end

  private

  def selected_checkbox_attributes(attribute_names)
    attribute_names.select { |type| public_send(type) == '1' }
  end
end
