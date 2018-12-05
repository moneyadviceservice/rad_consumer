module Languages
  UK_MINORITY_LANGUAGES = %w(sco gd bfi isg).map { |l| LanguageList::LanguageInfo.find l }
  EXCLUDED_LANGUAGES = %w(en).map { |l| LanguageList::LanguageInfo.find l }
  AVAILABLE_LANGUAGES = (
    (LanguageList::COMMON_LANGUAGES + UK_MINORITY_LANGUAGES) - EXCLUDED_LANGUAGES
  ).sort_by(&:common_name).freeze
  AVAILABLE_LANGUAGES_ISO_639_3_CODES = Set.new(AVAILABLE_LANGUAGES.map(&:iso_639_3)).freeze
end

class Adviser < ActiveRecord::Base
  scope :geocoded, -> { where.not(latitude: nil, longitude: nil) }

  belongs_to :firm

  has_and_belongs_to_many :qualifications
  has_and_belongs_to_many :accreditations
end

class InitialMeetingDuration < ActiveRecord::Base
end

class InitialAdviceFeeStructure < ActiveRecord::Base
end

class OngoingAdviceFeeStructure < ActiveRecord::Base
end

class AllowedPaymentMethod < ActiveRecord::Base
end

class Office < ActiveRecord::Base
  belongs_to :firm

  scope :geocoded, -> { where.not(latitude: nil, longitude: nil) }
end

module Lookup
  class Adviser < ActiveRecord::Base
    def self.table_name
      "lookup_#{super}"
    end
  end

  class Firm < ActiveRecord::Base
    def self.table_name
      "lookup_#{super}"
    end
  end
end

class Principal < ActiveRecord::Base
  self.primary_key = 'token'
end

module FirmIndexer
  class << self
    def index_firm(firm)
      if !firm.destroyed? && firm.publishable?
        store_firm(firm)
      else
        delete_firm(firm)
      end
    end

    alias_method :handle_firm_changed, :index_firm

    def handle_aggregate_changed(aggregate)
      # This method may be invoked as part of a cascade delete, in which case
      # we should do nothing here. The firm change notification will handle
      # the change.
      return if associated_firm_destroyed?(aggregate)
      index_firm(aggregate.firm)
    end

    def associated_firm_destroyed?(aggregate)
      firm = aggregate.firm
      return true if (firm.nil? || firm.destroyed?)
      !Firm.exists?(firm.id)
    end

    private

    def store_firm(firm)
      FirmRepository.new.store(firm)
    end

    def delete_firm(firm)
      FirmRepository.new.delete(firm.id)
    end
  end
end

FactoryGirl.define do
  factory :other_advice_method do
    name { Faker::Lorem.sentence }
    cy_name { Faker::Lorem.sentence }
  end

  sequence(:reference_number, 10000) { |n| "ABC#{n}" }

  factory :adviser do
    transient do
      create_linked_lookup_advisor true
    end

    reference_number
    name { Faker::Name.name }
    postcode { Faker::Address.postcode }
    travel_distance '650'
    latitude  { Faker::Address.latitude.to_f.round(6) }
    longitude { Faker::Address.longitude.to_f.round(6) }
    firm factory: :firm_without_advisers
    bypass_reference_number_check false

    after(:build) do |a, evaluator|
      if a.reference_number? && evaluator.create_linked_lookup_advisor
        Lookup::Adviser.create!(
          reference_number: a.reference_number,
          name: a.name
        )
      end
    end
  end

  sequence(:fca_number, 100000) { |n| n }

  sequence(:registered_name) { |n| "Financial Advice #{n} Ltd." }

  factory :firm, aliases: [:publishable_firm, :onboarded_firm] do
    fca_number
    registered_name
    website_address { Faker::Internet.url }
    in_person_advice_methods { create_list(:in_person_advice_method, rand(1..3)) }
    free_initial_meeting { [true, false].sample }
    initial_meeting_duration { create(:initial_meeting_duration) }
    initial_advice_fee_structures { create_list(:initial_advice_fee_structure, rand(1..3)) }
    ongoing_advice_fee_structures { create_list(:ongoing_advice_fee_structure, rand(1..3)) }
    allowed_payment_methods { create_list(:allowed_payment_method, rand(1..3)) }
    investment_sizes { create_list(:investment_size, rand(5..10)) }
    retirement_income_products_flag true
    pension_transfer_flag true
    long_term_care_flag true
    equity_release_flag true
    inheritance_tax_and_estate_planning_flag true
    wills_and_probate_flag true
    status :independent

    transient do
      offices_count 1
    end

    after(:create) do |firm, evaluator|
      create_list(:office, evaluator.offices_count, firm: firm)
      firm.reload
    end

    transient do
      advisers_count 1
    end

    after(:create) do |firm, evaluator|
      create_list(:adviser, evaluator.advisers_count, firm: firm)
    end

    factory :trading_name, aliases: [:subsidiary] do
      parent factory: :firm
    end

    factory :firm_with_advisers, traits: [:with_advisers]
    factory :firm_without_advisers, traits: [:without_advisers]
    factory :firm_with_offices, traits: [:with_offices]
    factory :firm_without_offices, traits: [:without_offices]
    factory :firm_with_principal, traits: [:with_principal]
    factory :firm_with_no_business_split, traits: [:with_no_business_split]
    factory :firm_with_remote_advice, traits: [:with_remote_advice]
    factory :firm_with_subsidiaries, traits: [:with_trading_names]
    factory :firm_with_trading_names, traits: [:with_trading_names]
    factory :invalid_firm, traits: [:invalid], aliases: [:not_onboarded_firm]

    trait :invalid do
      # Invalidate the marker field without referencing it directly
      __registered false
    end

    trait :with_no_business_split do
      retirement_income_products_flag false
      pension_transfer_flag false
      long_term_care_flag false
      equity_release_flag false
      inheritance_tax_and_estate_planning_flag false
      wills_and_probate_flag false
    end

    trait :with_advisers do
      advisers_count 3
    end

    trait :without_advisers do
      advisers_count 0
    end

    trait :with_principal do
      principal { create(:principal) }
    end

    trait :with_offices do
      offices_count 3
    end

    trait :without_offices do
      offices_count 0
    end

    trait :with_remote_advice do
      other_advice_methods { create_list(:other_advice_method, rand(1..3)) }
      in_person_advice_methods []
    end

    trait :with_trading_names do
      subsidiaries { create_list(:trading_name, 3, fca_number: fca_number) }
    end
  end

  factory :in_person_advice_method do
    sequence(:order) { |i| i }
    name { Faker::Lorem.sentence }
  end

  factory :initial_meeting_duration do
    sequence(:name) { |n| (n * 15).to_s + ' mins' }
  end

  factory :initial_advice_fee_structure do
    name { Faker::Lorem.sentence }
  end

  factory :ongoing_advice_fee_structure do
    name { Faker::Lorem.sentence }
  end

  factory :allowed_payment_method do
    name { Faker::Lorem.sentence }
  end

  factory :investment_size do
    name { Faker::Lorem.sentence }
    cy_name { Faker::Lorem.sentence }
  end

  factory :office do
    address_line_one { Faker::Address.street_address }
    address_line_two { Faker::Address.secondary_address }
    address_town { Faker::Address.city }
    address_county { Faker::Address.state }
    address_postcode 'EC1N 2TD'
    email_address { Faker::Internet.email }
    telephone_number '07111 333 222'
    disabled_access { [true, false].sample }
    latitude  { Faker::Address.latitude.to_f.round(6) }
    longitude { Faker::Address.longitude.to_f.round(6) }
  end

  factory :principal do
    fca_number
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email_address { Faker::Internet.email(first_name) }
    job_title { Faker::Name.title }
    telephone_number '07111 333 222'
    confirmed_disclaimer true

    after(:build) { |p| create(:lookup_firm, fca_number: p.fca_number) }
  end

  factory :lookup_firm, class: Lookup::Firm do
    fca_number
    registered_name { Faker::Company.name }
  end

  factory :accreditation do
    sequence(:name) { |n| "Accreditation #{n}" }
    sequence(:order) { |n| n }
  end

  factory :qualification do
    sequence(:name) { |n| "Qualification #{n}" }
    sequence(:order) { |n| n }
  end
end
