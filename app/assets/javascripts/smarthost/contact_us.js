//Contact Us Form
function checkcontact(input)
{
    var pattern1=/^([a-zA-Z0-9_.-])+@([a-zA-Z0-9_.-])+\.([a-zA-Z])+([a-zA-Z])+/;
    if(pattern1.test(input))
    {
        return true;
    }
    else
    {
        return false;
    }
}

$(function(){
    $("#new_tmp_message").submit(function(){
        $("#div_success").hide();
        $("#div_success").html("");
        $("#error").hide();
        $("#error").html("");
        $(".form .success").hide();
        $(".form .success").html("");

        var name = $("#tmp_message_name").val();
        var email = $("#tmp_message_email").val();
        var content = $("#tmp_message_content").val();

        var errors = "";

        if(name == "")
        {
            errors+= 'Please provide your name.<br />';
        }
        else if(email == "")
        {
            errors+= 'Please provide an email.<br />';
        }
        else if(checkcontact(email) == false)
        {
            errors+= 'Please provide a valid  email.<br />';
        }
        else if(content == "")
        {
            errors+= 'Please provide a message.<br />';
        }

        if(errors)
        {
            $("#error").show();
            $("#error").html(errors);
            return false;
        }
        else
        {
            $("#new_tmp_message .ajax-loading").show();
            return true;
        }
    });
});