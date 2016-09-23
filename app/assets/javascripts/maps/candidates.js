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
          map.setLayoutProperty(stage.name, 'visibility', 'none');
        });
        map.setLayoutProperty(currentStageName, 'visibility', 'visible');
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

    function initMap(candidatesGeoData) {
      var styleId, center, zoom, layers, sources, stages;
      styleId = "candidates";
      center = $("#map").data("center");
      zoom = $("#map").data("zoom");
      stages = candidatesGeoData.stages;

      sources = [{
        id: styleId,
        type: "geojson",
        data: candidatesGeoData
      }];

      layers = _.map(stages, _.bind(function(stage) {
        return {
          "id": stage.name,
          "type": "symbol",
          "source": styleId,
          "layout": {
            "icon-image": "chirpyhire-marker-15",
            "visibility": $(dropdownStageSelector).val() === stage.id.toString() ? 'visible' : 'none'
          },
          "filter": ["==", "stage_name", stage.name]
        };
      }, this));

      var map = new App.Map({
        center: center,
        zoom: zoom,
        sources: sources,
        layers: layers,
        popupLayers: _.map(stages, 'name')
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
