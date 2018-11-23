class Firm < ActiveRecord::Base
  def self.languages_used
    pluck('DISTINCT unnest("languages")').sort
  end

  has_and_belongs_to_many :in_person_advice_methods
  has_and_belongs_to_many :other_advice_methods
  has_and_belongs_to_many :investment_sizes

  has_many :advisers, dependent: :destroy
  has_many :offices, -> { order created_at: :asc }, dependent: :destroy
  has_many :qualifications, -> { reorder('').uniq }, through: :advisers
  has_many :accreditations, -> { reorder('').uniq }, through: :advisers

  def postcode_searchable?
    in_person_advice_methods.present?
  end

  def main_office
    offices.first
  end
end
