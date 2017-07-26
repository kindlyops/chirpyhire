$(function() {
  $('body').on('change', 'input[type="file"][data-toggle="custom-file"]', function (ev) {
    var $input = $(this);
    var target = $input.data('target');
    var $target = $(target);

    if (!$target.length)
      return console.error('Invalid target for custom file', $input);

    if (!$target.attr('data-content'))
      return console.error('Invalid `data-content` for custom file target', $input);

    // set original content so we can revert if user deselects file
    if (!$target.attr('data-original-content'))
      $target.attr('data-original-content', $target.attr('data-content'));

    var input = $input.get(0);

    var name = _.isObject(input)
      && _.isObject(input.files)
      && _.isObject(input.files[0])
      && _.isString(input.files[0].name) ? input.files[0].name : $input.val();

    if (_.isNull(name) || name === '')
      name = $target.attr('data-original-content');

    $target.attr('data-content', name);
  });
})
