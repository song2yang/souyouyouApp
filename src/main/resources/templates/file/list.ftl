<link rel="stylesheet" href="static/css/bootstrap-table.min.css">
<link rel="stylesheet" href="static/css/layer_3.1.1.css">
<link rel="stylesheet" href="static/css/fileinput.css">

<script src="static/js/respond.min.js"></script>
<#--<script src="static/js/jquery.1.9.1.min.js"></script>-->
<script src="static/js/bootstrap-table.min.js"></script>
<script src="static/js/bootstrap-table-zh-CN.min.js"></script>
<script src="static/js/table-export.min.js"></script>
<script src="static/js/layer_3.1.1.js"></script>
<script src="static/js/fileinput.js"></script>
<script src="static/js/locales/zh.js"></script>
<script src="static/js/commonList.js"></script>
<script src="static/js/colResizable-1.6.min.js"></script>
<script src="static/js/bootstrap-table-resizable.js"></script>

<style type="text/css">
    .dropdown-submenu {
        position: relative;
    }

    .dropdowmspc {
        position: absolute;
        z-index: 999;
        top: 173px;
    }

    .dropdowmspc > a {
        border: 1px solid #ccc;
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

    .mgl_125 {
        margin-left: 125px;
    }
</style>
<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">文件管理</h1>
    </div>
    <!-- /.col-lg-12 -->
</div>



<#--<div class="dropdown dropdowmspc" id="dropDown"></div>-->
<div class="content">
    <div class="table-responsive">

        <div id="toolbar">

            <form class="form-inline">
                <input type="hidden" id="fileClassify" name="fileClassify" value="${fileInfoEntity.fileClassify!}"/>
                <div class="form-group">
                    <label class="sr-only" for="searchContent">Email address</label>
                    <input type="text" id="searchContent" class="form-control" placeholder="请输入文件名搜索">
                </div>
                <div class="form-group">
                    <button class="btn btn-default" type="button" onclick="conditionSearch()">
                        <i class="fa fa-search"></i>
                    </button>
                </div>

            </form>


        </div>


        <table width="100%" class="table table-striped table-bordered table-hover" id="table" data-toolbar="#toolbar">

        </table>
    </div>
</div>


<!-- Modal -->
<div class="modal fade" id="fileuploadModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">上传文件</h4>
            </div>
            <div class="modal-body">
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
<!-- /.modal -->


<script type="text/javascript">

    function auditById(id, result,fileClassify) {
        if (result == 1) {
            layer.confirm("是否确定审核通过？", function () {

                var load = layer.load();
                $.post('auditFileById', {fileId: id, result: result,fileClassify:fileClassify}, function (result) {
                    result = JSON.parse(result)
                    layer.close(load);
                    if (result && result.msg != 'success') {
                        return layer.msg(result, so.default), !1;
                    }
                    layer.msg('审核成功。');
                    $('#table').bootstrapTable('refresh');
                });
            });
        } else {
            layer.prompt({title: '请输入拒绝原因'}, function(pass, index){
                layer.close(index);
                var load = layer.load();
                $.post('auditFileById', {fileId: id, result: result,content:pass,fileClassify:fileClassify}, function (result) {
                    result = JSON.parse(result)
                    layer.close(load);
                    if (result && result.msg != 'success') {
                        return layer.msg(result, so.default), !1;
                    }
                    layer.msg('审核成功。');
                    $('#table').bootstrapTable('refresh');
                });
            });
        }


    }


    function conditionSearch() {
        $('#table').bootstrapTable('refresh');
    }

    function deleteById(id) {
        layer.confirm("确定删除编号为【" + id + "】的文件？", function () {

            var load = layer.load();
            $.post('deleteById', {fileId: id}, function (result) {
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

    $(document).ready(function () {

        $('#table').bootstrapTable({
            url: 'files',         //请求后台的URL（*）
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
            strictSearch: false,
            showColumns: false,                  //是否显示所有的列
            showRefresh: false,                  //是否显示刷新按钮
            minimumCountColumns: 2,             //最少允许的列数
            clickToSelect: true,                //是否启用点击选中行
            height: 500,
            uniqueId: "ID",                     //每一行的唯一标识，一般为主键列
            showToggle: false,                    //是否显示详细视图和列表视图的切换按钮
            cardView: false,                    //是否显示详细视图
            detailView: false,                   //是否显示父子表
            responseHandler: responseHandler,//请求数据成功后，渲染表格前的方法
            showExport: true,
            exportDataType: "basic",

            columns: [
                {
                    field: 'id',
                    title: '文件编号',
                },
                {
                    field: 'fileClassify',
                    title: '文件类别',
                    formatter: function (value, row, index) {
                        if (value == 1)
                            return '项目文件';
                        if (value == 2)
                            return '案例库文件';
                        if (value == 3)
                            return '资料库文件';
                        if (value == 4)
                            return '专家库文件';
                        if (value == 5)
                            return '公告文件';
                    }

                },
                {
                    field: 'fileName',
                    title: '文件名称',
                    sortable: true,
                    formatter: function (value, row, index) {
                        return '<a href="downLoadFile?fileId=' + row.id + '" target="view_window">' + value + '</a>'
                    }
                },{
                    field: 'classificlevelId',
                    title: '密级',
                    formatter: function (value, row, index) {
                        if (value == 4){
                            return "机密";
                        }else if(value == 3){
                            return "秘密";
                        }else if(value == 2){
                            return "内部";
                        }else if(value == 1){
                            return "公开";
                        }
                    }
                },  {
                    field: 'createTime',
                    title: '上传日期',
                    sortable: true,
                }, {
                    field: 'creator',
                    title: '上传人',
                    sortable: true,
                }, {
                    field: 'audit',
                    title: '审核结果',
                    formatter: function (value, row, index) {

                        if (value == 1) {
                            return '审核通过';
                        } else if (value == 0) {
                            return '待审核';
                        } else {
                            return '审核未通过';
                        }

                    }
                }, {
                    field: 'operate',
                    title: '操作',
                    formatter: function (value, row, index) {
                        return '<a href="javascript:void(0)" onclick="auditById(' + row.id+','+1+','+row.fileClassify+')" style="color: green;">通过</a>&nbsp;&nbsp;' +
                                '<a href="javascript:void(0)" onclick="auditById('+row.id+','+-1+','+row.fileClassify+')" style="color: red">拒绝</a>&nbsp;'
//                                '<a href="javascript:void(0)" onclick="deleteById('+row.id+')" style="color: brown;">删除</a>'
                    }

                }]
            })

        $("#table").colResizable({resizeMode:'flex'});

    //请求服务数据时所传参数
    function queryParams(params) {
        params.searchValue = $("#searchContent").val();
        params.pageSize = params.limit;
        params.pageIndex = params.offset / params.limit + 1;
        params.fileClassify = $("#fileClassify").val();
        params.sortOrder = params.order;
        params.sortName = params.sort;


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




