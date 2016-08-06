$(document).on("turbolinks:load", function() {
  var map;
  var defaultDistance = 10;

  function initMap() {
    var zoom, longitude, latitude, center, styleId, geojson, sources, layers,
    distance, setCoordinatesInForm, setCoordinatesInFormByMouse, setCoordinatesInFormByTouch;

    zoom = 8;
    longitude = $("#address_question_address_question_option_attributes_longitude").val();
    if(!longitude) {
      longitude = $("#map").data("longitude");
      $("#address_question_address_question_option_attributes_longitude").val(longitude);
    }

    latitude = $("#address_question_address_question_option_attributes_latitude").val();
    if(!latitude) {
      latitude = $("#map").data("latitude");
      $("#address_question_address_question_option_attributes_latitude").val(latitude);
    }
    center = [longitude, latitude];

    styleId = "point";

    geojson = {
      "type": "FeatureCollection",
      "features": [{
        "type": "Feature",
        "geometry": {
          "type": "Point",
          "coordinates": center
        }
      }]
    }

    sources = [{
      id: styleId,
      type: "geojson",
      data: geojson
    }];

    distance = $("#address_question_address_question_option_attributes_distance").val();
    distance = distance || defaultDistance;

    layers = [{
      "id": styleId,
      "type": "circle",
      "source": styleId,
      "paint": {
        "circle-opacity": 0.3,
        "circle-radius": {
          "stops": [
            [0, 0],
            [20, App.Map.milesToPixelsAtMaxZoom(distance, latitude)]
          ],
          "base": 2
        },
        "circle-color": "#3887be"
      }
    }];

    map = new App.Map({
      center: center,
      zoom: zoom,
      sources: sources,
      layers: layers,
      draggableLayer: styleId
    });

    setCoordinatesInForm = function(coordsGenerator) {
      return function(e) {
        if (!map.isDragging) return;
        var coords = coordsGenerator(e);
        $("#address_question_address_question_option_attributes_longitude").val(coords.lng);
        $("#address_question_address_question_option_attributes_latitude").val(coords.lat);
      }.bind(this);
    }

    setCoordinatesInFormByMouse = setCoordinatesInForm(function(e) {
      return e.lngLat;
    });

    setCoordinatesInFormByTouch = setCoordinatesInForm(function(e) {
      var source = map.draggableSource();
      var coords = source.data.features[0].geometry.coordinates;
      return { lng: coords[0], lat: coords[1] };
    });

    map.on('mouseup', setCoordinatesInFormByMouse.bind(this));
    map.on('touchend', setCoordinatesInFormByTouch.bind(this));

    map.on('load', function() {
      $(document).on("input", "#address_question_address_question_option_attributes_distance", function() {
        var currentLatitude = $("#address_question_address_question_option_attributes_latitude").val();

        map.setPaintProperty(styleId, 'circle-radius', {
          "stops": [
            [0, 0],
            [20, App.Map.milesToPixelsAtMaxZoom($(this).val(), currentLatitude)]
          ],
          "base": 2
        });
      });
    });
  }

  if($(".question #address-question-option").length) {
    if($(".question #address-question-option #map").length) {
      initMap();
    }

    if($("#address-question-option .nested-fields").length) {
      $(".add_fields").hide();
    }

    $(document).on('cocoon:before-insert', '#address-question-option', function(e, option) {
      $(".add_fields").hide();
      option.find("#address_question_address_question_option_attributes_distance").val(defaultDistance);
    });

    $(document).on('cocoon:after-insert', '#address-question-option', function(e, option) {
      initMap();
    });

    $(document).on('cocoon:before-remove', '#address-question-option', function(e, option) {
      map.remove();
    });

    $(document).on('cocoon:after-remove', '#address-question-option', function(e, option) {
      $(".add_fields").show();
    });
  }
});
