define(['jquery'], function($) {

  'use strict';

  var $triggerAlt = $('[data-further-info-trigger-alt]');

  if ($triggerAlt.length) {
    $triggerAlt.wrap('<button type="button" class="further-info__button" data-further-info-trigger></button>');
  }

  var $element = $('[data-further-info]'),
      $trigger = $('[data-further-info-trigger]'),
      $target = $('[data-further-info-target]'),
      statusHidden = 'is-hidden';

  $element.each(function(indexInArray, objectInArray) {
    var $elementTrigger = $(objectInArray).find($trigger),
        $elementTarget = $(objectInArray).find($target);

    $elementTrigger.on('click', function(event) {
      event.preventDefault(event);

      if ($elementTarget.hasClass(statusHidden)) {
        $target.addClass(statusHidden);
        $elementTarget.removeClass(statusHidden);
      } else {
        $elementTarget.addClass(statusHidden);
      }
    });
  });
});
