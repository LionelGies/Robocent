$(function(){
    // Header Login button
    $(".signin").click(function(e) {
        e.preventDefault();
        $("fieldset#signin_menu").toggle();
        $(".signin").toggleClass("menu-open");
    });

    $("fieldset#signin_menu").mouseup(function() {
        return false
    });
    $(document).mouseup(function(e) {
        if($(e.target).parent("a.signin").length==0) {
            $(".signin").removeClass("menu-open");
            $("fieldset#signin_menu").hide();
        }
    });
});


//Home Page Tip
function randomtip() {

    var pause = 3000; // define the pause for each tip (in milliseconds) Feel free to make the pause longer so users can have time to read the tips :)
    var length = $("#tips li").length;
    var temp = -1;

    this.getRan = function(){
        // get the random number
        var ran = Math.floor(Math.random()*length) + 1;
        return ran;
    };
    this.show = function(){
        var ran = getRan();
        // to avoid repeating tips we need to check
        while (ran == temp){
            ran = getRan();
        }
        temp = ran;
        $("#tips li").hide();
        $("#tips li:nth-child(" + ran + ")").fadeIn("fast");
    };
    // initiate the script and also set an interval
    show();
    setInterval(show,pause);
}