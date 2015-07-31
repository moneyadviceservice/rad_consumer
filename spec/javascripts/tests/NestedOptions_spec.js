describe('show hidden options on checkbox change', function () {

  'use strict';

  beforeEach(function(done){
    this.$html = $(window.__html__['spec/javascripts/fixtures/NestedOptions.html']).appendTo('body');
    this.$nestedOptionsComponent = $('[data-nested-options-component]');
    this.$nestedOptionsTrigger = $('[data-nested-options-trigger]');
    this.$nestedOptions = $('[data-nested-options]');
    done();
  });

  afterEach(function() {
    this.$html.remove();
  });

  describe('NestedOptions is not loaded', function(){
    it('page elements exist', function(done) {
      expect(this.$nestedOptionsComponent).to.exist;
      expect(this.$nestedOptions).to.exist;
      expect(this.$nestedOptionsTrigger).to.exist;
      done();
    });

    it('is hidden on default', function(done) {
      expect(this.$nestedOptions).to.have.class('is-hidden');
      done();
    });

    it('hidden options are not shown when checkbox is checked', function(done) {
      this.$nestedOptionsTrigger.trigger('click');
      expect(this.$nestedOptionsTrigger).to.be.checked;
      expect(this.$nestedOptions).to.have.class('is-hidden');
      done();
    });
  });

  describe('NestedOptions is loaded', function() {
    it('page elements exist', function(done) {
      var self = this;

      requirejs(['NestedOptions'], function (NestedOptions) {
        expect(self.$nestedOptionsComponent).to.exist;
        expect(self.$nestedOptions).to.exist;
        expect(self.$nestedOptionsTrigger).to.exist;
      }, done);

      done();
    });

    it('is hidden on default', function(done) {
      var self = this;

      requirejs(['NestedOptions'], function (NestedOptions) {
        expect(self.$nestedOptions).to.have.class('is-hidden');
      }, done);

      done();
    });

    it('hidden options are shown on checkbox change', function(done) {
      var self = this;

      requirejs(['NestedOptions'], function (NestedOptions) {
        self.$nestedOptionsTrigger.trigger('click');
        expect(self.$nestedOptionsTrigger).to.be.checked;
        expect(self.$nestedOptions).to.not.have.class('is-hidden');
      }, done);

      done();
    });
  });
});
