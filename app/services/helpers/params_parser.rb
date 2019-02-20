module Helpers::ParamsParser
  class InvalidParamsError < StandardError; end

  DEFAULT_PAGE = 1
  SEARCH_TYPES = %w[face_to_face phone_or_online firm_name_search].freeze
  SEARCH_FIRMS_PARAMS = %i[name advice_method coordinates seed page].freeze
  FETCH_FIRM_PROFILE_PARAMS = %i[id coordinates page].freeze

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

  def parse(params:, strategy:)
    params = extract(params)

    case strategy
    when :search_firms
      parsed = SearchFirmsParams.new(
        params[:name],
        params[:advice_method],
        params[:coordinates],
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
      coordinates: extract_coordinates(params),
      page: params[:page] || DEFAULT_PAGE,
      seed: params[:random_search_seed]
    }
  end

  def extract_coordinates(params)
    params[:coordinates]&.map(&:to_f) || Geocode.call(params[:postcode])
  end
end
