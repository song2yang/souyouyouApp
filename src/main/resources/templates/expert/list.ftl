<link rel="stylesheet" href="static/css/bootstrap-table.min.css">
<link rel="stylesheet" href="static/css/layer.css">
<link rel="stylesheet" href="static/css/fileinput.css">

<script src="static/js/respond.min.js"></script>
<#--<script src="static/js/jquery.1.9.1.min.js"></script>-->
<script src="static/js/bootstrap-table.min.js"></script>
<script src="static/js/bootstrap-table-zh-CN.min.js"></script>
<script src="static/js/table-export.min.js"></script>
<script src="static/js/layer.js"></script>
<script src="static/js/fileinput.js"></script>
<script src="static/js/locales/zh.js"></script>
<script src="static/js/commonList.js"></script>
<script src="static/js/jquery.form.js"></script>
<script src="static/js/colResizable-1.6.min.js"></script>
<script src="static/js/bootstrap-table-resizable.js"></script>

<style type="text/css">
    .dropdown-submenu {
        position: relative;
    }
    .dropdowmspc{
        position: absolute;
        z-index: 999;
        top: 173px;
    }
    .dropdowmspc>a{
        border:1px solid #ccc;
        color: #555;
        width: 121px;
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
    .mgl_125{
        margin-left: 125px;
    }
</style>
<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">专家库</h1>
    </div>
    <!-- /.col-lg-12 -->
</div>



<#--<div class="dropdown dropdowmspc" id="dropDown"></div>-->
<div class="content">
    <div class="table-responsive">

        <div id="toolbar">

            <form class="form-inline">
                <input type="hidden" id="typeId" name="typeId" value="${ziliaoInfoEntity.typeId!}"/>
                <#--<div class="form-group" style="display: none">-->
                    <#--<select name="condition" id="condition" class="form-control">-->
                        <#--<option value="name" selected>姓名</option>-->
                    <#--</select>-->
                <#--</div>-->

                <div class="form-group">
                    <label class="sr-only" for="searchContent">Email address</label>
                    <input type="text" id="searchContent" class="form-control" placeholder="请输入查询信息">
                </div>
                <div class="form-group">
                    <button class="btn btn-default" type="button" onclick="conditionSearch()">
                        <i class="fa fa-search"></i>
                    </button>
                </div>
                <@shiro.hasPermission name="expert:import">
                    <div class="form-group">
                        <div class="btn-group">
                            <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">导入
                                <span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu" role="menu">
                                <li>
                                    <a href="downLoadDataTempate?fileName=专家模板.xlsx">下载模板</a>
                                </li>
                                <li>
                                    <a href="javascript:void(0)" onclick="batchImport()" data-toggle="modal" data-target="#fileuploadModal">批量导入</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </@shiro.hasPermission>

                <div class="form-group">
                    <@shiro.hasPermission name="expert:export">
                        <a href="javascript:void(0)" class="btn btn-primary"  onclick="exportData()">导出</a>
                    </@shiro.hasPermission>

                    <#--<a href="javascript:void(0)" class="btn btn-primary"  onclick="importExpert()" data-toggle="modal" data-target="#fileuploadModal">导入</a>-->
                    <@shiro.hasPermission name="expert:add">
                        <a href="javascript:void(0)" class="btn btn-info" onclick="expert()">新建</a>
                    </@shiro.hasPermission>
                        <a href="javascript:void(0)" class="btn btn-danger" onclick="deleteById()">删除</a>
                </div>


            </form>


        </div>


        <table width="100%" class="table table-striped table-bordered table-hover" id="table" data-toolbar="#toolbar">

        </table>
    </div>
</div>


<!-- 上传电子附件 -->
<div class="modal fade" id="fileuploadModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <input type="hidden" id="classificlevelId"/>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">批量导入专家信息</h4>
            </div>
            <div class="modal-body">
                <form id="fileForm" action="uploadAatachment" enctype="multipart/form-data" method="post">
                    <div class="form-group" style="height: 300px">
                        <input id="fileClassify" name="fileClassify" type="hidden" value="4"/>
                        <input id="dataFile" name="dataFile" type="file" multiple=""/>
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



<script type="text/javascript">

    function detailView(id) {
        $("#page-wrapper").load("expert?eid="+id)
    }
    function deleteById() {

        var selected = $("#table").bootstrapTable('getSelections');
        var ids = [];
        $.each(selected, function (i, item) {
            ids.push(item.id);
        })

        if (ids.length == 0 ){
            layer.msg("请勾选要删除的记录!");
            return;
        }

        layer.confirm("确定删除已勾选记录？", function () {

            var load = layer.load();
            $.post('delExpert', {ids: ids.join(',')}, function (result) {
                result = JSON.parse(result)
                layer.close(load);
                if (result && result.msg != 'success') {
                    return layer.msg(result, so.default), !1;
                }
                layer.msg('删除成功。');
                $('#table').bootstrapTable('refresh');
            });
        });

    }


    $('#saveFile').on('click', function () {

        var options = {
            url: 'importExpert',   //同action
            type: 'post',
            beforeSend: function (xhr) {//请求之前

            },
            success: function (data) {
                data = JSON.parse(data)
                if (data.msg == "success") {

                    layer.msg("专家信息导入成功!");
                    $('#table').bootstrapTable('refresh');
                    $('.modal').map(function () {
                        $(this).modal('hide');
                    });
                    $(".modal-backdrop").remove();
                } else {
                    layer.msg("专家信息导入失败,请稍后再试!");
                }

            },
            error: function (xhr, status, msg) {
                layer.msg('玩命加载中..');

            }
        };
        $("#fileForm").ajaxSubmit(options);

    });


    function expert() {
        $("#page-wrapper").load("expert")
    }


    function batchImport() {


        $('#dataFile').fileinput({//初始化上传文件框
            showUpload: false,
            showRemove: false,
            uploadAsync: true,
            uploadLabel: "上传",//设置上传按钮的汉字
            uploadClass: "btn btn-primary",//设置上传按钮样式
            showCaption: false,//是否显示标题
            language: "zh",//配置语言
            uploadUrl: "batchImport",
            maxFileSize: 0,
            maxFileCount: 1, /*允许最大上传数，可以多个，当前设置单个*/
            enctype: 'multipart/form-data',
            allowedPreviewTypes: ['image', 'html', 'text', 'video', 'audio', 'flash', 'object', 'other'], //allowedFileTypes: ['image', 'video', 'flash'],
            allowedFileExtensions: ["xls", "xlsx"], /*上传文件格式*/
            msgFilesTooMany: "选择上传的文件数量({n}) 超过允许的最大数值{m}！",
            dropZoneTitle: "请通过拖拽文件放到这里",
            dropZoneClickTitle: "或者点击此区域添加文件",
            uploadExtraData: {},//这个是外带数据
            showBrowse: false,
            browseOnZoneClick: true,
            slugCallback: function (filename) {
                return filename.replace('(', '_').replace(']', '_');
            }
        });

        //上传文件成功，回调函数
        $('#dataFile').on("fileuploaded", function (event, data, previewId, index) {
            //;
            //alert(data.response);

            if (data.response.msg == "success") {
                $('#table').bootstrapTable('refresh');
                layer.msg("文件上传成功!");
//                $("#fileuploadModal").modal("hide");
//                $(".modal-body").html('');
//                $(".modal-backdrop").css("display","none");
                $("#saveFile").attr("disabled", "disabled");
            } else {
                layer.msg("文件上传失败，请稍后重试!");
            }


        });

    }

    $('#saveFile').on('click', function () {// 提交图片信息 //
        //先上传文件，然后在回调函数提交表单
        $('#projectfile').fileinput('upload');

    });

    function conditionSearch() {
        $('#table').bootstrapTable('refresh');
    }

    function exportData() {
        $('#table').tableExport({ type: 'excel', escape: 'false'})
    }

    function importExpert() {

        $('#fileuploadModal').modal('show')

        alert(111)

        $('#dataFile').fileinput({//初始化上传文件框
            showUpload: false,
            showRemove: false,
            uploadAsync: true,
            uploadLabel: "上传",//设置上传按钮的汉字
            uploadClass: "btn btn-primary",//设置上传按钮样式
            showCaption: false,//是否显示标题
            language: "zh",//配置语言
            uploadUrl: "importExpert",
            maxFileSize: 0,
            maxFileCount: -1, /*允许最大上传数，可以多个，当前设置单个*/
            enctype: 'multipart/form-data',
            allowedPreviewTypes: ['image', 'html', 'text', 'video', 'audio', 'flash', 'object', 'other'], //allowedFileTypes: ['image', 'video', 'flash'],
            allowedFileExtensions: ["xls", "xlsx"], /*上传文件格式*/
            msgFilesTooMany: "选择上传的文件数量({n}) 超过允许的最大数值{m}！",
            dropZoneTitle: "请通过拖拽文件放到这里",
            dropZoneClickTitle: "或者点击此区域添加文件",
            uploadExtraData: {
            },//这个是外带数据
            showBrowse: false,
            browseOnZoneClick: true,
            slugCallback: function (filename) {
                return filename.replace('(', '_').replace(']', '_');
            }
        });

    };
    
    
    $(document).ready(function () {

        $('#table').bootstrapTable({
            url: 'experts',         //请求后台的URL（*）
            method: 'get',                      //请求方式（*）
            //toolbar: '#toolbar',                //工具按钮用哪个容器
            striped: true,                      //是否显示行间隔色
            cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
            pagination: true,                   //是否显示分页（*）
            sortable: true,                     //是否启用排序
            sortOrder: "asc",                   //排序方式
            queryParams: queryParams,//传递参数（*）
            sidePagination: "server",           //分页方式：client客户端分页，server服务端分页（*）
            pageNumber: 1,                       //初始化加载第一页，默认第一页
            pageSize: 10,                       //每页的记录行数（*）
            pageList: [10, 25, 50, 100],        //可供选择的每页的行数（*）
            search: false,                       //是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
            strictSearch: true,
            showColumns: true,                  //是否显示所有的列
            showRefresh: true,                  //是否显示刷新按钮
            minimumCountColumns: 2,             //最少允许的列数
            clickToSelect: true,                //是否启用点击选中行
            height: 500,                        //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
            uniqueId: "ID",                     //每一行的唯一标识，一般为主键列
//            showToggle: true,                    //是否显示详细视图和列表视图的切换按钮
            cardView: false,                    //是否显示详细视图
            detailView: false,                   //是否显示父子表
            responseHandler: responseHandler,//请求数据成功后，渲染表格前的方法
            showExport: true,
            exportDataType: "basic",

            columns: [
                {
                    field: 'check',
                    checkbox: true
                },
//                {
//                    field: 'id',
//                    title: '编号',
//                    formatter: function (value, row, index) {
//                        return '<a href="javascrip:void(0)" onclick="detailView('+value+')">'+value+'</a>'
//                    }
//                },
                {
                    class: 'W120',
                    field: 'name',
                    title: '姓名',
                    sortable: true,
                    formatter: function (value, row, index) {
                        return '<a href="javascrip:void(0)" onclick="detailView('+row.id+')">'+value+'</a>'
                    }
                }, {
                    field: 'gender',
                    title: '性别',
                    sortable: true,
                }, {
                    field: 'birth',
                    title: '出生日期',
                    sortable: true,
                }, {
                    field: 'idNo',
                    title: '身份证号',
                    sortable: true,
                }, {
                    field: 'education',
                    title: '学历',
                    sortable: true,
                }, {
                    field: 'sxzhuanye',
                    title: '业务专长',
                    sortable: true,
                },
                {
                    field: 'zhiwu',
                    title: '职务',
                    sortable: true,
                },
                {
                    field: 'zhicheng',
                    title: '职称',
                    sortable: true,
                },
                {
                    field: 'profile',
                    title: '个人简介',
                    sortable: true,
                },
                {
                    field: 'szdanwei',
                    title: '所在单位',
                    sortable: true,
                },
                {
                    field: 'szbumen',
                    title: '所在部门',
                    sortable: true,
                },
                {
                    field: 'sslingyu',
                    title: '单位所属领域',
                    sortable: true,
                },
                {
                    field: 'address',
                    title: '通信地址',
                    sortable: true,
                },
                {
                    field: 'postcode',
                    title: '邮编',
                    sortable: true,
                },
                {
                    field: 'mobile',
                    title: '手机',
                    sortable: true,
                },
                {
                    field: 'phone',
                    title: '座机',
                    sortable: true,
                },
                {
                    field: 'faxcode',
                    title: '传真',
                    sortable: true,
                },
                {
                    field: 'email',
                    title: '电子邮件',
                    sortable: true,
                },
                {
                    field: 'zjpingjia',
                    title: '最佳评价',
                    sortable: true,
                },
                {
                    field: 'pycishu',
                    title: '专家聘用次数',
                    sortable: true,
                },
                {
                    field: 'remark',
                    title: '备注信息',
                    sortable: true,
                },]
        });

        $("#table").colResizable({resizeMode:'flex'});

        //请求服务数据时所传参数
        function queryParams(params) {

//            var condition = $("#condition").val();
//
//            params[condition] = $("#searchContent").val();

            params.searchValue = $("#searchContent").val();
            params.pageSize = params.limit;
            params.pageIndex = params.offset / params.limit + 1;
            params.typeId = $("#typeId").val();
            params.sortOrder=params.order;
            params.sortName= params.sort;


            return params;
        }

        //请求成功方法
        function responseHandler(result) {
            result = result.result;
            //如果没有错误则返回数据，渲染表格
            return {
                total: result[0].totalElements, //总页数,前面的key必须为"total"
                rows: result[0].content //行数据，前面的key要与之前设置的dataField的值一致.
            };
        };

        //刷新表格数据,点击你的按钮调用这个方法就可以刷新
        function refresh() {
            $('#table').bootstrapTable('refresh', {url: 'users'});
        }
    })

</script>

<script type="text/javascript">
    var button = '<a id="dLabel" role="button" data-toggle="dropdown" class="btn btn-white" href="javascript:;"><span id="select-title">选择资料分类</span> <span class="caret"></span></a>';

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


    $('.dropdown li a').click(function () {

        title = $(this).attr("data-title");
        id = $(this).attr("data-content");
        $("#select-title").text(title);
        $("#typeId").val(id)
    })

    $(document).ready(function () {
        checkMenu(3);
    })

</script>



