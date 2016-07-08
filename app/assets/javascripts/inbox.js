$(document).on("turbolinks:load", function() {
  'use strict';

  var taskList = $('[data-task="list"]');
  var taskOpened = $('[data-task="opened"]');

  if (taskList.length) {
    taskList.ioslist();
  };

  $('body').on('click', '.item', function(e) {
    e.stopPropagation();

    var link = $(this).attr('data-link');
    $.get(link, {}, function(data) {
      $('.task-content-wrapper').replaceWith($(data));
      $("#new_message select").select2();
      $('.no-result').hide();
      $('.actions-dropdown').toggle();
      $('.actions, .task-content-wrapper').show();

      if ($.Pages.isVisibleSm() || $.Pages.isVisibleXs()) {
        $('.split-list').toggleClass('slideLeft');
      }

      $(".task-content-wrapper").scrollTop(0);

      // Initialize task action menu
      $('.menuclipper').menuclipper({
        bufferWidth: 20
      });
    }, "html");

    $('.item').removeClass('active');
    $(this).addClass('active');
  });

  $('.split-list-toggle').click(function() {
    $('.split-list').toggleClass('slideLeft');
  });

  $(window).resize(function() {
    if ($(window).width() > 1024) {
      $('.split-list').length && $('.split-list').removeClass('slideLeft');
    }
  });
});
