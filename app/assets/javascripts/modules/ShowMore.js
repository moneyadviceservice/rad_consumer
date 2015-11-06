/**
 * # ShowMore
 *
 * Component to
 *
 * @module ShowMore
 * @returns {class} ShowMore
 */

define(['jquery', 'DoughBaseComponent'],
       function($, DoughBaseComponent) {
  'use strict';

  var ShowMoreProto,
      defaultConfig = {
        displayCount: 10,
        triggerSelector: '[data-dough-show-more-trigger]',
        itemSelector: '[data-dough-show-more-item]'
      };

  /**
   * @constructor
   * @extends {DoughBaseComponent}
   * @param {HTMLElement} $el    Element with dough-component on it
   * @param {Object}             config Hash of config options
   */
  function ShowMore($el, config) {
    ShowMore.baseConstructor.call(this, $el, config, defaultConfig);
  }

  /**
   * Inherit from base module, for shared methods and interface
   */
  DoughBaseComponent.extend(ShowMore);
  ShowMore.componentName = 'ShowMore';
  ShowMoreProto = ShowMore.prototype;

  /**
   * Init function
   *
   * Set up listeners and accept promise
   *
   * @param {Object} initialised Promise passed from eventsWithPromises (RSVP Promise).
   * @returns {MultiTableFilter}
   */
  ShowMoreProto.init = function(initialised) {
    this._displayInitialVisibleItems();
    this._displayShowMoreTrigger();
    this._bindTriggerClick();

    this._initialisedSuccess(initialised);
    return this;
  };

  /**
   * $find
   *
   * Sets up the page to only display the first set of visible items
   *
   * @param {String} Element selector
   * @returns {HTMLElement} DOM element scoped to the component's parent element
   */
  ShowMoreProto.$find = function(selector) {
    return this.$el.find(selector);
  };

  /**
   * _displayInitialVisibleItems
   *
   * Sets up the page to only display the first set of visible items
   *
   * @private
   */
  ShowMoreProto._displayInitialVisibleItems = function() {
    var count = this.config.displayCount - 1;
    var selector = this.config.itemSelector + ':gt('+ count +')';
    this.$find(selector).addClass('is-hidden');
  };

  /**
   * _bindTriggerClick
   *
   * Setups the trigger's click event
   *
   * @private
   */
  ShowMoreProto._bindTriggerClick = function() {
    var self = this;

    this.$find(this.config.triggerSelector).on('click', function(e){
      e.preventDefault();

      self._displayNextItems();
      self._displayShowMoreTrigger();
    });
  };

  /**
   * _displayNextItems
   *
   * Makes the next set of items visible
   *
   * @private
   */
  ShowMoreProto._displayNextItems = function() {
    var hiddenItems = this.config.itemSelector + '.is-hidden';
    var nextItemsToDisplay = this.$find(hiddenItems).slice(0, this.config.displayCount);
    nextItemsToDisplay.removeClass('is-hidden');
  };

  /**
   * _displayShowMoreTrigger
   *
   * Shows or hides the ShowMore trigger depending if there are more items to be displayed
   *
   * @private
   */
  ShowMoreProto._displayShowMoreTrigger = function() {
    var trigger = this.$find(this.config.triggerSelector);
    if(this._hasMoreItemsToDisplay()) {
      trigger.removeClass('is-hidden');
    } else {
      trigger.addClass('is-hidden');
    }
  };

  /**
   * _hasMoreItemsToDisplay
   *
   * @private
   * returns {Boolean} Whether there are more items to be displayed
   */
  ShowMoreProto._hasMoreItemsToDisplay = function() {
    return this.$find(this.config.itemSelector + '.is-hidden').length > 0;
  };

  return ShowMore;
});
