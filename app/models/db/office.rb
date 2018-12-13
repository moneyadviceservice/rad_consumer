class Office < ActiveRecord::Base
  include Geocodable

  belongs_to :firm
end
