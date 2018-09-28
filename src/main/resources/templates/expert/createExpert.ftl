<link href="static/css/bootstrap-datetimepicker.min.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="static/css/bootstrap-table.min.css">
<link rel="stylesheet" href="static/css/layer.css">
<link rel="stylesheet" href="static/css/fileinput.css">


<script src="static/js/bootstrap-datetimepicker.js"></script>
<script src="static/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script src="static/js/bootstrap-table.min.js"></script>
<script src="static/js/bootstrap-table-zh-CN.min.js"></script>
<script src="static/js/layer.js"></script>
<script src="static/js/fileinput.js"></script>
<script src="static/js/locales/zh.js"></script>
<script src="static/js/jquery.form.js"></script>
<script src="static/js/formValidator.js"></script>

<style type="text/css">
    .dropdown-submenu {
        position: relative;
    }

    .dropdowmspc > a {
        text-align:left;
        border: 1px solid #ccc;
        color: #555;
        width: 65%;
    }

    .dropdown-submenu > .dropdown-menu {
        top: 0;
        left: 100%;
        margin-top: -6px;
        margin-left: -1px;
        -webkit-border-radius: 0 6px 6px 6px;
        -moz-border-radius: 0 6px 6px;
        border-radius: 0 6px 6px 6px;
    }

    .dropdown-submenu:hover > .dropdown-menu {
        display: block;
    }

    .dropdown-submenu > a:after {
        display: block;
        content: " ";
        float: right;
        width: 0;
        height: 0;
        border-color: transparent;
        border-style: solid;
        border-width: 5px 0 5px 5px;
        border-left-color: #ccc;
        margin-top: 5px;
        margin-right: -10px;
    }

    .dropdown-submenu:hover > a:after {
        border-left-color: #fff;
    }

    .dropdown-submenu.pull-left {
        float: none;
    }

    .dropdown-submenu.pull-left > .dropdown-menu {
        left: -100%;
        margin-left: 10px;
        -webkit-border-radius: 6px 0 6px 6px;
        -moz-border-radius: 6px 0 6px 6px;
        border-radius: 6px 0 6px 6px;
    }

    /*.form-horizontal .form-group {*/
    /*margin-right: -15;*/
    /*margin-left: -171px;*/
    /*}*/
</style>

<script type="text/javascript" src="static/js/ckeditor/ckeditor.js"></script>
<#--<script type="text/javascript" src="static/js/ckeditor/ckeditor_msg.js"></script>-->
<div class="content">

    <div class="row">
        <div class="col-lg-12">
            <h1 class="page-header">新建专家</h1>
        </div>
        <!-- /.col-lg-12 -->
    </div>


    <form class="form-horizontal" id="expertForm">
        <div class="form-group">
            <input type="hidden" id="typeId" name="typeId"/>
            <input type="hidden" name="id" id="id" value="${expert.id!}"/>
            <input type="hidden" id="keywordTid" name="keywordTid" value="${expert.id!}"/>
            <input type="hidden" id="keywordMid" name="keywordMid" value="4">
            <label for="firstname" class="col-sm-2 control-label">类别</label>
            <div class="col-sm-4">
                <div class="dropdown dropdowmspc" id="dropDown"></div>
            </div>
        <#if expert.id??>
            <div class="col-sm-2" style="margin-left: -112px;">
                <@shiro.hasPermission name="keyword:add">
                    <button id="btn_addkeyword" type="button" class="btn btn-info" data-toggle="modal"
                            data-target="#addKeywordModal">
                        添加标签
                    </button>
                </@shiro.hasPermission>
            </div>
        </#if>
        </div>

        <div class="form-group">
            <label for="classiclevelId" class="col-sm-2 control-label">密级</label>
            <div class="col-sm-4">
                <select name="classiclevelId" id="classiclevelId" class="form-control">
                <#--<option value="-1">请选择</option>-->
                    <option value="4">机密</option>
                    <option value="3">秘密</option>
                    <option value="2">内部</option>
                    <option value="1">公开</option>
                </select>
            </div>

        </div>


        <div class="form-group">
            <label class="col-sm-2 control-label">照片</label>
            <div class="col-sm-4">
                <#if (expert.pic)??>
                    <img src="${expert.pic!}" style="width: 100px;height: 100px">
                <#else>
                    <input type="file" name="pic" style="position: absolute;width: 60px;">
                </#if>

            </div>

        </div>

        <div class="form-group">
            <label for="name" class="col-sm-2 control-label">姓名</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="name" name="name"  placeholder="请输入姓名" value="${expert.name!}">
            </div>
        </div>

        <div class="form-group">
            <label for="gender" class="col-sm-2 control-label">性别</label>
            <div class="col-sm-4">
                <select id="gender" name="gender" class="form-control">
                    <option value="男">男</option>
                    <option value="女">女</option>
                </select>
            </div>

        </div>


        <div class="form-group">
            <label for="idNo" class="col-sm-2 control-label">身份证号</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="idNo" name="idNo"  placeholder="身份证号" value="${expert.idNo!}">
            </div>
        </div>

        <div class="form-group">
            <label for="birth" class="col-sm-2 control-label">出生日期</label>
            <div class="col-sm-4">
                <input type="date" class="form-control" id="birth" name="birth"  placeholder="出生日期" value="${expert.birth!}">
            </div>
        </div>

        <div class="form-group">
            <label for="education" class="col-sm-2 control-label">学历</label>
            <div class="col-sm-4">
                <select name="education" id="education" class="form-control">
                    <#--<option value="-1">请选择学历</option>-->
                    <option value="博士">博士</option>
                    <option value="硕士">硕士</option>
                    <option value="本科">本科</option>
                </select>
            </div>

        </div>

        <div class="form-group">
            <label for="sxzhuanye" class="col-sm-2 control-label">业务专长</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="sxzhuanye" name="sxzhuanye" placeholder="请输入业务专长" value="${expert.sxzhuanye!}">
            </div>
        </div>


        <div class="form-group">
            <label for="zhiwu" class="col-sm-2 control-label">职务</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="zhiwu" name="zhiwu" placeholder="请输入职务" value="${expert.zhiwu!}">
            </div>
        </div>

        <div class="form-group">
            <label for="zhicheng" class="col-sm-2 control-label">职称</label>
            <div class="col-sm-4">
                <select name="zhicheng" id="zhicheng" class="form-control">
                    <#--<option value="-1">请选择职称</option>-->
                    <option value="工程师">工程师</option>
                    <option value="高级工程师">高级工程师</option>
                    <option value="讲师">讲师</option>
                    <option value="副教授">副教授</option>
                    <option value="教授">教授</option>
                    <option value="副研究员">副研究员</option>
                    <option value="研究员">研究员</option>
                    <option value="院士">院士</option>
                </select>
            </div>

        </div>

        <div class="form-group">
            <label for="profile" class="col-sm-2 control-label">个人简介</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="profile" name="profile" placeholder="请输入个人简介" value="${expert.profile!}">
            </div>
        </div>


        <div class="form-group">
            <label for="szdanwei" class="col-sm-2 control-label">所在单位</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="szdanwei" name="szdanwei" placeholder="请输入所在单位" value="${expert.szdanwei!}">
            </div>
        </div>

        <div class="form-group">
            <label for="szbumen" class="col-sm-2 control-label">所在部门</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="szbumen" name="szbumen" placeholder="请输入所在部门" value="${expert.szbumen!}">
            </div>
        </div>


        <div class="form-group">
            <label for="sslingyu" class="col-sm-2 control-label">单位所属领域</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="sslingyu" name="sslingyu" placeholder="请输入单位所属领域" value="${expert.sslingyu!}">
            </div>
        </div>


        <div class="form-group">
            <label for="address" class="col-sm-2 control-label">通信地址</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="address" name="address" placeholder="请输入通信地址" value="${expert.address!}">
            </div>
        </div>


        <div class="form-group">
            <label for="postcode" class="col-sm-2 control-label">邮编</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="postcode" name="postcode" placeholder="请输入邮编" value="${expert.postcode!}">
            </div>
        </div>


        <div class="form-group">
            <label for="mobile" class="col-sm-2 control-label">手机</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="mobile" name="mobile" placeholder="请输入手机" value="${expert.mobile!}">
            </div>
        </div>


        <div class="form-group">
            <label for="phone" class="col-sm-2 control-label">座机</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="phone" name="phone" placeholder="请输入座机" value="${expert.phone!}">
            </div>
        </div>


        <div class="form-group">
            <label for="faxcode" class="col-sm-2 control-label">传真</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="faxcode" name="faxcode" placeholder="请输入传真" value="${expert.faxcode!}">
            </div>
        </div>


        <div class="form-group">
            <label for="email" class="col-sm-2 control-label">电子邮件</label>
            <div class="col-sm-4">
                <input type="email" class="form-control" id="email" name="email" placeholder="请输入电子邮件" value="${expert.email!}">
            </div>
        </div>

        <div class="form-group">
            <label for="zjpingjia" class="col-sm-2 control-label">最佳评价</label>
            <div class="col-sm-4">
                <select name="zjpingjia" id="zjpingjia" class="form-control">
                    <#--<option value="-1">请选择最佳评价</option>-->
                    <option value="优">优</option>
                    <option value="良">良</option>
                    <option value="中">中</option>
                    <option value="较差">较差</option>
                    <option value="差">差</option>
                </select>
            </div>

        </div>

        <div class="form-group">
            <label for="pycishu" class="col-sm-2 control-label">专家聘用次数</label>
            <div class="col-sm-4">
                <input type="number" class="form-control" id="pycishu" name="pycishu" placeholder="专家聘用次数" value="${expert.pycishu!}">
            </div>
        </div>


        <div class="form-group">
            <label for="remark" class="col-sm-2 control-label">备注信息</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="remark" name="remark" placeholder="备注信息" value="${expert.remark!}">
            </div>
        </div>


        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
            <@shiro.lacksPermission name="expert:save">
                <script language="JavaScript" type="text/javascript">
                    $('input').attr("readonly", "readonly")
                    $('select').attr("disabled", "disabled")
                    $('textarea').attr("readonly", "readonly")
                    $("[onclick='electronicFile()']").attr('disabled','disabled')
                    $("[onclick='paperFile()']").attr('disabled','disabled');
                    $('#dLabel').attr('data-toggle','');
                </script>

            </@shiro.lacksPermission>

            <@shiro.hasPermission name="expert:save">
                <a href="javascript:void(0)" class="btn btn-success" onclick="createExpert()">保存</a>
            </@shiro.hasPermission>

                <a href="javascript:void(0)" class="btn btn-primary" onclick="back()">返回</a>
            </div>
        </div>
    </form>

<#include "../keyword/AddKeyword.ftl">


</div>


<script type="text/javascript">
    var button = '<a id="dLabel" role="button" data-toggle="dropdown" class="btn btn-white" href="javascript:;"><span id="select-title">选择分类</span> <span class="caret"></span></a>';

    var html = '';

    var subHtml = addSubMenu(3, 0);

    if (subHtml) {
        html = button + subHtml;
        $("#dropDown").html(html);
    }


    function addSubMenu(type, parentId) {
        var subHtml = [];
        $.ajax({
            type: "post",
            url: "findMenuByTypeAndParentId",
            data: {type: type, parentId: parentId},
            async: false,
            success: function (result) {
                result = JSON.parse(result).result;
                if (result && result.length > 0) {
                    subHtml.push('<ul class="dropdown-menu multi-level" role="menu" aria-labelledby="dropdownMenu">');

                    $.each(result, function () {

                        subHtml.push('<li class="dropdown-submenu">');
                        subHtml.push('<a href="javascript:void(0);" data-title="' + this.typeName + '" data-content="' + this.id + '">' + this.typeName + '</a>');
                        subHtml.push(addSubMenu(type, this.id));
                        subHtml.push('</li>');

                    })

                    subHtml.push('</ul>');

                }
            }
        });

        return subHtml.join('');

    }

    function back() {
        $("#page-wrapper").load("expertList");
    }

    $('.dropdown li a').click(function () {

        title = $(this).attr("data-title");
        id = $(this).attr("data-content");
        $("#select-title").text(title);
        $("#typeId").val(id)
    })
</script>
<script type="text/javascript">
    
    function createExpert() {

        if ($('#typeId').val() == ''){
            layer.msg('请选择资料类别');
            return false;
        }

        var bootstrapValidator = $("#expertForm").data('bootstrapValidator');
        bootstrapValidator.validate()
        if (!bootstrapValidator.isValid())
            return;

        var form = new FormData(document.getElementById("expertForm"));

        $.ajax({
            url:"createExpert",
            type:"post",
            data:form,
            processData:false,
            contentType:false,
            success:function(data){
                $("#page-wrapper").load("expertList")
            },
            error:function(data){
                layer.err("新建专家失败")
            }
        });
    }




</script>
<script>
    $('.form_date').datetimepicker({
        language: 'zh-CN',
        weekStart: 1,
        todayBtn: 1,
        autoclose: 1,
        todayHighlight: 1,
        startView: 2,
        minView: 2,
        forceParse: 0
    });
</script>

<script>

    if ('${expert.classiclevelId!}' != ''){
        $("#classiclevelId").val('${expert.classiclevelId!}');
    }

    $("#typeId").val('${expert.typeId!}');

    if ('${expert.education!}' != ''){
        $("#education").val('${expert.education!}');
    }

    if ('${expert.zhicheng!}' != ''){
        $("#zhicheng").val('${expert.zhicheng!}');
    }

    if ('${expert.zjpingjia!}' != ''){
        $("#zjpingjia").val('${expert.zjpingjia!}');
    }

    if ('${expert.gender!}' != ''){
        $("#gender").val('${expert.gender!}');
    }


    if ('${expert.birth!}' != ''){
        $("#birth").val('${expert.birth!}');
    }

    if ('${expert.typeId!}' != '' && '${expert.typeId!}' != 0){
        $.ajax({
            type : "post",
            url : "findMenuById",
            data : {mid:'${expert.typeId!}'},
            async : false,
            success : function(data){

                data = JSON.parse(data)
                $("#select-title").text(data.typeName);
            }
        });
    }
</script>