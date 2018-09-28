<link href="static/css/bootstrap-datetimepicker.min.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="static/css/bootstrap-table.min.css">
<link rel="stylesheet" href="static/css/layer.css">
<link rel="stylesheet" href="static/css/fileinput.css">
<link rel="stylesheet" href="static/css/bootstrap-select.css">


<script src="static/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="static/js/bootstrap-select.js"></script>
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
        width: 64%;
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
            <h1 class="page-header">新建公告</h1>
        </div>
        <!-- /.col-lg-12 -->
    </div>


    <form class="form-horizontal" role="form" id="dataForm">
        <div class="form-group">
            <input type="hidden" id="typeId" name="typeId"/>
            <input type="hidden" name="id" id="id" value="${info.id!}"/>
            <input type="hidden" id="keywordTid" name="keywordTid" value="${info.id!}"/>
            <input type="hidden" id="keywordMid" name="keywordMid" value="5">
            <label for="firstname" class="col-sm-2 control-label">类别</label>
            <div class="col-sm-4">
                <div class="dropdown dropdowmspc" id="dropDown"></div>
            </div>
        <#if info.id??>
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
            <label for="title" class="col-sm-2 control-label">标题</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="title" name="title" placeholder="请输入标题"
                       value="${info.title!}">
            </div>
        </div>

        <div class="form-group">
            <label for="sponsor" class="col-sm-2 control-label">发起人</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" readonly id="sponsor" name="sponsor" value="<@shiro.principal property="realName"/>">
            </div>
        </div>

        <div class="form-group">
            <label for="sponsor" class="col-sm-2 control-label">相关人员</label>
            <div class="col-sm-4">
                <select id="relatedUsers" name="relatedUsers" class="selectpicker form-control" multiple required data-live-search="true">
                    <#--<option value="-1">请选择相关人员</option>-->
                <#foreach user in users>
                    <option value="${user.id}">${user.realName!}</option>
                </#foreach>
                </select>
            </div>

        </div>

        <div class="form-group">
            <label for="typeName" class="col-sm-2 control-label">公告类型</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="typeName" name="typeName" placeholder="请输入公告类型"
                       value="${info.typeName!}">
            </div>
        </div>


        <div class="form-group">
            <label for="sponsorDate" class="col-sm-2 control-label">发起时间</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" readonly id="sponsorDate" name="sponsorDate" value="${info.sponsorDate!}">
            </div>
        </div>

        <div class="form-group">
            <label for="deadlineDate" class="col-sm-2 control-label">截止时间</label>
            <div class="col-sm-4">
                <input type="date" class="form-control" id="deadlineDate" name="deadlineDate" placeholder="请选择公告截止时间"
                       value="${info.deadlineDate!}">
            </div>
        </div>

        <div class="form-group">
            <label for="ziliaoContent" class="col-sm-2 control-label">上传附件</label>

            <div class="col-sm-10">
                <a href="javascript:void(0)" class="btn btn-warning " onclick="electronicFile()"
                   data-toggle="modal" data-target="#fileuploadModal">电子</a>
                <a href="javascript:void(0)" class="btn btn-primary" onclick="paperFile()"
                   data-toggle="modal" data-target="#paperuploadModal">纸质</a>
            </div>
        </div>

        <div class="form-group">
            <label for="attachment" class="col-sm-2 control-label">附件列表</label>
            <div class="col-sm-10" id="attachment">
            </div>
        </div>

        <div class="form-group">
            <label for="content" class="col-sm-2 control-label">摘要</label>
            <div class="col-sm-10">
                <textarea id="ckeditor" name="ckeditor" class="form-control" rows="10" cols="38"></textarea>
                <script type="text/javascript">CKEDITOR.replace('ckeditor')</script>
            </div>
        </div>


        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">

            <@shiro.lacksPermission name="announce:save">
                <script language="JavaScript" type="text/javascript">
                    $('input').attr("readonly", "readonly")
                    $('select').attr("disabled", "disabled")
                    $('textarea').attr("readonly", "readonly")
                    $("[onclick='electronicFile()']").attr('disabled','disabled')
                    $("[onclick='paperFile()']").attr('disabled','disabled');
                    $('#dLabel').attr('data-toggle','');
                </script>

            </@shiro.lacksPermission>

            <@shiro.hasPermission name="announce:save">
                <a href="javascript:void(0)" class="btn btn-success" onclick="createAnnouce()">保存</a>
            </@shiro.hasPermission>

                <a href="javascript:void(0)" class="btn btn-primary" onclick="back()">返回</a>
            </div>
        </div>
    </form>
</div>

<#include "../keyword/AddKeyword.ftl">


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
                    <input type="hidden" name="category" value="GG"/>
                    <input type="hidden" name="fileType" value="1"/>
                    <input id="fileClassify" name="fileClassify" type="hidden" value="5"/>
                    <div class="form-group">
                        <select name="classificlevel" id="classificlevel" class="form-control">
                        <#--<option value="-1">请选择</option>-->
                            <option value="4">机密</option>
                            <option value="3">秘密</option>
                            <option value="2">内部</option>
                            <option value="1">公开</option>
                        </select>
                    </div>
                    <div class="form-group" style="height: 300px;">
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


    $(document).ready(function () {
        $('#relatedUsers').selectpicker();

        var uidStr = '${info.relatedUserIds!}';

        var relatedUsers = [];
        if (uidStr != ''){
            uidArr = uidStr.split('');
            $.each(uidArr,function () {
                if (this != '[' && this != ']'){
                    relatedUsers.push(this);
                }
            })
            $('.selectpicker').selectpicker('val', relatedUsers);//默认选中
            $('.selectpicker').selectpicker('refresh');
        }

    })

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


    var paperContent = '<div class="panel-body"><div class="row"><div class="col-lg-6"><form role="form"id="paperForm"action="paperForm"><div class="form-group"><label for="select">密级</label><select id="select"name="classificlevel"class="form-control"><option value="4">机密</option><option value="3">秘密</option><option value="2">内部</option><option value="1">公开</option></select></div><div class="form-group"><label>文件名</label><input class="form-control"name="fileName"placeholder="请输入文件名"/></div><div class="form-group"><label>责任人</label><input type="hidden" name="fileType" value="0"/><input type="hidden"name="category"value="GG"/><input type="hidden"name="creator"value=<@shiro.principal property="realName"/>><input class="form-control"name="zrr"placeholder="请输入责任人"/></div></form></div></div></div>'
    function paperFile() {
        $("#savePaperFile").removeAttr("disabled");

        $(".paper-body").html(paperContent);

//        $('#paperForm').bootstrapValidator({
//            message: 'This value is not valid',
//            feedbackIcons: {
//                valid: 'glyphicon glyphicon-ok',
//                invalid: 'glyphicon glyphicon-remove',
//                validating: 'glyphicon glyphicon-refresh'
//            },
//            fields: {
//                fileName: {
//                    validators: {
//                        notEmpty: {
//                            message: '文件名不能为空'
//                        }
//                    }
//                },
//                zrr: {
//                    validators: {
//                        notEmpty: {
//                            message: '责任人不能为空'
//                        }
//                    }
//                },
//                classificlevel: {
//                    message: '请选择文件密级',
//                    validators: {
//                        message: '请选择文件密级',
//                        callback: {
//                            callback: function (value, validator) {
//                                if (value == -1) {
//                                    return false;
//                                } else {
//                                    return true;
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        });
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
    }

    function back() {
        $("#page-wrapper").load("announceList");
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
                'category': 'GG',
                "fileType": '1',
                'classificlevel': document.getElementById("classificlevel").value,
                'fileClassify':5
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

    var subHtml = addSubMenu(4, 0);

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

    function createAnnouce() {
        var data = CKEDITOR.instances.ckeditor.getData();

        if ($('#typeId').val() == '') {
            layer.msg('请选择公告类别');
            return false;
        }

//        var bootstrapValidator = $("#dataForm").data('bootstrapValidator');
//        bootstrapValidator.validate();
//
//        if (!bootstrapValidator.isValid()) {
//            return;
//        }

        if (data == '') {
            layer.msg('请填写资料摘要');
            return false;
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
            sponsorDate: $("#sponsorDate").val(),
            deadlineDate: $("#deadlineDate").val(),
            sponsor: $("#sponsor").val(),
            typeName: $("#typeName").val(),
            id: $("#id").val(),
            type: 'GG',
            relatedUsers:$('#relatedUsers').val()
        }


        $.post('createAnnounce', params, function (result) {

            result = JSON.parse(result);

            if (result.msg == 'success') {
                layer.msg("资料信息保存成功!");
                $("#page-wrapper").load("announceList")
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
            data: {zid: '${info.id!}', type: 'GG'},
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
                            result = JSON.parse(result);

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

