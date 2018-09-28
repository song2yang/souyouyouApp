<div class="panel-body">
    <form role="form" id="updateprojectForm" name="updateprojectForm">
        <div class="panel-group" id="accordion">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">基本信息</a>
                    </h4>
                </div>
                <div id="collapseOne" class="panel-collapse collapse in">
                    <div class="panel-body">

                        <input type="hidden" id="id" name="id" value="${proentity.id}">
                        <div class="form-group col-md-6">
                            <label>项目名称</label>
                            <input class="form-control" id="proName" name="proName"
                                   value="${proentity.proName}">
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
                            <label>是否立项</label>
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
                            <input class="form-control" id="proNo" name="proNo" value="${proentity.proNo}">
                        </div>


                        <div class="form-group col-md-6">
                            <label>项目来源</label>
                            <input class="form-control" id="proFrom" name="proFrom"
                                   value="${proentity.proFrom}">
                        </div>
                        <div class="form-group col-md-6">
                            <label>项目负责人</label>
                            <select class="form-control" id="proLeaders" onchange="FilterUsers(1)"  name="proLeaders">
                            </select>
                        </div>
                        <div class="form-group col-md-6">
                            <label>主要完成人</label>
                            <select class="selectpicker form-control" onchange="FilterUsers(3)" multiple id="proCompleteors"
                                    title='选择参与者 (必选、可多选)' name="proCompleteors">
                            </select>
                        </div>

                        <div class="form-group col-md-6">
                            <label>项目参与者</label>
                            <select name="proJoiners" id="proJoiners" onchange="FilterUsers(2)" multiple
                                    class="selectpicker form-control"
                                    title='选择参与者(非必选)'>
                            </select>
                        </div>

                        <div class="form-group col-md-6">
                            <label>主管部门</label>
                            <input class="form-control" id="mainDepartment" name="mainDepartment"
                                   value="${proentity.mainDepartment!}">
                        </div>

                        <div class="form-group col-md-6">
                            <label>研究周期</label>
                            <div class="input-group">
                            <input class="form-control" id="yanjiuZhouQi" name="yanjiuZhouQi"
                                   value="${proentity.yanjiuZhouQi!}">
                            <span class="input-group-addon">月</span>
                            </div>
                        </div>

                        <div class="form-group col-md-6">
                            <label>总经费</label>
                            <div class="input-group">
                                <input class="form-control" id="totalFee" type="text" name="totalFee"
                                       value="${proentity.totalFee!}">
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

                            <input class="form-control" type="date" value="${proentity.createPhasetime!}"
                                   id="createPhasetime"
                                   name="createPhasetime">

                        <#--<input class="form-control" id="createPhasetime" name="createPhasetime">-->
                        </div>
                        <div class="form-group col-md-6">
                            <label>立项提前通知时间</label>

                            <div class="input-group">
                                <input class="form-control" id="cpAlertdays" name="cpAlertdays"
                                       value="${proentity.cpAlertdays!}">
                                <span class="input-group-addon">天</span>
                            </div>
                        </div>
                        <div class="form-group col-md-6">
                            <label for="dtp_input3">开题时间</label>
                            <input class="form-control" type="date" value="${proentity.openPhasetime!}"
                                   id="openPhasetime"
                                   name="openPhasetime">
                        </div>

                        <div class="form-group col-md-6">
                            <label>开题提前通知时间</label>
                            <div class="input-group">
                                <input class="form-control" id="opAlertdays" name="opAlertdays"
                                       value="${proentity.opAlertdays!}">
                                <span class="input-group-addon">天</span>
                            </div>
                        </div>


                        <div class="form-group col-md-6">
                            <label for="dtp_input4">中期检查时间</label>
                            <input class="form-control" type="date"
                                   value="${proentity.midcheckPhasetime!}"
                                   id="midcheckPhasetime"
                                   name="midcheckPhasetime">

                        <#--<input class="form-control" id="createPhasetime" name="createPhasetime">-->
                        </div>
                        <div class="form-group col-md-6">
                            <label>中期检查提前通知时间</label>
                            <div class="input-group">
                                <input class="form-control" id="mpAlertdays" name="mpAlertdays"
                                       value="${proentity.mpAlertdays!}">
                                <span class="input-group-addon">天</span>
                            </div>
                        </div>

                        <div class="form-group col-md-6">
                            <label for="dtp_input4">结题时间</label>

                            <input class="form-control" type="date" value="${proentity.closePhasetime!}"
                                   id="closePhasetime"
                                   name="closePhasetime">
                        <#--<input class="form-control" id="createPhasetime" name="createPhasetime">-->
                        </div>
                        <div class="form-group col-md-6">
                            <label>结题提前通知时间</label>
                            <div class="input-group">
                                <input class="form-control" id="closepAlertdays" name="closepAlertdays"
                                       value="${proentity.closepAlertdays!}">
                                <span class="input-group-addon">天</span>
                            </div>
                        </div>

                        <div class="form-group col-md-6">
                            <label for="dtp_input4">验收时间</label>
                            <input class="form-control" type="date" value="${proentity.endPhasetime!}"
                                   id="endPhasetime"
                                   name="endPhasetime">
                        <#--<input class="form-control" id="createPhasetime" name="createPhasetime">-->
                        </div>
                        <div class="form-group col-md-6">
                            <label>验收管理提前通知时间 </label>
                            <div class="input-group">
                                <input class="form-control" id="epAlertdays" name="epAlertdays"
                                       value="${proentity.epAlertdays!}">
                                <span class="input-group-addon">天</span>
                            </div>
                        </div>
                        <div class="form-group col-md-6">
                            <label>是否报奖</label>
                            <select class="form-control" id="isreportReward" name="isreportReward">
                                <#--<option value="-1">请选择</option>-->
                                <option value="0">否</option>
                                <option value="1">是</option>
                            </select>
                        </div>

                        <div class="form-group col-md-6">
                            <label>报奖渠道</label>
                            <select class="form-control" id="reportChannel" name="reportChannel">
                                <#--<option value="-1">请选择</option>-->
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
                $('select').attr("disabled", "disabled")
                $('textarea').attr("readonly", "readonly")
                $('#proJoiners').attr("disabled", "disabled")
            </script>
                    <@shiro.hasPermission name="project:save">
                     <script language="JavaScript" type="text/javascript">
                         $('input').removeAttr("readonly")
                         $('select').removeAttr("disabled")
                         $('textarea').removeAttr("readonly")
                         $('#proJoiners').removeAttr("disabled")
                     </script>
            <a class="btn btn-primary" onclick="UdpateProjectForm()">
                <i class="fa fa-save"></i> 修改
            </a>
                    </@shiro.hasPermission>


        <#--<button class="btn btn-danger" type="reset">-->
        <#--<span class="glyphicon glyphicon-refresh" aria-hidden="true">重置</span>-->
        <#--</button>-->

        </div>
    </form>
</div>

<script src="static/js/custom/updateProjectValidator.js"></script>
<script language="JavaScript" type="text/javascript">

    function FilterUsers(tag) {

        var proJoiners = $("#proJoiners").val();
        var proLeader = $("#proLeaders").val();
        var proCompleteors = $("#proCompleteors").val();

        if (tag == 1 && proLeader) {

            if (proJoiners.length > 0) {
                for (var i = 0; i < proJoiners.length; i++) {
                    if (proJoiners[i] == proLeader) {
                        layer.msg("项目负责人、主要完成人、项目参与者不能重复选择！");
                        $("#proLeaders").val("");
                        return false;
                    }
                }
            }

            if (proCompleteors.length > 0) {
                for (var i = 0; i < proCompleteors.length; i++) {
                    if (proCompleteors[i] == proLeader) {
                        layer.msg("项目负责人、主要完成人、项目参与者不能重复选择！");
                        $("#proLeaders").val("");
                        return false;
                    }
                }
            }

        }

        if (tag == 2 && proJoiners.length > 0) {

            if (proLeader) {
                for (var i = 0; i < proJoiners.length; i++) {
                    if (proJoiners[i] == proLeader) {
                        layer.msg("项目负责人、主要完成人、项目参与者不能重复选择！");
                        $("#proJoiners").val("");
                        $('#proJoiners').selectpicker("refresh");
                        return false;
                    }
                }
            }

            if (proCompleteors.length > 0) {

                var isEqual = false;
                for (var i = 0; i < proJoiners.length; i++) {
                    for (var j = 0; j < proCompleteors.length; j++) {
                        if (proJoiners[i] == proCompleteors[j]) {
                            isEqual = true;
                            break;
                        }
                    }
                }
                if (isEqual) {
                    $("#proJoiners").val("");
                    $('#proJoiners').selectpicker("refresh");
                    layer.msg("项目负责人、主要完成人、项目参与者不能重复选择！");
                    return false;
                }

            }
        }

        if (tag == 3 && proCompleteors.length > 0) {

            if (proLeader) {

                for (var i = 0; i < proCompleteors.length; i++) {
                    if (proCompleteors[i] == proLeader) {
                        $("#proCompleteors").val("");
                        $('#proCompleteors').selectpicker("refresh");
                        layer.msg("项目负责人、主要完成人、项目参与者不能重复选择！");
                        return false;
                    }
                }
            }

            if (proJoiners.length) {
                var isEqual = false;
                for (var i = 0; i < proJoiners.length; i++) {
                    for (var j = 0; j < proCompleteors.length; j++) {
                        if (proJoiners[i] == proCompleteors[j]) {
                            isEqual = true;
                            break;
                        }
                    }
                }
                if (isEqual) {
                    $("#proCompleteors").val("");
                    $('#proCompleteors').selectpicker("refresh");
                    layer.msg("项目负责人、主要完成人、项目参与者不能重复选择！");
                    return false;
                }

            }
        }


    }


    function LoadUsers() {
        $.post("getlallusers", {}, function (result) {

            result = JSON.parse(result);
            //var htmlstr = "<option value='-1'>请选择</option>";
            var htmlstr="";
            $.each(result, function (i, item) {
                // htmlstr += "<option value='" + item.id + "'>" + item.username + "</option>";
                htmlstr += "<option value='" + item.username + "'>" + item.username + "</option>";
            })

            if (htmlstr != null && htmlstr.length > 0) {
                //$("#proLeaders").innerHTML(htmlstr);

                $("#proLeaders").append(htmlstr);
                $("#proLeaders").val('${proentity.proLeaders!}');
                $("#proJoiners").append(htmlstr);
                $("#proCompleteors").append(htmlstr);
                $('#proJoiners').selectpicker();
                $('#proCompleteors').selectpicker();

                var proJoiners = "${proentity.proJoiners!}";
                var proCompleteors = "${proentity.proCompleteors!}";

                $('#proJoiners').selectpicker("val", proJoiners.split(","));
                $('#proJoiners').selectpicker("refresh");

                $('#proCompleteors').selectpicker("val", proCompleteors.split(","));
                $('#proCompleteors').selectpicker("refresh");

            }
        })
    }

    //提交更新项目表单
    function UdpateProjectForm() {

        var bootstrapValidator = $("#updateprojectForm").data('bootstrapValidator');
        bootstrapValidator.validate()
        if (!bootstrapValidator.isValid())
            return;

        $.post("UpdateProject", $("#updateprojectForm").serialize(), function (result) {
            result = JSON.parse(result);

            debugger;
            if (result.msg == 'success') {
                layer.msg("修改项目成功！");
                $("#page-wrapper").load("ProjectList")
            } else {
                layer.msg("修改项目失败！");
            }
        });

    }

    function InitData() {

        $("#isreportReward").val("${proentity.isreportReward!}");
        $("#reportChannel").val("${proentity.reportChannel!}");
        $("#proPhase").val("${proentity.proPhase!}");
        $("#classificlevelId").val("${proentity.classificlevelId!}");

        $("#proResearchcontent").val("${proentity.proResearchcontent!}");
        $("#proRemark").val("${proentity.proRemark!}");
        $("#yanjiuFangXiang").val("${proentity.yanjiuFangXiang!}");
    }

    $(document).ready(function () {

        LoadUsers();
        InitData();
    })


</script>