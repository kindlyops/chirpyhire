$(function() {
  $(document).on('click', '.export-caregivers', function(e) {
    e.preventDefault();
    window.location.href = '/caregivers.csv' + location.search;
   });
});
