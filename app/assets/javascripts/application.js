//= require require_config.js.erb

// Components
require(['jquery', 'jqueryUi', 'componentLoader', 'eventsWithPromises'], function ($, componentLoader, eventsWithPromises) {
  componentLoader.init($('body'));
});

require(['NestedOptions', 'ResultsFilter', 'FurtherInfo', 'SearchFilter', 'EducationModule', 'ResultsModule'],
        function (NestedOptions, ResultsFilter) {
  new NestedOptions();
  new ResultsFilter();
});
