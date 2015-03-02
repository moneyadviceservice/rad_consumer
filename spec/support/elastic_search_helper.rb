module ElasticSearchHelper
  def with_fresh_index!
    `curl -XDELETE -sS http://127.0.0.1:9200/rad_test`
    `curl -XPOST -sS http://127.0.0.1:9200/rad_test -d @elastic_search_mapping.json`
    yield
    `curl -XPOST -sS http://127.0.0.1:9200/rad_test/_refresh`
  end

  def with_elastic_search!
    VCR.turned_off do
      begin
        WebMock.allow_net_connect!
        yield
      ensure
        WebMock.disable_net_connect!
      end
    end
  end
end
