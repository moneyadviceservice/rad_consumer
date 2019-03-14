RSpec.describe FirmProfilePresenter do
  subject(:presenter) { described_class.new(json) }
  let(:json) do
    {
      "advisers": {
        "hits": [
          {
            "_geoloc": {
              "lat": 51.511952,
              "lng": -0.108341
            },
            "name": 'Mr Adviser 1',
            "postcode": 'EC4Y0HP',
            "travel_distance": 5,
            "qualification_ids": [
              1
            ],
            "accreditation_ids": [],
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
            "objectID": '229370990',
            "_highlightResult": {
              "firm": {
                "registered_name": {
                  "value": 'Best Advisers Ltd',
                  "matchLevel": 'none',
                  "matchedWords": [
                  ]
                }
              }
            },
            "_rankingInfo": {
              "nbTypos": 0,
              "firstMatchedWord": 0,
              "proximityDistance": 0,
              "userScore": 128,
              "geoDistance": 686,
              "geoPrecision": 1,
              "nbExactWords": 0,
              "words": 0,
              "filters": 1,
              "matchedGeoLocation": {
                "lat": 51.5119,
                "lng": -0.1084,
                "distance": 686
              }
            }
          },
          {
            "_geoloc": {
              "lat": 51.511952,
              "lng": -0.108341
            },
            "name": 'Mr Adviser 2',
            "postcode": 'EC4Y0HP',
            "travel_distance": 5,
            "qualification_ids": [
              1
            ],
            "accreditation_ids": [],
            "firm": {
              "id": 2,
              "registered_name": 'Best advisers Ltd',
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
              "languages": [
              ],
              "total_offices": 1,
              "total_advisers": 6
            },
            "objectID": '229370980',
            "_highlightResult": {
              "firm": {
                "registered_name": {
                  "value": 'Best Advisers Ltd',
                  "matchLevel": 'none',
                  "matchedWords": [
                  ]
                }
              }
            },
            "_rankingInfo": {
              "nbTypos": 0,
              "firstMatchedWord": 0,
              "proximityDistance": 0,
              "userScore": 127,
              "geoDistance": 686,
              "geoPrecision": 1,
              "nbExactWords": 0,
              "words": 0,
              "filters": 1,
              "matchedGeoLocation": {
                "lat": 51.5119,
                "lng": -0.1084,
                "distance": 686
              }
            }
          }
        ],
        "nbHits": 2,
        "page": 0,
        "nbPages": 1,
        "hitsPerPage": 1000,
        "processingTimeMS": 1,
        "exhaustiveNbHits": true,
        "query": '',
        "params": 'aroundLatLng=%5B51.5180697%2C-0.1085203%5D&distinct=false&getRankingInfo=true&facetFilters=%5B%22firm.id%3A1%22%5D&page=0&hitsPerPage=1000&query=',
        "automaticRadius": '8564746',
        "serverUsed": 'c11-eu-1.algolia.net',
        "indexUsed": 'firm-advisers',
        "parsedQuery": '',
        "timeoutCounts": false,
        "timeoutHits": false
      },
      "offices": {
        "hits": [
          {
            "_geoloc": {
              "lat": 51.511949,
              "lng": -0.108293
            },
            "firm_id": 1,
            "address_line_one": 'Temple Chambers',
            "address_line_two": '1-2 Temple Avenue',
            "address_town": 'London',
            "address_county": 'Greater London ',
            "address_postcode": 'EC4Y 0HP',
            "email_address": 'hello@bestadvisers.co.uk ',
            "telephone_number": '020 7555 8001',
            "disabled_access": false,
            "website": nil,
            "objectID": '229423840',
            "_highlightResult": {
              "_geoloc": {
                "lat": {
                  "value": '51.511949',
                  "matchLevel": 'none',
                  "matchedWords": [

                  ]
                },
                "lng": {
                  "value": '-0.108293',
                  "matchLevel": 'none',
                  "matchedWords": [

                  ]
                }
              },
              "firm_id": {
                "value": '1',
                "matchLevel": 'none',
                "matchedWords": [

                ]
              },
              "address_line_one": {
                "value": 'Temple Chambers',
                "matchLevel": 'none',
                "matchedWords": [

                ]
              },
              "address_line_two": {
                "value": '1-2 Temple Avenue',
                "matchLevel": 'none',
                "matchedWords": [

                ]
              },
              "address_town": {
                "value": 'London',
                "matchLevel": 'none',
                "matchedWords": [

                ]
              },
              "address_county": {
                "value": 'Greater London ',
                "matchLevel": 'none',
                "matchedWords": [

                ]
              },
              "address_postcode": {
                "value": 'EC4Y 0HP',
                "matchLevel": 'none',
                "matchedWords": [

                ]
              },
              "email_address": {
                "value": 'hello@bestadvisers.co.uk ',
                "matchLevel": 'none',
                "matchedWords": [

                ]
              },
              "telephone_number": {
                "value": '020 7555 8001',
                "matchLevel": 'none',
                "matchedWords": [

                ]
              }
            },
            "_rankingInfo": {
              "nbTypos": 0,
              "firstMatchedWord": 0,
              "proximityDistance": 0,
              "userScore": 2977,
              "geoDistance": 686,
              "geoPrecision": 1,
              "nbExactWords": 0,
              "words": 0,
              "filters": 1,
              "matchedGeoLocation": {
                "lat": 51.5119,
                "lng": -0.1083,
                "distance": 686
              }
            }
          }
        ],
        "nbHits": 1,
        "page": 0,
        "nbPages": 1,
        "hitsPerPage": 1000,
        "processingTimeMS": 1,
        "exhaustiveNbHits": true,
        "query": '',
        "params": 'aroundLatLng=%5B51.5180697%2C-0.1085203%5D&getRankingInfo=true&facetFilters=%5B%22firm_id%3A1%22%5D&page=0&hitsPerPage=1000&query=',
        "automaticRadius": '15740531',
        "serverUsed": 'c11-eu-1.algolia.net',
        "indexUsed": 'firm-offices',
        "parsedQuery": '',
        "timeoutCounts": false,
        "timeoutHits": false
      }
    }.with_indifferent_access
  end

  describe '#firm' do
    let(:json_firm) { json['advisers']['hits'].first['firm'] }
    let(:json_advisers) do
      json['advisers']['hits'].map do |hit|
        hit.except('firm')
      end
    end
    let(:json_offices) { json['offices']['hits'] }
    let(:json_adviser_distances) do
      json_advisers.map do |hit|
        hit['_rankingInfo']['geoDistance'] * 0.00062137
      end
    end

    let(:presented_firm) { instance_double(Results::FirmPresenter) }
    let(:presented_advisers) do
      Array.new(json_advisers.size) do
        instance_double(Results::AdviserPresenter)
      end
    end
    let(:presented_offices) do
      Array.new(json_offices.size) do
        instance_double(Results::OfficePresenter)
      end
    end

    context 'when the firm does have advisers' do
      it 'builds and returns the firm with offices, advisers, and ' \
         'the closest adviser distance' do
        aggregate_failures do
          expect(Results::FirmPresenter).to receive(:new)
            .with(json_firm).and_return(presented_firm)

          json_advisers.each_with_index do |json_adviser, i|
            expect(Results::AdviserPresenter).to receive(:new)
              .with(json_adviser).and_return(presented_advisers[i])

            expect(presented_advisers[i]).to receive(:distance=)
              .with(json_adviser_distances[i])
          end

          json_offices.each_with_index do |json_office, i|
            expect(Results::OfficePresenter).to receive(:new)
              .with(json_office).and_return(presented_offices[i])
          end

          expect(presented_firm).to receive(:advisers=)
            .with(presented_advisers)
          expect(presented_firm).to receive(:offices=)
            .with(presented_offices)
          expect(presented_firm).to receive(:closest_adviser_distance=)
            .with(json_adviser_distances.first)

          expect(presenter.firm).to eq(presented_firm)
        end
      end
    end

    context 'when the firm does not have advisers' do
      before do
        json.merge!(advisers: { hits: [] })
      end

      it 'returns nil' do
        expect(presenter.firm).to be_nil
      end
    end

    context 'when ranking info is not present' do
      before do
        json.merge!(
          advisers: {
            hits: json[:advisers][:hits].map do |hit|
                    hit.except(:_rankingInfo)
                  end
          }
        )
      end

      it 'builds and returns the firm with advisers, offices but without ' \
         'the closest_adviser_distance' do
        aggregate_failures do
          expect(Results::FirmPresenter).to receive(:new)
            .with(json_firm).and_return(presented_firm)

          json_advisers.each_with_index do |json_adviser, i|
            expect(Results::AdviserPresenter).to receive(:new)
              .with(json_adviser).and_return(presented_advisers[i])

            expect(presented_advisers[i]).to receive(:distance=)
              .with(nil)
          end

          json_offices.each_with_index do |json_office, i|
            expect(Results::OfficePresenter).to receive(:new)
              .with(json_office).and_return(presented_offices[i])
          end

          expect(presented_firm).to receive(:advisers=)
            .with(presented_advisers)
          expect(presented_firm).to receive(:offices=)
            .with(presented_offices)
          expect(presented_firm).to receive(:closest_adviser_distance=)
            .with(nil)

          expect(presenter.firm).to eq(presented_firm)
        end
      end
    end
  end
end
