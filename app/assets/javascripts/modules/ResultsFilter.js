define(['jquery', 'typeahead'], function($, typeahead) {

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

    // Set up dataset for autocomplete
    var resultsSource = function(query, syncResults) {
      var requestUrl = '/' + window.location.pathname.split('/')[1] + '/search.json';
      $.ajax({
        url: requestUrl,
        data: 'term=' + query,
        success: function(response) {
          var matches = [];
          $.map(response, function(item, index){
            matches.push({
              value: item.label,
              url: item.value
            });
          });
          syncResults(matches);
        }
      });
    };

    // Configure autocomplete
    $resultsFilterAutoComplete.typeahead({
      minLength: 2,
      hint: false
    }, {
      source: resultsSource,
      templates: {
        suggestion: function(data) {
          return '<a class="search-filter__autocomplete-link" href="' + data.url + '">' + data.value + '</a>';
        }
      }
    });

    // Event that fires on autocomplete selection
    $resultsFilterAutoComplete.on('typeahead:selected', function(ev, suggestion){
      window.location = suggestion.url;
    });
    
    //Run on page load to display active search box
    $activeResultsFilterSwitch.parent().siblings('[data-results-filter-target]').removeClass(statusHidden);
  };

  return resultsFilter;

});
