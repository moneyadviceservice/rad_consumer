RSpec.describe SearchFormSerializer do
  let(:form) { double(coordinates: [51.123456, -0.969782]) }

  subject { JSON.parse(described_class.new(form).to_json) }

  describe 'the `sort` element' do
    describe 'the `_geo_distance` element' do
      let(:element) { subject['sort']['_geo_distance'] }

      it 'exposes the `advisers.location` coordinates as lon/lat' do
        expect(element['advisers.location']).to eq(form.coordinates.reverse)
      end

      it 'exposes the `order` as `ascending`' do
        expect(element['order']).to eq('asc')
      end

      it 'exposes the range `unit` as `miles`' do
        expect(element['unit']).to eq('miles')
      end
    end
  end

  describe 'the `query` element' do
    describe 'the `nested` element' do
      let(:element) { subject['query']['nested'] }

      it 'exposes the `path` as `advisers`' do
        expect(element['path']).to eq('advisers')
      end

      describe 'the `filter` element' do
        describe 'the `geo_distance` element' do
          let(:element) { subject['query']['nested']['filter']['geo_distance'] }

          it 'exposes the `distance` as `650miles`' do
            expect(element['distance']).to eq('650miles')
          end

          it 'exposes the `location` coordinates as lon/lat' do
            expect(element['location']).to eq(form.coordinates.reverse)
          end
        end
      end
    end
  end
end
