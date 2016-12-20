define(['jquery'], function($) {

  'use strict';

  var resultsFilter = function(){
    var $resultsFilterSwitch = $('[data-results-filter-trigger]'),
    $resultsFilterInputs = $('[data-results-input-target]'),
    $resultsFilterTargets = $('[data-results-filter-target]'),
    $activeResultsFilterSwitch = $('[data-results-filter-trigger]:checked'),
    $resultsFilterAutoComplete = $('[data-results-input-autocomplete]'),
    statusHidden = 'is-hidden';

    $resultsFilterSwitch.change(function(){
      $resultsFilterTargets.addClass(statusHidden);
      $resultsFilterInputs.val('');
      $(this).parentsUntil('section').siblings('[data-results-filter-target]').removeClass(statusHidden);
    });

    $resultsFilterAutoComplete.autocomplete({
      highlight: true, // Or string with your own classname
      minLength: 3,
      source: ['Mojito', 'Long Island Iced Tea', 'Margarita', 'Pina Colada', 'Mai Tai']
    });

    //Run on page load to display active search box
    $activeResultsFilterSwitch.parent().siblings('[data-results-filter-target]').removeClass(statusHidden);
  };

  return resultsFilter;

});
