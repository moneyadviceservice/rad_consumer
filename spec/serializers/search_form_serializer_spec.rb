RSpec.describe SearchFormSerializer do
  let(:params) { {} }
  let(:search_form) { SearchForm.new(params) }

  subject { described_class.new(search_form) }

  describe '#query' do
    context 'no firm_id is included in the search form params' do
      let(:params) { { firm_id: nil } }

      it 'includes a term filter to limit the query to the one firm id' do
        query_hash = subject.query[:filtered][:query]
        expect(query_hash).to eq(bool: { must: [] })
      end
    end

    context 'a firm_id is included in the search form params' do
      let(:params) { { firm_id: 123 } }

      it 'includes a term filter to limit the query to the one firm id' do
        query_hash = subject.query[:filtered][:query]
        expect(query_hash).to eq(bool: { must: [{ term: { _id: 123 } }] })
      end
    end
  end
end
