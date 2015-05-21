VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock

  # Allow access to Elastic Search running locally
  config.ignore_localhost = true
end
