/**
 * # FirmMap
 *
 * A map that plots Advisers and Offices.
 *
 * @module FirmMap
 * @returns {class} FirmMap
 */

define(['jquery', 'DoughBaseComponent'],
       function($, DoughBaseComponent) {
  'use strict';

  var FirmMapProto,
      defaultConfig = {
        zoomLevel: 11,
        center: {lat: 0, lng: 0}
      };

  /**
   * @constructor
   * @extends {DoughBaseComponent}
   * @param {HTMLElement} $el    Element with dough-component on it
   * @param {Object}             config Hash of config options
   */
  function FirmMap($el, config) {
    FirmMap.baseConstructor.call(this, $el, config, defaultConfig);
  }

  /**
   * Inherit from base module, for shared methods and interface
   */
  DoughBaseComponent.extend(FirmMap);
  FirmMap.componentName = 'FirmMap';
  FirmMapProto = FirmMap.prototype;

  /**
   * Init function
   *
   * Set up listeners and accept promise
   *
   * @param {Object} initialised Promise passed from eventsWithPromises (RSVP Promise).
   * @returns {MultiTableFilter}
   */
  FirmMapProto.init = function(initialised) {
    this.initializeGoogleMaps();
    this._initialisedSuccess(initialised);
    return this;
  };

  /**
   * initializeGoogleMaps
   *
   * Adds the google maps script tag, and adds setupMap to the window object
   * so the library can find it.
   */
  FirmMapProto.initializeGoogleMaps = function() {
    window.doughMap__initMap = $.proxy(this.setupMap, this);
    var $map = this._getMapElement();
    $map.parent().append('<script defer src="https://maps.googleapis.com/maps/api/js?key=' +
                          this.config.apiKey + '&callback=doughMap__initMap"></script>');
  };

  /**
   * setupMap
   *
   * Sets up the map and adds advisers to it.
   * Is called by the google maps library.
   */
  FirmMapProto.setupMap = function() {
    var $map = this._getMapElement(),
        gMap = this._createMap($map);
    this._positionMarkers(gMap);
  };

  /**
   * _createMap
   *
   * Creates an instance of a google map, binding it to the param element.
   *
   * @private
   * @param {HTMLElement} $map Element to contain map
   * @return {GoogleMap} instance of google map
   */
  FirmMapProto._createMap = function($map) {
    return new google.maps.Map($map[0], {
      center: {
        lat: this.config.center.lat,
        lng: this.config.center.lng
      },
      zoom: this.config.zoomLevel
    });
  };

  /**
   * _positionMarkers
   *
   * Positions the adviser markers on the map.
   *
   * @private
   * @param {GoogleMap} gMap Instance of the map to position markers onto
   */
  FirmMapProto._positionMarkers = function(gMap) {
    var $advisers = this.$find('[data-dough-map-point]');

    $advisers.each($.proxy(function(_, adviser) {
      var $adviser = $(adviser),
          markerConfig = this._generateMarkerConfig($adviser);

      markerConfig.map = gMap;
      new google.maps.Marker(markerConfig);
    }, this));
  };

  /**
   * _getMapElement
   *
   * @private
   * @return {HTMLElement} Finds map element
   */
  FirmMapProto._getMapElement = function() {
    return this.$find('[data-dough-map]');
  };

  /**
   * _generateMarkerConfig
   *
   * @private
   * @param {HTMLElement} $element Element that has marker data attributes
   * @returns {Object} Config for creating a google maps marker with
   */
  FirmMapProto._generateMarkerConfig = function($element) {
    return {
      position: {
        lat: $element.data('dough-map-point-lat'),
        lng: $element.data('dough-map-point-lng')
      },
      title: $element.text()
    };
  };

  FirmMapProto.$find = function(selector) {
    return this.$el.find(selector);
  };

  return FirmMap;
});
