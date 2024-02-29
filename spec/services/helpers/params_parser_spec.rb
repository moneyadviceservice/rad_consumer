RSpec.describe Helpers::ParamsParser, type: :helper do
  describe '.parse' do
    subject(:parse) { helper.parse(strategy: strategy, **params) }

    before do
      allow(Geocode).to receive(:call).and_return([55.378051, -3.435973])
    end

    context 'search firm params' do
      let(:strategy) { :search_firms }

      context 'with invalid params' do
        let(:params) do
          {
            firm_name: 'test',
            advice_method: 'not-existing',
            coordinates: [],
            filters: {},
            random_search_seed: 123,
            postcode: 'EC1N 2TD',
            page: 1
          }
        end

        it 'raises an error' do
          expect { parse }.to raise_error(described_class::InvalidParamsError)
        end
      end

      context 'with valid params' do
        context 'without coordinates' do
          let(:params) do
            {
              firm_name: '',
              advice_method: 'face_to_face',
              coordinates: [],
              filters: {},
              random_search_seed: 123,
              page: 1
            }
          end

          it 'returns the expected struct with parsed params' do
            expect(parse).to eq(
              described_class::SearchFirmsParams.new(
                '',
                'face_to_face',
                [],
                {},
                123,
                1
              )
            )
          end
        end

        context 'with coordinates' do
          let(:params) do
            {
              firm_name: '',
              advice_method: 'face_to_face',
              coordinates: ['55.378051', '-3.435973'],
              filters: {},
              random_search_seed: 123,
              page: 1
            }
          end

          it 'returns the expected struct with parsed params' do
            expect(parse).to eq(
              described_class::SearchFirmsParams.new(
                '',
                'face_to_face',
                [55.378051, -3.435973],
                {},
                123,
                1
              )
            )
          end
        end

        context 'with qualification filter' do
          let(:params) do
            {
              firm_name: '',
              advice_method: 'phone_or_online',
              coordinates: [],
              filters: {
                qualification_or_accreditation: 'q1'
              },
              random_search_seed: 123,
              page: 1
            }
          end

          it 'returns the expected struct with parsed params' do
            expect(parse).to eq(
              described_class::SearchFirmsParams.new(
                '',
                'phone_or_online',
                [],
                { adviser_qualification_ids: '1' },
                123,
                1
              )
            )
          end
        end

        context 'with accreditation filter' do
          let(:params) do
            {
              firm_name: 'test',
              advice_method: 'phone_or_online',
              coordinates: [],
              filters: {
                qualification_or_accreditation: 'a2'
              },
              random_search_seed: 123,
              page: 1
            }
          end

          it 'returns the expected struct with parsed params' do
            expect(parse).to eq(
              described_class::SearchFirmsParams.new(
                'test',
                'phone_or_online',
                [],
                { adviser_accreditation_ids: '2' },
                123,
                1
              )
            )
          end
        end

        context 'with workplace financial advice filter' do
          let(:params) do
            {
              firm_name: 'test',
              advice_method: 'phone_or_online',
              coordinates: [],
              filters: {
                setting_up_workplace_pension_flag: '1',
                existing_workplace_pension_flag: '0'
              },
              random_search_seed: 123,
              page: 1
            }
          end

          it 'returns the expected struct with parsed params' do
            expect(parse).to eq(
              described_class::SearchFirmsParams.new(
                'test',
                'phone_or_online',
                [],
                { workplace_financial_advice_flag: '1' },
                123,
                1
              )
            )
          end
        end
      end
    end

    context 'fetch firm profile params' do
      let(:strategy) { :fetch_firm_profile }

      context 'with invalid params' do
        let(:params) do
          {
            id: nil,
            coordinates: [],
            page: 1
          }
        end

        it 'raises an error' do
          expect { parse }.to raise_error(described_class::InvalidParamsError)
        end
      end

      context 'with valid params' do
        let(:params) do
          {
            id: 1,
            coordinates: [],
            page: 1
          }
        end

        it 'returns the expected struct with parsed params' do
          expect(parse).to eq(
            described_class::FetchFirmProfileParams.new(
              1,
              [],
              1
            )
          )
        end
      end
    end
  end
end
