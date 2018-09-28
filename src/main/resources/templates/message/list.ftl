<link rel="stylesheet" href="static/css/bootstrap-select.css">
<link rel="stylesheet" href="static/css/bootstrap-table.min.css">
<link rel="stylesheet" href="static/css/layer.css">

<script type="text/javascript" src="static/js/bootstrap-select.js"></script>
<script src="static/js/bootstrap-table.min.js"></script>
<script src="static/js/bootstrap-table-zh-CN.min.js"></script>
<script src="static/js/table-export.min.js"></script>
<script src="static/js/layer.js"></script>
<script src="static/js/fileinput.js"></script>
<script src="static/js/locales/zh.js"></script>
<script src="static/js/jquery.form.js"></script>
<script src="static/js/colResizable-1.6.min.js"></script>
<script src="static/js/bootstrap-table-resizable.js"></script>

<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">聊天室</h1>
    </div>
    <!-- /.col-lg-12 -->
</div>



<#--<div class="dropdown dropdowmspc" id="dropDown"></div>-->
<div class="content">
    <div class="table-responsive">

        <div id="toolbar">

            <form class="form-inline">
            <@shiro.hasPermission name="datum:add">
                <div class="form-group">
                    <a href="javascript:void(0)" class="btn btn-info" data-target="#createGroup" data-toggle="modal">新建</a>
                </div>
            </@shiro.hasPermission>
                <div class="form-group">
                    <a href="javascript:void(0)" class="btn btn-danger" onclick="deleteById()">删除</a>
                </div>
            </form>


        </div>


        <table width="100%" class="table table-striped table-bordered table-hover" id="table" data-toolbar="#toolbar">

        </table>
    </div>
</div>


<!-- Modal -->
<div class="modal fade" id="createGroup" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">新建聊天</h4>
            </div>
            <div class="modal-body">
                <div class="panel-body">
                    <div class="row">
                        <div class="col-lg-10">
                            <form role="form" id="groupForm">
                                <div class="form-group">
                                    <label>群聊名称</label>
                                    <input class="form-control" name="groupName" placeholder="请输入群聊名称"></div>
                                <div class="form-group">
                                    <label>群聊成员</label>
                                    <select id="uId" name="uId" class="selectpicker form-control" multiple required data-live-search="true">
                                        <#--<option value="-1">请选择成员</option>-->
                                    <#foreach user in users>
                                        <option value="${user.id?c}">${user.realName!}</option>
                                    </#foreach>
                                    </select>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal" >关闭</button>
                <button type="button" class="btn btn-primary" id="saveFile" onclick="createGroup()">保存</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- /.modal -->


<script type="text/javascript">

    $(document).ready(function () {
        $('#uId').selectpicker();

    })

    function detailView(id) {
        $("#page-wrapper").load("createData?zid=" + id)
    }

    function deleteById() {

        var selected = $("#table").bootstrapTable('getSelections');
        var ids = [];
        $.each(selected, function (i, item) {
            ids.push(item.id);
        })

        if (ids.length == 0) {
            layer.msg("请勾选要删除的记录!");
            return;
        }
        layer.confirm("确定删除已勾选记录？", function () {

            var load = layer.load();
            $.post('delGroup', {ids: ids.join(',')}, function (result) {
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

    function createGroup() {

        var options = {
            url: 'createGroup',
            type: 'post',
            beforeSend: function (xhr) {

            },
            success: function (data) {
                data = JSON.parse(data)
                if (data.msg == "success") {

                    $('#table').bootstrapTable('refresh');

                    layer.msg("新建群聊成功!");

                    $('.modal').map(function () {
                        $(this).modal('hide');
                    });
                    $(".modal-backdrop").remove();
                } else {
                    layer.msg("新建群聊失败，请稍后重试!");
                }

            },
            error: function (xhr, status, msg) {
                layer.msg('玩命加载中..');

            }
        };
        $("#groupForm").ajaxSubmit(options);


    }
    
    function msgGroupDetail(id) {
        $("#page-wrapper").load("msgDetail/?msgGroupId="+id)
    }


    $(document).ready(function () {

        $('#table').bootstrapTable({
            url: 'msgGroups',         //请求后台的URL（*）
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
                    field: 'check',
                    checkbox: true
                },
                {
                    field: 'groupName',
                    title: '群聊名称',
                    sortable: true,
                    formatter:function (value, row, index) {
//                        return '<a href="msgDetail?msgGroupId='+row.id+'">'+value+'</a>'
                        return '<a href="javascript:void(0)" onclick="msgGroupDetail('+row.id+')">'+value+'</a>'
                    }
                }, {
                    field: 'groupUsers',
                    title: '群聊成员',
                    sortable: true,
                }]
        })

        $("#table").colResizable({resizeMode:'flex'});

        //请求服务数据时所传参数
        function queryParams(params) {

            params.pageSize = params.limit;
            params.pageIndex = params.offset / params.limit + 1;
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
            $('#table').bootstrapTable('refresh', {url: 'msgGroups'});
        }
    })

</script>



