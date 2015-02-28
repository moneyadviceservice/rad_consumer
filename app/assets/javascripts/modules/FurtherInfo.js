define(['jquery'], function($) {

  'use strict';

  var $element = $('[data-further-info]'),
      $trigger = $('[data-further-info-trigger]'),
      $triggerAlt = $('[data-further-info-trigger-alt]'),
      $target = $('[data-further-info-target]'),
      statusHidden = 'is-hidden';

  if ($triggerAlt.length) {
    $triggerAlt.wrap('<button type="button" class="further-info__button"></button>');
  }

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
