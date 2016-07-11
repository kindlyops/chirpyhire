$(document).on("turbolinks:load", function() {
  var map = L.map('map', {minZoom: 10, maxZoom: 10});
  var layer = Tangram.leafletLayer({
    scene: '/scenes'
  });
  layer.addTo(map);
  map.setView([$('#map').data('lat'), $('#map').data('long')], 10);
  var marker = L.marker([$('#map').data('lat'), $('#map').data('long')]).addTo(map);

  $(document).on("change", ".dropdown select", function(event) {
    var newSearch, queryParamRegExp;
    var search = location.search;
    var queryParam = this.name + "=" + this.value;

    if (!search) {
      Turbolinks.visit(location.pathname + "?" + queryParam);
    } else {
      queryParamRegExp = new RegExp("(" + this.name + "=[^\&]+)");

      if (search.match(queryParamRegExp)) {
        newSearch = search.replace(queryParamRegExp, queryParam);
      } else {
        newSearch = search + "&" + queryParam;
      }
      Turbolinks.visit(location.pathname + newSearch);
    }
  });
});
