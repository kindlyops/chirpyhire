App.Map = function($mapEl, sourceName) {
  this.sourceName = sourceName;
  mapboxgl.accessToken = mapboxgl.accessToken || 'pk.eyJ1IjoiaGFycnl3IiwiYSI6ImNpb3lkYm1rdTAwYnd2Ym01c2tiZ3locjYifQ.LpY1AwiHQcBeOm9z-z5bNA';
  this._map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/harryw/cioz0jzv4000kavm7ndil75zx',
      center: $mapEl.data("center"),
      zoom: $mapEl.data("zoom")
  });
};

App.Map.prototype = {
  addLayer: function(args) {
    var sourceUrl = args.sourceUrl;
    var sourceType = args.sourceType;
    var icon = args.icon;
    var sourceName = this.sourceName;
    var map = this._map;

    map.on('load', function() {
      map.addSource(sourceName, {
        type: sourceType,
        data: sourceUrl
      });

      map.addLayer({
        "id": sourceName,
        "type": "symbol",
        "source": sourceName,
        "layout": {
          "icon-image": icon
        }
      });
    });
  },
  addPopup: function(args) {
    var popup = new mapboxgl.Popup({
      closeButton: false,
      closeOnClick: false
    });
    var sourceName = this.sourceName;
    var map = this._map;

    map.on('mousemove', function(e) {
      var features = map.queryRenderedFeatures(e.point, { layers: [sourceName] });
      map.getCanvas().style.cursor = (features.length) ? 'pointer' : '';

      if (!features.length) {
          popup.remove();
          return;
      }

      var feature = features[0];
      popup.setLngLat(feature.geometry.coordinates)
          .setHTML(feature.properties.description)
          .addTo(map);
    });
  }
};
