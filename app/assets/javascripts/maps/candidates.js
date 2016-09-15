$(document).on("turbolinks:load", function() {
  if($(".maps-candidates #map").length) {
    var dropdownStageSelector = ".maps-candidates .dropdown select";

    function watchSelect(map, stage_infos) {
      $(document).on("change", dropdownStageSelector, function(event) {
        var currentStageId = this.value,
          isCurrentStage = function(stage_info) {
            return stage_info.id.toString() === currentStageId
          },
          currentStageName = stage_infos.filter(isCurrentStage)[0].name,
          unselectedStageInfos = _.reject(stage_infos, isCurrentStage);

        map.popup.remove();

        _.each(unselectedStageInfos, function(info) {
          map.setLayoutProperty(info.name, 'visibility', 'none');
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
      var styleId, center, zoom, layers, sources, stage_infos;
      styleId = "candidates";
      center = $("#map").data("center");
      zoom = $("#map").data("zoom");
      stage_infos = candidatesGeoData.stage_infos;

      sources = [{
        id: styleId,
        type: "geojson",
        data: candidatesGeoData
      }];

      layers = _.map(stage_infos, _.bind(function(info) {
        return {
          "id": info.name,
          "type": "symbol",
          "source": styleId,
          "layout": {
            "icon-image": "chirpyhire-marker-15",
            "visibility": $(dropdownStageSelector).val() === info.id.toString() ? 'visible' : 'none'
          },
          "filter": ["==", "stage_name", info.name]
        };
      }, this));

      var map = new App.Map({
        center: center,
        zoom: zoom,
        sources: sources,
        layers: layers,
        popupLayers: _.map(stage_infos, 'name')
      });

      if(map.loaded()) {
        watchSelect(map, stage_infos);
      } else {
        map.on('load', function() {
          watchSelect(map, stage_infos);
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
