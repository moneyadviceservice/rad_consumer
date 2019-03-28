RSpec.describe Results::FirmPresenter do
  let(:object) do
    {
      _geoloc: { lat: 51.5180967, lng: -0.1102626 },
      id: 1,
      registered_name: 'Best Advisers Ltd',
      telephone_number: nil,
      website_address: nil,
      email_address: nil,
      free_initial_meeting: nil,
      minimum_fixed_fee: nil,
      other_advice_methods: nil,
      in_person_advice_methods: nil,
      investment_sizes: [1, 2, 3],
      adviser_accreditation_ids: nil,
      adviser_qualification_ids: nil,
      ethical_investing_flag: nil,
      sharia_investing_flag: nil,
      workplace_financial_advice_flag: nil,
      non_uk_residents_flag: nil,
      languages: nil,
      total_advisers: nil,
      total_offices: nil,
      retirement_income_products_flag: false,
      pension_transfer_flag: true,
      long_term_care_flag: true,
      equity_release_flag: true,
      inheritance_tax_and_estate_planning_flag: false,
      wills_and_probate_flag: nil
    }.with_indifferent_access
  end
  subject(:presenter) { described_class.new(object) }

  describe 'directly mapped fields' do
    %i[
      id
      registered_name
      telephone_number
      website_address
      email_address
      free_initial_meeting
      minimum_fixed_fee
      other_advice_methods
      in_person_advice_methods
      investment_sizes
      adviser_accreditation_ids
      adviser_qualification_ids
      ethical_investing_flag
      sharia_investing_flag
      workplace_financial_advice_flag
      non_uk_residents_flag
      languages
      total_advisers
      total_offices
      retirement_income_products_flag
      pension_transfer_flag
      long_term_care_flag
      equity_release_flag
      inheritance_tax_and_estate_planning_flag
      wills_and_probate_flag
    ].each do |field|
      it { expect(presenter).to respond_to(field) }
      it { expect(presenter.public_send(field)).to eq(object[field]) }
    end
  end

  describe 'other fields' do
    %i[
      offices
      advisers
      closest_adviser_distance
    ].each do |field|
      it { expect(presenter).to respond_to(field) }
      it { expect(presenter).to respond_to(:"#{field}=") }
      it { expect(presenter.public_send(field)).to eq(object[field]) }
    end
  end

  describe '#name' do
    it 'returns the registered name' do
      expect(presenter.name).to eq(presenter.registered_name)
    end
  end

  describe '#free_initial_meeting?' do
    it 'returns whether the free initial_meeting_flag is true or false' do
      expect(presenter.free_initial_meeting?)
        .to eq(presenter.free_initial_meeting)
    end
  end

  describe '#includes_advice_type?' do
    it 'returns whether an advice type is available or not' do
      expect(presenter.retirement_income_products_flag).to eq(false)
      expect(presenter.pension_transfer_flag).to eq(true)
    end
  end

  describe '#type_of_advice_method' do
    context 'when no in person advice methods are present' do
      it { expect(presenter.type_of_advice_method).to eq(:remote) }
    end

    context 'when in person advice methods are present' do
      before do
        object.merge!(in_person_advice_methods: [1])
      end

      it { expect(presenter.type_of_advice_method).to eq(:face_to_face) }
    end
  end

  describe '#minimum_pot_size_id' do
    it 'returns the minimum pot size id' do
      expect(presenter.minimum_pot_size_id).to eq(1)
    end
  end

  describe '#minimum_pot_size?' do
    context 'when not present' do
      it { expect(presenter.minimum_pot_size?).to eq(false) }
    end

    context 'when present' do
      before do
        object.merge!(investment_sizes: [2, 3])
      end

      it { expect(presenter.minimum_pot_size?).to eq(true) }
    end
  end
end
