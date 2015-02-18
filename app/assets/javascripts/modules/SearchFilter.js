define(['jquery'], function($) {

  'use strict';

  var $element = $('[data-search-filter]'),
      $trigger = $('[data-search-filter-trigger]'),
      $triggerIcon = $('[data-search-filter-icon]'),
      $target = $('[data-search-filter-target]');

  $element.each(function() {
    var $this = $(this);

    $this.find($trigger).on('click', function(event) {
      $target.addClass('is-hidden');
      $triggerIcon.removeClass('search__triangle-icon--down');
      $this.find($target).toggleClass('is-hidden');
      $this.find($triggerIcon).toggleClass('search__triangle-icon--down');
      event.preventDefault();
    });
  });
});
