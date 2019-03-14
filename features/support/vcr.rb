require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'features/cassettes'
  c.hook_into :webmock

  c.around_http_request do |request|
    uri = URI(request.uri)

    if uri.host =~ /google/
      filtered_query = CGI.parse(uri.query).except('key').to_query
      cassette_name = "/google/#{uri.path}/#{filtered_query}"
      record_mode = ENV['FORCE_RECORD_VCR'] == 'true' ? :all : :new_episodes
      VCR.use_cassette(cassette_name, match_requests_on: [:uri, VCR.request_matchers.uri_without_param(:key)], record: record_mode, &request)
    else
      request.proceed
    end
  end

  c.filter_sensitive_data('<GOOGLE_GEOCODER_API_KEY>') { ENV['GOOGLE_GEOCODER_API_KEY'] }
  c.filter_sensitive_data('<GOOGLE_GEOCODER_API_KEY>') { ENV['GOOGLE_GEOCODER_API_KEY'] }
end
