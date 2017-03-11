$(document).on('turbolinks:before-cache', function () {
  Smooch._container && $(Smooch._container).detach();
});

$(document).on('turbolinks:render', function () {
  Smooch._container && $('body').append(Smooch._container);
});
