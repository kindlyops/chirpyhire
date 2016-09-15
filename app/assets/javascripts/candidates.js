$(document).on("turbolinks:load", function() {

  var bindUI = function() {
    $(document).on("click", ".candidates .card-call-to-actions button", function() {
      var $button = $(this);
      Turbolinks.visit($button.find('a').attr('href'));
    });
    // Toggle to ensure zero height div at start, and then make visible
    $(".card-stages-drawer").slideToggle(0, function() { $(".card-stages-drawer").css("visibility", "visible") });
    $(document).on("click", "button.change-candidate-stage", function() {
      var parentCard = $(this).closest(".card");
      parentCard.find(".card-stages-drawer").slideToggle(400);
    });
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
