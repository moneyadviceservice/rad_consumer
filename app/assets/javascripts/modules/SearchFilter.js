define(['jquery'], function($) {

  'use strict';

  var $elements = $('[data-search-filter]'),
      trigger = '[data-search-filter-trigger]',
      $triggerIcon = $('[data-search-filter-icon]'),

      $triggerHeading = $('[data-search-filter-heading]'),
      $triggerHeadingSecond = $('[data-search-heading-second]'),

      // set statuses
      borderRadius = 'search-filter__heading--second',
      iconOpen = 'search-filter__triangle-icon--down',
      statusHidden = 'is-hidden',

      $button = $('<button type="button" class="search-filter__heading-trigger" data-search-filter-trigger></button>'),
      $target = $('[data-search-filter-target]');

  $triggerHeading.wrap($button);

  $elements.each(function(indexInArray, objectInArray) {
    var $elementTarget = $(objectInArray).find($target),
        $elementTrigger = $(objectInArray).find(trigger),
        $elementTriggerIcon = $(objectInArray).find($triggerIcon),
        $elementTriggerHeading = $(objectInArray).find($triggerHeadingSecond);

    $elementTrigger.on('click', function(event) {
      $target.addClass(statusHidden);

      // force the icons to revert to pointing left/closed
      $triggerIcon.removeClass(iconOpen);

      // find the specific filter section and toggle its visibility,
      // and set the icon to open/down
      $elementTarget.toggleClass(statusHidden);
      $elementTriggerIcon.toggleClass(iconOpen);

      // if data-attribute is present then set the correct border-radius
      if ( $elementTriggerHeading.length ) {
        $elementTriggerHeading.removeClass(borderRadius);
      } else {
        $triggerHeadingSecond.addClass(borderRadius);
      }

    });
  });
});
