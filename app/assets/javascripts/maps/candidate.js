$(document).on("turbolinks:load", function() {
  if($(".maps-candidate #map").length) {
    function initMap(candidateGeoData) {
      var addressSourceId = "candidate_address",
        zipcodeSourceId = "candidate_zipcode",
        zoom =  $("#map").data("zoom"),
        layers, sources,
        addressSourceData = candidateGeoData.sources[0],
        zipcodeSourceData = candidateGeoData.sources[1],
        center = determineCenter(addressSourceData, zipcodeSourceData),
        addressSource, zipcodeSource,
        addressLayer, zipcodeLayer, zipcodeHoverLayer,
        hoverLayerConfigs;

      addressSource = {
        id: addressSourceId,
        type: "geojson",
        data: addressSourceData
      };

      zipcodeSource = {
        id: zipcodeSourceId,
        type: "geojson",
        data: zipcodeSourceData
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

      sources = [addressSource];
      layers = [addressLayer];
      popupLayers = [addressSourceId];
      if (zipcodeSourceData.features.length) {
        
        sources.push(zipcodeSource);
        layers.push(zipcodeLayer)
        layers.push(zipcodeHoverLayer)
        popupLayers.push(zipcodeSourceId)

        hoverLayerConfig = {
          layers: [zipcodeLayer, zipcodeHoverLayer],
          hoverOffFilter: zipcodeHoverLayer.filter,
          hoverOnFilterFunction: function(feature) { return ["==", "zipcode", feature.properties.zipcode]; }
        };
        hoverLayerConfigs.push(hoverLayerConfig)
      }


      var map = new App.Map({
        center: center,
        zoom: zoom,
        sources: sources,
        layers: layers,
        popupLayers: popupLayers,
        hoverLayerConfigs: hoverLayerConfigs
      });
    };

    function determineCenter(addressSourceData, zipcodeSourceData) {
      if (addressSourceData.features.length == 1) {
        return addressSourceData.features[0].geometry.coordinates
      } else {
        return zipcodeSourceData.features[0].properties.center
      }
    };
    $.get({
      url: "/candidates/" + $("#map").data("id") + ".geojson",
      dataType: "json",
      success: initMap.bind(this)
    });
  }
});
