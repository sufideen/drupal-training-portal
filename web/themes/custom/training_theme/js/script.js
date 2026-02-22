(function ($, Drupal) {
  'use strict';
  Drupal.behaviors.trainingTheme = {
    attach: function (context, settings) {
      once('training-menu', '.region-header a', context).forEach(function (el) {
        if (el.href === window.location.href) {
          el.classList.add('active');
        }
      });
    }
  };
})(jQuery, Drupal);
