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

  OTHER_SERVICES = [:ethical_investing_flag, :sharia_investing_flag, :non_uk_residents_flag]
  WORKPLACE_SERVICES = [:setting_up_workplace_pension_flag,
                        :existing_workplace_pension_flag,
                        :advice_for_employees_flag]

  attr_accessor :checkbox,
                :advice_method,
                :postcode,
                :coordinates,
                :pension_pot_size,
                :firm_id,
                :qualification_or_accreditation,
                :language,
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

  def options_for_pension_pot_sizes
    InvestmentSize.all.map do |investment_size|
      [investment_size.localized_name, investment_size.id]
    end << [I18n.t('search_filter.pension_pot.any_size_option'), ANY_SIZE_VALUE]
  end

  def options_for_qualifications_and_accreditations
    (options_for(Qualification) + options_for(Accreditation)).sort
  end

  def options_for_language
    languages = Firm.languages_used.map do |iso_639_3|
      LanguageList::LanguageInfo.find iso_639_3
    end

    languages.sort_by(&:common_name)
  end

  def any_pension_pot_size?
    pension_pot_size && pension_pot_size == ANY_SIZE_VALUE
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

  def selected_qualification_id
    selected_filter_id_for(Qualification)
  end

  def selected_accreditation_id
    selected_filter_id_for(Accreditation)
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

  def prefix_for(model)
    model.model_name.singular[0]
  end

  def filters_for(model)
    key_to_i = -> (k, v) { [k.to_s.to_i, v] }
    I18n.t("search.filter.#{model.model_name.i18n_key}.ordinal").map(&key_to_i).to_h
  end

  def options_for(model)
    filters = filters_for(model)
    model
      .where(order: filters.keys)
      .pluck(:order, :id)
      .map { |order, id| [filters[order], "#{prefix_for(model)}#{id}"] }
  end

  def selected_checkbox_attributes(attribute_names)
    attribute_names.select { |type| public_send(type) == '1' }
  end

  def selected_filter_id_for(model)
    is_desired_type = ->(prefix, item) { !!item[/^#{prefix}/] }
    extract_id = ->(item) { item[1..-1] }
    type_prefix = prefix_for(model)

    [qualification_or_accreditation]
      .compact
      .select(&is_desired_type.curry[type_prefix])
      .map(&extract_id)
      .map(&:to_i)
      .first
  end
end
