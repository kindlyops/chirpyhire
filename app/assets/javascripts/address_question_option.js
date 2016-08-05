$(document).on("turbolinks:load", function() {
  if($(".question #address-question-option").length) {
    if($("#address-question-option .nested-fields").length) {
      $(".add_fields").hide();
    }

    $(document).on('cocoon:before-insert', '#address-question-option', function(e, option) {
      $(".add_fields").hide();
    });

    $(document).on('cocoon:after-remove', '#address-question-option', function(e, option) {
      $(".add_fields").show();
    });
  }
});
