<link href="static/css/style.css" rel="stylesheet"/>
<link href="static/css/prettify.min.css" rel="stylesheet"/>
<link rel="stylesheet" href="static/css/bootstrapValidator.min.css">

<#--<script src="static/js/jquery.min.js"></script>-->
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/jquery.fn.gantt.js"></script>
<script src="static/js/prettify.min.js"></script>
<script src="static/js/bootstrapValidator.min.js"></script>

<#--<div class="row">-->
    <#--<div class="col-lg-12">-->
        <#--<h1 class="page-header"><@shiro.hasAnyRoles name="admin">-->
            <#--用户[<@shiro.principal property="username"/>]拥有角色admin或user或member<br/>-->
        <#--</@shiro.hasAnyRoles></h1>-->
    <#--</div>-->
    <#--<!-- /.col-lg-12 &ndash;&gt;-->
<#--</div>-->
<div class="row">
    <div class="col-lg-12 alert">
        <h3 style="color: #337ab7;">今天是 ${.now?string("yyyy-MM-dd")},欢迎【<@shiro.principal property="realName"/>】您使用本系统。</h3>
        <hr>
    </div>
</div>
<!-- /.row -->
<div class="row">
    <div class="col-lg-3 col-md-6">
        <div class="panel panel-primary">
            <div class="panel-heading">
                <div class="row">
                    <div class="col-xs-3">
                        <i class="fa fa-cubes fa-5x"></i>
                    </div>
                    <div class="col-xs-9 text-right">
                        <div class="huge" id="procount">0</div>
                        <div>项目管理</div>
                    </div>
                </div>
            </div>
            <a href="javascript:void(0)" onclick="tab(1)">
                <div class="panel-footer">
                    <span class="pull-left">查看</span>
                    <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                    <div class="clearfix"></div>
                </div>
            </a>
        </div>
    </div>
    <div class="col-lg-3 col-md-6">
        <div class="panel panel-green">
            <div class="panel-heading">
                <div class="row">
                    <div class="col-xs-3">
                        <i class="fa fa-suitcase fa-5x"></i>
                    </div>
                    <div class="col-xs-9 text-right">
                        <div class="huge">${anliCount!}</div>
                        <div>案例管理</div>
                    </div>
                </div>
            </div>
            <a href="javascript:void(0)" onclick="tab(3)">
                <div class="panel-footer">
                    <span class="pull-left">查看</span>
                    <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                    <div class="clearfix"></div>
                </div>
            </a>
        </div>
    </div>
    <div class="col-lg-3 col-md-6">
        <div class="panel panel-yellow">
            <div class="panel-heading">
                <div class="row">
                    <div class="col-xs-3">
                        <i class="fa fa-folder fa-5x"></i>
                    </div>
                    <div class="col-xs-9 text-right">
                        <div class="huge">${dataCount!}</div>
                        <div>资料管理</div>
                    </div>
                </div>
            </div>
            <a href="javascript:void(0)" onclick="tab(2)">
                <div class="panel-footer">
                    <span class="pull-left">查看</span>
                    <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                    <div class="clearfix"></div>
                </div>
            </a>
        </div>
    </div>
    <div class="col-lg-3 col-md-6">
        <div class="panel panel-red">
            <div class="panel-heading">
                <div class="row">
                    <div class="col-xs-3">
                        <i class="fa fa-wechat fa-5x"></i>
                    </div>
                    <div class="col-xs-9 text-right">
                        <div class="huge">${announceCount!}</div>
                        <div>公告管理</div>
                    </div>
                </div>
            </div>
            <a href="javascript:void(0)" onclick="tab(5)">
                <div class="panel-footer">
                    <span class="pull-left">查看</span>
                    <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                    <div class="clearfix"></div>
                </div>
            </a>
        </div>
    </div>
</div>
<!-- /.row -->

<!-- /.row -->
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <#--<div class="panel-heading">-->
                <#--<i class="fa fa-bar-chart-o fa-fw"></i> <span id="pronamespan">项目阶段计划</span>-->
            <#--</div>-->
            <#--<div class="gantt"></div>-->


        </div>

    </div>
    <!-- /.col-lg-8 -->

    <!-- /.col-lg-4 -->
</div>
<!-- /.row -->

<div class="row">

    <#--<div class="col-lg-8">-->
        <#--<!-- /.panel &ndash;&gt;-->
        <#--<div class="panel panel-default">-->
            <#--<div class="panel-heading">-->
                <#--<i class="fa fa-bar-chart-o fa-fw"></i> 模块升级中-->
                <#--<div class="pull-right">-->
                    <#--&lt;#&ndash;<div class="btn-group">&ndash;&gt;-->
                        <#--&lt;#&ndash;<button type="button" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown">&ndash;&gt;-->
                            <#--&lt;#&ndash;Actions&ndash;&gt;-->
                            <#--&lt;#&ndash;<span class="caret"></span>&ndash;&gt;-->
                        <#--&lt;#&ndash;</button>&ndash;&gt;-->
                        <#--&lt;#&ndash;<ul class="dropdown-menu pull-right" role="menu">&ndash;&gt;-->
                            <#--&lt;#&ndash;<li><a href="#">Action</a>&ndash;&gt;-->
                            <#--&lt;#&ndash;</li>&ndash;&gt;-->
                            <#--&lt;#&ndash;<li><a href="#">Another action</a>&ndash;&gt;-->
                            <#--&lt;#&ndash;</li>&ndash;&gt;-->
                            <#--&lt;#&ndash;<li><a href="#">Something else here</a>&ndash;&gt;-->
                            <#--&lt;#&ndash;</li>&ndash;&gt;-->
                            <#--&lt;#&ndash;<li class="divider"></li>&ndash;&gt;-->
                            <#--&lt;#&ndash;<li><a href="#">Separated link</a>&ndash;&gt;-->
                            <#--&lt;#&ndash;</li>&ndash;&gt;-->
                        <#--&lt;#&ndash;</ul>&ndash;&gt;-->
                    <#--&lt;#&ndash;</div>&ndash;&gt;-->
                <#--</div>-->
            <#--</div>-->
            <#--<!-- /.panel-heading &ndash;&gt;-->
            <#--<div class="panel-body">-->
                <#--<div id="morris-area-chart"></div>-->
            <#--</div>-->
            <#--<!-- /.panel-body &ndash;&gt;-->
        <#--</div>-->
    <#--</div>-->
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                <i class="fa fa-bell fa-fw"></i>节点提醒
            </div>
            <!-- /.panel-heading -->
            <div class="panel-body">
                <div class="list-group" id="alertCenterDiv" style="height: 150px;">

                </div>
                <!-- /.list-group -->
            </div>
            <!-- /.panel-body -->
        </div>
    </div>
</div>

<script>

    var proData = "";
    var proNames = [];
    $(document).ready(function () {
        //LoadProjectProcess();
        LoadAlertList();
        LoadProjectList();
        //弹窗功能
//        $(".gantt").popover({
//            selector: ".bar",
//            title: "I'm a popover",
//            content: "And I'm the content of said popover.",
//            trigger: "hover",
//            placement: "auto"
//        });


    })


    function LoadProjectList() {

        $.post("GetProjectCount", {}, function (result) {

            result = JSON.parse(result);

            if (result.msg == "success") {

                $("#procount").html(result.data);

            }

        });
    }

    function LoadAlertList() {

        $.post("LoadAlertList", {}, function (result) {

            result = JSON.parse(result);

            if (result.msg == "success") {

                $("#alertCenterDiv").html(result.data);

            } else {
                $("#alertCenterDiv").html("<b>无提醒消息</b>")
            }

        });
    }
    function LoadProjectProcess() {

        $.post("LoadProjectProcess",
                {}
                , function (result) {

                    result = JSON.parse(result);
                    proData = result.proData;
                    proNames = result.proNames;
                    //初始化gantt
                    $(".gantt").gantt({
                        source: proData,
                        navigate: 'scroll',//buttons  scroll
                        scale: "days",// months  weeks days  hours
                        maxScale: "months",
                        minScale: "days",
                        months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
                        itemsPerPage: 5,
                        onItemClick: function (data) {
                            //alert("Item clicked - show some details");
                        },
                        onAddClick: function (dt, rowId) {
                            //alert("Empty space clicked - add an item!");
                        },
                        onRender: function () {
                            if (window.console && typeof console.log === "function") {
                                console.log("chart rendered");
                            }
                            //alert($(".page-number span").html().split("/")[0]);
                            if (proNames != null && proNames.length > 0) {
                                $("#pronamespan").html("<b>项目名称：<b>" + proNames[parseInt($(".page-number span").html().split("/")[0]) - 1].proname);
                                $(".spacer").html("负责人：" + proNames[parseInt($(".page-number span").html().split("/")[0]) - 1].proLeaders + "<br>参与人：" + proNames[parseInt($(".page-number span").html().split("/")[0]) - 1].proJoiners);
                            }
                        }
                    });

                })

    }


</script>