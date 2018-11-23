class Adviser < ActiveRecord::Base
  include Geocodable

  belongs_to :firm

  has_and_belongs_to_many :qualifications
  has_and_belongs_to_many :accreditations
end
