$(document).on('turbolinks:load', function() {
  var idealCandidate = $('.ideal-candidate:not([loaded])');
  if(idealCandidate.length) {
    var cover = $('.cover');
    var pattern = Trianglify({
        width: cover.innerWidth(),
        height: 315
    });
    cover.append(pattern.svg());
    idealCandidate.attr('loaded', true);
  }
});
