$(document).ready(function() {
  $("#credit-card input, #credit-card select").attr("disabled", false);
  $("#billing_setting_stripe_token").val("");

  $("form:has(#credit-card)").submit(function() {
    var form = this;

    var submit = $(this).find('input[type=submit]');
    var submit_prev = submit.val();
    submit.val('Please wait...').attr('disabled', true).end();

    $("#credit-card input, #credit-card select").attr("name", "");
    $("#credit-card-errors").hide();

    if (!$("#credit-card").is(":visible")) {
      $("#credit-card input, #credit-card select").attr("disabled", true);
      return true;
    }


    var exp_month = $("#_expiry_date_2i").val();
    var exp_year = $("#_expiry_date_1i").val();

    var card = {
      name: $("#billing_setting_card_holder_name").val(),
      number: $("#credit_card_number").val(),
      expMonth: $("#_expiry_date_2i").val(),
      expYear: $("#_expiry_date_1i").val(),
      cvc: $("#cvv").val()
    };

    if ($('#billing_setting_stripe_token').val()) {
      form.submit();
    }
    else {
      Stripe.createToken(card, function(status, response) {
        if (status === 200) {
          $("#billing_setting_card_last_four_digits").val(response.card.last4);
          $("#billing_setting_stripe_token").val(response.id);
          $("#billing_setting_card_exp_month").val(exp_month);
          $("#billing_setting_card_exp_year").val(exp_year);
          $("#billing_setting_card_type").val(response.card.type);
          form.submit();
        }
        else {
          $("#stripe-error-message").text(response.error.message);
          $("#credit-card-errors").show();
          submit.val(submit_prev).attr('disabled', false).end();
        }
      });
    }
    return false;
  });

});