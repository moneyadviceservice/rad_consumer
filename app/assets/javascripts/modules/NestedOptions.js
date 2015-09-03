define(['jquery'], function($) {
  'use strict';

  var NestedOptions = function () {
    var $nestedOptionsComponent = $('[data-nested-options-component]'),
        $nestedOptionTrigger = $('[data-nested-options-trigger]'),
        $nestedOptions = $('[data-nested-options]'),
        statusHidden = 'is-hidden';

    if ($nestedOptionTrigger.is(':checked')) {
      $nestedOptions.toggleClass(statusHidden);
    }

    $nestedOptionsComponent.each(function(indexInArray, objectInArray) {
      var $elementTrigger = $(objectInArray).find($nestedOptionTrigger),
          $elementOptions = $(objectInArray).find($nestedOptions);

      $elementTrigger.change(function() {
        $elementOptions.toggleClass(statusHidden);
      });
    });
  };

  return NestedOptions;
});
