define(['jquery'], function($) {

  'use strict';

  var $element = $('[data-results-module]'),
      $heading = $('[data-results-module-heading]'),
      $target = $('[data-results-module-target]'),
      $adviserElement = $('.result__adviser-distance'),
      $buttonElement = $('<button type="button" class="education__button unstyled-button" data-results-module-trigger></button>'),
      $iconElement = $('<span class="education__icon education__icon--plus" data-results-module-icon></span>'),
      statusHidden = 'is-hidden-on-mobile',
      $targetClosed = $('[data-results-module-target="closed"]'),
      iconSelector = '[data-results-module-icon]',
      triggerSelector = '[data-results-module-trigger]',
      mobileApplied = false;

  function bindResultsModuleEventHandlers() {
    $element.each(function(_, resultsModule) {
      $(resultsModule).on('click', triggerSelector, function() {
        var $elementTrigger = $(resultsModule).find(triggerSelector),
            $elementTriggerIcon = $(resultsModule).find(iconSelector),
            $elementTarget = $(resultsModule).find($target),
            $icons = $(iconSelector);

        $icons.removeClass('education__icon--minus');
        $icons.addClass('education__icon--plus');

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
  }

  function applyMobileElementsIfWindowSizeMatches() {
    var windowWidth = $(window).width();
    if (mobileApplied === false && windowWidth <= 720) {
      mobileApplied = true;
      addMobileElements();
    } else if (mobileApplied === true && windowWidth > 720) {
      mobileApplied = false;
      removeMobileElements();
    }
  }

  function addMobileElements() {
    $heading.wrap($buttonElement);
    $heading.prepend($iconElement);

    if ($targetClosed.find('.form__row').hasClass('is-errored') === true) {
      $target.addClass(statusHidden);
      $targetClosed.removeClass(statusHidden);
    } else {
      $targetClosed.addClass(statusHidden);
    }
  }

  function removeMobileElements() {
    $heading.unwrap();
    $heading.find('.education__icon').remove();

    if ($targetClosed.find('.form__row').hasClass('is-errored') === true) {
      $target.removeClass(statusHidden);
      $targetClosed.addClass(statusHidden);
    } else {
      $targetClosed.removeClass(statusHidden);
    }
  }

  bindResultsModuleEventHandlers();
  applyMobileElementsIfWindowSizeMatches();
  $(window).bind('orientationchange resize', applyMobileElementsIfWindowSizeMatches);
});
