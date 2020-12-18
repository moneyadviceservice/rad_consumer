class SearchForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  include ::Filters::AdviceMethod
  include ::Filters::TypeOfAdvice
  include ::Filters::InvestmentSize
  include ::Filters::QualificationOrAccreditation
  include ::Filters::Language
  include ::Filters::Service

  attr_accessor :checkbox,
                :firm_id,
                :random_search_seed,
                :filters

  before_validation :upcase_postcode, if: :face_to_face?
  validates :advice_method, presence: true
  validate :geocode_postcode, if: :face_to_face?

  def initialize(attributes = {})
    attributes.each do |key, _|
      attributes.delete(key.to_sym) unless SearchForm.attribute_method? key
    end
    attributes.fetch(:filters, {}).each do |key, value|
      public_send("#{key}=", value) if respond_to?("#{key}=")
    end

    super(attributes)
  end

  def as_json
    super(except: %w[validation_context errors]).with_indifferent_access
  end

  private

  def selected_checkbox_attributes(attribute_names)
    attribute_names.select { |type| public_send(type) == '1' }
  end
end
