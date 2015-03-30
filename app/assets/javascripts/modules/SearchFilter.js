define(['jquery'], function($) {

  'use strict';

  var $elements = $('[data-search-filter]'),
      trigger = '[data-search-filter-trigger]',
      $triggerIcon = $('[data-search-filter-icon]'),
      $triggerHeading = $('[data-search-filter-heading]'),
      $triggerHeadingSecond = $('[data-search-heading-second]'),
      iconOpen = 'search-filter__triangle-icon--down',
      statusHidden = 'is-hidden',
      $button = $('<button type="button" class="search-filter__heading-trigger" data-search-filter-trigger></button>'),
      $target = $('[data-search-filter-target]'),
      $targetClosed = $('[data-search-filter-target="closed"]');

  $triggerHeading.wrap($button);

  if ($targetClosed.find('.form__row').hasClass('is-errored') === true) {
    $target.addClass(statusHidden);
    $targetClosed.removeClass(statusHidden);
  } else {
    $targetClosed.addClass(statusHidden);
  }

  $elements.each(function(indexInArray, objectInArray) {
    var $elementTarget = $(objectInArray).find($target),
        $elementTrigger = $(objectInArray).find(trigger),
        $elementTriggerIcon = $(objectInArray).find($triggerIcon),
        $elementTriggerHeading = $(objectInArray).find($triggerHeadingSecond);

    $elementTrigger.click(function() {
      $target.addClass(statusHidden);
      $triggerIcon.removeClass(iconOpen);

      $elementTarget.toggleClass(statusHidden);
      $elementTriggerIcon.toggleClass(iconOpen);
    });
  });
});
