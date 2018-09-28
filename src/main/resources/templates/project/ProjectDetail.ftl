<!-- Bootstrap Core CSS -->
<#--<link href="static/css/bootstrap.min.css" rel="stylesheet">-->

<#--<!-- MetisMenu CSS &ndash;&gt;-->
<#--<!--<link href="static/js/metisMenu.min.css" rel="stylesheet">&ndash;&gt;-->

<#--<!-- Custom CSS &ndash;&gt;-->
<#--<link href="static/css/sb-admin-2.css" rel="stylesheet">-->

<#--<!-- Custom Fonts &ndash;&gt;-->
<#--<link href="static/css/font-awesome.min.css" rel="stylesheet" type="text/css">-->


<link rel="stylesheet" href="static/css/bootstrap-table.min.css">
<link rel="stylesheet" href="static/css/layer.css">
<link rel="stylesheet" href="static/css/fileinput.css">
<link rel="stylesheet" href="static/css/bootstrapValidator.min.css">
<link rel="stylesheet" href="static/css/bootstrap-select.css">


<script src="static/js/bootstrap-table.min.js"></script>
<script src="static/js/bootstrap-table-zh-CN.min.js"></script>
<script src="static/js/layer.js"></script>
<script src="static/js/fileinput.js"></script>
<script src="static/js/locales/zh.js"></script>
<script src="static/js/jquery.form.js"></script>
<script type="text/javascript" src="static/js/bootstrap-select.js"></script>


<div class="content">

    <div class="row">
        <div class="col-lg-12">
            <h1 class="page-header">项目详情</h1>
        </div>
        <!-- /.col-lg-12 -->
    </div>
    <input type="hidden" id="basePath" value="${basePath}">

    <div class="row">
        <div class="col-lg-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <button id="btn_edit" type="button" class="btn btn-primary" onclick="backtoList()">
                        <span class="glyphicon glyphicon-backward" aria-hidden="true">返回到项目列表</span>
                    </button>
                <@shiro.hasPermission name="keyword:add">
                    <button id="btn_addkeyword" type="button" class="btn btn-info" data-toggle="modal"
                            data-target="#addKeywordModal" onclick="">
                        <span class="glyphicon glyphicon-book" aria-hidden="false">添加标签</span>
                    </button>
                </@shiro.hasPermission>
                </div>
            </div>

            <div class="panel-body">
                <div class="row">
                    <div class="col-lg-12">
                        <!-- Nav tabs -->
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#basicinfo" data-toggle="tab">基本信息</a>
                            </li>
                            <li><a href="#danweiinfo" data-toggle="tab">承研单位</a>
                            </li>
                            <li><a href="#phaseinfo" data-toggle="tab">阶段信息</a>
                            </li>
                            <li><a href="#baojianginfo" data-toggle="tab">报奖信息</a>
                            </li>
                            <#--<li><a href="#feeinfo" data-toggle="tab">经费信息</a>-->
                            <#--</li>-->
                            <#--<li><a href="#meetinfo" data-toggle="tab">研讨记录</a>-->
                            <#--</li>-->
                        </ul>
                        <!-- Tab panes -->
                        <div class="tab-content">
                            <div class="tab-pane fade in active" id="basicinfo">
                            <#include "ProjectBasic.ftl">
                            </div>
                            <div class="tab-pane fade" id="danweiinfo">
                            <#include "chengyandanwei.ftl">
                            </div>
                            <!--阶段begin-->
                            <div class="tab-pane fade" id="phaseinfo">
                            <#include "ProjectPhase.ftl">
                            </div>

                            <div class="tab-pane fade" id="baojianginfo">
                            <#include "ProjectBaoJiang.ftl">
                            </div>
                            <!--阶段end-->
                            <#--<div class="tab-pane fade" id="feeinfo">-->
                            <#--<#include "ProjectFee.ftl">-->
                            <#--</div>-->
                            <#--<div class="tab-pane fade" id="meetinfo">-->
                            <#--<#include "ProjectYantao.ftl">-->
                            <#--</div>-->
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
<input type="hidden" id="keywordTid" name="keywordTid" value="${proentity.id!}"/>
<input type="hidden" id="keywordMid" name="keywordMid" value="1">
<#include "../keyword/AddKeyword.ftl">



<script src="static/js/custom/project_phaseinfo.js"></script>
<script src="static/js/custom/project_feeinfo.js"></script>
<script language="JavaScript">

    // $(document).ready(function () {
    //
    //    // LoadZrr();
    //     OnPhaseItemChange();
    // })

    //$("#phaselist").on("change", OnPhaseItemChange);

    function backtoList() {
        //window.location.href="/ship/ProjectList"
        $("#page-wrapper").load("ProjectList")
    }

    function RefreshFilelist() {
        $("#filetable").bootstrapTable('refresh')
    }

</script>

