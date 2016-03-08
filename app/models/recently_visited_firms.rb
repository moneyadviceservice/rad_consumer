class RecentlyVisitedFirms
  def initialize(store)
    @store = store
    @store[:recently_visited_firms] ||= []
  end

  def firms
    @store[:recently_visited_firms]
  end

  def store(firm, url)
    return if firm_already_present?(firm)
    firms.pop if firms.length >= 3
    firms.unshift('id' => firm.id,
                  'name' => firm.name,
                  'closest_adviser' => firm.closest_adviser,
                  'url' => url)
  end

  private

  def firm_already_present?(firm)
    firms.any? { |f| firm.id == f['id'] }
  end
end
