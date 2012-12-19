// This is a manifest file that'll be compiled into public.js, which will include all the files
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
//= require dashboard/kanrisha
//= require stripe

// Contacts
$(function() {
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

  $("form#new_list").submit(function(){
    var action = $(this).attr('action');
    $.ajax({
      type: 'POST',
      url: action,
      data: $(this).serialize(),
      dataType: "script"
    });
    $("#contact-lists-table .ajax-loading").show();
    $("#dialog").dialog("close");
    return false;
  });
});