Rails.application.configure do
  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'

  config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')
  config.assets.paths << Rails.root.join('vendor', 'javascripts')

  # Application Stylesheets
  config.assets.precompile += %w(
    enhanced_fixed.css
    enhanced_responsive.css
    dough/assets/stylesheets/basic.css
    dough/assets/stylesheets/font_files.css
    dough/assets/stylesheets/font_base64.css
  )

  # Application JavaScript
  config.assets.precompile += %w(
    rsvp/rsvp.js
    modules/FurtherInfo.js
    modules/SearchFilter.js
    modules/NestedOptions.js
    modules/ResultsFilter.js
    modules/EducationModule.js
    modules/ResultsModule.js
    modules/FirmMap.js
    modules/ShowMore.js
    dough/assets/js/lib/*.js
    dough/assets/js/**/*.js
  )

  # Vendor JavaScript
  config.assets.precompile += %w(
    jquery/dist/jquery.js
    typeahead.js
    jquery-ujs/src/rails.js
    jqueryThrottleDebounce/jquery.ba-throttle-debounce.js
    eventsWithPromises/src/eventsWithPromises.js
    rsvp/rsvp.amd.js
    requirejs/require.js
    requirejs-plugins/src/async.js
  )
end
