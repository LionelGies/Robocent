// This is a manifest file that'll be compiled into public.js, which will include all the files
//= require public_js/jquery.min
//= require public_js/general
//= require public_js/jquery.easing.1.3
//= require public_js/jquery.onebyone
//= require public_js/jquery.touchwipe.min
//= require public_js/jquery.jcarousel.min
//= require public_js/jquery.uniform
//= require stripe

$(document).ready(function(){
    $("select").uniform();
});

//Register Form validation
$(document).ready(function(){
    $("#user_form_step_1_submit").click(function(){
        var email_regexp = /^[\w\.\+-]{1,}\@([\da-zA-Z-]{1,}\.){1,}[\da-zA-Z-]{2,6}$/;
        var name = $("#user_name").val();
        var email = $("#user_email").val();
        //var organization_name = $("#user_organization_name").val();
        //var phone = $("#user_phone").val();
        //var organization_type = $("#user_organization_type").val();
        //var state = $("#user_state").val();
        //var time_zone = $("#user_time_zone").val();
        var password = $("#user_password").val();
        var password_confirmation = $("#user_password_confirmation").val();

        var error = " ";
        if(name == "") error += "Name can't be blank.<br/>";
        if(!email_regexp.test(email)) error += "Email is invalid.<br/>";
        //if(organization_name == "") error += "Company/Organization can't be blank.<br/>";
        //if(phone == "") error += "Phone can't be blank.<br/>";
        //if(organization_type == "") error += "Organization type can't be blank.<br/>";
        //if(state == "") error += "State can't be blank.<br/>";
        //if(time_zone == "") error += "Time Zone can't be blank.<br/>";

        if($(".comment-form form").attr("id") == "new_user"){
            if(password.length < 6) error += "Password is too short (minimum is 6 characters).<br/>";
            if(password != password_confirmation) error += "Password doesn't match confirmation.<br/>";
        }

        if(!$('#user_terms_and_conditions').is(':checked')) error += "Terms and conditions must be accepted.<br/>";

        if(error != " ")
        {
            $("#results").html("Please correct these errors:<br/>"+error);
            return false;
        }
        else
        {
            $("#results").html("");
            return true;
        }
    });

    $("#twilio_phone_number_area_code").keyup(function(){
        var area_code = $(this).val();
        if(area_code.length == 3){
            $("#ajax-loader img").show();
            $("#twilio_phone_number_phone_number").attr('disabled', true).end();
            $("#twilio_phone_number_select").load("/twilionumbers/"+area_code, function(){
                $("select#twilio_phone_number_phone_number").uniform();
                $("#ajax-loader img").hide();
            });
        }
    });

    $("#user_form_step_2_submit").click(function(){
        var phone_number = $("#twilio_phone_number_phone_number").val();
        var time_zone = $("#user_time_zone").val();
    
        var error = "";

        if(time_zone == "") error += "Time Zone can't be blank.<br/>";
        if(phone_number == "") error += "Must select Phone Number.<br/>";

        if(error != "")
        {
            $("#results").html("Please correct these errors:<br/>"+error);
            return false;
        }
        else
        {
            $("#results").html("");
            return true;
        }
    });
});