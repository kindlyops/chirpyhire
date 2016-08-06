$(document).on("turbolinks:load", function() {
  if($(".maps-candidates #map").length) {
    function watchSelect(map, statuses) {
      $(document).on("change", ".maps-candidates .dropdown select", function(event) {
        var currentStatus = this.value;
        var unselectedStatuses = _.reject(statuses, function(status) {
          return status === currentStatus;
        });

        map.popup.remove();

        _.each(unselectedStatuses, function(status) {
          map.setLayoutProperty(status, 'visibility', 'none');
        });
        map.setLayoutProperty(currentStatus, 'visibility', 'visible');
      });
    }

    function watchCardLink() {
      $(document).on("click", ".maps-candidates .candidates-cards", function(event) {
        event.preventDefault();
        Turbolinks.visit($(this).attr("href") + "?status=" + $(".maps-candidates .dropdown select").val());
      });
    }

    function initMap(candidates) {
      var styleId, center, zoom, layers, sources, statuses;
      styleId = "candidates";
      center = $("#map").data("center");
      zoom = $("#map").data("zoom");
      statuses = candidates.statuses;

      sources = [{
        id: styleId,
        type: "geojson",
        data: candidates
      }];

      layers = _.map(statuses, _.bind(function(status) {
        return {
          "id": status,
          "type": "symbol",
          "source": styleId,
          "layout": {
            "icon-image": "chirpyhire-marker-15",
            "visibility": $(".maps-candidates .dropdown select").val() === status ? 'visible' : 'none'
          },
          "filter": ["==", "status", status]
        };
      }, this));

      var map = new App.Map({
        center: center,
        zoom: zoom,
        sources: sources,
        layers: layers,
        popupLayers: statuses
      });

      if(map.loaded()) {
        watchSelect(map, statuses);
      } else {
        map.on('load', function() {
          watchSelect(map, statuses);
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
