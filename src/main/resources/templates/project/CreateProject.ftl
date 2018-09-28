<#--<link rel="stylesheet" href="static/css/bootstrap-table.min.css">-->
<link rel="stylesheet" href="static/css/layer.css">
<link rel="stylesheet" href="static/css/bootstrap-select.css">
<#--<script src="static/js/bootstrap-table.min.js"></script>-->
<#--<script src="static/js/bootstrap-table-zh-CN.min.js"></script>-->
<script src="static/js/layer.js"></script>
<script src="static/js/jquery.form.js"></script>
<script type="text/javascript" src="static/js/bootstrap-select.js"></script>

<div class="content">

    <div class="row">
        <div class="col-lg-12">
            <h1 class="page-header">新建项目</h1>
        </div>
        <!-- /.col-lg-12 -->
    </div>

    <div class="row">
        <div class="col-lg-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <button id="btn_edit" type="button" class="btn btn-primary" onclick="backtoList()">
                        <span class="glyphicon glyphicon-backward" aria-hidden="true">返回到项目列表</span>
                    </button>
                </div>
            </div>

            <div class="panel-body">
            <#--<div class="row">-->
            <#--<div class="col-lg-12">-->
                <form role="form" id="projectForm" name="projectForm">
                    <div class="panel-group" id="accordion">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">基本信息</a>
                                </h4>
                            </div>
                            <div id="collapseOne" class="panel-collapse collapse in">
                                <div class="panel-body">
                                    <div class="form-group col-md-6">
                                        <label>项目名称</label>
                                        <input class="form-control" id="proName" readonly="readonly" name="proName">
                                    </div>

                                    <div class="form-group col-md-6">
                                        <label>项目密级</label>
                                        <select class="form-control" id="classificlevelId" name="classificlevelId">
                                        <#--<option value="-1">请选择</option>-->
                                            <option value="4">机密</option>
                                            <option value="3">秘密</option>
                                            <option value="2">内部</option>
                                            <option value="1">公开</option>
                                        </select>
                                    </div>

                                    <div class="form-group col-md-6">
                                        <label>项目当前状态</label>
                                        <select class="form-control" id="proPhase" name="proPhase">
                                            <#--<option value="-1">请输入</option>-->
                                            <option value="0">立项中</option>
                                            <option value="1">在研中</option>
                                            <option value="2">已验收</option>
                                            <option value="3">待验收</option>
                                            <option value="4">未立项</option>
                                        </select>
                                    </div>

                                    <div class="form-group col-md-6">
                                        <label>项目编号</label>
                                        <input class="form-control" id="proNo" name="proNo">
                                    </div>

                                    <div class="form-group col-md-6">
                                        <label>项目来源</label>
                                        <input class="form-control" id="proFrom" name="proFrom">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label>项目负责人</label>
                                        <select class="form-control" id="proLeaders" onchange="FilterUsers(1)" name="proLeaders">

                                        </select>

                                    </div>

                                    <div class="form-group col-md-6">
                                        <label>主要完成人</label>
                                        <select class="selectpicker form-control" multiple id="proCompleteors" onchange="FilterUsers(3)" title='选择参与者 (必选、可多选)' name="proCompleteors">
                                        </select>
                                    </div>

                                    <div class="form-group col-md-6">
                                        <label>项目参与者</label>
                                        <select name="proJoiners" id="proJoiners" multiple onchange="FilterUsers(2)"
                                                class="selectpicker form-control" title='选择参与者 (非必选)'>
                                        </select>
                                    </div>

                                    <div class="form-group col-md-6">
                                        <label>主管部门</label>
                                        <input class="form-control" id="mainDepartment" name="mainDepartment">
                                    </div>

                                    <div class="form-group col-md-6">
                                        <label>研究周期</label>
                                        <div class="input-group">
                                        <input class="form-control" id="yanjiuZhouQi" name="yanjiuZhouQi">
                                        <span class="input-group-addon">月</span>
                                        </div>
                                    </div>

                                    <div class="form-group col-md-6">
                                        <label>总经费</label>
                                        <div class="input-group">
                                            <input class="form-control" id="totalFee" name="totalFee">
                                            <span class="input-group-addon">万元</span>
                                        </div>
                                    </div>

                                    <div class="form-group col-md-12">
                                        <label>项目研究内容</label>
                                        <textarea class="form-control" rows="3" id="proResearchcontent"
                                                  name="proResearchcontent"></textarea>
                                    </div>

                                    <div class="form-group col-md-12">
                                        <label>项目方向</label>
                                        <textarea class="form-control" rows="3" id="yanjiuFangXiang"
                                                  name="yanjiuFangXiang"></textarea>
                                    </div>


                                    <div class="form-group col-md-12">
                                        <label>项目备注</label>
                                        <textarea class="form-control" rows="3" id="proRemark"
                                                  name="proRemark"></textarea>
                                    </div>

                                </div>
                            </div>
                        </div>
                    <#--<div class="panel panel-default">-->
                    <#--<div class="panel-heading">-->
                    <#--<h4 class="panel-title">-->
                    <#--<a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">报奖信息</a>-->
                    <#--</h4>-->
                    <#--</div>-->
                    <#--<div id="collapseTwo" class="panel-collapse collapse">-->
                    <#--<div class="panel-body">-->
                    <#---->
                    <#--</div>-->
                    <#--</div>-->
                    <#--</div>-->
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree">阶段时间设置</a>
                                </h4>
                            </div>
                            <div id="collapseThree" class="panel-collapse collapse">
                                <div class="panel-body">
                                    <div class="form-group col-md-6">
                                        <label for="dtp_input2">立项时间</label>
                                        <input class="form-control" type="date" id="createPhasetime"
                                               name="createPhasetime">
                                    <#--<input class="form-control" id="createPhasetime" name="createPhasetime">-->
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label>立项提前通知时间</label>
                                        <div class="input-group">
                                        <input class="form-control" id="cpAlertdays" name="cpAlertdays">
                                        <span class="input-group-addon">天</span>
                                        </div>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="dtp_input3">开题时间</label>
                                        <input class="form-control" type="date" id="openPhasetime"
                                               name="openPhasetime">
                                    </div>

                                    <div class="form-group col-md-6">
                                        <label>开题提前通知时间</label>
                                        <div class="input-group">
                                        <input class="form-control" id="opAlertdays" name="opAlertdays">
                                        <span class="input-group-addon">天</span>
                                        </div>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="dtp_input4">中期检查时间</label>
                                        <input class="form-control" type="date" id="midcheckPhasetime"
                                               name="midcheckPhasetime">
                                    <#--<input class="form-control" id="createPhasetime" name="createPhasetime">-->
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label>中期检查提前通知时间</label>
                                        <div class="input-group">
                                        <input class="form-control" id="mpAlertdays" name="mpAlertdays">
                                        <span class="input-group-addon">天</span>
                                        </div>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="dtp_input4">结题时间</label>
                                        <input class="form-control" type="date" id="closePhasetime"
                                               name="closePhasetime">
                                    <#--<input class="form-control" id="createPhasetime" name="createPhasetime">-->
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label>结题提前通知时间</label>
                                        <div class="input-group">
                                        <input class="form-control" id="closepAlertdays" name="closepAlertdays">
                                        <span class="input-group-addon">天</span>
                                        </div>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="dtp_input4">验收时间</label>
                                        <input class="form-control" type="date" id="endPhasetime"
                                               name="endPhasetime">
                                    <#--<input class="form-control" id="createPhasetime" name="createPhasetime">-->
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label>验收管理提前通知时间</label>
                                        <div class="input-group">
                                        <input class="form-control" id="epAlertdays" name="epAlertdays">
                                        <span class="input-group-addon">天</span>
                                        </div>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label>是否报奖</label>
                                        <select class="form-control" id="isreportReward" name="isreportReward">
                                            <#--<option value="-1">请输入</option>-->
                                            <option value="0">否</option>
                                            <option value="1">是</option>
                                        </select>
                                    </div>

                                    <div class="form-group col-md-6">
                                        <label>报奖渠道</label>
                                        <select class="form-control" id="reportChannel" name="reportChannel">
                                            <#--<option value="-1">请输入</option>-->
                                            <option value="0">院内</option>
                                            <option value="1">集团</option>
                                            <option value="2">地方/行业/学会</option>
                                            <option value="3">国防</option>
                                            <option value="4">国家</option>
                                        </select>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group col-md-12" style="margin-left: 40%">
                        <script language="JavaScript" type="text/javascript">
                            $('input').attr("readonly", "readonly")
                            $('select').attr("readonly", "readonly")
                            $('textarea').attr("readonly", "readonly")
                            $('#proJoiners').attr("disabled", "disabled")
                        </script>
                    <@shiro.hasPermission name="project:save">
                     <script language="JavaScript" type="text/javascript">
                         $('input').removeAttr("readonly")
                         $('select').removeAttr("readonly")
                         $('textarea').removeAttr("readonly")
                         $('#proJoiners').removeAttr("disabled")
                     </script>
                        <a class="btn btn-primary" onclick="SaveProjectForm()">
                            <i class="fa fa-save"></i> 保存
                        </a>
                    </@shiro.hasPermission>
                        <button class="btn btn-danger" type="button" onclick="backtoList()">
                            <span class="glyphicon glyphicon-remove-circle" aria-hidden="true">取消</span>
                        </button>

                    </div>
                </form>
            <#--</div>-->
            <#--</div>-->
            </div>

        </div>
    </div>
</div>

<script src="static/js/custom/createProjectValidator.js"></script>
<script language="JavaScript">

    function FilterUsers(tag){

        var proJoiners=$("#proJoiners").val();
        var proLeader=$("#proLeaders").val();
        var proCompleteors=$("#proCompleteors").val();

        if(tag==1&&proLeader){

            if(proJoiners.length>0){
                for (var i=0;i<proJoiners.length;i++){
                    if(proJoiners[i]==proLeader){
                        layer.msg("项目负责人、主要完成人、项目参与者不能重复选择！");
                        $("#proLeaders").val("");
                        return false;
                    }
                }
            }

            if(proCompleteors.length>0){
                for (var i=0;i<proCompleteors.length;i++){
                    if(proCompleteors[i]==proLeader){
                        layer.msg("项目负责人、主要完成人、项目参与者不能重复选择！");
                        $("#proLeaders").val("");
                        return false;
                    }
                }
            }

        }

        if(tag==2&&proJoiners.length>0){

            if(proLeader) {
                for (var i = 0; i < proJoiners.length; i++) {
                    if (proJoiners[i] == proLeader) {
                        layer.msg("项目负责人、主要完成人、项目参与者不能重复选择！");
                        $("#proJoiners").val("");
                        $('#proJoiners').selectpicker("refresh");
                        return false;
                    }
                }
            }

            if(proCompleteors.length>0){

                var isEqual=false;
                for (var i=0;i<proJoiners.length;i++){
                    for (var j=0;j<proCompleteors.length;j++){
                        if(proJoiners[i]==proCompleteors[j]){
                            isEqual=true;
                            break;
                        }
                    }
                }
                if(isEqual){
                    $("#proJoiners").val("");
                    $('#proJoiners').selectpicker("refresh");
                    layer.msg("项目负责人、主要完成人、项目参与者不能重复选择！");
                    return false;
                }

            }
        }

        if(tag==3&&proCompleteors.length>0){

            if(proLeader){

                for (var i = 0; i < proCompleteors.length; i++) {
                    if (proCompleteors[i] == proLeader) {
                        $("#proCompleteors").val("");
                        $('#proCompleteors').selectpicker("refresh");
                        layer.msg("项目负责人、主要完成人、项目参与者不能重复选择！");
                        return false;
                    }
                }
            }

            if(proJoiners.length){
                var isEqual=false;
                for (var i=0;i<proJoiners.length;i++){
                    for (var j=0;j<proCompleteors.length;j++){
                        if(proJoiners[i]==proCompleteors[j]){
                            isEqual=true;
                            break;
                        }
                    }
                }
                if(isEqual){
                    $("#proCompleteors").val("");
                    $('#proCompleteors').selectpicker("refresh");
                    layer.msg("项目负责人、主要完成人、项目参与者不能重复选择！");
                    return false;
                }

            }
        }


    }

    function backtoList() {
        //window.location.href="/ship/ProjectList"
        $("#page-wrapper").load("ProjectList")
    }


    function LoadUsers() {
        $.post("getlallusers", {}, function (result) {

            result = JSON.parse(result);
            var htmlstr = "";
            $.each(result, function (i, item) {
               // htmlstr += "<option value='" + item.id + "'>" + item.username + "</option>";
                htmlstr += "<option value='" + item.username + "'>" + item.username + "</option>";
            })

            if (htmlstr != null && htmlstr.length > 0) {
                //$("#proLeaders").innerHTML(htmlstr);
                $("#proLeaders").append(htmlstr);
                $("#proJoiners").append(htmlstr);
                $("#proCompleteors").append(htmlstr);
                $('#proJoiners').selectpicker();
                $('#proJoiners').selectpicker("refresh");
                $("#proCompleteors").selectpicker();
                $("#proCompleteors").selectpicker("refresh");
            }
        })
    }

    function SaveProjectForm() {

        var bootstrapValidator = $("#projectForm").data('bootstrapValidator');
        bootstrapValidator.validate()
        if (!bootstrapValidator.isValid())
            return;

        $.post("SaveProject", $("#projectForm").serialize(), function (result) {
            result = JSON.parse(result);

            if (result.msg == 'success') {
                layer.msg("创建项目成功！")
                $("#page-wrapper").load("ProjectList")
            } else {
                alert("创建项目失败！")
            }
        });

    }

    $(document).ready(function () {
        LoadUsers();
    })
</script>