describe('showing more content', function () {
  'use strict';

  beforeEach(function (done){
    var self = this;

    requirejs(['jquery', 'ShowMore'], function ($, ShowMore) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/ShowMore.html']).appendTo('body');
      self.component = self.$html.find('[data-dough-show-more-component]');
      self.trigger = self.$html.find('[data-dough-show-more-trigger]');

      self.ShowMore = new ShowMore(self.component).init();
      done();
    }, done);
  });

  afterEach(function () {
    this.$html.remove();
  });

  describe('loading the component', function() {
    it('only displays 10 items', function() {
      var visibleItems = this.$html.find('[data-dough-show-more-item]:not(.is-hidden)');
      expect(visibleItems.length).to.equal(10);
    });

    it('shows the trigger link', function() {
      expect(this.trigger).to.exist;
      expect(this.trigger.hasClass('is-hidden')).to.be.false;
    });
  });

  describe('clicking the trigger', function() {
    it('displays the remaining items', function() {
      this.trigger.click();
      var visibleItems = this.$html.find('[data-dough-show-more-item]:not(.is-hidden)');
      expect(visibleItems.length).to.equal(11);
    });

    it('hides the trigger', function(){
      this.trigger.click();
      expect(this.trigger.hasClass('is-hidden')).to.be.true;
    });
  });
});
