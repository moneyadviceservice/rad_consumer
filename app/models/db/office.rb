class Office < ActiveRecord::Base
  belongs_to :firm

  scope :geocoded, -> { where.not(latitude: nil, longitude: nil) }
end
