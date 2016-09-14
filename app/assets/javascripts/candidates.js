$(document).on("turbolinks:load", function() {

  var bindUI = function() {
    $(".candidates .card-call-to-actions button").on("click", function(event) {
      var $button = $(this);
      Turbolinks.visit($button.find('a').attr('href'));
    });
    // Toggle to start to hide.
    $(".card-stages-drawer").slideToggle();
    $("button.change-candidate-stage").on("click", function(e) {
      $(this).closest(".card").find(".card-stages-drawer").slideToggle(400)
    })
  }

  if($(".candidates").length) {
    bindUI();

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
