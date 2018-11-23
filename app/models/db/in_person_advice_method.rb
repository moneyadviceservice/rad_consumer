class InPersonAdviceMethod < ActiveRecord::Base
  include FriendlyNamable

  has_and_belongs_to_many :firms

  default_scope { order(:order) }
end
