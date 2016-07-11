$(document).on("turbolinks:load", function(event) {
  $(document).on("click", ".dropdown-button", function() {
    var $button, $menu;
    $button = $(this);
    $menu = $button.siblings(".dropdown-menu");
    $('.dropdown .dropdown-menu.show-menu').removeClass("show-menu");
    $menu.addClass("show-menu");
    $menu.children("li").click(function() {
      $menu.removeClass("show-menu");
      $button.html($(this).html());
    });
  });
});
