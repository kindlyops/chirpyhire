$(document).on("turbolinks:load", function() {
  if($(".maps-candidates #map").length) {
    var dropdownStageSelector = ".maps-candidates .dropdown select",
      isCurrentStageFunc = function(currentStageId) {
        return function(stage) {
          return stage.id.toString() === currentStageId
        }
      };

    function watchSelect(map, stages) {
      $(document).on("change", dropdownStageSelector, function(event) {
        var currentStageId = this.value,
          isCurrentStage = isCurrentStageFunc(currentStageId)
          currentStageName = 
            stages.filter(isCurrentStage)[0].name,
          unselectedStages = _.reject(stages, isCurrentStage);

        map.popup.remove();

        _.each(unselectedStages, function(stage) {
          getOrderedLayerIds(stage.name).forEach(function(layer_id) {
            map.setLayoutProperty(layer_id, 'visibility', 'none');
          });
        });
        getOrderedLayerIds(currentStageName).forEach(function(layer_id) {
          map.setLayoutProperty(layer_id, 'visibility', 'visible');
        });
      });
    }

    function watchCardLink(stages) {
      $(document).on("click", ".maps-candidates .candidates-cards", function(event) {
        var url = 
          $(this).attr("href") 
          + "?stage_name=" 
          + stages.filter(isCurrentStageFunc($(dropdownStageSelector).val()))[0].name;
        event.preventDefault();
        Turbolinks.visit(url);
      });
    }

    function getOrderedLayerIds(stage_name) {
      return [
        stage_name + "_address",
        stage_name + "_zipcode",
        stage_name + "_zipcode_hover"
      ]
    }

    function initMap(candidatesGeoData) {
      var addressSourceId = "candidates_address",
        zipcodeSourceId = "candidates_zipcode",
        center =  $("#map").data("center"),
        zoom = $("#map").data("zoom"),
        stages = candidatesGeoData.stages,
        layers, sources,
        addressSource, zipcodeSource,
        addressLayers, zipcodeLayers,
        zipcodeLayersInfo,
        nonHoverLayers;

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
        layerIds = getOrderedLayerIds(stage.name);
        return {
          "id": layerIds[0],
          "type": "symbol",
          "source": addressSourceId,
          "layout": {
            "icon-image": App.MapsCommon.icon,
            "visibility": $(dropdownStageSelector).val() === stage.id.toString() ? 'visible' : 'none'
          },
          "filter": ["==", "stage_name", stage.name]
        };
      });
      
      zipcodeLayersInfo = _.map(stages, function(stage) {
        layerIds = getOrderedLayerIds(stage.name);
        standardLayer = {
          "id": layerIds[1],
          "type": "fill",
          "source": zipcodeSourceId,
          "paint": App.MapsCommon.paintFill,
          "layout": {
            "visibility": $(dropdownStageSelector).val() === stage.id.toString() ? 'visible' : 'none'
          },
          "filter": ["==", "stage_name", stage.name]
        };
        hoverLayer = {
          id: layerIds[2],
          "type": "fill",
          "source": zipcodeSourceId,
          "paint": App.MapsCommon.hoverPaintFill,
          "layout": {
            "visibility": $(dropdownStageSelector).val() === stage.id.toString() ? 'visible' : 'none'
          },
          "filter": ["==", "zipcode", ""]
        };
        return {
          triggerLayer: standardLayer
          hoverLayer: hoverLayer
          hoverOffFilter: hoverLayer.filter,
          hoverOnFilterFunction: function(feature) { return ["==", "zipcode", feature.properties.zipcode]; },
        }
      });

      zipcodeLayers = _.flatten(_.map(zipcodeLayersInfo, function(info) { [info.triggerLayer, info.hoverLayer] }))
      layers = addressLayers.concat(zipcodeLayers);
      nonHoverLayers = _.map(addressLayers.concat(_.map(zipcodeLayersInfo, 'triggerLayer' })), 'id');

      var map = new App.Map({
        center: center,
        zoom: zoom,
        sources: sources,
        layers: layers,
        popupLayers: nonHoverLayers,
        hoverLayerConfigs: zipcodeLayersInfo
      });

      if(map.loaded()) {
        watchSelect(map, stages);
      } else {
        map.on('load', function() {
          watchSelect(map, stages);
        });
      }

      watchCardLink(stages);
    }

    $.get({
      url: "/candidates.geojson",
      dataType: "json",
      success: initMap.bind(this)
    });
  }
});
