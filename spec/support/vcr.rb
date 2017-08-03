VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.ignore_localhost = false
  # Allow access to Elastic Search running locally but record CMS
  config.ignore_request do |request|
    uri = URI(request.uri)
    uri.host == 'localhost' && uri.port != 3000
  end

  config.around_http_request do |request|
    uri = URI(request.uri)

    if ENV['MAS_CMS_URL'] =~ /#{uri.host}/
      VCR.use_cassette("/CMS/#{request.method}#{uri.path}#{uri.query}", &request)
    else
      request.proceed
    end
  end
end

def vcr_options_for_feature(cassette_name)
  { cassette_name: cassette_name, record: :none }
end
