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
        center: {lat: 0, lng: 0},
        adviserPinUrl: null,
        officePinUrl: null
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
   * Loads the google maps library and calls setupMap when it's done.
   */
  FirmMapProto.initializeGoogleMaps = function() {
    var $map = this._getMapElement();
    require(['async!//maps.google.com/maps/api/js?key=' + this.config.apiKey],
            $.proxy(this.setupMap, this));
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
    var $elements = this.$find('[data-dough-map-point]'),
        infoWindow = new google.maps.InfoWindow();

    $elements.each($.proxy(function(_, element) {
      var $element = $(element),
          markerConfig = this._generateMarkerConfig($element),
          marker;

      markerConfig.map = gMap;
      marker = new google.maps.Marker(markerConfig);
      FirmMapProto._addMarkerClickEvent(gMap, marker, infoWindow, $element.text());
    }, this));
  };

  /**
   * _addMarkerClickEvent
   *
   * Sets up the click event to display the content for a given marker
   *
   * @private
   *
   */
  FirmMapProto._addMarkerClickEvent = function(map, marker, infoWindow, content){
    google.maps.event.addListener(marker, 'click', function() {
      infoWindow.setContent(content);
      infoWindow.open(map, this);
    });
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
    var pinUrlString = $element.data('dough-map-point-type') + 'PinUrl';
    var iconUrl = this.config[pinUrlString];

    return {
      position: {
        lat: $element.data('dough-map-point-lat'),
        lng: $element.data('dough-map-point-lng')
      },
      icon: { url: iconUrl },
      clickable: ($element.data('dough-map-point-type') === 'office')
    };
  };

  FirmMapProto.$find = function(selector) {
    return this.$el.find(selector);
  };

  return FirmMap;
});
