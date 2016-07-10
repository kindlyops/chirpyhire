$(document).on("turbolinks:load", function() {
  var map = L.map('map', {minZoom: 10, maxZoom: 10});
  var layer = Tangram.leafletLayer({
    scene: '/scenes'
  });
  layer.addTo(map);
  map.setView([$('#map').data('lat'), $('#map').data('long')], 10);
  var marker = L.marker([$('#map').data('lat'), $('#map').data('long')]).addTo(map);
});
