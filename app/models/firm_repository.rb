class FirmRepository
  attr_reader :client

  def initialize(client = ElasticSearchClient)
    @client = client.new
  end

  def find(firm)
    path = "#{firm.model_name.plural}/#{firm.to_param}"
    JSON.parse(client.find(path).body)
  end

  def search(query, page: 1)
    response = client.search("firms/_search?from=#{from_for(page)}", query)
    SearchResult.new(response, page: page)
  end

  def from_for(page)
    return 0 if page == 1

    ((page - 1) * 10)
  end
end
