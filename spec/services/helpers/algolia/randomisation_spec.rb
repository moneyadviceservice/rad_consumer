RSpec.describe Helpers::Algolia::Randomisation, type: :helper do
  describe '.calculate_random_firm_ids' do
    let(:query) do
      {
        index: :advisers,
        value: [
          '',
          { anything: :really }
        ]
      }
    end
    let(:response) do
      {
        hits: [
          { firm: { id: 1 } },
          { firm: { id: 2 } },
          { firm: { id: 3 } },
          { firm: { id: 4 } },
          { firm: { id: 5 } },
          { firm: { id: 6 } },
          { firm: { id: 7 } },
          { firm: { id: 8 } },
          { firm: { id: 9 } },
          { firm: { id: 10 } },
          { firm: { id: 11 } },
          { firm: { id: 12 } },
          { firm: { id: 13 } }
        ],
        nbPages: 1
      }.with_indifferent_access
    end

    before do
      allow_any_instance_of(::Algolia::Index).to receive(:search)
        .and_return(response)
    end

    it 'returns groups of 10 or less random ids for the given seed' do
      aggregate_failures do
        ids_first_run = helper.calculate_random_firm_ids(query: query, seed: 1)
        ids_second_run = helper.calculate_random_firm_ids(query: query, seed: 1)
        ids_third_run = helper.calculate_random_firm_ids(query: query, seed: 99)

        expect(ids_first_run).to eq(
          [
            [3, 4, 5, 11, 2, 7, 1, 8, 13, 10],
            [9, 12, 6]
          ]
        )
        expect(ids_second_run).to eq(
          [
            [3, 4, 5, 11, 2, 7, 1, 8, 13, 10],
            [9, 12, 6]
          ]
        )
        expect(ids_third_run).to eq(
          [
            [1, 12, 8, 13, 7, 6, 5, 3, 11, 9],
            [10, 4, 2]
          ]
        )

        expect(ids_second_run).to eq(ids_first_run)
        expect(ids_third_run).not_to eq(ids_first_run)
      end
    end
  end

  describe '.randomise' do
    shared_examples :shuffle_results do
      it 'shuffles the hits based on the randomised ids order' do
        expect(randomise[:hits]).to eq(expected_response[:hits])
      end

      it 'sums and returns the total number of hits' do
        expect(randomise[:nbHits]).to eq(expected_response[:nbHits])
      end
    end

    subject(:randomise) do
      helper.randomise(response: response, ids: randomised_ids, page: page)
    end
    let(:response_page1) do
      {
        hits: [
          { firm: { id: 1 } },
          { firm: { id: 2 } },
          { firm: { id: 3 } },
          { firm: { id: 4 } },
          { firm: { id: 5 } },
          { firm: { id: 6 } },
          { firm: { id: 7 } },
          { firm: { id: 8 } },
          { firm: { id: 9 } },
          { firm: { id: 10 } }
        ]
      }.with_indifferent_access
    end
    let(:response_page2) do
      {
        hits: [
          { firm: { id: 11 } },
          { firm: { id: 12 } },
          { firm: { id: 13 } },
          { firm: { id: 14 } },
          { firm: { id: 15 } },
          { firm: { id: 16 } },
          { firm: { id: 17 } },
          { firm: { id: 18 } },
          { firm: { id: 19 } },
          { firm: { id: 20 } }
        ]
      }.with_indifferent_access
    end
    let(:randomised_ids) do
      [
        [7, 6, 2, 8, 9, 10, 1, 3, 5, 4],
        [17, 12, 14, 11, 15, 16, 18, 20, 13, 19]
      ]
    end
    let(:page) { 1 }
    let(:response) { public_send(:"response_page#{page}") }

    context 'first page' do
      let(:page) { 1 }

      let(:expected_response) do
        {
          nbHits: 20,
          hits: [
            { firm: { id: 7 } },
            { firm: { id: 6 } },
            { firm: { id: 2 } },
            { firm: { id: 8 } },
            { firm: { id: 9 } },
            { firm: { id: 10 } },
            { firm: { id: 1 } },
            { firm: { id: 3 } },
            { firm: { id: 5 } },
            { firm: { id: 4 } }
          ]
        }.with_indifferent_access
      end

      include_examples :shuffle_results
    end

    context 'page other than 1' do
      let(:page) { 2 }
      let(:expected_response) do
        {
          nbHits: 20,
          hits: [
            { firm: { id: 17 } },
            { firm: { id: 12 } },
            { firm: { id: 14 } },
            { firm: { id: 11 } },
            { firm: { id: 15 } },
            { firm: { id: 16 } },
            { firm: { id: 18 } },
            { firm: { id: 20 } },
            { firm: { id: 13 } },
            { firm: { id: 19 } }
          ]
        }.with_indifferent_access
      end

      include_examples :shuffle_results
    end
  end
end
