$(function() {
  var formatTag = function(tag) {
    var formattedTag = '<span><i class="fa fa-tag mr-2"></i>' + tag.text + '</span>';
    return $(formattedTag);
  };

  var selects = [
    '.new_follow_up #tags select',
    '.edit_follow_up #tags select'
  ];

  selects.forEach(function(select) {
    $(select).select2({
      theme: 'bootstrap',
      placeholder: "Add a tag",
      allowClear: true,
      tags: true,
      tokenSeparators: [','],
      templateSelection: formatTag
    });
  });
});
