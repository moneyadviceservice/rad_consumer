require_relative 'boot'

require 'rails/all'

require_relative '../app/middleware/partner_tools_cookies.rb'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RadConsumer
  class Application < Rails::Application
    config.load_defaults 5.2
    Rails.application.config.active_record.belongs_to_required_by_default = false

    config.time_zone = 'Europe/London'
    config.chat_opening_hours = OpeningHours.new('8:00 AM', '6:00 PM')
    config.chat_opening_hours.update(:sat, '08:00 AM', '3:00 PM')
    config.chat_opening_hours.closed(:sun)

    config.eager_load_paths << Rails.root.join('lib')
    config.autoload_paths += Dir["#{config.root}/app/services/**/", Rails.root.join("app/middleware")]

    # config.middleware.use CaptureRequestId # capture X-Request-ID header
    # config.middleware.use OverrideHead # convert HEAD requests to GET and return an empty body
    config.middleware.insert_after(ActionDispatch::Static, PartnerToolsCookies)
    
    # config.middleware.use Rack::Session::Cookie,
    #     :key          => 'rack.session', 
    #     :httponly     => true,
    #     :same_site    => :strict,
    #     :path         => '/',
    #     :expire_after => 86400,
    #     :secret       => 1234
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    

    # Switch off sassc concurrency. See this issue
    # https://github.com/rails/sprockets/issues/581#issuecomment-486984663
    config.assets.configure do |env|
      env.export_concurrent = false
    end
  end
end

ActiveRecord::SessionStore::Session.table_name = 'rad_consumer_sessions'


