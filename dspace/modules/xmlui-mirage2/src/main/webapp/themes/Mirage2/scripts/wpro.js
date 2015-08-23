$(function() {
    var pgurl = window.location.pathname;
    var navmenu = $("#nav ul li a");
    navmenu.each(function(){
        if($(this).attr("href") == pgurl)
            $(this).parent().addClass("active");
    })
});