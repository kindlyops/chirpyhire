App.Payment = {
  initialize: function() {
    $('#new_subscription').on('submit', function() {
      return App.Payment.handleSubmit($(this));
    });
  },

  handleSubmit: function(form) {
    $(form).find(':submit').prop('disabled', true);
    $('.payment-spinner').show();
    Stripe.card.createToken(form, function(status, response) {
      App.Payment.stripeResponseHandler(form, status, response);
    });
    return false;
  },

  stripeResponseHandler: function(form, status, response) {
    if (response.error) {
      App.Payment.showError(form, response.error.message);
    } else {
      var action = $(form).attr('action');
      form.append($('<input type="hidden" name="stripe_token">').val(response.id));
      form.append(App.Payment.authenticityTokenInput());
      $.ajax({
        type: "POST",
        url: action,
        data: form.serialize(),
        success: function(data) { App.Payment.poll(form, 60, data.id); },
        error: function(data) { App.Payment.showError(form, jQuery.parseJSON(data.responseText).error); }
      });
    }
  },

  poll: function(form, num_retries_left, id) {
    if (num_retries_left === 0) {
      App.Payment.showError(form, "This seems to be taking too long. Please contact support and give them transaction ID: " + id);
    }
    var handler = function(data) {
      if (data.status === "active") {
        window.location = '/subscriptions/' + id + '/edit';
      } else {
        setTimeout(function() { App.Payment.poll(form, num_retries_left - 1, id); }, 500);
      }
    };
    var errorHandler = function(jqXHR){
      App.Payment.showError(form, jQuery.parseJSON(jqXHR.responseText).error);
    };

    $.ajax({
      type: 'GET',
      dataType: 'json',
      url: '/subscriptions/' + id,
      success: handler,
      error: errorHandler
    });
  },

  showError: function(form, message) {
    $('.payment-spinner').hide();
    $(form).find(':submit')
    .prop('disabled', false)
    .trigger('error', message);

    var error_selector = form.data('payment-error-selector');
    if (error_selector) {
      $(error_selector).text(message);
      $(error_selector).show();
    } else {
      form.find('.payment-error').text(message);
      form.find('.payment-error').show();
    }
  },

  authenticityTokenInput: function() {
    return $('<input type="hidden" name="authenticity_token"></input>').val($('meta[name="csrf-token"]').attr("content"));
  }
};

$(document).on('turbolinks:load', App.Payment.initialize);
