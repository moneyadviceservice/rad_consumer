define(['jquery'], function($) {

  'use strict';

  var $resultsFilter = $('[data-results-filter]'),

      $resultsFilterTriggerOne = $('[data-results-filter-trigger="1"]'),
      $resultsFilterTriggerTwo = $('[data-results-filter-trigger="2"]'),

      $resultsFilterTarget = $('[data-results-filter-target]'),
      $resultsFilterTargetOne = $('[data-results-filter-target="1"]'),
      $resultsFilterTargetTwo = $('[data-results-filter-target="2"]'),
      statusHidden = 'is-hidden';

      if ( $resultsFilterTriggerOne.is(':checked') ) {
        $resultsFilterTargetOne.addClass(statusHidden);
      } else if ( $resultsFilterTriggerTwo.is(':checked')  ) {
        $resultsFilterTargetTwo.addClass(statusHidden);
      }

  $resultsFilter.each(function(indexInArray, objectInArray) {
    var $elementTriggerOne = $(objectInArray).find($resultsFilterTriggerOne),
        $elementTriggerTwo = $(objectInArray).find($resultsFilterTriggerTwo),
        $elementTargetOne = $(objectInArray).find($resultsFilterTargetOne),
        $elementTargetTwo = $(objectInArray).find($resultsFilterTargetTwo);

    $elementTriggerOne.change(function() {
      $resultsFilterTarget.addClass(statusHidden);
      $elementTargetTwo.toggleClass(statusHidden);
    });

    $elementTriggerTwo.change(function() {
      $resultsFilterTarget.addClass(statusHidden);
      $elementTargetOne.toggleClass(statusHidden);
    });
  });
});
