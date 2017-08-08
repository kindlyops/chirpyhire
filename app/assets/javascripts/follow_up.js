$(function() {
  $("#tags a.add_fields").
    data("association-insertion-position", 'before').
    data("association-insertion-node", 'this');

  $('.follow-ups-tag-fields').on('cocoon:after-insert', function()
     $(this).children(".tag_from_list").remove();
     $(this).children("a.add_fields").hide();
   });

  $('#tags').on('cocoon:after-insert', function() {
     $(".follow-ups-tag-fields a.add_fields").
        data("association-insertion-position", 'before').
        data("association-insertion-node", 'this');

     $('.follow-ups-tag-fields').on('cocoon:after-insert', function() {
        $(this).children(".tag_from_list").remove();
        $(this).children("a.add_fields").hide();
      });
   });
});
