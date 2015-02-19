define(['jquery'], function($) {

  'use strict';

  var $elements = $('[data-search-filter]'),
      $trigger = $('[data-search-filter-trigger]'),
      $triggerIcon = $('[data-search-filter-icon]'),
      $triggerHeading = $('[data-search-heading-second]'),
      triggerHeadingIconOpen = 'search-filter__triangle-icon--down',
      triggerHeadingSecondStyle = 'search-filter__heading--second',
      statusHidden = 'is-hidden',
      $target = $('[data-search-filter-target]');

  $elements.each(function(indexInArray, objectInArray) {
    var $elementTarget = $(objectInArray).find($target),
        $elementTrigger = $(objectInArray).find($trigger),
        $elementTriggerIcon = $(objectInArray).find($triggerIcon),
        $elementTriggerHeading = $(objectInArray).find($triggerHeading);

    $elementTrigger.on('click', function(event) {
      event.preventDefault();

      // hide all of the filter sections on the page
      $target.addClass(statusHidden);

      // force the icons to revert to pointing left/closed
      $triggerIcon.removeClass(triggerHeadingIconOpen);

      // find the specific filter section and toggle its visibility and set the icon to open/down
      $elementTarget.toggleClass(statusHidden);
      $elementTriggerIcon.toggleClass(triggerHeadingIconOpen);

      // if data-attribute is present then set the correct border-radius
      $elementTriggerHeading.length ? $elementTriggerHeading.removeClass(triggerHeadingSecondStyle) : $triggerHeading.addClass(triggerHeadingSecondStyle);
    });
  });
});
