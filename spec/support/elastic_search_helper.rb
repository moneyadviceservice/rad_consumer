module ElasticSearchHelper
  def with_fresh_index!
    rebuild_index!
    yield if block_given?
    index_all!
    refresh_index!
  end

  def rebuild_index!
    `curl -XDELETE -sS http://127.0.0.1:9200/rad_test`
    `curl -XPOST -sS http://127.0.0.1:9200/rad_test -d @elastic_search_mapping.json`
  end

  def refresh_index!
    `curl -XPOST -sS http://127.0.0.1:9200/rad_test/_refresh`
    `sleep 3` if ENV['TRAVIS']
  end

  def with_elastic_search!
    WebMock.allow_net_connect!
    yield
  ensure
    WebMock.disable_net_connect!
  end

  def index_all!
    Firm.all.map { |f| IndexFirmJob.perform_later(f) }
  end
end
