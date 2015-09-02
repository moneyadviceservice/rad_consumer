describe('show hidden options on checkbox change', function () {
  'use strict';

  var $html, $nestedOptionsComponent, $nestedOptionsTrigger, $nestedOptions;

  beforeEach(function(done){
    requirejs(['NestedOptions'], function (NestedOptions) {
      $html = $(window.__html__['spec/javascripts/fixtures/NestedOptions.html']).appendTo('body');
      $nestedOptionsComponent = $('[data-nested-options-component]');
      $nestedOptionsTrigger = $('[data-nested-options-trigger]');
      $nestedOptions = $('[data-nested-options]');
      new NestedOptions();
      done();
    });
  });

  afterEach(function() {
    $html.remove();
  });

  describe('NestedOptions is loaded', function() {
    it('page elements exist', function() {
      expect($nestedOptionsComponent).to.exist;
      expect($nestedOptions).to.exist;
      expect($nestedOptionsTrigger).to.exist;
    });

    it('is hidden on default', function() {
      expect($nestedOptions).to.have.class('is-hidden');
    });

    it('hidden options are shown on checkbox change', function() {
      $nestedOptionsTrigger.trigger('click');
      expect($nestedOptionsTrigger).to.be.checked;
      expect($nestedOptions).to.not.have.class('is-hidden');
    });
  });
});
