VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  record_mode = ENV['FORCE_RECORD_VCR'] == 'true' ? :all : :new_episodes
  config.default_cassette_options = { record: record_mode }

  config.filter_sensitive_data('<GOOGLE_GEOCODER_API_KEY>') { ENV['GOOGLE_GEOCODER_API_KEY'] }
  config.filter_sensitive_data('<GOOGLE_GEOCODER_API_KEY>') { ENV['GOOGLE_GEOCODER_API_KEY'] }

  config.filter_sensitive_data('<API_KEY>') { ENV['ALGOLIA_API_KEY'] }
  config.filter_sensitive_data('<APP_ID>') { ENV['ALGOLIA_APP_ID'] }
end
