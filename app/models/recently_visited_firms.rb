class RecentlyVisitedFirms
  def initialize(store)
    @store = store
    @store[:recently_visited_firms] ||= []
  end

  def firms
    @store[:recently_visited_firms]
  end

  def store(firm_result, url)
    return if firm_already_present?(firm_result)
    firms.pop if firms.length >= 3
    firms.unshift('id' => firm_result.id,
                  'name' => firm_result.name,
                  'closest_adviser' => firm_result.closest_adviser,
                  'face_to_face?' => firm_result.in_person_advice_methods.present?,
                  'url' => url)
  end

  private

  def firm_already_present?(firm_result)
    firms.any? { |firm_hash| firm_result.id == firm_hash['id'] }
  end
end
