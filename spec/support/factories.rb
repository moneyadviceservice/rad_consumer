FactoryBot.define do
  factory :firm, traits: [:with_no_business_split] do
    sequence(:fca_number, 100000) { |n| n }
    sequence(:registered_name) { |n| "Financial Advice #{n} Ltd." }
    website_address { Faker::Internet.url }
    in_person_advice_methods { create_list(:in_person_advice_method, rand(1..3)) }
    free_initial_meeting { [true, false].sample }
    investment_sizes { create_list(:investment_size, rand(5..10)) }

    trait :with_no_business_split do
      retirement_income_products_flag { false }
      pension_transfer_flag { false }
      long_term_care_flag { false }
      equity_release_flag { false }
      inheritance_tax_and_estate_planning_flag { false }
      wills_and_probate_flag { false }
    end

    transient do
      offices_count { 1 }
    end

    after(:create) do |firm, evaluator|
      create_list(:office, evaluator.offices_count, firm: firm)
      firm.reload
    end

    transient do
      advisers_count { 1 }
    end

    after(:create) do |firm, evaluator|
      create_list(:adviser, evaluator.advisers_count, firm: firm)
    end

    factory :firm_without_advisers, traits: [:without_advisers]

    trait :without_advisers do
      advisers_count { 0 }
    end

    trait :with_remote_advice do
      other_advice_methods { create_list(:other_advice_method, rand(1..3)) }
      in_person_advice_methods { [] }
    end
  end

  factory :accreditation do
    sequence(:name) { |n| "Accreditation #{n}" }
    sequence(:order) { |n| n }
  end

  factory :qualification do
    sequence(:name) { |n| "Qualification #{n}" }
    sequence(:order) { |n| n }
  end

  factory :adviser do
    sequence(:reference_number, 10000) { |n| "ABC#{n}" }
    name { Faker::Name.name }
    postcode { Faker::Address.postcode }
    travel_distance { '650' }
    latitude  { Faker::Address.latitude.to_f.round(6) }
    longitude { Faker::Address.longitude.to_f.round(6) }
    firm factory: :firm_without_advisers
    bypass_reference_number_check { false }
  end

  factory :office do
    address_line_one { Faker::Address.street_address }
    address_line_two { Faker::Address.secondary_address }
    address_town { Faker::Address.city }
    address_county { Faker::Address.state }
    address_postcode { 'EC1N 2TD' }
    email_address { Faker::Internet.email }
    telephone_number { '07111 333 222' }
    disabled_access { [true, false].sample }
    latitude  { Faker::Address.latitude.to_f.round(6) }
    longitude { Faker::Address.longitude.to_f.round(6) }
  end

  factory :other_advice_method do
    name { Faker::Lorem.sentence }
    cy_name { Faker::Lorem.sentence }
  end

  factory :in_person_advice_method do
    sequence(:order) { |i| i }
    name { Faker::Lorem.sentence }
  end

  factory :investment_size do
    name { Faker::Lorem.sentence }
    cy_name { Faker::Lorem.sentence }
  end
end
