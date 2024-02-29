require 'cucumber/rails'
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'capybara/cucumber'
require 'site_prism'

Capybara.javascript_driver = :poltergeist
Capybara.server = :webrick

Around do |scenario, block|
  scenario_path = scenario.source.map(&:name).map(&:parameterize).join('/')

  VCR.configure do |c|
    c.around_http_request do |request|
      uri = URI(request.uri)

      if uri.host =~ /algolia/
        cassette_name = "/algolia/#{scenario_path}/#{request.method}#{uri.path}"
        record_mode = ENV['FORCE_RECORD_VCR'] == 'true' ? :all : :new_episodes
        VCR.use_cassette(cassette_name, match_requests_on: [:body], record: record_mode, &request)
      else
        request.proceed
      end
    end

    c.filter_sensitive_data('<API_KEY>') { ENV['ALGOLIA_API_KEY'] }
    c.filter_sensitive_data('<APP_ID>') { ENV['ALGOLIA_APP_ID'] }
  end

  block.call
end
