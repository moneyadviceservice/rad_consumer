RSpec.describe SearchFirms do
  describe '.call' do
    subject(:perform_search) { described_class.call(**args) }
    let(:args) do
      {
        params: params,
        page: 1,
        session: {
          random_search_seed: 137
        }
      }
    end
    let(:base_search_params) do
      {
        'postcode' => '',
        'advice_method' => '',
        'firm_name' => '',
        'retirement_income_products' => '0',
        'pension_transfer' => '0',
        'options_when_paying_for_care' => '0',
        'equity_release' => '0',
        'inheritance_tax_planning' => '0',
        'wills_and_probate' => '0',
        'ethical_investing_flag' => '0',
        'sharia_investing_flag' => '0',
        'non_uk_residents_flag' => '0',
        'pension_pot_size' => 'any',
        'qualification_or_accreditation' => '',
        'language' => '',
        'setting_up_workplace_pension_flag' => '0',
        'existing_workplace_pension_flag' => '0',
        'advice_for_employees_flag' => '0',
        'random_search_seed' => 137
      }.with_indifferent_access
    end

    before { VCR.insert_cassette(cassette_name) }
    after { VCR.eject_cassette }

    context 'in person search' do
      let(:cassette_name) { :search_in_person_valid_geocode }
      let(:params) do
        base_search_params.merge(
          postcode: 'EC4A 2AH',
          advice_method: 'face_to_face'
        )
      end
      let(:query) do
        {
          index: :advisers,
          value: [
            '',
            {
              aroundLatLng: [51.5139284, -0.1113308],
              aroundRadius: 1_207_008,
              attributesToRetrieve: ['firm'],
              distinct: true,
              facetFilters: [
                'firm.postcode_searchable:true',
                ['firm.id:1', 'firm.id:2', 'firm.id:3']
              ],
              getRankingInfo: true,
              page: 0,
              hitsPerPage: 10
            }
          ]
        }
      end

      it 'builds and sends a query to Algolia' do
        expect_any_instance_of(described_class)
          .to receive(:search)
          .with(query: query)
          .exactly(:once)
          .and_call_original

        perform_search
      end

      it 'returns results ordered by distance' do
        results = perform_search['hits']
        distances = results.map { |hit| hit['_rankingInfo']['geoDistance'] }

        expect(distances).to eq([490, 4061, 76510])
      end
    end

    context 'phone or online search' do
      let(:cassette_name) { :search_phone_or_online }
      let(:params) do
        base_search_params.merge(advice_method: 'phone_or_online')
      end
      let(:query) do
        {
          index: :advisers,
          value: [
            '',
            {
              attributesToRetrieve: ['firm'],
              distinct: true,
              facetFilters: [
                ['firm.other_advice_methods:1', 'firm.other_advice_methods:2'],
                'firm.in_person_advice_methods:-1',
                'firm.in_person_advice_methods:-2',
                'firm.in_person_advice_methods:-3',
                ['firm.id:5', 'firm.id:6', 'firm.id:4']
              ],
              page: 0,
              hitsPerPage: 10
            }
          ]
        }
      end

      it 'builds and sends a query to Algolia' do
        expect_any_instance_of(described_class)
          .to receive(:search)
          .with(query: query)
          .exactly(:once)
          .and_call_original

        perform_search
      end

      it 'returns random results for the session' do
        results = perform_search['hits']
        firm_ids = results.map { |hit| hit['firm']['id'] }
        session_assigned_firm_ids =
          args[:session][:last_search][:randomised_firm_ids].flatten

        expect(firm_ids).to eq(session_assigned_firm_ids)
      end

      it 'updates the session with the latest search params' do
        expect_any_instance_of(SessionJar)
          .to receive(:update_most_recent_search)
          .with(hash_including(args[:params]), [[5, 6, 4]])
          .exactly(:once)
          .and_call_original

        perform_search
      end
    end

    context 'firm by name search' do
      let(:cassette_name) { :search_firm_by_name }
      let(:params) do
        base_search_params.merge(
          advice_method: 'firm_name_search',
          firm_name: 'london'
        )
      end
      let(:query) do
        {
          index: :advisers,
          value: [
            'london',
            {
              attributesToRetrieve: ['firm'],
              distinct: true,
              facetFilters: [['firm.id:1', 'firm.id:2']],
              page: 0,
              hitsPerPage: 10
            }
          ]
        }
      end

      it 'builds and sends a query to Algolia' do
        expect_any_instance_of(described_class)
          .to receive(:search)
          .with(query: query)
          .exactly(:once)
          .and_call_original

        perform_search
      end

      it 'returns random results for the session matching the name provided' do
        aggregate_failures do
          results = perform_search['hits']
          firm_ids = results.map { |hit| hit['firm']['id'] }
          session_assigned_firm_ids =
            args[:session][:last_search][:randomised_firm_ids].flatten

          firm_names = results.map { |hit| hit['firm']['registered_name'] }

          expect(firm_ids).to eq(session_assigned_firm_ids)
          expect(firm_names).to all(match(/[lL]ondon/))
        end
      end
    end
  end
end
