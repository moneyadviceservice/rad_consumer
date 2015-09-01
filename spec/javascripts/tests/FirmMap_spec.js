describe('google map', function () {
  'use strict';

  beforeEach(function (done){
    var self = this;

    requirejs(['jquery', 'FirmMap'], function ($, FirmMap) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/FirmMap.html']).appendTo('body');
      self.component = self.$html.find('#map-wrapper');
      self.FirmMap = new FirmMap(self.component).init();

      done();
    }, done);
  });

  afterEach(function () {
    this.$html.remove();
  });

  describe('initializeGoogleMaps', function () {
    it('appends a google maps script tag after the wrapper', function(){
      expect(this.$html.find('script')).to.exist;
    });
  });
});
