$(document).on("turbolinks:load", function() {
  if($(".maps-candidate #map").length) {
    function initMap(candidates) {
      var styleId, center, zoom, layers, sources, popupLayers;
      styleId = "candidate";
      center = candidates.features[0].geometry.coordinates
      zoom = $("#map").data("zoom");

      sources = [{
        id: styleId,
        type: "geojson",
        data: candidates
      }];

      layers = [{
        "id": styleId,
        "type": "symbol",
        "source": styleId,
        "layout": {
          "icon-image": "chirpyhire-marker-15"
        }
      }];

      popupLayers = [styleId];

      var map = new App.Map({
        center: center,
        zoom: zoom,
        sources: sources,
        layers: layers,
        popupLayers: popupLayers
      });
    }

    $.get({
      url: "/candidates/" + $("#map").data("id") + ".geojson",
      dataType: "json",
      success: initMap.bind(this)
    });
  }
});
