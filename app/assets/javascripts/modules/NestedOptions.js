define(['jquery'], function($) {

  'use strict';

  var $nestedOptionsComponent = $('[data-nested-options-component]'),
      $nestedOptionTrigger = $('[data-nested-options-trigger]'),
      $nestedOptions = $('[data-nested-options]'),
      statusHidden = 'is-hidden';

  $nestedOptionsComponent.each(function(indexInArray, objectInArray) {
    var $elementTrigger = $(objectInArray).find($nestedOptionTrigger),
        $elementOptions = $(objectInArray).find($nestedOptions);

    $elementTrigger.change(function() {
      $elementOptions.toggleClass(statusHidden);
    });
  });
});
