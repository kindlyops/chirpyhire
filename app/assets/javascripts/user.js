$(document).on("page:change", function() {
  $(".user").on("click", ".send-chirp, .cancel-chirp", function(e) {
    if($("form.new_chirp").length) {
      e.stopPropagation();
      e.preventDefault();
      $("form.new_chirp").remove();
      $('.main-content-wrapper').css('height', 'calc(100% - 150px)')
    }
  });

  if ($('.user section.timeline').length) {
    setInterval(function() {
      if($('.user').data('id')) {
        $.get("/users/" + $('.user').data('id') + "/activities").then(function(data) {
          $('section.timeline').html(data);
        });
      }
    }, 3000);
  }

  if ($('#map').length) {
    var map = L.map('map');
    var layer = Tangram.leafletLayer({
      scene: '/scenes',
      attribution: '<a href="https://mapzen.com/tangram" target="_blank">Tangram</a> | <a href="http://www.openstreetmap.org/about" target="_blank">&copy; OSM contributors | <a href="https://mapzen.com/" target="_blank">Mapzen</a>',
    });
    layer.addTo(map);
    map.setView([$('#map').data('lat'), $('#map').data('long')], 16);
  }

  $(".user").on("change", "select#candidate_status", function(e) {
    var editCandidateForm = $("form.edit_candidate");
    $.ajax({
      url: editCandidateForm.attr("action"),
      data: editCandidateForm.serialize(),
      method: 'PUT',
      dataType: 'html'
    }).done(function(data) {
      var authToken = $(data).find("input[name='authenticity_token']");
      $("form.edit_user input[name='authenticity_token']").replaceWith(authToken);
    });
  });
});
