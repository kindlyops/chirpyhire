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
        addressSource, zipcodeSource,
        addressLayer, zipcodeLayer, zipcodeHoverLayer,
        hoverLayerConfig;

      addressSource = {
        id: addressSourceId,
        type: "geojson",
        data: candidateGeoData.sources[0]
      };

      zipcodeSource = {
        id: zipcodeSourceId,
        type: "geojson",
        data: candidateGeoData.sources[1]
      };

      addressLayer = {
        "id": addressSourceId,
        "type": "symbol",
        "source": addressSourceId,
        "layout": {
          "icon-image": App.MapsCommon.icon
        }
      };

      zipcodeLayer = {
        "id": zipcodeSourceId,
        "type": "fill",
        "source": zipcodeSourceId,
        "paint": App.MapsCommon.paintFill
      };

      zipcodeHoverLayer = {
        "id": zipcodeSourceId + "_hover",
        "type": "fill",
        "source": zipcodeSourceId,
        "paint": App.MapsCommon.hoverPaintFill,
        "filter": ["==", "zipcode", ""]
      };

      sources = [addressSource, zipcodeSource];
      layers = [addressLayer, zipcodeLayer, zipcodeHoverLayer];

      popupLayers = [addressSourceId, zipcodeSourceId];
      hoverLayerConfig = {
        layers: [zipcodeLayer, zipcodeHoverLayer],
        hoverOffFilter: zipcodeHoverLayer.filter,
        hoverOnFilterFunction: function(feature) { return ["==", "zipcode", feature.properties.zipcode]; }
      };

      var map = new App.Map({
        center: center,
        zoom: zoom,
        sources: sources,
        layers: layers,
        popupLayers: popupLayers,
        hoverLayerConfigs: [hoverLayerConfig]
      });
    }

    $.get({
      url: "/candidates/" + $("#map").data("id") + ".geojson",
      dataType: "json",
      success: initMap.bind(this)
    });
  }
});
