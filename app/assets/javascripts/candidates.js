$(document).on("turbolinks:load", function() {
  if($(".candidates").length) {
    $(document).on("click", ".candidates .card-call-to-actions button", function(event) {
      var $button = $(this);
      Turbolinks.visit($button.find('a').attr('href'));
    });

    $(document).on("change", ".candidates .dropdown select", function(event) {
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
  }
});
