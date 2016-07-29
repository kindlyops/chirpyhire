$(document).on("turbolinks:load", function() {
  if($("#map").length) {
    mapboxgl.accessToken = 'pk.eyJ1IjoiaGFycnl3IiwiYSI6ImNpb3lkYm1rdTAwYnd2Ym01c2tiZ3locjYifQ.LpY1AwiHQcBeOm9z-z5bNA';
    var map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/harryw/cioz0jzv4000kavm7ndil75zx',
        center: $("#map").data("center"),
        zoom: $("#map").data("zoom")
    });

    map.on('load', function() {
      map.addSource("candidate", {
        type: "geojson",
        data: "/candidates/" + $("#map").data("id") + ".geojson"
      });

      map.addLayer({
        "id": "candidate",
        "type": "symbol",
        "source": "candidate",
        "layout": {
          "icon-image": "chirpyhire-marker-15"
        }
      });
    });
  }
});
