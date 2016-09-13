$(document).on("turbolinks:load", function() {
  if($(".maps-candidates #map").length) {
    var dropdownStageSelector = ".maps-candidates .dropdown select";

    function watchSelect(map, stage_ids) {
      $(document).on("change", dropdownStageSelector, function(event) {
        var currentStageId = this.value;
        var unselectedStageIds = _.reject(stage_ids, function(id) {
          return id === currentStageId;
        });

        map.popup.remove();

        _.each(unselectedStageIds, function(id) {
          map.setLayoutProperty(id, 'visibility', 'none');
        });
        map.setLayoutProperty(currentStageId, 'visibility', 'visible');
      });
    }

    function watchCardLink() {
      $(document).on("click", ".maps-candidates .candidates-cards", function(event) {
        event.preventDefault();
        Turbolinks.visit($(this).attr("href") + "?stage_id=" + $(dropdownStageSelector).val());
      });
    }

    function initMap(candidatesGeoData) {
      var styleId, center, zoom, layers, sources, stage_ids;
      styleId = "candidates";
      center = $("#map").data("center");
      zoom = $("#map").data("zoom");
      stage_ids = candidatesGeoData.stage_ids;

      sources = [{
        id: styleId,
        type: "geojson",
        data: candidatesGeoData
      }];

      layers = _.map(stage_ids, _.bind(function(stage_id) {
        return {
          "id": stage_id,
          "type": "symbol",
          "source": styleId,
          "layout": {
            "icon-image": "chirpyhire-marker-15",
            "visibility": $(dropdownStageSelector).val() === stage_id ? 'visible' : 'none'
          },
          "filter": ["==", "stage_id", stage_id]
        };
      }, this));

      var map = new App.Map({
        center: center,
        zoom: zoom,
        sources: sources,
        layers: layers,
        popupLayers: stage_ids // TODO not sure about this one
      });

      if(map.loaded()) {
        watchSelect(map, stage_ids);
      } else {
        map.on('load', function() {
          watchSelect(map, stage_ids);
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
