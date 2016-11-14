$(document).on("turbolinks:load", function() {
  if($(".maps-candidates #map").length) {
    var dropdownStageSelector = ".maps-candidates .dropdown select",
      currentStageId = $(dropdownStageSelector).val(),
      mapType = $(".map-type i[selected]").attr('data-map-type'),
      stages,
      map,
      cache = {},
      useLocalStorage = hasLocalStorage()
      addressLayers = [],
      zipcodeLayers = [];

    function init() {
      $.get({
        url: "/candidates.geojson",
        dataType: "json",
        success: fetchZipcodeData
      });
    }

    function initMap(candidatesGeoData) {
      var addressSourceId = "candidates_address",
        zipcodeSourceId = "candidates_zipcode",
        center =  $("#map").data("center"),
        zoom = $("#map").data("zoom"),
        layers, sources,
        addressSource, zipcodeSource,
        nonHoverLayers;

      stages = candidatesGeoData.stages;
      addressSource = {
        id: addressSourceId,
        type: "geojson",
        data: candidatesGeoData.sources[0]
      };

      zipcodeSource = {
        id: zipcodeSourceId,
        type: "geojson",
        data: candidatesGeoData.sources[1]
      };

      sources = [addressSource, zipcodeSource];

      addressLayers = _.map(stages, function(stage) {
        var layerIds = getLayerIds(stage.name),
          visible = $(dropdownStageSelector).val() === stage.id.toString()
            && mapType === 'address';
        return {
          "id": layerIds.address,
          "type": "symbol",
          "source": addressSourceId,
          "layout": {
            "icon-image": App.MapsCommon.icon,
            "visibility": visible ? 'visible' : 'none'
          },
          "filter": ["==", "stage_name", stage.name]
        };
      });
      
      zipcodeLayersInfo = _.map(stages, function(stage) {
        var layerIds = getLayerIds(stage.name),
          visible = $(dropdownStageSelector).val() === stage.id.toString()
            && mapType === 'zipcode';
          standardLayer = {
            "id": layerIds.zipcode,
            "type": "fill",
            "source": zipcodeSourceId,
            "paint": App.MapsCommon.paintFill,
            "layout": {
              "visibility": visible ? 'visible' : 'none'
            },
            "filter": ["==", "stage_name", stage.name]
          },
          hoverLayer = {
            id: layerIds.zipcodeHover,
            "type": "fill",
            "source": zipcodeSourceId,
            "paint": App.MapsCommon.hoverPaintFill,
            "layout": {
              "visibility": visible ? 'visible' : 'none'
            },
            "filter": ["==", "zipcode", ""]
          };
        zipcodeLayers.push(standardLayer);
        zipcodeLayers.push(hoverLayer);
        return {
          layers: [standardLayer, hoverLayer],
          hoverOffFilter: hoverLayer.filter,
          hoverOnFilterFunction: function(feature) { return ["==", "zipcode", feature.properties.zipcode]; },
        }
      });

      layers = addressLayers.concat(_.flatten(_.map(zipcodeLayersInfo, 'layers')));
      nonHoverLayers = _.map(addressLayers.concat(_.map(zipcodeLayersInfo, function(info) { return info.layers[0] })), 'id');

      map = new App.Map({
        center: center,
        zoom: zoom,
        sources: sources,
        layers: layers,
        popupLayers: nonHoverLayers,
        hoverLayerConfigs: zipcodeLayersInfo
      });

      if(map.loaded()) {
        onMapLoad();
      } else {
        map.on('load', function() {
          onMapLoad();
        });
      }

      watchCardLink();
    };

    function fetchZipcodeData(candidatesGeoData) {
      var zipcodeSourceData = candidatesGeoData.sources[1],
        zipcodeFeatures = [],
        fetchedData = {},
        zipcodes = zipcodeSourceData.features.map(function(feature) { return feature.properties.zipcode; }),
        zipcodesToFetch = zipcodes.length,
        checkFinishedFetchingData = function() {
          zipcodesToFetch -= 1;
          if (zipcodesToFetch == 0) {
            zipcodeSourceData.features.forEach(function(feature) {
              var zipcode = feature.properties.zipcode,
                data = getItem(zipcode);
              if (data) {
                data = JSON.parse(data);
                feature.geometry = data.geometry;
                feature.properties.center = data.geometry.center;
                zipcodeFeatures.push(feature);
              }
            });
            zipcodeSourceData.features = zipcodeFeatures;
            initMap(candidatesGeoData);
          }
        };
      if (zipcodesToFetch > 0) {
        zipcodes.forEach(function(zipcode) {
          if (!getItem(zipcode)) {
            $.get({
              url: "/zipcode/" + zipcode,
              dataType: "text",
              success: function(featureJson) {
                setItem(zipcode, featureJson);
              }
            }).always(checkFinishedFetchingData);
          } else {
            checkFinishedFetchingData();
          }
        })
      }
      else {
        initMap(candidatesGeoData);
      }
    }

    function getLayerIds(stage_name) {
      return {
        address: stage_name + "_address",
        zipcode: stage_name + "_zipcode",
        zipcodeHover: stage_name + "_zipcode_hover"
      };
    }

    function isCurrentStage(currentStageId) {
      return function(stage) {
        return stage.id.toString() === currentStageId;
      };
    }

    function currentLayers() {
      var isCurrentStageFunc = isCurrentStage(currentStageId),
        currentStageName = stages.filter(isCurrentStageFunc)[0].name;
      return getLayerIds(currentStageName);
    }

    function watchSelect() {
      $(document).on("change", dropdownStageSelector, function(event) {
        var currentLayerIds,
          unselectedStages;
        currentStageId = this.value;

        currentLayerIds = currentLayers();
        unselectedStages = _.reject(stages, isCurrentStage(currentStageId));

        map.popup.remove();

        _.each(unselectedStages, function(stage) {
          if (mapType === 'address') {
            map.setLayoutProperty(getLayerIds(stage.name).address, 'visibility', 'none');
          } else {
            map.setLayoutProperty(getLayerIds(stage.name).zipcode, 'visibility', 'none');
            map.setLayoutProperty(getLayerIds(stage.name).zipcodeHover, 'visibility', 'none');
          }
        });
        if (mapType === 'address') {
          map.setLayoutProperty(currentLayerIds.address, 'visibility', 'visible');
        } else {
          map.setLayoutProperty(currentLayerIds.zipcode, 'visibility', 'visible');
          map.setLayoutProperty(currentLayerIds.zipcodeHover, 'visibility', 'visible');
        }
      });
    }

    function watchMapType() {
      $(".button-group.map-type").on("click", function(event) {
        var $target = $(event.target),
          currentLayersIds = currentLayers(),
          addressVisibleValue,
          zipcodeVisibleValue;
        if (!$target.attr('selected')) {
          $target.attr('selected', true)
          $(".map-type i[data-map-type='" + mapType + "']").removeAttr('selected');
          mapType = $target.attr('data-map-type');

          addressVisibleValue = mapType === 'address'
            ? 'visible'
            : 'none';
          zipcodeVisibleValue = mapType === 'zipcode'
            ? 'visible'
            : 'none';

          map.setLayoutProperty(currentLayersIds.address, 'visibility', addressVisibleValue);
          map.setLayoutProperty(currentLayersIds.zipcode, 'visibility', zipcodeVisibleValue);
          map.setLayoutProperty(currentLayersIds.zipcodeHover, 'visibility', zipcodeVisibleValue);
        }
      });
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

    function onMapLoad() {
      watchMapType();
      watchSelect();
    }

    function watchCardLink() {
      $(document).on("click", ".maps-candidates .candidates-cards", function(event) {
        var url = 
          $(this).attr("href") 
          + "?stage_name=" 
          + stages.filter(isCurrentStage($(dropdownStageSelector).val()))[0].name;
        event.preventDefault();
        Turbolinks.visit(url);
      });
    }

    init();
  }
});
