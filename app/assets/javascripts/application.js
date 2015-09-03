//= require require_config.js.erb

// Components
require(['jquery', 'componentLoader', 'eventsWithPromises'], function ($, componentLoader, eventsWithPromises) {
  componentLoader.init($('body'));
});

require(['NestedOptions', 'FurtherInfo', 'SearchFilter', 'ResultsFilter', 'EducationModule', 'ResultsModule'],
        function (NestedOptions) {
  new NestedOptions();
});
