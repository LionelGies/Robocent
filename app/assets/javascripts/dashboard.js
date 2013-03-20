// This is a manifest file that'll be compiled into dashboard.js, which will include all the files
//= require dashboard/jQuery/jquery-1.7.2.min
//= require dashboard/Flot/jquery.flot
//= require dashboard/Flot/jquery.flot.resize
//= require dashboard/Flot/jquery.flot.pie
//= require dashboard/DataTables/jquery.dataTables.min
//= require dashboard/ColResizable/colResizable-1.3
//= require dashboard/jQueryUI/jquery-ui-1.8.21.min
//= require dashboard/Uniform/jquery.uniform
//= require dashboard/Tipsy/jquery.tipsy
//= require dashboard/Elastic/jquery.elastic
//= require dashboard/ColorPicker/colorpicker
//= require dashboard/SuperTextarea/jquery.supertextarea.min
//= require dashboard/UISpinner/ui.spinner
//= require dashboard/MaskedInput/jquery.maskedinput-1.3
//= require dashboard/ClEditor/jquery.cleditor
//= require dashboard/FullCalendar/fullcalendar
//= require dashboard/ColorBox/jquery.colorbox
//= require jquery.fancybox.pack
//= require dhtmlxcalendar
//= require dashboard/kanrisha
//= require stripe
//= require jquery_ujs
//= require swfobject
//= require jquery.joyride-2.0.3
//= require jquery.form

// Contacts
$(function() {
    $(".fancybox").fancybox()

    var delay = (function(){
        var timer = 0;
        return function(callback, ms){
            clearTimeout (timer);
            timer = setTimeout(callback, ms);
        };
    })();
    
    $( "#dialog" ).dialog({
        autoOpen: false,
        show: "blind",
        hide: "explode",
        width:'auto'
    });

    $( "#new_list_link" ).click(function() {
        $( "#dialog" ).dialog( "open" );
        $(".w_Options.i_16_add").trigger('click');
        return false;
    });

    $( "#new_list_link_1" ).click(function() {
        $( "#dialog" ).dialog( "open" );
        return false;
    });
    $( ".add_new_list_trigger" ).click(function() {
        $( "#dialog" ).dialog( "open" );
        return false;
    });

    $("#provide_card_link").click(function(){
        $( "#dialog" ).dialog( "open" );
        return false;
    })

    $("form.list_form input").live("keyup", function(){
        delay(function(){
            if(typeof window.xhr != 'undefined'){
                window.xhr.abort();
            }
            $("form.list_form .ajax-loading").show();
            var form = $("form.list_form");
            var action = '/lists/check_validation'
            window.xhr = $.ajax({
                type: 'POST',
                url: action,
                data: form.serialize(),
                dataType: "script"
            });
        }, 1000);
    });

    $("form.list_form select").live("change", function(){

        var type_of_list = $("#list_type_of_list").val();
        if(type_of_list == "text"){
            $("#row-keyword").show();
            $("#row-shortcode-keyword").show();
            $("#row-greeting").show();
        }
        else if(type_of_list == "call"){
            $("#list_keyword").val("");
            $("#list_shortcode_keyword").val("");
            $("#list_greeting").val("");
            $("#row-keyword").hide();
            $("#row-shortcode-keyword").hide();
            $("#row-greeting").hide();
        }

        delay(function(){
            if(typeof window.xhr != 'undefined'){
                window.xhr.abort();
            }
            $("form.list_form .ajax-loading").show();
            var form = $("form.list_form");
            var action = '/lists/check_validation'
            window.xhr = $.ajax({
                type: 'POST',
                url: action,
                data: form.serialize(),
                dataType: "script"
            });
        }, 1000);
    });


    $(".dialog form#new_list").submit(function(){
        var action = $(this).attr('action');
        $.ajax({
            type: 'POST',
            url: action,
            data: $(this).serialize(),
            dataType: "script"
        });
        $("#contact-lists-table .ajax-loading").show();
        $("#contact_list .ajax-loading").show();
        $("#import_form_contact_list .ajax-loading").show();
        $("#dialog").dialog("close");
        return false;
    });

    $("form#list_delete_link").live("submit", function(){
        if (confirm('By deleting this list, all contacts within this list will be erased. Do you want to proceed?')) {
            var action = $(this).attr("action");
            $.ajax({
                type: 'DELETE',
                url: action,
                data: $(this).serialize(),
                dataType: "script"
            });
            $("#contact-lists-table .ajax-loading").show();
        }
        return false;
    });

    $("form#contact_delete_link").live("submit", function(){
        if (confirm('Are you sure to delete!')) {
            var action = $(this).attr("action");
            $.ajax({
                type: 'DELETE',
                url: action,
                data: $(this).serialize(),
                dataType: "script"
            });
            $("#contacts-table .ajax-loading").show();
        }
        return false;
    });
    
    $("#see_more_form_fields").live('click', function(){
        $("#see_more_form_fields").hide();
        $("#see_less_form_fields").show();
        $("#more_form_fields").show();
    });
    $("#see_less_form_fields").live('click', function(){
        $("#see_more_form_fields").show();
        $("#see_less_form_fields").hide();
        $("#more_form_fields").hide();
    });

    $(".dnc-link").live('click', function(){
        $("#contacts-table .ajax-loading").show();
        $("#dnc-table .ajax-loading").show();
    });
    
    var time_interval_id = null;
    $("#text_message_content").focus(function(){
        time_interval_id = setInterval(function(){
            console.log("running");
            $("#text_message_content").val($("#text_message_content").val().replace(/[\~`\^\|\\]/g, ""));
        }, 200);
		
    });
    $("#text_message_content").focusout(function(){
        clearInterval(time_interval_id);
        console.log("stopped");
    });
});

//Fix file uploader click event
$(function(){
    $(".uploader span.action").click(function(){
        $(this).parent(".uploader").children(".simple_form").click();
    });
});

//Import Contacts
$(function(){
	
    $('#import_file_name').change(function(){
        var ext = $('#import_file_name').val().split('.').pop().toLowerCase();
        if($.inArray(ext, ['xls','xlsx','csv']) == -1) {
            alert('You may only upload an xls, xlsx, or csv file');
        }
    });

    var bar = $('.bar');	
	var status = $('.status'); 
	$('input[type="submit"]').removeAttr('disabled');
	$('#new_import').ajaxForm({
		dataType: 'script',
		beforeSend: function() {
			$(".progress").show();
			$(".status").show();
			var percentVal = '0%';
			bar.width(percentVal);
			$("#uniform-import_file_name").hide();
			$('input[type="submit"]').attr('disabled', 'disabled');
		},
		uploadProgress: function(event, position, total, percentComplete) {
			var percentVal = percentComplete + '%';
			bar.width(percentVal)
			status.html("Uploading: <span class='must'>" + percentVal+ "</span>");
			
		},
		complete: function(xhr) {
			var percentVal = '100%'; 
			bar.width(percentVal); 
			status.html("Upload Finished: <span class='must'>" + percentVal+ "</span>");
		}
	}); 
    
});


//Send a Test
$(function(){
    $("#text_message_content").bind("keyup blur",function(){
        var content = $(this).val();
        var char_text = content.length == 1 ? " Character, " : " Characters, ";
        var msg_count = Math.ceil(parseFloat(content.length) / 160.0);
        var msg_text = msg_count == 1 ? " Text Message Used" : " Text Messages Used";
        var text = content.length + char_text + msg_count + msg_text;
        $("#content_length").html(text);
    });
});
