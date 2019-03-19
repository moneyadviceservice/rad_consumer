RSpec.describe Helpers::Algolia::Queries, type: :helper do
  describe '.browse_query_for' do
    subject(:browse_query) do
      helper.browse_query_for(purpose, source_query: query)
    end
    let(:query) do
      {
        index: :advisers,
        value: [
          'adviser',
          {
            attributesToRetrieve: ['firm'],
            distinct: true,
            page: 0,
            hitsPerPage: 10
          }
        ]
      }
    end

    context 'geolocation' do
      let(:purpose) { :geolocation }
      let(:final_query) do
        {
          index: :advisers,
          value: [
            'adviser',
            {
              attributesToRetrieve: [
                '_geoloc', 'name', 'travel_distance', 'firm.id'
              ],
              distinct: true,
              page: 0,
              hitsPerPage: 1000
            }
          ]
        }
      end

      it 'changes the query to retrieve geoloc-related attributes and ' \
         'maximises hitsPerPage' do
        expect(browse_query).to eq(final_query)
      end
    end

    context 'randomisation' do
      let(:purpose) { :randomisation }
      let(:final_query) do
        {
          index: :advisers,
          value: [
            'adviser',
            {
              attributesToRetrieve: ['firm.id'],
              distinct: true,
              page: 0,
              hitsPerPage: 1000
            }
          ]
        }
      end

      it 'changes the query to retrieve firm.id and maximises hitsPerPage' do
        expect(browse_query).to eq(final_query)
      end
    end

    context 'other' do
      let(:purpose) { :other }

      it 'raises an error' do
        expect { browse_query }.to raise_error(NotImplementedError)
      end
    end
  end

  describe '.face_to_face_query' do
    let(:params) do
      OpenStruct.new(
        advice_method: 'in_person',
        coordinates: [55.378051, -3.435973],
        page: 1
      )
    end
    let(:expected_query) do
      {
        index: :advisers,
        value: [
          '',
          {
            aroundLatLng: [55.378051, -3.435973],
            aroundRadius: 1_207_008,
            attributesToRetrieve: ['firm'],
            distinct: true,
            facetFilters: ['firm.postcode_searchable:true'],
            getRankingInfo: true,
            hitsPerPage: 10,
            page: 0
          }
        ]
      }
    end

    it 'returns a face to face query' do
      expect(helper.face_to_face_query(params)).to eq(expected_query)
    end
  end

  describe '.phone_or_online_query' do
    let(:params) do
      OpenStruct.new(
        advice_method: 'phone_or_online',
        seed: 438,
        page: 1
      )
    end
    let(:expected_query) do
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
              'firm.in_person_advice_methods:-3'
            ],
            hitsPerPage: 10,
            page: 0
          }
        ]
      }
    end

    it 'returns a phone or online query' do
      expect(helper.phone_or_online_query(params)).to eq(expected_query)
    end
  end

  describe '.by_firm_name_query' do
    let(:params) do
      OpenStruct.new(
        name: 'adviser',
        advice_method: 'firm_name_search',
        coordinates: [55.378051, -3.435973],
        seed: 438,
        page: 1
      )
    end
    let(:expected_query) do
      {
        index: :advisers,
        value: [
          'adviser',
          {
            attributesToRetrieve: ['firm'],
            distinct: true,
            hitsPerPage: 10,
            page: 0
          }
        ]
      }
    end

    it 'returns a firm by name query' do
      expect(helper.by_firm_name_query(params)).to eq(expected_query)
    end
  end

  describe '.firm_advisers_query' do
    let(:params) do
      OpenStruct.new(
        id: 1,
        coordinates: [55.378051, -3.435973]
      )
    end
    let(:expected_query) do
      {
        index: :advisers,
        value: [
          '',
          {
            aroundLatLng: [55.378051, -3.435973],
            distinct: false,
            facetFilters: ['firm.id:1'],
            getRankingInfo: true,
            hitsPerPage: 1_000,
            page: 0
          }
        ]
      }
    end

    it 'returns a firm advisers query' do
      expect(helper.firm_advisers_query(params)).to eq(expected_query)
    end
  end

  describe '.firm_offices_query' do
    let(:params) do
      OpenStruct.new(
        id: 1,
        coordinates: [55.378051, -3.435973]
      )
    end
    let(:expected_query) do
      {
        index: :offices,
        value: [
          '',
          {
            aroundLatLng: [55.378051, -3.435973],
            facetFilters: ['firm_id:1'],
            getRankingInfo: true,
            hitsPerPage: 1_000,
            page: 0
          }
        ]
      }
    end

    it 'returns a firm offices query' do
      expect(helper.firm_offices_query(params)).to eq(expected_query)
    end
  end
end
