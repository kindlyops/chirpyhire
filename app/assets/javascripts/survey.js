$(document).on("turbolinks:load", function() {
  if($(".survey .survey-question #map").length) {
    var zoom = 8;
    var longitude = $("#map").data("longitude");
    var latitude = $("#map").data("latitude");
    var center = [longitude, latitude];
    var distance = $("#map").data("distance");
    var styleId = "point";

    function milesToPixelsAtMaxZoom(miles, latitude) {
      var milesPerPixel = 0.00004660282;
      return miles / milesPerPixel / Math.cos(latitude * Math.PI / 180);
    }

    var layers = [{
      "id": styleId,
      "type": "circle",
      "source": styleId,
      "paint": {
        "circle-opacity": 0.3,
        "circle-radius": {
          "stops": [
            [0, 0],
            [20, milesToPixelsAtMaxZoom(distance, latitude)]
          ],
          "base": 2
        },
        "circle-color": "#3887be"
      }
    }];

    var geojson = {
      "type": "FeatureCollection",
      "features": [{
        "type": "Feature",
        "geometry": {
          "type": "Point",
          "coordinates": [longitude, latitude]
        }
      }]
    };

    var sources = [{
      id: styleId,
      type: "geojson",
      data: geojson
    }];

    var map = new App.Map({
      center: center,
      zoom: zoom,
      sources: sources,
      layers: layers
    });
  };
});
