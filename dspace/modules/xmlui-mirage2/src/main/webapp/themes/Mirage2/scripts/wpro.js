$(function () {
    var pgurl = window.location.pathname;
    var navmenu = $("#nav ul li a");
    navmenu.each(function () {
        if ($(this).attr("href") == pgurl)
            $(this).parent().addClass("active");
    });
    var logo = $(".ds-logo-wrapper");
    logo.addClass("pull-right");
    logo.detach().prependTo("#aspect_artifactbrowser_CommunityViewer_div_community-search-browse,#aspect_artifactbrowser_CollectionViewer_div_collection-search-browse");
    $('#tree > li > div > h4 > a').each(function (i) {
        if ($(this).attr("href") == "/handle/10665.1/9971") {
            $(this).html("Regional Office for the Western Pacific Publications").attr('id', 'topCommunity');
        }
        $('#topCommunity').parent().parent().prev().attr('id', 'expand-by-default');
        if ($('#expand-by-default').hasClass('expandable-hitarea')) {
            $('#expand-by-default').click();
        }
    });
});

$(document).ready(function () {
        var submissionTable = $("#aspect_submission_Submissions_table_completed-submissions");
        submissionTable.addClass("tablesorter");
        var theader = $(".ds-table-header-row").wrap("<thead></thead>");
        var $toolbar = $('#aspect_submission_Submissions_table_completed-submissions > tbody > thead');
        $toolbar.parent().before($toolbar);
        submissionTable.tablesorter();
    }
);
