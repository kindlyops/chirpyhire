$(function() {
  $(document).on('change', '.settings.subscription .active-candidates-slider', function(e) {
    var count = parseInt($(this).val());
    $('.settings.subscription .candidates--number').text(count.toLocaleString());

    var dynamicPrice = function(count, slope) {
      var priceCount = Math.floor(count / 200) * 200;
      var price = priceCount * slope;
      return '$' + Math.round(price) + ' / mo';
    }

    if(count <= 200) {
      $('.settings.subscription .candidates--price').text('$125 / mo');
    } else if(count <= 400) {
      $('.settings.subscription .candidates--price').text('$200 / mo');
    } else if(count <= 600) {
      $('.settings.subscription .candidates--price').text('$275 / mo');
    } else if(count <= 800) {
      $('.settings.subscription .candidates--price').text('$350 / mo');
    } else if(count <= 1000) {
      $('.settings.subscription .candidates--price').text('$425 / mo');
    } else if(count <= 1200) {
      $('.settings.subscription .candidates--price').text('$500 / mo');
    } else if(count <= 1400) {
      $('.settings.subscription .candidates--price').text('$575 / mo');
    } else if(count <= 1600) {
      $('.settings.subscription .candidates--price').text('$650 / mo');
    } else if(count <= 1800) {
      $('.settings.subscription .candidates--price').text('$725 / mo');
    } else if(count <= 2000) {
      $('.settings.subscription .candidates--price').text('$800 / mo');
    } else {
      var price = dynamicPrice(count, 0.375);
      $('.settings.subscription .candidates--price').text(price);
    }
  });
});
