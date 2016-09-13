$(document).on("turbolinks:load", function() {
  if($(".maps-candidates #map").length) {
    var dropdownStageSelector = ".maps-candidates .dropdown select";
    function watchSelect(map, stages) {
      $(document).on("change", dropdownStageSelector, function(event) {
        var currentStage = this.value;
        var unselectedStages = _.reject(stages, function(stage) {
          return stage === currentStage;
        });

        map.popup.remove();

        _.each(unselectedStages, function(stage) {
          map.setLayoutProperty(stage, 'visibility', 'none');
        });
        map.setLayoutProperty(currentStage, 'visibility', 'visible');
      });
    }

    function watchCardLink() {
      $(document).on("click", ".maps-candidates .candidates-cards", function(event) {
        event.preventDefault();
        Turbolinks.visit($(this).attr("href") + "?stage=" + $(dropdownStageSelector).val());
      });
    }

    function initMap(candidates) {
      var styleId, center, zoom, layers, sources, stages;
      styleId = "candidates";
      center = $("#map").data("center");
      zoom = $("#map").data("zoom");
      stages = candidates.stages;

      sources = [{
        id: styleId,
        type: "geojson",
        data: candidates
      }];

      layers = _.map(stages, _.bind(function(stage) {
        return {
          "id": stage,
          "type": "symbol",
          "source": styleId,
          "layout": {
            "icon-image": "chirpyhire-marker-15",
            "visibility": $(dropdownStageSelector).val() === stage ? 'visible' : 'none'
          },
          "filter": ["==", "stage", stage]
        };
      }, this));

      var map = new App.Map({
        center: center,
        zoom: zoom,
        sources: sources,
        layers: layers,
        popupLayers: stages
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
