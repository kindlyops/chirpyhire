$(function() {
  $(document).on('change', '.settings.pricing .active-candidates-slider', function(e) {
    var candidatesCount = parseInt($(this).val());
    $('.settings.pricing .candidates--number').text(candidatesCount);
    if(candidatesCount <= 50) {
      $('.settings.pricing .candidates--price').text('$125 / mo');
    } else if(candidatesCount <= 100) {
      $('.settings.pricing .candidates--price').text('$170 / mo');
    } else if(candidatesCount <= 150) {
      $('.settings.pricing .candidates--price').text('$195 / mo');
    } else if(candidatesCount <= 200) {
      $('.settings.pricing .candidates--price').text('$220 / mo');
    } else if(candidatesCount <= 500) {
      $('.settings.pricing .candidates--price').text('$350 / mo');
    } else if(candidatesCount <= 1000) {
      $('.settings.pricing .candidates--price').text('$475 / mo');
    } else if(candidatesCount <= 2000) {
      $('.settings.pricing .candidates--price').text('$750 / mo');
    } else if(candidatesCount <= 4000) {
      $('.settings.pricing .candidates--price').text('$1,000 / mo');
    }
  });
});
