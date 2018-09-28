<link rel="stylesheet" href="static/css/bootstrap-table.min.css">
<link rel="stylesheet" href="static/css/layer.css">
<script src="static/js/bootstrap-table.min.js"></script>
<script src="static/js/bootstrap-table-zh-CN.min.js"></script>
<script src="static/js/layer.js"></script>
<script src="static/js/formValidator.js"></script>
<script src="static/js/colResizable-1.6.min.js"></script>
<script src="static/js/bootstrap-table-resizable.js"></script>
<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">角色列表</h1>
    </div>
    <!-- /.col-lg-12 -->
</div>
<div class="content">
    <div class="table-responsive">
        <div id="toolbar" class="btn-group">
            <button id="btn_edit" type="button" class="btn btn-primary" onclick="createRole()" data-target="#roleModel" data-toggle="modal">
                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>新建
            </button>
            <button id="btn_delete" type="button" class="btn btn-danger" onclick="deleteRoles()">
                <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除
            </button>
        </div>
        <table width="100%" class="table table-striped table-bordered table-hover" id="table" data-toolbar="#toolbar">
        </table>
    </div>
</div>



<#--弹框-->
<div class="modal fade bs-example-modal-sm" id="selectPermission" tabindex="-1" role="dialog"
     aria-labelledby="selectPermissionLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="selectPermissionLabel">权限分配</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="selectRoleId"/>
                <form id="boxPermissionForm">
                    loading...
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" onclick="selectPermission();" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
</div>
<#--/弹框-->

<#--弹框-->
<div class="modal fade" id="roleModel" tabindex="-2" role="dialog"
     aria-labelledby="roleModelLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="roleModelLabel">新建角色</h4>
            </div>
            <div class="role-body">

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" onclick="saveRole();" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- Page-Level Demo Scripts - Tables - Use for reference -->
<script type="text/javascript">
    $(document).ready(function () {

        $('#table').bootstrapTable({
            url: 'roles',         //请求后台的URL（*）
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
            search: true,                       //是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
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
//            {
//                field: 'id',
//                title: '编号',
//                sortable: true
//            },
            {
                field: 'identification',
                title: '角色名称',
                sortable: true
            }, {
                field: 'description',
                title: '角色描述',
                sortable: true
            }, {
                field: 'operate',
                title: '操作',
                formatter: function (value, row, index) {
//                    <i class="glyphicon glyphicon-eye-open"></i>&nbsp;
                    return '<i class="glyphicon glyphicon-share-alt"></i><a href="javascript:selectPermissionByIds(' + row.id + ');">选择权限</a>'
                }
            },]
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
//            var errcode = result.errcode;//在此做了错误代码的判断
//            if (errcode != 0) {
//                alert("错误代码" + errcode);
//                return;
//            }
            //如果没有错误则返回数据，渲染表格
            return {
                total: result[0].totalElements, //总页数,前面的key必须为"total"
                rows: result[0].content //行数据，前面的key要与之前设置的dataField的值一致.
            };
        };

        //刷新表格数据,点击你的按钮调用这个方法就可以刷新
        function refresh() {
            $('#table').bootstrapTable('refresh', {url: 'roles'});
        }
    })

    /*
			*根据角色ID选择权限，分配权限操作。
			*/
    function selectPermissionByIds(id) {
        var load = layer.load();
//        setTimeout(" layer.close(load);",500000)
        $.post("findPermissionByRoleId", {rid: id}, function (result) {
            console.log(result)
            layer.close(load);
            if (result && result.length) {
                var html = [];
                html.push('<div class="checkbox"><label><input type="checkbox"  selectAllBox="">全选</label></div>');
                $.each(result, function () {
                    html.push("<div class='checkbox'><label>");
                    html.push("<input type='checkbox' selectBox='' id='");
                    html.push(this[0]);
                    html.push("'");
                    if (this[2]) {
                        html.push(" checked='checked'");
                    }
                    html.push("name='");
                    html.push(this[1]);
                    html.push("'/>");
                    html.push(this[1]);
                    html.push('</label></div>');
                });
                //初始化全选。
                return so.id('boxPermissionForm').html(html.join('')),
                        so.checkBoxInit('[selectAllBox]', '[selectBox]'),
                        $('#selectPermission').modal(), $('#selectRoleId').val(id), !1;
            } else {
                return layer.msg('没有获取到权限数据，请先添加权限数据。', so.default);
            }
        }, 'json');

    }
</script>

<script type="text/javascript">
    (function (o, w) {
        if (!w.so) w.so = {};
        return (function (so) {
            so.$1 = !0,//true
                    so.$0 = !1;//false
            /**
             * 全选
             */
            so.checkBoxInit = function (prentCheckbox, childCheckbox) {
                childCheckbox = o(childCheckbox), prentCheckbox = o(prentCheckbox);
                //先取消全选。
                //childCheckbox.add(prentCheckbox).attr('checked',!1);
                //全选
                prentCheckbox.on('click', function () {
                    childCheckbox.attr('checked', this.checked);
                });
                //子选择
                childCheckbox.on('click', function () {
                    prentCheckbox.attr('checked', childCheckbox.length === childCheckbox.end().find(':checked').not(prentCheckbox).length);
                });
            },
                    //初始化
                    so.init = function (fn) {
                        o(function () {
                            fn()
                        });
                    }
            so.id = function (id) {
                return o('#' + id);
            }
            so.default = function () {
            }

        })(so);
    })($, window);


    <#--选择权限后保存-->
    function selectPermission() {
        var checked = $("#boxPermissionForm  :checked");
        var ids = [], names = [];
        $.each(checked, function () {
            if (this.id != '') {
                ids.push(this.id);
                names.push($.trim($(this).attr('name')));
            }

        });
        var index = layer.confirm("确定操作？", function () {
        <#--loding-->
            var load = layer.load();
            $.post('savePermissions', {pids: ids.join(','), roleId: $('#selectRoleId').val()}, function (result) {
                result = JSON.parse(result)
                layer.close(load);
                if (result && result.msg != 'success') {
                    return layer.msg(result, so.default), !1;
                }
                layer.msg('添加成功。');
                $('#selectPermission').modal('hide')
//                setTimeout(function () {
//                    $('#formId').submit();
//                }, 1000);
            });
        });
    }

    var content = '<div class="panel-body"><div class="row"><div class="col-lg-12"><form role="form" id="roleForm"><div class="form-group" style="display: none"><label>角色名称</label><input class="form-control" name="name" placeholder="请输入角色名称" /></div><div class="form-group"><label>角色名称</label><input class="form-control" name="identification" placeholder="请输入角色类型" /></div><div class="form-group"><label>角色描述</label><input class="form-control" name="description" placeholder="请输入角色描述" /></div></form></div></div></div>'

    function createRole() {
        $('.role-body').html(content);

        $('#roleForm').bootstrapValidator({
            message: 'This value is not valid',
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
//                name: {
//                    message: '角色名称校验失败',
//                    validators: {
//                        notEmpty: {
//                            message: '角色名称不能为空'
//                        }
//                    }
//                },
                identification: {
                    message: '角色类型校验失败',
                    validators: {
                        notEmpty: {
                            message: '角色类型不能为空'
                        }
                    }
                },
                description: {
                    message: '角色描述校验失败',
                    validators: {
                        notEmpty: {
                            message: '角色描述不能为空'
                        }
                    }
                }
            }
        })
    }
    
    function saveRole() {
        var bootstrapValidator = $("#roleForm").data('bootstrapValidator');
        bootstrapValidator.validate();

        if (!bootstrapValidator.isValid()){
            return;
        }

        $.post("saveRole", $("#roleForm").serialize(), function (result) {
            result = JSON.parse(result);
            if (result.msg == 'success') {
                layer.msg('新建角色成功');
                $('.modal').map(function () {
                    $(this).modal('hide');
                });
                $(".modal-backdrop").remove();
                $("#table").bootstrapTable('refresh')
            }else {
                layer.msg(result.msg)
            }
        });

    }
    
    
    function deleteRoles() {
        var selected = $("#table").bootstrapTable('getSelections');
        var rids = [];
        $.each(selected, function (i, item) {
            rids.push(item.id);
        })


        $.post("deleteRoleByIds", {rids: rids.join(',')}, function (result) {

            result = JSON.parse(result)
            if (result.msg == 'success') {
                layer.msg('删除角色成功');
                $("#table").bootstrapTable('refresh')
            }
        });


    }
</script>