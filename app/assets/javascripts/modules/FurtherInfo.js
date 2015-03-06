define(['jquery'], function($) {

  'use strict';

  var $element = $('[data-further-info]'),
      $trigger = $('[data-further-info-trigger]'),
      $triggerAlt = $('[data-further-info-trigger-alt]'),
      $triggerIcon = $('[data-further-info-icon]'),
      $target = $('[data-further-info-target]'),
      statusHidden = 'is-hidden',
      iconOpen = 'has-icon--open',
      iconClosed = 'has-icon--closed';

  if ($triggerAlt.length) {
    $triggerAlt.wrap('<button type="button" class="further-info__button"></button>');
  }

  if ($triggerIcon.length) {
    $triggerIcon.addClass(iconClosed);
  }

  $element.each(function(indexInArray, objectInArray) {
    var $elementTrigger = $(objectInArray).find($trigger),
        $elementTarget = $(objectInArray).find($target),
        $elementIcon = $(objectInArray).find($triggerIcon);

    $elementTrigger.on('click', function(event) {
      event.preventDefault();

      if ($elementTarget.hasClass(statusHidden)) {
        $target.addClass(statusHidden);
        $elementTarget.removeClass(statusHidden);
      } else {
        $elementTarget.addClass(statusHidden);
      }

      if ($elementIcon.hasClass(iconClosed)) {
        $elementIcon.removeClass(iconClosed);
        $elementIcon.addClass(iconOpen);
      } else {
        $elementIcon.removeClass(iconOpen);
        $elementIcon.addClass(iconClosed);
      }

    });
  });
});
