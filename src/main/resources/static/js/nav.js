/**
 * Created by souyouyou on 2018/2/7.
 */
function tab(val) {
    if (val == 1) {
        $("#page-wrapper").load("ProjectList")
    }
    if (val == 2) {
        $("#page-wrapper").load("dataList")
    }
    if (val == 3) {
        $("#page-wrapper").load("anliList")
    }
    if (val == 4) {
        $("#page-wrapper").load("expertList")
    }
    if (val == 5) {
        $("#page-wrapper").load("announceList")
    }
    if (val == 6) {
        $("#page-wrapper").load("msgGroupList")
    }
    if (val == 7) {
        $("#page-wrapper").load("outBoxList")
    }
    if (val == 8) {
        $("#page-wrapper").load("draftList")
    }
    if (val == 9) {
        $("#page-wrapper").load("memberList")
    }
    if (val == 10) {
        $("#page-wrapper").load("roleList")
    }
    if (val == 11) {
        $("#page-wrapper").load("permissionList")
    }
    if (val == 12) {
        $("#page-wrapper").load("CreateProject")
    }
    if (val == 13) {
        $("#page-wrapper").load("KeywordList")
    }
    if (val == 16) {
        $("#page-wrapper").load("logList")
    }


}


function menu(type) {
    $("#page-wrapper").load("menuList/"+type)
}

function review(type) {
    $("#page-wrapper").load("reviewList/"+type)
}

$(document).ready(
    function () {
        $("#page-wrapper").load("main")
    }
)
