VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  # Allow access to Elastic Search running locally
  # config.ignore_localhost = true
  config.ignore_localhost = true
  # Allow access to Elastic Search running locally but record CMS
  #config.ignore_request do |request|
  #  uri = URI(request.uri)
  #  puts "[#{uri.port == 9200}]request #{uri}"
  #  uri.port == 9200
  #end

  config.around_http_request do |request|
    uri = URI(request.uri)
    if ENV['MAS_CMS_URL'] =~ /#{uri.host}/
      VCR.use_cassette("/CMS/#{request.method}#{uri.path}#{uri.query}", &request)
    else
      puts "request #{uri}"
      request.proceed
    end
  end
end

def vcr_options_for_feature(cassette_name)
  { cassette_name: cassette_name, record: :new_episodes }
end
