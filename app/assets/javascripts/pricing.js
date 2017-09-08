$(function() {
  $(document).on('change', '.settings.pricing .active-candidates-slider', function(e) {
    var count = parseInt($(this).val());
    $('.settings.pricing .candidates--number').text(count.toLocaleString());

    var dynamicPrice = function(count, slope) {
      var priceCount = Math.floor(count / 100) * 100;
      var price = priceCount * slope;
      return '$' + Math.round(price) + ' / mo';
    }

    if(count <= 50) {
      $('.settings.pricing .candidates--price').text('$125 / mo');
    } else if(count <= 100) {
      $('.settings.pricing .candidates--price').text('$150 / mo');
    } else if(count <= 200) {
      $('.settings.pricing .candidates--price').text('$175 / mo');
    } else if(count <= 300) {
      $('.settings.pricing .candidates--price').text('$225 / mo');
    } else if(count <= 400) {
      $('.settings.pricing .candidates--price').text('$250 / mo');
    } else if(count <= 500) {
      $('.settings.pricing .candidates--price').text('$275 / mo');
    } else if(count <= 600) {
      $('.settings.pricing .candidates--price').text('$315 / mo');
    } else if(count <= 700) {
      $('.settings.pricing .candidates--price').text('$350 / mo');
    } else if(count <= 800) {
      $('.settings.pricing .candidates--price').text('$380 / mo');
    } else if(count <= 900) {
      $('.settings.pricing .candidates--price').text('$400 / mo');
    } else if(count <= 1000) {
      $('.settings.pricing .candidates--price').text('$450 / mo');
    } else if(count <= 2000) {
      var price = dynamicPrice(count, 0.43);
      $('.settings.pricing .candidates--price').text(price);
    } else if(count <= 3000) {
      var price = dynamicPrice(count, 0.42);
      $('.settings.pricing .candidates--price').text(price);
    } else {
      var price = dynamicPrice(count, 0.41);
      $('.settings.pricing .candidates--price').text(price);
    }
  });
});
