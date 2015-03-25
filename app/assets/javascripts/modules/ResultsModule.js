define(['jquery'], function($) {

  'use strict';

  var $element = $('[data-results-module]'),
      $heading = $('[data-results-module-heading]'),
      $target = $('[data-results-module-target]'),
      $buttonElement = $('<button type="button" class="education__button unstyled-button" data-results-module-trigger></button>'),
      $iconElement = $('<span class="education__icon education__icon--plus" data-results-module-icon></span>'),
      statusHidden = 'is-hidden';

  if ($(window).width() <= 720) {
    $target.addClass(statusHidden);
    $heading.wrap($buttonElement);
    $heading.prepend($iconElement);
  }

  var $icon = $('[data-results-module-icon]'),
      $button = $('[data-results-module-trigger]');

  $element.each(function(indexInArray, objectInArray) {
    var $elementTrigger = $(objectInArray).find($button),
        $elementTriggerIcon = $(objectInArray).find($icon),
        $elementTarget = $(objectInArray).find($target);

    $elementTrigger.on('click', function(event) {
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
