<link rel="stylesheet" href="static/css/bootstrap-table.min.css">
<script src="static/js/bootstrap-table.min.js"></script>
<script src="static/js/bootstrap-table-zh-CN.min.js"></script>
<script src="static/js/layer.js"></script>
<script src="static/js/colResizable-1.6.min.js"></script>
<script src="static/js/bootstrap-table-resizable.js"></script>
<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">权限列表</h1>
    </div>
    <!-- /.col-lg-12 -->
</div>

<div class="content">
    <div class="table-responsive">
    <#--<@shiro.hasPermission name="superadmin">-->
        <div id="toolbar" class="btn-group">
            <button id="btn_edit" type="button" class="btn btn-primary" onclick="createPermission()" data-toggle="modal" data-target="#permissionModal">
                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>新建
            </button>
            <button id="btn_delete" type="button" class="btn btn-danger" onclick="deletePermissions()">
                <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除
            </button>
        </div>
    <#--</@shiro.hasPermission>-->
        <table width="100%" class="table table-striped table-bordered table-hover" id="table" data-toolbar="#toolbar">
        </table>
    </div>
</div>

<!-- 权限model -->
<div class="modal fade" id="permissionModal" tabindex="-1" role="dialog" aria-labelledby="permissionModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="permissionModalLabel">新建权限</h4>
            </div>
            <div class="permission-body">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" onclick="savePermission()">保存</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>


<!-- Page-Level Demo Scripts - Tables - Use for reference -->
<script type="text/javascript">
    $(document).ready(function () {

        $('#table').bootstrapTable({
            url: 'permissions',         //请求后台的URL（*）
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
//            height: 500,                        //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
            uniqueId: "ID",                     //每一行的唯一标识，一般为主键列
            showToggle: true,                    //是否显示详细视图和列表视图的切换按钮
            cardView: false,                    //是否显示详细视图
            detailView: false,                   //是否显示父子表
            responseHandler: responseHandler,//请求数据成功后，渲染表格前的方法
            columns: [
            {
                field: 'check',
                checkbox: true,
                formatter: function (value, row, index) {
                    if (row.available == true)
                        return {
//                            disabled : true,//设置是否可用
                            checked: true//设置选中
                        };
                    return value;
                }

            },
            {
                field: 'name',
                title: '权限名称',
                sortable: true
            }, {
                field: 'identification',
                title: '权限类型',
                sortable: true
            }, {
                field: 'description',
                title: '权限描述',
                sortable: true
            }]
        });


        $("#table").colResizable({resizeMode:'flex'});

        //请求服务数据时所传参数
        function queryParams(params) {
            return {
                pageSize: params.limit, //每一页的数据行数，默认是上面设置的10(pageSize)
                pageIndex: params.offset / params.limit + 1, //当前页面,默认是上面设置的1(pageNumber)
                param: "Your Param" //这里是其他的参数，根据自己的需求定义，可以是多个
            }
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
            $('#table').bootstrapTable('refresh', {url: 'permissions'});
        }
    })

    var content = '<div class="panel-body"><div class="row"><div class="col-lg-12"><form role="form" id="permissionForm"><div class="form-group"><label>权限名称</label><input class="form-control" name="name" placeholder="请输入权限名称" /></div><div class="form-group"><label>权限类型</label><input class="form-control" name="identification" placeholder="请输入权限类型" /></div><div class="form-group"><label>权限描述</label><input class="form-control" name="description" placeholder="请输入权限描述" /></div></form></div></div></div>'
    function createPermission() {

        $('.permission-body').html(content);


        $('#permissionForm').bootstrapValidator({
            message: 'This value is not valid',
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                name: {
                    message: '权限名称校验失败',
                    validators: {
                        notEmpty: {
                            message: '权限名称不能为空'
                        }
                    }
                },
                identification: {
                    message: '权限类型校验失败',
                    validators: {
                        notEmpty: {
                            message: '权限类型不能为空'
                        }
                    }
                },
                description: {
                    message: '权限描述校验失败',
                    validators: {
                        notEmpty: {
                            message: '权限描述不能为空'
                        }
                    }
                }
            }
        })

    }

    function savePermission() {
        $.post("savePermission", $("#permissionForm").serialize(), function (result) {
            result = JSON.parse(result)
            if (result.msg == 'success') {
                layer.msg('新建权限成功');
                $("#table").bootstrapTable('refresh')
                $('.modal').map(function () {
                    $(this).modal('hide');
                });
                $(".modal-backdrop").remove();
            }else {
                layer.msg(result.msg)
            }
        });
    }

    function deletePermissions() {
        var selected = $("#table").bootstrapTable('getSelections');
        var pids = [];
        $.each(selected, function (i, item) {
            pids.push(item.id);
        })


        $.post("deletePermissionByIds", {pids: pids.join(',')}, function (result) {
            result = JSON.parse(result);
            if (result.msg == 'success') {
                layer.msg('删除角色成功');
                $("#table").bootstrapTable('refresh')
            }
        });
    }
</script>