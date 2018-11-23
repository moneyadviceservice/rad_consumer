module ElasticSearchHelper
  BASE_PATH = 'http://127.0.0.1:9200/rad_test'.freeze
  MAPPINGS = 'elastic_search_mapping.json'.freeze

  def with_fresh_index!
    rebuild_index!
    yield if block_given?
    index_all!
    refresh_index!
  end

  def rebuild_index!
    client.delete(BASE_PATH)
    client.post(BASE_PATH, File.read(MAPPINGS))
  end

  def refresh_index!
    client.post(BASE_PATH + '/_refresh')
    sleep 3 if ENV['TRAVIS']
  end

  def add_to_index(path, json)
    client.put(BASE_PATH + path, JSON.generate(json))
  end

  def with_elastic_search!
    WebMock.allow_net_connect!
    yield
  ensure
    WebMock.disable_net_connect!
  end

  def index_all!
    Firm.find_each do |firm|
      json = FirmSerializer.new(firm).as_json
      path = "/#{firm.model_name.plural}/#{firm.to_param}"

      add_to_index(path, json)
    end
  end

  def client
    @client ||= HTTPClient.new
  end
end
