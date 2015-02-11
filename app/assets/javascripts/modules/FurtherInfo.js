define(['jquery'], function($) {

  'use strict';

  var $element = $('[data-further-info]'),
      $trigger = $('[data-further-info-trigger]'),
      $target = $('[data-further-info-target]');

  $element.each(function() {
    var $this = $(this);

    $this.find($trigger).on('click', function(event) {
      $this.find($target).toggleClass('is-hidden');
      event.preventDefault();
    });
  });

});
