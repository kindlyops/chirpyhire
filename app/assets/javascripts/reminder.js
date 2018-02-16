$(function() {
  if($('.reminder').length) {
    var $timepicker = $('.reminder #timepicker');
    $timepicker.timepicker({ 
      scrollDefault: 'now',
      step: 15,
      forceRoundTime: true
    });

    if(!$timepicker.val()) {
      $timepicker.timepicker('setTime', new Date());
    } else {
      $timepicker.timepicker('setTime', new Date($timepicker.val()));
    }

    var $datepicker = $('.reminder #datepicker');

    if ($datepicker.length) {    
      if(!$datepicker.val()) {
        $datepicker.datepicker({
          language: 'en',
          inline: true,
          minDate: new Date(),
          dateFormat: 'dd/mm/yyyy'
        }).data('datepicker').selectDate(new Date());
      } else {
        $datepicker.datepicker({
          language: 'en',
          inline: true,
          minDate: new Date(),
          dateFormat: 'dd/mm/yyyy'
        }).data('datepicker').selectDate(new Date($datepicker.val()));
      }
    }
  }
});
