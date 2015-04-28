define(['jquery'], function($) {

  'use strict';

  var location = $('[data-geo-location]'),
      placeholder = $('[data-geo-location-placeholder]'),
      geocoder;

  function initialise() {
    geocoder = new google.maps.Geocoder();
  }

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(successFunction, errorFunction);
  }

  function successFunction(position) {
    var lat = position.coords.latitude;
    var lng = position.coords.longitude;

    codeLatLng(lat, lng);
  }

  function errorFunction() {
    alert("Geocoder failed");
  }

  function codeLatLng(lat, lng) {
    var latlng = new google.maps.LatLng(lat, lng);

    geocoder.geocode({'latLng' : latlng}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        if (results[1]) {
          var arrAddress = results;

          $.each(arrAddress, function(i, address_component) {
            if (address_component.types[0] == "postal_code") {
              var postcode = address_component.address_components[0].long_name;

              location.text(postcode);
              placeholder.attr('placeholder', postcode);
            }
          });
        } else {
          alert("No results found");
        }
      } else {
        alert("Geocoder failed due to: " + status);
      }
    });
  }

  initialise();
});
