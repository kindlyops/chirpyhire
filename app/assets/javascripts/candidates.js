$(document).on("turbolinks:load", function() {
  $('.card').each(function(index, card) {
    var mapEl = $(card).find('#map');
    var lat = mapEl.data('lat');
    var long = mapEl.data('long');

    if (lat && long) {
      var map = L.map(mapEl[0], {minZoom: 10, maxZoom: 10});
      var layer = Tangram.leafletLayer({
        scene: '/scenes'
      });
      layer.addTo(map);
      map.setView([lat, long], 10);
      var marker = L.marker([lat, long]).addTo(map);
    } else {
      mapEl.addClass("empty-map");
      mapEl.append("<div>No address found yet</div>");
    }

  });

  $(document).on("click", ".card-call-to-actions button", function(event) {
    var $button = $(this);
    Turbolinks.visit($button.find('a').attr('href'));
  });

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
