class InvestmentSize < ActiveRecord::Base
  include Translatable
  include FriendlyNamable

  has_and_belongs_to_many :firms

  default_scope { order(:order) }

  def self.lowest
    first
  end

  def lowest?
    self == self.class.lowest
  end
end
