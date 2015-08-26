$(function() {
    var pgurl = window.location.pathname;
    var navmenu = $("#nav ul li a");
    navmenu.each(function(){
        if($(this).attr("href") == pgurl)
            $(this).parent().addClass("active");
    });
    var logo = $(".ds-logo-wrapper");
    logo.addClass("pull-right");
    logo.detach().prependTo("#aspect_artifactbrowser_CommunityViewer_div_community-search-browse,#aspect_artifactbrowser_CollectionViewer_div_collection-search-browse");
});