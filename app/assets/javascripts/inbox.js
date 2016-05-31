(function($) {
    'use strict';

    var taskList = $('[data-task="list"]');
    var taskOpened = $('[data-task="opened"]');

    if (taskList.length) {
        taskList.ioslist();
    };

    $('body').on('click', '.item', function(e) {
        e.stopPropagation();

        var id = $(this).attr('data-task-id');
        var task = null;
        var thumbnailWrapper = $(this).find('.thumbnail-wrapper');
        $.each(data.tasks, function(i) {
            var obj = data.tasks[i];
            var list = obj.list;
            $.each(list, function(j) {
                if (list[j].id == id) {
                    task = list[j];

                    return;
                }
            });

            if (task != null) return;
        });

        taskOpened.find('.sender .name').text(task.from);
        taskOpened.find('.sender .datetime').text(task.datetime);
        taskOpened.find('.subject').text(task.subject);
        taskOpened.find('.task-content-body').html(task.body);

        var thumbnailClasses = thumbnailWrapper.attr('class').replace('d32', 'd48');
        taskOpened.find('.thumbnail-wrapper').attr('class', thumbnailClasses);

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


})(window.jQuery);
