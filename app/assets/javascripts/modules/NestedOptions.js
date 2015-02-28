define(['jquery'], function($) {

  'use strict';

  var $nestedOptionTrigger = $('[data-nested-options-trigger]'),
      $nestedOptions = $('[data-nested-options]'),
      statusHidden = 'is-hidden';

  $nestedOptionTrigger.on('change', function() {
    if ($nestedOptions.hasClass(statusHidden) ) {
      $($nestedOptions).removeClass(statusHidden);
    } else {
      $($nestedOptions).addClass(statusHidden);
    }
  });
});
