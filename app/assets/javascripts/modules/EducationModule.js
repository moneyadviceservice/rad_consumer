define(['jquery'], function($) {

  'use strict';

  var $element = $('[data-education-module]'),
      $heading = $('[data-education-module-heading]'),
      $target = $('[data-education-module-target]'),
      $buttonElement = $('<button type="button" class="education__button" data-education-module-trigger></button>'),
      $iconElement = $('<span class="education__icon education__icon--plus" data-education-module-icon></span>'),
      statusHidden = 'is-hidden';

  $heading.wrap($buttonElement);
  $heading.prepend($iconElement);

  var $icon = $('[data-education-module-icon]'),
      $button = $('[data-education-module-trigger]');

  $element.each(function(indexInArray, objectInArray) {
    var $elementTrigger = $(objectInArray).find($button),
        $elementTriggerIcon = $(objectInArray).find($icon),
        $elementTarget = $(objectInArray).find($target);

    $elementTrigger.click(function() {
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
