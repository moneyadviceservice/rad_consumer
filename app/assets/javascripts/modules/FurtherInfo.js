define(['jquery'], function($) {

  'use strict';

  var $element = $('[data-further-info]'),
      $trigger = $('[data-further-info-trigger]'),
      $target = $('[data-further-info-target]'),
      statusHidden = 'is-hidden';

  $element.each(function(indexInArray, objectInArray) {
    var $elementTrigger = $(objectInArray).find($trigger),
        $elementTarget = $(objectInArray).find($target);

    $elementTrigger.on('click', function(event) {
      event.preventDefault();

      if ($elementTarget.hasClass(statusHidden)) {
        $target.addClass(statusHidden);
        $elementTarget.removeClass(statusHidden);
      } else {
        $elementTarget.addClass(statusHidden);
      }
    });
  });

});
