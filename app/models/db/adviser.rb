class Adviser < ActiveRecord::Base
  scope :geocoded, -> { where.not(latitude: nil, longitude: nil) }

  belongs_to :firm

  has_and_belongs_to_many :qualifications
  has_and_belongs_to_many :accreditations
end
