require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'features/cassettes'
  c.hook_into :webmock

  c.around_http_request do |request|
    uri = URI(request.uri)

    if uri.host =~ /google/
      cassette_name = "/google/#{uri.path}/#{uri.query}"
      VCR.use_cassette(cassette_name, match_requests_on: [:uri], &request)
    else
      request.proceed
    end
  end

  c.filter_sensitive_data('<GOOGLE_GEOCODER_API_KEY>') { ENV['GOOGLE_GEOCODER_API_KEY'] }
  c.filter_sensitive_data('<GOOGLE_GEOCODER_API_KEY>') { ENV['GOOGLE_GEOCODER_API_KEY'] }
end
