module Helpers::ParamsParser
  class InvalidParamsError < StandardError; end

  DEFAULT_PAGE = 1
  SEARCH_TYPES = %w[face_to_face phone_or_online firm_name_search].freeze
  SEARCH_FIRMS_PARAMS = %i[name advice_method coordinates filters seed page].freeze
  FETCH_FIRM_PROFILE_PARAMS = %i[id coordinates page].freeze
  WORKPLACE_FINANCIAL_ADVICE_FLAGS = %i[
    setting_up_workplace_pension_flag
    existing_workplace_pension_flag
    advice_for_employees_flag
  ].freeze

  SearchFirmsParams = Struct.new(*SEARCH_FIRMS_PARAMS) do
    def valid?
      SEARCH_TYPES.include?(advice_method) &&
        valid_coordinates? && seed.present? && page.present? && page > 0
    end

    def valid_coordinates?
      (advice_method == 'face_to_face' && coordinates.present? || true)
    end
  end

  FetchFirmProfileParams = Struct.new(*FETCH_FIRM_PROFILE_PARAMS) do
    def valid?
      id.present? && page.present?
    end
  end

  def parse(strategy:, **params)
    params = params.symbolize_keys
    params = extract(params)

    case strategy
    when :search_firms
      parsed = SearchFirmsParams.new(
        params[:name],
        params[:advice_method],
        params[:coordinates],
        params[:filters],
        params[:seed],
        params[:page]
      )
    when :fetch_firm_profile
      parsed = FetchFirmProfileParams.new(
        params[:id],
        params[:coordinates],
        params[:page]
      )
    else
      raise NotImplementedError
    end

    parsed.valid? && parsed || raise(InvalidParamsError)
  end

  private

  def extract(params)
    {
      id: params[:id],
      name: params[:firm_name],
      advice_method: params[:advice_method],
      coordinates: params[:coordinates]&.map(&:to_f),
      filters: extract_filters(params),
      page: params[:page] || DEFAULT_PAGE,
      seed: params[:random_search_seed]
    }
  end

  def extract_filters(params)
    filters = params.fetch(:filters, {})
    extract_qualification_or_accreditations!(filters)
    extract_workplace_financial_advice!(filters)
  end

  def qualification_or_accreditation_key(value)
    if value.start_with?('a')
      :adviser_accreditation_ids
    elsif value.start_with?('q')
      :adviser_qualification_ids
    end
  end

  def extract_qualification_or_accreditations!(filters)
    qualification_or_accreditation = filters[:qualification_or_accreditation]

    if qualification_or_accreditation
      key = qualification_or_accreditation_key(qualification_or_accreditation)
      filters[key] = qualification_or_accreditation[1..] if key
    end

    filters.except!(:qualification_or_accreditation)
  end

  def extract_workplace_financial_advice!(filters)
    any_workplace_financial_advice_flag?(filters) &&
      filters[:workplace_financial_advice_flag] = '1'

    filters.except!(*WORKPLACE_FINANCIAL_ADVICE_FLAGS)
  end

  def any_workplace_financial_advice_flag?(filters)
    WORKPLACE_FINANCIAL_ADVICE_FLAGS.map do |flag|
      filters[flag] == '1'
    end.compact.any?
  end
end
