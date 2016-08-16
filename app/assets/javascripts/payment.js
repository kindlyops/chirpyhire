App.Payment = {
  initialize: function() {
    var $form = $('#new_subscription');
    $form.submit(App.Payment.handleSubmit);
  },

  handleSubmit: function() {
    var $form = $('#new_subscription');
    $form.find('.submit').prop('disabled', true);
    $form.find(".submit").html("<i class='fa fa-circle-o-notch fa-spin'></i>");

    Stripe.card.createToken($form, App.Payment.stripeResponseHandler);

    return false;
  },

  stripeResponseHandler: function(status, response) {
    var $form = $('#new_subscription');

    if (response.error) {
      $form.find('.payment-errors').text(response.error.message);
      $form.find('.submit').prop('disabled', false);
    } else {
      var token = response.id;

      $form.append($('<input type="hidden" name="stripe_token">').val(token));
      $form.get(0).submit();
    }
  }
};

$(document).on('turbolinks:load', App.Payment.initialize);
