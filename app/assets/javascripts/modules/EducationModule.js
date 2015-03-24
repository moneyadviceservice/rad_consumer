define(['jquery'], function($) {

  'use strict';

  var $element = $('[data-education-module]'),
      $heading = $('[data-education-module-heading]'),
      $target = $('[data-education-module-target]'),
      $button = $('<button type="button" class="unstyled-button" data-education-module-trigger></button>'),
      $iconElement = $('<span class="education__icon education__icon--plus" data-education-module-icon></span>'),

      statusHidden = 'is-hidden';

  $target.addClass(statusHidden);
  $heading.wrap($button);
  $heading.prepend($iconElement);

  var $icon = $('[data-education-module-icon]');

  $element.each(function(indexInArray, objectInArray) {
    var $elementTrigger = $(objectInArray).find($heading),
        $elementTriggerIcon = $(objectInArray).find($icon),
        $elementTarget = $(objectInArray).find($target);

    $elementTrigger.on('click', function(event) {
      event.preventDefault();

      $icon.removeClass('education__icon--minus');
      $icon.addClass('education__icon--plus');

      if ($elementTarget.hasClass(statusHidden)) {
        $target.addClass(statusHidden);
        $elementTriggerIcon.removeClass('education__icon--plus');
        $elementTriggerIcon.addClass('education__icon--minus');
        $elementTarget.removeClass(statusHidden);
      } else {
        $elementTarget.addClass(statusHidden);
        $elementTriggerIcon.addClass('education__icon--plus');
        $elementTriggerIcon.removeClass('education__icon--minus');
      }
    });
  });
});
