RSpec.describe SearchResultsPresenter do
  subject(:presenter) { described_class.new(json, page:) }
  let(:page) { 1 }
  let(:json) do
    {
      "hits": [
        {
          "firm": {
            "id": 1,
            "registered_name": 'Best Advisers Ltd',
            "postcode_searchable": true,
            "telephone_number": '01855 555555',
            "website_address": 'http://www.bestadvisers.co.uk',
            "email_address": 'hello@bestadvisers.co.uk',
            "free_initial_meeting": true,
            "minimum_fixed_fee": 0,
            "retirement_income_products": true,
            "pension_transfer": true,
            "options_when_paying_for_care": false,
            "equity_release": false,
            "inheritance_tax_planning": false,
            "wills_and_probate": false,
            "other_advice_methods": [],
            "investment_sizes": [
              4
            ],
            "in_person_advice_methods": [
              3
            ],
            "adviser_qualification_ids": [
              3,
              5,
              7
            ],
            "adviser_accreditation_ids": [],
            "ethical_investing_flag": false,
            "sharia_investing_flag": false,
            "workplace_financial_advice_flag": false,
            "non_uk_residents_flag": false,
            "languages": [],
            "total_offices": 1,
            "total_advisers": 1
          },
          "objectID": '229383330',
          "_highlightResult": {
            "firm": {
              "registered_name": {
                "value": 'Best Advisers Ltd',
                "matchLevel": 'none',
                "matchedWords": []
              }
            }
          },
          "_rankingInfo": {
            "nbTypos": 0,
            "firstMatchedWord": 0,
            "proximityDistance": 0,
            "userScore": 7106,
            "geoDistance": 88,
            "geoPrecision": 1,
            "nbExactWords": 0,
            "words": 0,
            "filters": 2,
            "matchedGeoLocation": {
              "lat": 51.5183,
              "lng": -0.1073,
              "distance": 88
            }
          }
        },
        {
          "firm": {
            "id": 2,
            "registered_name": 'Another best advisers Ltd',
            "postcode_searchable": true,
            "telephone_number": '020 6966 0100',
            "website_address": 'http://www.anotherbestadvisers.co.uk',
            "email_address": 'info@anotherbestadvisers.co.uk',
            "free_initial_meeting": true,
            "minimum_fixed_fee": 1000,
            "retirement_income_products": true,
            "pension_transfer": true,
            "options_when_paying_for_care": true,
            "equity_release": false,
            "inheritance_tax_planning": true,
            "wills_and_probate": true,
            "other_advice_methods": [
              1
            ],
            "investment_sizes": [
              4
            ],
            "in_person_advice_methods": [
              1,
              2,
              3
            ],
            "adviser_qualification_ids": [
              3,
              5,
              6,
              7
            ],
            "adviser_accreditation_ids": [],
            "ethical_investing_flag": false,
            "sharia_investing_flag": false,
            "workplace_financial_advice_flag": false,
            "non_uk_residents_flag": false,
            "languages": [],
            "total_offices": 1,
            "total_advisers": 6
          },
          "objectID": '229342730',
          "_highlightResult": {
            "firm": {
              "registered_name": {
                "value": 'Another best advisers Ltd',
                "matchLevel": 'none',
                "matchedWords": []
              }
            }
          },
          "_rankingInfo": {
            "nbTypos": 0,
            "firstMatchedWord": 0,
            "proximityDistance": 0,
            "userScore": 282,
            "geoDistance": 118,
            "geoPrecision": 1,
            "nbExactWords": 0,
            "words": 0,
            "filters": 2,
            "matchedGeoLocation": {
              "lat": 51.5171,
              "lng": -0.1078,
              "distance": 118
            }
          }
        }
      ],
      "nbHits": 2,
      "page": 0,
      "nbPages": 1,
      "hitsPerPage": 10,
      "processingTimeMS": 1,
      "exhaustiveNbHits": true,
      "query": '',
      "params": 'aroundLatLng=%5B51.5180697%2C-0.1085203%5D&aroundRadius=1207008&attributesToRetrieve=%5B%22firm%22%5D&distinct=true&facetFilters=%5B%22firm.postcode_searchable%3Atrue'
    }.with_indifferent_access
  end

  it { expect(described_class < Results::Pagination).to eq(true) }

  describe '#current_page' do
    it 'returns the page the object was initialised with' do
      expect(presenter.current_page).to eq(page)
    end
  end

  describe '#total_records' do
    it 'returns the total number of hits' do
      expect(presenter.total_records).to eq(2)
    end
  end

  describe '#firms' do
    let(:json_firms) { json['hits'].map { |hit| hit['firm'] } }
    let(:presented_firms) do
      [
        instance_double(Results::FirmPresenter),
        instance_double(Results::FirmPresenter)
      ]
    end

    context 'when ranking info is present' do
      let(:json_distances) do
        json['hits'].map do |hit|
          hit['_rankingInfo']['matchedGeoLocation']['distance'] * 0.00062137
        end
      end

      it 'builds and returns firms for each hit with ' \
         'the closest adviser distance' do
        aggregate_failures do
          json_firms.each_with_index do |json_firm, i|
            expect(Results::FirmPresenter).to receive(:new)
              .with(json_firm).and_return(presented_firms[i])

            expect(presented_firms[i]).to receive(:closest_adviser_distance=)
              .with(json_distances[i])
          end

          expect(presenter.firms).to eq(presented_firms)
        end
      end
    end

    context 'when ranking info is not present' do
      before do
        json.merge!(
          hits: json[:hits].map do |hit|
            hit.except(:_rankingInfo)
          end
        )
      end

      it 'builds and returns firms for each hit ' \
         'without the closest adviser distance' do
        aggregate_failures do
          json_firms.each_with_index do |json_firm, i|
            expect(Results::FirmPresenter).to receive(:new)
              .with(json_firm).and_return(presented_firms[i])

            expect(presented_firms[i]).to receive(:closest_adviser_distance=)
              .with(nil)
          end

          expect(presenter.firms).to eq(presented_firms)
        end
      end
    end
  end
end
