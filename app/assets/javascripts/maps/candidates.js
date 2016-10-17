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
      return [stage_name + "_address", stage_name + "_zipcode"]
    }

    function initMap(candidatesGeoData) {
      var addressSourceId = "candidates_address",
        zipcodeSourceId = "candidates_zipcode",
        center =  $("#map").data("center"),
        zoom = $("#map").data("zoom"),
        stages = candidatesGeoData.stages,
        layers, sources,
        address_source,zipcode_source,
        address_layers, zipcode_layers;

      address_source = {
        id: addressSourceId,
        type: "geojson",
        data: candidatesGeoData.sources[0]
      };

      zipcode_source = {
        id: zipcodeSourceId,
        type: "geojson",
        data: candidatesGeoData.sources[1]
      };

      sources = [address_source, zipcode_source];

      address_layers = _.map(stages, function(stage) {
        layer_ids = getOrderedLayerIds(stage.name);
        return {
          "id": layer_ids[0],
          "type": "symbol",
          "source": addressSourceId,
          "layout": {
            "icon-image": "chirpyhire-marker-15",
            "visibility": $(dropdownStageSelector).val() === stage.id.toString() ? 'visible' : 'none'
          },
          "filter": ["==", "stage_name", stage.name]
        };
      });
      
      zipcode_layers = _.map(stages, function(stage) {
        layer_ids = getOrderedLayerIds(stage.name);
        return {
          "id": layer_ids[1],
          "type": "fill",
          "source": zipcodeSourceId,
          "paint": {
            "fill-color": "rgba(100, 100, 100, 0.2)"
          },
          "layout": {
            "visibility": $(dropdownStageSelector).val() === stage.id.toString() ? 'visible' : 'none'
          },
          "filter": ["==", "stage_name", stage.name]
        };
      });

      layers = _.flatten([address_layers, zipcode_layers])

      var map = new App.Map({
        center: center,
        zoom: zoom,
        sources: sources,
        layers: layers,
        popupLayers: _.map(layers, 'id')
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
