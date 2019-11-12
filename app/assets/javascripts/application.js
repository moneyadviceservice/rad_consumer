//= require require_config.js

// Components
require(['jquery', 'componentLoader', 'eventsWithPromises'], function ($, componentLoader, eventsWithPromises) {
  componentLoader.init($('body'));
});

require(['NestedOptions', 'ResultsFilter', 'FurtherInfo', 'SearchFilter', 'EducationModule', 'ResultsModule'],
        function (NestedOptions, ResultsFilter) {
  new NestedOptions();
  new ResultsFilter();
});
