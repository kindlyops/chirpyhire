$(document).on("turbolinks:load", function() {
  if($(".maps-candidate #map").length) {
    function determineCenter(candidateGeoData) {
      if (candidateGeoData.sources[0].features.length == 1) {
        return candidateGeoData.sources[0].features[0].geometry.coordinates
      } else {
        return candidateGeoData.sources[1].features[0].properties.center
      }
    };

    function initMap(candidateGeoData) {
      var addressSourceId = "candidate_address",
        zipcodeSourceId = "candidate_zipcode",
        center = determineCenter(candidateGeoData),
        zoom =  $("#map").data("zoom"),
        layers, sources,
        address_source, zipcode_source,
        address_layer, zipcode_layer;


      address_source = {
        id: addressSourceId,
        type: "geojson",
        data: candidateGeoData.sources[0]
      };

      zipcode_source = {
        id: zipcodeSourceId,
        type: "geojson",
        data: candidateGeoData.sources[1]
      };

      address_layer = {
        "id": addressSourceId,
        "type": "symbol",
        "source": addressSourceId,
        "layout": {
          "icon-image": App.MapsCommon.icon
        }
      };

      zipcode_layer = {
        "id": zipcodeSourceId,
        "type": "fill",
        "source": zipcodeSourceId,
        "paint": App.MapsCommon.paintFill
      }

      sources = [address_source, zipcode_source];
      layers = [address_layer, zipcode_layer];

      popupLayers = [addressSourceId, zipcodeSourceId];

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
