//= require require_config.js.erb

require(['jquery'], function ($) {
  require([
    'FurtherInfo',
    'SearchFilter',
    'NestedOptions',
    'ResultsFilter',
    'EducationModule',
    'ResultsModule'
    ]);

    // Components
    require(['componentLoader'], function (componentLoader) {
      componentLoader.init($('body'));
    });
});
