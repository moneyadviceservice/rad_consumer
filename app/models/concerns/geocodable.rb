module Geocodable
  extend ActiveSupport::Concern

  included do
    scope :geocoded, -> { where.not(latitude: nil, longitude: nil) }
  end
end
