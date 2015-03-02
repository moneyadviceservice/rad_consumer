define(['jquery'], function($) {

  'use strict';

  var $nestedOptionTrigger = $('[data-nested-options-trigger]'),
      $nestedOptions = $('[data-nested-options]'),
      statusHidden = 'is-hidden';

  $nestedOptionTrigger.on('change', function() {
    $nestedOptions.toggleClass(statusHidden);
  });
});
