(function() {
  if ($) {
    var token = $('meta[name="csrf-token"]').attr('content');

    $.ajaxSetup( {
      beforeSend: function (xhr) {
        xhr.setRequestHeader('X-CSRF-Token', token);
      }
    });
  }
})();
