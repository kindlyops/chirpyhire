$(document).on("turbolinks:load", function() {
  if($(".candidate #map").length) {
    var map = new App.Map($("#map"), "candidate");
    map.addLayer({
      sourceUrl: "/candidates/" + $("#map").data("id") + ".geojson",
      sourceType: "geojson",
      icon: "chirpyhire-marker-15"
    });
    map.addPopup();
  }
});
