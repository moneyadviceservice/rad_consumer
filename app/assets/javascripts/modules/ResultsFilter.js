define(['jquery'], function($) {

  'use strict';

  var $resultsFilter = $('[data-results-filter]'),

      $resultsFilterTrigger = $('[data-results-filter-trigger]'),
      $resultsFilterTriggerOne   = $('[data-results-filter-trigger="1"]'),
      $resultsFilterTriggerTwo   = $('[data-results-filter-trigger="2"]'),
      $resultsFilterTriggerThree = $('[data-results-filter-trigger="3"]'),

      $resultsFilterTarget = $('[data-results-filter-target]'),
      $resultsFilterTargetOne   = $('[data-results-filter-target="1"]'),
      $resultsFilterTargetTwo   = $('[data-results-filter-target="2"]'),
      $resultsFilterTargetThree = $('[data-results-filter-target="3"]'),

      $resultsFilterTargetOneInput   = $('[data-results-input-target="1"]'),
      $resultsFilterTargetThreeInput = $('[data-results-input-target="3"]'),

      statusHidden = 'is-hidden';

  if ($resultsFilterTriggerOne.is(':checked')) {
    $resultsFilterTargetOne.removeClass(statusHidden);
  }
  else if ($resultsFilterTriggerTwo.is(':checked')) {
    $resultsFilterTargetOne.removeClass(statusHidden);
  }
  else if ($resultsFilterTriggerThree.is(':checked')) {
    $resultsFilterTargetThree.removeClass(statusHidden);
  }

  $resultsFilter.each(function(indexInArray, objectInArray) {
    var $elementTriggerOne = $(objectInArray).find($resultsFilterTriggerOne),
        $elementTriggerTwo = $(objectInArray).find($resultsFilterTriggerTwo),
        $elementTriggerThree = $(objectInArray).find($resultsFilterTriggerThree),

        $elementTargetOne = $(objectInArray).find($resultsFilterTargetOne),
        $elementTargetTwo = $(objectInArray).find($resultsFilterTargetTwo),
        $elementTargetThree = $(objectInArray).find($resultsFilterTargetThree);

    $elementTriggerOne.change(function() {
      $resultsFilterTarget.addClass(statusHidden);
      $elementTargetOne.toggleClass(statusHidden);
      $resultsFilterTargetThreeInput.val('');
    });

    $elementTriggerTwo.change(function() {
      $resultsFilterTarget.addClass(statusHidden);
    });

    $elementTriggerThree.change(function() {
      $resultsFilterTarget.addClass(statusHidden);
      $elementTargetThree.toggleClass(statusHidden);
      $resultsFilterTargetOneInput.val('');
    });
  });
});
