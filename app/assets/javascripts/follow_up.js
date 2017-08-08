$(function() {
  var formatTag = function(tag) {
    var formattedTag = '<span><i class="fa fa-tag mr-2"></i>' + tag.text + '</span>';
    return $(formattedTag);
  };

  $('.edit_choice_follow_up #tags select').select2({
    theme: 'bootstrap',
    placeholder: "Add a tag",
    allowClear: true,
    tags: true,
    tokenSeparators: [',', ' '],
    templateSelection: formatTag
  });
});
