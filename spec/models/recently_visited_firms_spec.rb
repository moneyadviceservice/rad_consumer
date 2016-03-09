RSpec.describe RecentlyVisitedFirms do
  def firm_result(id, name: 'foobar', closest_adviser: 10, in_person_advice_methods: [1,2])
    FirmResult.new('_source' => { '_id' => id,
                                  'registered_name' => name,
                                  'advisers' => [],
                                  'offices' => [],
                                  'in_person_advice_methods' => in_person_advice_methods },
                   'sort' => [closest_adviser])
  end

  describe 'recently visited firms' do
    it 'stores the attributes' do
      visited_firms = RecentlyVisitedFirms.new({})
      visited_firms.store(firm_result(1, name: 'foobar', closest_adviser: 10), 'url')

      expect(visited_firms.firms.first['id']).to eq(1)
      expect(visited_firms.firms.first['name']).to eq('foobar')
      expect(visited_firms.firms.first['closest_adviser']).to eq(10)
      expect(visited_firms.firms.first['face_to_face?']).to eq(true)
      expect(visited_firms.firms.first['url']).to eq('url')
    end

    context 'remote search' do
      it 'stores the attributes' do
        visited_firms = RecentlyVisitedFirms.new({})
        visited_firms.store(firm_result(1, in_person_advice_methods: []), 'url')

        expect(visited_firms.firms.first['face_to_face?']).to eq(false)
      end
    end

    it 'stores firms ordered by most recent first' do
      visited_firms = RecentlyVisitedFirms.new({})
      visited_firms.store(firm_result(1), 'url')
      visited_firms.store(firm_result(2), 'url')

      expect(visited_firms.firms[0]['id']).to eq(2)
      expect(visited_firms.firms[1]['id']).to eq(1)
    end

    it 'stores no duplicate firms' do
      visited_firms = RecentlyVisitedFirms.new({})
      visited_firms.store(firm_result(1), 'url')
      visited_firms.store(firm_result(1), 'url')

      expect(visited_firms.firms.length).to eq(1)
    end

    it 'stores no more than three firms' do
      visited_firms = RecentlyVisitedFirms.new({})
      visited_firms.store(firm_result(1), 'url')
      visited_firms.store(firm_result(2), 'url')
      visited_firms.store(firm_result(3), 'url')
      visited_firms.store(firm_result(4), 'url')

      expect(visited_firms.firms.map { |f| f['id'] }).to eq([4, 3, 2])
    end
  end
end
