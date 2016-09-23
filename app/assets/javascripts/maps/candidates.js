$(document).on("turbolinks:load", function() {
  if($(".maps-candidates #map").length) {
    var dropdownStageSelector = ".maps-candidates .dropdown select";

    function watchSelect(map, stages) {
      $(document).on("change", dropdownStageSelector, function(event) {
        var currentStageId = this.value,
          isCurrentStage = function(stage) {
            return stage.id.toString() === currentStageId
          },
          currentStageName = stages.filter(isCurrentStage)[0].name,
          unselectedStages = _.reject(stages, isCurrentStage);

        map.popup.remove();

        _.each(unselectedStages, function(stage) {
          map.setLayoutProperty(stage.name, 'visibility', 'none');
        });
        map.setLayoutProperty(currentStageName, 'visibility', 'visible');
      });
    }

    function watchCardLink() {
      $(document).on("click", ".maps-candidates .candidates-cards", function(event) {
        event.preventDefault();
        Turbolinks.visit($(this).attr("href") + "?stage_id=" + $(dropdownStageSelector).val());
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

      watchCardLink();
    }

    $.get({
      url: "/candidates.geojson",
      dataType: "json",
      success: initMap.bind(this)
    });
  }
});
