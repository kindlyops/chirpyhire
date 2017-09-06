$(function() {
  $(document).on('change', '.settings.pricing .active-candidates-slider', function(e) {
    var candidatesCount = parseInt($(this).val());
    $('.settings.pricing .candidates--number').text(candidatesCount.toLocaleString());

    if(candidatesCount <= 50) {
      $('.settings.pricing .candidates--price').text('$125 / mo');
    } else if(candidatesCount <= 100) {
      $('.settings.pricing .candidates--price').text('$150 / mo');
    } else if(candidatesCount <= 200) {
      $('.settings.pricing .candidates--price').text('$175 / mo');
    } else if(candidatesCount <= 300) {
      $('.settings.pricing .candidates--price').text('$225 / mo');
    } else if(candidatesCount <= 400) {
      $('.settings.pricing .candidates--price').text('$250 / mo');
    } else if(candidatesCount <= 500) {
      $('.settings.pricing .candidates--price').text('$275 / mo');
    } else if(candidatesCount <= 600) {
      $('.settings.pricing .candidates--price').text('$315 / mo');
    } else if(candidatesCount <= 700) {
      $('.settings.pricing .candidates--price').text('$350 / mo');
    } else if(candidatesCount <= 800) {
      $('.settings.pricing .candidates--price').text('$380 / mo');
    } else if(candidatesCount <= 900) {
      $('.settings.pricing .candidates--price').text('$400 / mo');
    } else if(candidatesCount <= 1000) {
      $('.settings.pricing .candidates--price').text('$450 / mo');
    } else if(candidatesCount <= 2000) {
      var priceCount = Math.floor(candidatesCount / 100) * 100;
      var price = priceCount * 0.43;
      var priceString = '$' + Math.round(price) + ' / mo';
      $('.settings.pricing .candidates--price').text(priceString);
    } else if(candidatesCount <= 3000) {
      var priceCount = Math.floor(candidatesCount / 100) * 100;
      var price = priceCount * 0.42;
      var priceString = '$' + Math.round(price) + ' / mo';
      $('.settings.pricing .candidates--price').text(priceString);
    } else {
      var priceCount = Math.floor(candidatesCount / 100) * 100;
      var price = priceCount * 0.41;
      var priceString = '$' + Math.round(price) + ' / mo';
      $('.settings.pricing .candidates--price').text(priceString);
    }
  });
});
