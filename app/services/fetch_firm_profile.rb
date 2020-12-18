class FetchFirmProfile
  include Helpers::ParamsParser
  include Helpers::Algolia::Index
  include Helpers::Algolia::Queries

  def self.call(*args)
    new(*args).call
  end

  def initialize(params:)
    @raw_params = params
  end

  def call
    advisers = search(query: firm_advisers_query(params))
    offices = search(query: firm_offices_query(params))

    { advisers: advisers, offices: offices }
  end

  private

  attr_reader :raw_params

  def params
    @params ||= parse(params: raw_params, strategy: :fetch_firm_profile)
  end
end
