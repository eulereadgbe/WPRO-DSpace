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

$(document).ready(function()
    {
        var submissionTable = $("#aspect_submission_Submissions_table_completed-submissions");
        submissionTable.addClass("tablesorter");
        var theader = $(".ds-table-header-row").wrap("<thead></thead>");
        var $toolbar = $('#aspect_submission_Submissions_table_completed-submissions > tbody > thead');
        $toolbar.parent().before($toolbar);
        submissionTable.tablesorter();
    }
);