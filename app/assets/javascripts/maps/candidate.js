$(document).on("turbolinks:load", function() {
  if($(".maps-candidate #map").length) {
    var useLocalStorage = hasLocalStorage(),
      cache = {};
    function fetchZipcodeData(candidateGeoData) {
      var zipcodeSourceData = candidateGeoData.sources[1],
        feature = zipcodeSourceData.features[0],
        zipcode = feature.properties.zipcode,
        loadMapAfterLoadingZipcodeData = function() {
          var data = JSON.parse(getItem(zipcode));
          feature.geometry = data.geometry;
          feature.properties.center = data.geometry.center;
          initMap(candidateGeoData);
        };

      if (!getItem(zipcode)) {
        $.get({
          url: "/zipcode/" + zipcode,
          dataType: "text",
          success: function(featureJson) {
            if (featureJson) {
              setItem(zipcode, featureJson);
              loadMapAfterLoadingZipcodeData();
            }
          }
        });
      } else {
        loadMapAfterLoadingZipcodeData();
      }
    }

    function initMap(candidateGeoData) {
      var addressSourceId = "candidate_address",
        zipcodeSourceId = "candidate_zipcode",
        zoom = $("#map").data("zoom"),
        addressSourceData = candidateGeoData.sources[0],
        zipcodeSourceData = candidateGeoData.sources[1],
        center = determineCenter(addressSourceData, zipcodeSourceData),
        addressLayer = buildAddressLayer(addressSourceId),
        zipcodeLayer = buildZipcodeLayer(zipcodeSourceId),
        zipcodeHoverLayer = buildZipcodeHoverLayer(zipcodeSourceId),
        layers = [addressLayer],
        addressSource = {
          id: addressSourceId,
          type: "geojson",
          data: addressSourceData
        },
        zipcodeSource = {
          id: zipcodeSourceId,
          type: "geojson",
          data: zipcodeSourceData
        },
        sources = [addressSource],
        popupLayers = [addressSourceId],
        hoverLayerConfigs = [];

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

    function buildAddressLayer(sourceId) {
      return {
        "id": sourceId,
        "type": "symbol",
        "source": sourceId,
        "layout": {
          "icon-image": App.MapsCommon.icon
        }
      };
    };

    function buildZipcodeLayer(souceId) {
      return {
        "id": souceId,
        "type": "fill",
        "source": souceId,
        "paint": App.MapsCommon.paintFill
      };
    };

    function buildZipcodeHoverLayer(sourceId) {
      return {
        "id": sourceId + "_hover",
        "type": "fill",
        "source": sourceId,
        "paint": App.MapsCommon.hoverPaintFill,
        "filter": ["==", "zipcode", ""]
      };
    }

    function setItem(key, item) {
      if (useLocalStorage) {
        localStorage.setItem(key, item);
      } else {
        cache[key] = item;
      }
    }

    function getItem(key) {
      if (useLocalStorage) {
        return localStorage.getItem(key);
      } else {
        return cache[key];
      }
    }

    function hasLocalStorage() {
      var test = 'test';
      try {
        localStorage.setItem(test, test);
        localStorage.removeItem(test);
        return true;
      } catch(e) {
        return false;
      }
    }

    function determineCenter(addressSourceData, zipcodeSourceData) {
      if (addressSourceData.features.length === 1) {
        return addressSourceData.features[0].geometry.coordinates
      } else {
        return zipcodeSourceData.features[0].properties.center
      }
    };

    $.get({
      url: "/candidates/" + $("#map").data("id") + ".geojson",
      dataType: "json",
      success: fetchZipcodeData
    });
  }
});
