define(['jquery'], function($) {

  'use strict';

  var resultsFilter = function(){
    var $resultsFilterSwitch = $('[data-results-filter-trigger]'),
    $resultsFilterInputs = $('[data-results-input-target]'),
    $resultsFilterTargets = $('[data-results-filter-target]'),
    $activeResultsFilterSwitch = $('[data-results-filter-trigger]:checked'),
    $resultsFilterAutoComplete = $('[data-results-input-autocomplete]'),
    statusHidden = 'is-hidden',
    autoCompleteSource = '/' + window.location.pathname.split('/')[1] + '/search.json';

    $resultsFilterSwitch.change(function(){
      $resultsFilterTargets.addClass(statusHidden);
      $resultsFilterInputs.val('');
      $(this).parentsUntil('section').siblings('[data-results-filter-target]').removeClass(statusHidden);
    });

    $resultsFilterAutoComplete.autocomplete({
      highlight: true,
      minLength: 3,
      source: autoCompleteSource,
      select: function( event, ui ) {
        event.stopPropagation();
        window.location = ui.item.value;
        return false;
      }
    });

    //Run on page load to display active search box
    $activeResultsFilterSwitch.parent().siblings('[data-results-filter-target]').removeClass(statusHidden);
  };

  return resultsFilter;

});
