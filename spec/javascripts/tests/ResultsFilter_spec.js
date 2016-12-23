describe('show search inputs on radio button change', function () {
  'use strict';

  var $html;

  beforeEach(function(done){
    var self = this;

    requirejs(['jquery', 'ResultsFilter'], function ($, ResultsFilter) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/ResultsFilter.html']).appendTo('body');
      self.$resultsFilterTrigger = $('[data-results-filter-trigger]');
      self.$resultsFilterTarget = $('[data-results-filter-target]');
      self.$resultsAutoComplete = $('[data-results-input-autocomplete]');
      new ResultsFilter();
      done();
    });
  });

  afterEach(function() {
    this.$html.remove();
  });

  describe('ResultsFilter radio buttons toggle inputs', function() {

    it('removes the is-hidden class initially', function() {
      expect(this.$resultsFilterTarget.eq(0)).to.not.have.class('is-hidden');
    }); 

    it('hides all inputs when a trigger without target is clicked', function(){
      var trigger = this.$resultsFilterTrigger.eq(1);
      // Check there is no target sibling
      expect(trigger.parent().siblings('[data-results-filter-target]').length).to.equal(0);
      trigger.click();
      // Check that all targets are hidden
      $.each(this.$resultsFilterTarget, function(){
        var $this = $(this);
        expect($this).to.have.class('is-hidden');
      });
    });

    it('shows the sibling target when a trigger is clicked', function(){
      var target = this.$resultsFilterTarget.eq(1);
      expect(target).to.have.class('is-hidden');
      target.parent().find('[data-results-filter-trigger]').click();
      expect(target).to.not.have.class('is-hidden');
    });
  });

  describe('Typeahead tests', function() {
    it('initialises the typeahead library', function() {
     expect(this.$resultsAutoComplete).to.have.class('tt-input');
   });
  });
});
