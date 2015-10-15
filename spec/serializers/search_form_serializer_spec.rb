RSpec.describe SearchFormSerializer do
  let(:default_params) { { pension_pot_size: SearchForm::ANY_SIZE_VALUE } }
  let(:search_form) { SearchForm.new(params) }

  subject { described_class.new(search_form) }

  describe '#query' do
    context 'no firm_id is included in the search form params' do
      let(:params) { default_params.merge(firm_id: nil) }

      it 'includes a term filter to limit the query to the one firm id' do
        query_hash = subject.query[:filtered][:query]
        expect(query_hash).to eq(bool: { must: [] })
      end
    end

    context 'a firm_id is included in the search form params' do
      let(:params) { default_params.merge(firm_id: 123) }

      it 'includes a term filter to limit the query to the one firm id' do
        query_hash = subject.query[:filtered][:query]
        expect(query_hash).to eq(bool: { must: [{ term: { _id: 123 } }] })
      end
    end

    context 'the pension pot size is "any size"' do
      let(:params) { default_params }

      it 'does not include a match filter for investment sizes' do
        query_hash = subject.query[:filtered][:query]
        expect(query_hash).to eq(bool: { must: [] })
      end
    end

    context 'the pension pot size is set to a value' do
      let(:params) { default_params.merge(pension_pot_size: '3') }

      it 'includes a filter for the investment size' do
        query_hash = subject.query[:filtered][:query]
        expect(query_hash).to eq(bool: { must: [{ match: { investment_sizes: '3' } }] })
      end
    end
  end
end
