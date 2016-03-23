RSpec.describe RadConsumerSession do
  def firm_result(id, name: 'foobar', closest_adviser: 10, in_person_advice_methods: [1, 2])
    FirmResult.new('_source' => { '_id' => id,
                                  'registered_name' => name,
                                  'advisers' => [],
                                  'offices' => [],
                                  'in_person_advice_methods' => in_person_advice_methods },
                   'sort' => [closest_adviser])
  end

  def params(id = '1')
    {
      search_form: {
        'advice_method' => 'face_to_face', 'postcode' => 'EC1N 2TD'
      },
      'id' => id.to_s,
      'locale' => 'en',
      'controller' => 'firms',
      'action' => 'show'
    }
  end

  def expected_search_path(locale)
    "/#{locale}/search?search_form%5Badvice_method%5D=face_to_face&search_form%5Bpostcode%5D=EC1N+2TD"
  end

  def expected_firm_profile_path(id, locale)
    "/#{locale}/firms/#{id}?search_form%5Badvice_method%5D=face_to_face&search_form%5Bpostcode%5D=EC1N+2TD"
  end

  subject { described_class.new({}) }

  describe '#search_results_url' do
    it 'returns the most_recent_search_url' do
      subject.store(firm_result(1), params)
      expect(subject.search_results_url['en']).to eq(expected_search_path('en'))
      expect(subject.search_results_url['cy']).to eq(expected_search_path('cy'))
    end
  end

  describe 'profile_path' do
    it 'returns the most_recent_search_url' do
      subject.store(firm_result(1), params)
      expect(subject.firms[0]['profile_path']['en']).to eq(expected_firm_profile_path(1, 'en'))
      expect(subject.firms[0]['profile_path']['cy']).to eq(expected_firm_profile_path(1, 'cy'))
    end
  end

  describe 'recently visited firms' do
    it 'stores the attributes' do
      subject.store(firm_result(1, name: 'foobar', closest_adviser: 10), params)

      expect(subject.firms.first['id']).to eq(1)
      expect(subject.firms.first['name']).to eq('foobar')
      expect(subject.firms.first['closest_adviser']).to eq(10)
      expect(subject.firms.first['face_to_face?']).to eq(true)
    end

    context 'remote search' do
      it 'stores the attributes' do
        subject.store(firm_result(1, in_person_advice_methods: []), params)

        expect(subject.firms.first['face_to_face?']).to eq(false)
      end
    end

    it 'stores firms ordered by most recent first' do
      subject.store(firm_result(1), params)
      subject.store(firm_result(2), params(2))

      expect(subject.firms[0]['id']).to eq(2)
      expect(subject.firms[1]['id']).to eq(1)
    end

    it 'stores no duplicate firms' do
      subject.store(firm_result(1), params)
      subject.store(firm_result(1), params)

      expect(subject.firms.length).to eq(1)
    end

    it 'stores no more than three firms' do
      subject.store(firm_result(1), params(1))
      subject.store(firm_result(2), params(2))
      subject.store(firm_result(3), params(3))
      subject.store(firm_result(4), params(4))

      expect(subject.firms.map { |f| f['id'] }).to eq([4, 3, 2])
    end
  end
end
