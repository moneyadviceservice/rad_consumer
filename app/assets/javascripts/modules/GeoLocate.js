define(['jquery'], function($) {

  'use strict';

  var location = $('[data-geo-location]'),
      description = $('.search-filter__description'),
      input = $('[data-geo-location-input]'),
      label = $('[data-geo-location-label]'),
      container = $('[data-geo-location-container]'),
      button = $('[data-geo-location-button]'),
      geocoder,
      postcode;

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
              postcode = address_component.address_components[0].long_name;

              location.text(postcode);
              input.attr('placeholder', postcode);

              button.click(function(){
                event.preventDefault();

                container.text(postcode);
                description.remove();
                button.remove();

                input.val(lat + " " + lng).addClass('visually-hidden');

                label.text('Search with postcode');
              });
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
