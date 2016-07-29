$(document).on("turbolinks:load", function() {
  if($("#map").length) {
    mapboxgl.accessToken = 'pk.eyJ1IjoiaGFycnl3IiwiYSI6ImNpb3lkYm1rdTAwYnd2Ym01c2tiZ3locjYifQ.LpY1AwiHQcBeOm9z-z5bNA';
    var map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/harryw/cioz0jzv4000kavm7ndil75zx',
        center: $("#map").data("center"),
        zoom: $("#map").data("zoom")
    });

    map.on('load', function() {
      map.addSource("candidates", {
        type: "geojson",
        data: "/candidates.geojson" + location.search
      });

      map.addLayer({
        "id": "candidates",
        "type": "symbol",
        "source": "candidates",
        "layout": {
          "icon-image": "chirpyhire-marker-15"
        }
      });
    });

    var popup = new mapboxgl.Popup({
      closeButton: false,
      closeOnClick: false
    });

    map.on('mousemove', function(e) {
      var features = map.queryRenderedFeatures(e.point, { layers: ['candidates'] });
      // Change the cursor style as a UI indicator.
      map.getCanvas().style.cursor = (features.length) ? 'pointer' : '';

      if (!features.length) {
          popup.remove();
          return;
      }

      var feature = features[0];

      // Populate the popup and set its coordinates
      // based on the feature found.
      popup.setLngLat(feature.geometry.coordinates)
          .setHTML(feature.properties.description)
          .addTo(map);
    });
  }



  $(document).on("click", ".card-call-to-actions button", function(event) {
    var $button = $(this);
    Turbolinks.visit($button.find('a').attr('href'));
  });

  $(document).on("change", ".dropdown select", function(event) {
    var newSearch, queryParamRegExp;
    var search = location.search;
    var queryParam = this.name + "=" + this.value;
    newSearch = search.replace(/\?page=\d/, "?").replace(/&page=\d/, "");

    if (!newSearch) {
      Turbolinks.visit(location.pathname + "?" + queryParam);
    } else {
      queryParamRegExp = new RegExp("(" + this.name + "=[^\&]+)");

      if (newSearch.match(queryParamRegExp)) {
        newSearch = newSearch.replace(queryParamRegExp, queryParam);
      } else {
        newSearch = newSearch + "&" + queryParam;
      }

      Turbolinks.visit(location.pathname + newSearch);
    }
  });
});
