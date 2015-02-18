define(['jquery'], function($) {

  'use strict';

  var $element = $('[data-search-filter]'),
      $trigger = $('[data-search-filter-trigger]'),
      $triggerIcon = $('[data-search-filter-icon]'),
      $triggerHeading = $('[data-search-heading-second]'),
      $target = $('[data-search-filter-target]');

  $element.each(function() {
    var $this = $(this);

    $this.find($trigger).on('click', function(event) {
      event.preventDefault();

      // hide all of the filter sections on the page
      $target.addClass('is-hidden');

      // force the icons to revert to pointing left/closed
      $triggerIcon.removeClass('search__triangle-icon--down');

      // find the specific filter section and toggle its visibility and set the icon to open/down
      $this.find($target).toggleClass('is-hidden');
      $this.find($triggerIcon).toggleClass('search__triangle-icon--down');

      // if data-attribute is present then set the correct border-radius
      $this.find($triggerHeading).length ? $this.find($triggerHeading).removeClass('search-filter__heading--second') : $triggerHeading.addClass('search-filter__heading--second');
    });
  });
});
