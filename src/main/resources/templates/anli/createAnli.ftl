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
        text-align: left;

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
            <h1 class="page-header">新建案例</h1>
        </div>
        <!-- /.col-lg-12 -->
    </div>


    <div class="row">
        <ul id="myTab" class="nav nav-tabs">
            <li class="active"><a href="#home" data-toggle="tab">基本信息</a></li>
            <li><a href="#ios" data-toggle="tab">政策法规</a></li>
            <li><a href="#sifa" data-toggle="tab">国外司法判例</a></li>
        </ul>


        <div id="myTabContent" class="tab-content">
            <div class="tab-pane fade in active" id="home">
                <div style="margin-top: 30px">
                    <form class="form-horizontal" role="form" id="dataForm">
                        <div class="form-group">
                            <input type="hidden" id="typeId" name="typeId"/>
                            <input type="hidden" name="id" id="id" value="${info.id!}"/>
                            <input type="hidden" id="keywordTid" name="keywordTid" value="${info.id!}"/>
                            <input type="hidden" id="keywordMid" name="keywordMid" value="3">
                            <label for="firstname" class="col-sm-1 control-label">类别</label>
                            <div class="col-sm-6">
                                <div class="dropdown dropdowmspc" id="dropDown"></div>
                            </div>
                        <#if info.id??>
                            <div class="col-sm-1" style="margin-left: -112px;">
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
                            <label for="title" class="col-sm-1 control-label">标题</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="title" name="title" placeholder="请输入标题"
                                       value="${info.title!}">
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="classificlevelId" class="col-sm-1 control-label">密级</label>
                            <div class="col-sm-6">
                                <select name="classificlevelId" id="classificlevelId" class="form-control">
                                    <#--<option value="-1">请选择</option>-->
                                        <option value="4">机密</option>
                                        <option value="3">秘密</option>
                                        <option value="2">内部</option>
                                        <option value="1">公开</option>
                                </select>
                            </div>

                        </div>

                        <div class="form-group">
                            <label for="ziliaoContent" class="col-sm-1 control-label">上传附件</label>

                            <div class="col-sm-6">
                                <a href="javascript:void(0)" class="btn btn-warning" onclick="electronicFile()"
                                   data-toggle="modal" data-target="#fileuploadModal">电子</a>
                                <a href="javascript:void(0)" class="btn btn-primary" onclick="paperFile()"
                                   data-toggle="modal" data-target="#paperuploadModal">纸质</a>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="ziliaoContent" class="col-sm-1 control-label">附件列表</label>
                            <div class="col-sm-6" id="attachment">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="ziliaoContent" class="col-sm-1 control-label">摘要</label>
                            <div class="col-sm-6">
                                <textarea id="ckeditor" name="ckeditor" class="form-control" rows="5"
                                          cols="38"></textarea>
                                <script type="text/javascript">CKEDITOR.replace('ckeditor')</script>
                            </div>
                        </div>

                    </form>
                </div>
            </div>
            <div class="tab-pane fade" id="ios">
                <div style="margin-top: 30px">
                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="policy" class="col-sm-1 control-label">政策</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="policy" name="policy" placeholder="请输入政策"
                                       value="${info.policy!}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="mainAuthor" class="col-sm-1 control-label">执笔人</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="mainAuthor" name="mainAuthor"
                                       placeholder="请输入主要执笔人"
                                       value="${info.mainAuthor!}">
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="participant" class="col-sm-1 control-label">参与人</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="participant" name="participant"
                                       placeholder="请输入参与人"
                                       value="${info.participant!}">
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="policySource" class="col-sm-1 control-label">政策来源</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="policySource" name="policySource"
                                       placeholder="请输入政策来源"
                                       value="${info.policySource!}">
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="startDate" class="col-sm-1 control-label">起始日期</label>
                            <div class="col-sm-6">
                                <input type="date" class="form-control" id="startDate" name="startDate"
                                       placeholder="请输入起始日期"
                                       value="${info.startDate!}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="endDate" class="col-sm-1 control-label">结束日期</label>
                            <div class="col-sm-6">
                                <input type="date" class="form-control" id="endDate" name="endDate"
                                       placeholder="请选择结束日期"
                                       value="${info.endDate!}">
                            </div>
                        </div>
                    </form>
                </div>

            </div>
            <div class="tab-pane fade" id="sifa">
                <div class="panel-body" style="margin-top: 30px">
                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="plaintiff" class="col-sm-1 control-label">原告</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="plaintiff" name="plaintiff" placeholder="请输入原告"
                                       value="${info.plaintiff!}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="defendant" class="col-sm-1 control-label">被告</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="defendant" name="defendant"
                                       placeholder="请输入主要被告"
                                       value="${info.defendant!}">
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="caseNum" class="col-sm-1 control-label">案例编号</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="caseNum" name="caseNum"
                                       placeholder="请输入案例编号"
                                       value="${info.participant!}">
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="judicialStatus" class="col-sm-1 control-label">状态</label>
                            <div class="col-sm-6">
                                <select class="form-control" id="judicialStatus" name="judicialStatus">
                                    <option value="一审">一审</option>
                                    <option value="二审">二审</option>
                                    <option value="再审">再审</option>
                                    <option value="其他">其他</option>
                                </select>
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="keyword" class="col-sm-1 control-label">关键词</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="keyword" name="keyword"
                                       placeholder="请输入关键词"
                                       value="${info.keyword!}">
                            </div>
                        </div>

                    </form>
                </div>
            </div>
        </div>


        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-6">
            <@shiro.lacksPermission name="anli:save">
                <script language="JavaScript" type="text/javascript">
                    $('input').attr("readonly", "readonly")
                    $('select').attr("disabled", "disabled")
                    $('textarea').attr("readonly", "readonly")
                    $("[onclick='electronicFile()']").attr('disabled', 'disabled')
                    $("[onclick='paperFile()']").attr('disabled', 'disabled');
                    $('#dLabel').attr('data-toggle', '');
                </script>

            </@shiro.lacksPermission>

            <@shiro.hasPermission name="anli:save">
                <a href="javascript:void(0)" class="btn btn-success" onclick="createAnli()">保存</a>
            </@shiro.hasPermission>

                <a href="javascript:void(0)" class="btn btn-primary" onclick="back()">返回</a>
            </div>
        </div>
        <script>
            $(function () {
                $('#myTab li:eq(0) a').tab('show');
            });
        </script>

    </div>


<#include "../keyword/AddKeyword.ftl">


</div>


<!-- 上传电子附件 -->
<div class="modal fade" id="fileuploadModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <input type="hidden" id="classificlevelId"/>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">电子附件</h4>
            </div>
            <div class="modal-body">
                <form id="fileForm" action="uploadAatachment" enctype="multipart/form-data" method="post">
                    <input type="hidden" name="category" value="AL"/>
                    <input type="hidden" name="fileType" value="1"/>
                    <input id="fileClassify" name="fileClassify" type="hidden" value="2"/>
                    <div class="form-group">
                        <select name="classificlevel" id="classificlevel" class="form-control">
                            <option value="4">机密</option>
                            <option value="3">秘密</option>
                            <option value="2">内部</option>
                            <option value="1">公开</option>
                        </select>
                    </div>
                    <div class="form-group" style="height: 300px">
                        <input id="dataFile" name="dataFile" onchange="selectFile()" type="file" multiple=""/>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveFile">保存</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>


<!-- 更新纸质附件信息 -->
<div class="modal fade" id="paperuploadModal" role="dialog" aria-labelledby="myPaperModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myPaperModalLabel">纸质附件</h4>
            </div>
            <div class="paper-body">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="savePaperFile">保存</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- /.modal -->
<script type="text/javascript">


    function addInput(id, fileName, type) {
        var viewDiv = '';
        if (type == 1) {
            viewDiv = '<a href="getFile?mid=' + id + '" download="' + fileName + '"><span class="fa fa-download" style="margin-left: 6px"></span></a>';
        } else {
            viewDiv = '<a href="javascript:void(0)" onclick="viewFile(' + id + ')"><span class="fa fa-eye" style="margin-left: 6px"></span></a>';
        }

        var childInput = '<div><input style="margin-top: 5px;" type="text" name="mid" data-value="' + id + '" value="' + fileName + '" class="btn btn-default" readonly><span class="glyphicon glyphicon-remove" style="color: red;margin-left: 6px" onclick="removeInput(this)"></span>' + viewDiv + '</div>'
        $("#attachment").append(childInput)

    }

    function removeInput(obj) {

        obj.parentElement.remove();

    }


    var paperContent = '<div class="panel-body"><div class="row"><div class="col-lg-6"><form role="form"id="paperForm"><div class="form-group"><label for="select">密级</label><select id="classificlevel"name="classificlevel"class="form-control"><option value="4">机密</option><option value="3">秘密</option><option value="2">内部</option><option value="1">公开</option></select></div><div class="form-group"><label>文件名</label><input class="form-control"name="fileName"placeholder="请输入文件名"/></div><div class="form-group"><label>责任人</label><input type="hidden"name="fileType"value="0"/><input type="hidden"name="category"value="AL"/><input type="hidden"name="creator"value=<@shiro.principal property="username"/>><input class="form-control"name="zrr"placeholder="请输入责任人"/></div></form></div></div></div>'
    function paperFile() {

        $("#savePaperFile").removeAttr("disabled");

        $(".paper-body").html(paperContent);


        $('#paperForm').bootstrapValidator({
            message: 'This value is not valid',
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                fileName: {
                    validators: {
                        notEmpty: {
                            message: '文件名不能为空'
                        }
                    }
                },
                zrr: {
                    validators: {
                        notEmpty: {
                            message: '责任人不能为空'
                        }
                    }
                },
                classificlevel: {
                    message: '请选择文件密级',
                    validators: {
                        message: '请选择文件密级',
                        callback: {
                            callback: function (value, validator) {
                                if (value == -1) {
                                    return false;
                                } else {
                                    return true;
                                }
                            }
                        }
                    }
                }
            }
        });
    }

    function back() {
        $("#page-wrapper").load("anliList");
    }

    function selectFile() {
        var obj = document.getElementById("dataFile");
        var len = obj.files.length;
        for (var i = 0; i < len; i++) {
            temp = obj.files[i].name;

            $("input[name='mid']").each(function () {
                if (temp == this.value) {
                    layer.msg("请勿重复上传同一文件,或者修改名称后重新上传");
                    $("#saveFile").attr("disabled", "disabled");
                    return;
                }

            });

        }
    }

    var modalContent = '';

    $("#classificlevel").change(function () {
        var selectVal = $("#classificlevel").find("option:selected").val();

        $("#classificlevelId").val(selectVal);

    })
    function electronicFile() {

        $("#saveFile").removeAttr("disabled");
        $('#fileuploadModal').modal('show')


        $('#dataFile').fileinput({//初始化上传文件框
            showUpload: false,
            showRemove: false,
            uploadAsync: true,
            uploadLabel: "上传",//设置上传按钮的汉字
            uploadClass: "btn btn-primary",//设置上传按钮样式
            showCaption: false,//是否显示标题
            language: "zh",//配置语言
            uploadUrl: "uploadAatachment",
            maxFileSize: 0,
            maxFileCount: -1, /*允许最大上传数，可以多个，当前设置单个*/
            enctype: 'multipart/form-data',
            allowedPreviewTypes: ['image', 'html', 'text', 'video', 'audio', 'flash', 'object', 'other'], //allowedFileTypes: ['image', 'video', 'flash'],
            allowedFileExtensions: ["jpg", "png", "jpeg", "gif", "docx", "pdf", "xls", "xlsx", "doc", "txt"], /*上传文件格式*/
            msgFilesTooMany: "选择上传的文件数量({n}) 超过允许的最大数值{m}！",
            dropZoneTitle: "请通过拖拽文件放到这里",
            dropZoneClickTitle: "或者点击此区域添加文件",
            uploadExtraData: {
                'category': 'AL',
                "fileType": '1',
                'classificlevel': document.getElementById("classificlevel").value,
                'fileClassify': 2,
            },//这个是外带数据
            showBrowse: false,
            browseOnZoneClick: true,
            slugCallback: function (filename) {
                return filename.replace('(', '_').replace(']', '_');
            }
        });

    };

    $('#saveFile').on('click', function () {

        var selectVal = $("#classificlevel").find("option:selected").val();

        if (selectVal == -1) {
            layer.msg("请选择密级");
            return;
        }

        var options = {
            url: 'uploadAatachment',   //同action
            type: 'post',
            beforeSend: function (xhr) {//请求之前

            },
            success: function (data) {
                data = JSON.parse(data)
                if (data.msg == "success") {

                    var mid = data.mid;
                    var fileName = data.fileName;

                    addInput(mid, fileName, 1);
                    layer.msg("文件上传成功!");
//
                    $("#saveFile").attr("disabled", "disabled");
                    $('.modal').map(function () {
                        $(this).modal('hide');
                    });
                    $(".modal-backdrop").remove();
                } else {
                    layer.msg("文件上传失败，请稍后重试!");
                }

            },
            error: function (xhr, status, msg) {
                layer.msg('玩命加载中..');

            }
        };
        $("#fileForm").ajaxSubmit(options);

    });

    $('#savePaperFile').on('click', function () {

        var bootstrapValidator = $("#paperForm").data('bootstrapValidator');
        bootstrapValidator.validate()
        if (!bootstrapValidator.isValid())
            return;

        $.post('uploadAatachment', $("#paperForm").serialize(), function (data) {
            data = JSON.parse(data)

            if (data.msg == 'success') {
                layer.msg("附件信息保存成功!");

                addInput(data.mid, data.fileName, 0);
                $("#savePaperFile").attr("disabled", "disabled");

                $('.modal').map(function () {
                    $(this).modal('hide');
                });
                $(".modal-backdrop").remove();
            }

        })
    })


</script>

<script type="text/javascript">
    var button = '<a id="dLabel" role="button" data-toggle="dropdown" class="btn btn-white" href="javascript:;"><span id="select-title">选择分类</span> <span class="caret"></span></a>';

    var html = '';

    var subHtml = addSubMenu(1, 0);

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


    $('.dropdown li a').click(function () {

        title = $(this).attr("data-title");
        id = $(this).attr("data-content");
        $("#select-title").text(title);
        $("#typeId").val(id)
    })
</script>
<script type="text/javascript">

    function createAnli() {
        var data = CKEDITOR.instances.ckeditor.getData();

        if (data == '') {
            layer.msg('请填写案例摘要');
            return false;
        }

        if ($('#typeId').val() == '') {
            layer.msg('请选择案例类别');
            return false;
        }

        var bootstrapValidator = $("#dataForm").data('bootstrapValidator');
        bootstrapValidator.validate();

        if (!bootstrapValidator.isValid()) {
            return;
        }

        var mids = [];
        $("input[name='mid']").each(function () {
            mids.push(this.dataset.value)
        });

        var params = {
            title: $("#title").val(),
            content: data,
            classificlevelId: $("#classificlevelId").val(),
            typeId: $("#typeId").val(),
            mids: mids,
            id: $("#id").val(),
            type: 'AL',
            policy:$('#policy').val(),
            mainAuthor:$('#mainAuthor').val(),
            participant:$('#participant').val(),
            policySource:$('#policySource').val(),
            startDate:$('#startDate').val(),
            endDate:$('#endDate').val(),
            plaintiff:$('#plaintiff').val(),
            defendant:$('#defendant').val(),
            caseNum:$('#caseNum').val(),
            judicialStatus:$('#judicialStatus').val(),
            keyword:$('#keyword').val()
        }


        $.post('createAnli', params, function (result) {


            result = JSON.parse(result);

            if (result.msg == 'success') {
                layer.msg("案例信息保存成功!");
                $("#page-wrapper").load("anliList");
            } else {
                layer.msg(result.msg);
            }
        });

    }


</script>

<script type="text/javascript">
    var classificlevelId = '${info.classificlevelId!}';

    if (classificlevelId != "") {
        $("#classificlevelId").val(classificlevelId);
    }

    CKEDITOR.instances.ckeditor.setData('${info.content!}');
    $("#typeId").val('${info.typeId!}');

    if ('${info.typeId!}' != '') {
        $.ajax({
            type: "post",
            url: "findMenuById",
            data: {mid: '${info.typeId!}'},
            async: false,
            success: function (data) {
                data = JSON.parse(data)
                $("#select-title").text(data.typeName);
            }
        });
    }


    if ('${info.id!}' != '') {

        $.ajax({
            type: "post",
            url: "findFileByZid",
            data: {zid: '${info.id!}', type: 'AL'},
            async: false,
            success: function (data) {


                data = JSON.parse(data)
                $.each(data, function () {
                    var fileName = this.fileName;
                    var audit = this.audit;
                    $.ajax({
                        type: "post",
                        url: "findModuleFileByFileCode",
                        data: {fileCode: this.fileCode},
                        async: false,
                        success: function (result) {
                            result = JSON.parse(result)
                            var fileType = result.fileType;
                            var viewDiv = '<span class="glyphicon glyphicon-remove" style="color: red;margin-left: 6px" onclick="removeInput(this)"></span>';
                            if (fileType == 1) {
                                viewDiv += '<a href="getFile?mid=' + result.id + '" download="' + fileName + '"><span class="fa fa-download" style="margin-left: 6px"></span></a>';
                            } else {
                                viewDiv += '<a href="javascript:void(0)" onclick="viewFile(' + result.id + ')"><span class="fa fa-eye" style="margin-left: 6px"></span></a>';
                            }


                            if(audit == -1){
                                viewDiv += '<label style="margin-left: 20px;color: red;">审核未通过</label>'
                            }else if(audit == 0){
                                viewDiv = '<label style="margin-left: 20px;color: grey;">审核中</label>'
                            }


                            var childInput = '<div><input style="margin-top: 5px;"  type="text" name="mid" data-value="' + result.id + '" value="' + fileName + '" class="btn btn-default" readonly>' + viewDiv + '</div>'
                            $("#attachment").append(childInput)
                        }
                    });
                })

            }
        });
    }


</script>