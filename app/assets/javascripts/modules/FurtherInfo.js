define(['jquery'], function($) {

  'use strict';

  var $element = $('[data-further-info]'),
      $trigger = $('[data-further-info-trigger]'),
      $target = $('[data-further-info-target]'),
      statusHidden = 'is-hidden';

  $element.each(function(indexInArray, objectInArray) {
    var $elementTrigger = $(objectInArray).find($trigger),
        $elementTarget = $(objectInArray).find($target);

    $elementTrigger.click(function() {
      event.preventDefault();
      event.stopPropagation();

      if ( $elementTarget.hasClass(statusHidden) ) {
        $target.addClass(statusHidden);
        $elementTarget.removeClass(statusHidden);
      } else {
        $elementTarget.addClass(statusHidden);
      }
    });
  });
});
