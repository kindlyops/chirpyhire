$(function() {
  var formatTag = function(tag) {
    var formattedTag = '<span><i class="fa fa-tag mr-2"></i>' + tag.text + '</span>';
    return $(formattedTag);
  };

  $('#tags select').select2({
    theme: 'bootstrap',
    placeholder: "Add a tag",
    allowClear: true,
    tags: true,
    tokenSeparators: [','],
    templateSelection: formatTag
  });

  calculateFollowUpRanks = function(followUps) {
    var eachWithIndex = R.addIndex(R.forEach)

    eachWithIndex(function(followUp, i) {
      $(followUp).find('.follow-up-rank').val(i + 1);
    }, followUps);
  }

  $('#follow-ups').on('cocoon:after-remove', function(e, item) {
    calculateFollowUpRanks($('#follow-ups .nested-fields'));
  });

  $('#follow-ups').on('cocoon:after-insert', function(e, item) {
    var responseName = item.find('#response').attr('name');
    var baseName = responseName.match(/.+?(?=\[response\])/)[0];
    item.find('#tags-label').attr('name', baseName + '[tags][]');
    var tags = item.find('#tags-select');
    tags.attr('name', baseName + '[tags][]');
    tags.select2({
      theme: 'bootstrap',
      placeholder: "Add a tag",
      allowClear: true,
      tags: true,
      tokenSeparators: [','],
      templateSelection: formatTag
    });

    calculateFollowUpRanks($('#follow-ups .nested-fields'));
  });
});
