$(document).on('ready', function() {
  var idealCandidate = $('.ideal-candidate:not([loaded])');
  if(idealCandidate.length) {
    var cover = $('.cover');
    var pattern = Trianglify({
        width: cover.innerWidth(),
        height: 315,
        x_colors: 'RdYlGn'
    });
    cover.append(pattern.svg());
    idealCandidate.attr('loaded', true);
  }
});
