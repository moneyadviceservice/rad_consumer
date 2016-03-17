RSpec.describe RadConsumerSession do
  def firm_result(id, name: 'foobar', closest_adviser: 10, in_person_advice_methods: [1, 2])
    FirmResult.new('_source' => { '_id' => id,
                                  'registered_name' => name,
                                  'advisers' => [],
                                  'offices' => [],
                                  'in_person_advice_methods' => in_person_advice_methods },
                   'sort' => [closest_adviser])
  end

  let(:search_url) { '/en/search' }

  subject { described_class.new({}) }

  describe '#search_results_url' do
    it 'returns the most_recent_search_url' do
      subject.store(firm_result(1), '/profile-url', '/search/en/my-last-search')
      expect(subject.search_results_url).to eq('/search/en/my-last-search')
    end
  end

  describe 'recently visited firms' do
    it 'stores the attributes' do
      subject.store(firm_result(1, name: 'foobar', closest_adviser: 10), 'url', search_url)

      expect(subject.firms.first['id']).to eq(1)
      expect(subject.firms.first['name']).to eq('foobar')
      expect(subject.firms.first['closest_adviser']).to eq(10)
      expect(subject.firms.first['face_to_face?']).to eq(true)
      expect(subject.firms.first['profile_url']).to eq('url')
    end

    context 'remote search' do
      it 'stores the attributes' do
        subject.store(firm_result(1, in_person_advice_methods: []), 'url', search_url)

        expect(subject.firms.first['face_to_face?']).to eq(false)
      end
    end

    it 'stores firms ordered by most recent first' do
      subject.store(firm_result(1), 'url', search_url)
      subject.store(firm_result(2), 'url', search_url)

      expect(subject.firms[0]['id']).to eq(2)
      expect(subject.firms[1]['id']).to eq(1)
    end

    it 'stores no duplicate firms' do
      subject.store(firm_result(1), 'url', search_url)
      subject.store(firm_result(1), 'url', search_url)

      expect(subject.firms.length).to eq(1)
    end

    it 'stores no more than three firms' do
      subject.store(firm_result(1), 'url', search_url)
      subject.store(firm_result(2), 'url', search_url)
      subject.store(firm_result(3), 'url', search_url)
      subject.store(firm_result(4), 'url', search_url)

      expect(subject.firms.map { |f| f['id'] }).to eq([4, 3, 2])
    end
  end
end
