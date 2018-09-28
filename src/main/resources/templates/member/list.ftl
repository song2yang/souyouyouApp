<link rel="stylesheet" href="static/css/bootstrap-table.min.css">
<link rel="stylesheet" href="static/css/layer.css">
<script src="static/js/bootstrap-table.min.js"></script>
<script src="static/js/bootstrap-table-zh-CN.min.js"></script>
<script src="static/js/layer.js"></script>
<script src="static/js/jquery.form.js"></script>
<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">用户列表</h1>
    </div>
    <!-- /.col-lg-12 -->
</div>


<div class="content">
    <div class="table-responsive">
    <@shiro.hasAnyRoles name="administrator,superadmin">
        <div id="toolbar" class="btn-group">
            <button id="btn_edit" type="button" class="btn btn-primary" data-target="#createUser" data-toggle="modal"
                    onclick="createUser()">
                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>新建
            </button>
            <button id="btn_delete" type="button" class="btn btn-danger" onclick="deleteUsers()">
                <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除
            </button>
        </div>
    </@shiro.hasAnyRoles>
    <table width="100%" class="table table-striped table-bordered table-hover" id="table" data-toolbar="#toolbar">
            <thead>
            <tr>
                <th data-field="id" data-checkbox="true"></th>
                <th>username</th>
                <th>positions</th>
                <th>mobile</th>
                <th>description</th>
                <th>status</th>
            </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
</div>



<#--弹框-->
<div class="modal fade bs-example-modal-sm" id="selectRole" tabindex="-1" role="dialog"
     aria-labelledby="selectRoleLabel">
    <div class="modal-dialog modal-sm" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="selectRoleLabel">角色分配</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="selectUserId"/>
                <form id="boxRoleForm">
                    loading...
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" onclick="selectRole();" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
</div>
<#--/弹框-->



<#--弹框-->
<div class="modal fade" id="createUser" role="dialog"
     aria-labelledby="createUserLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="createUserLabel">新建用户</h4>
            </div>
            <div class="user-body">

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" onclick="saveUser();" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
</div>
<!-- Page-Level Demo Scripts - Tables - Use for reference -->
<script type="text/javascript">
    $(document).ready(function () {

        $('#table').bootstrapTable({
            url: 'users',         //请求后台的URL（*）
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
            height: 500,
            uniqueId: "ID",                     //每一行的唯一标识，一般为主键列
            showToggle: true,                    //是否显示详细视图和列表视图的切换按钮
            cardView: false,                    //是否显示详细视图
            detailView: false,                   //是否显示父子表
            responseHandler: responseHandler,//请求数据成功后，渲染表格前的方法

            columns: [
                {
                    field: 'check',
                    checkbox: true,
                },
//                {
//                    field: 'id',
//                    title: '编号'
//                },
                {
                    field: 'username',
                    title: '用户名',
                },
                {
                    field: 'realName',
                    title: '真实姓名',
                },{
                    field: 'positions',
                    title: '职务',
                    formatter: function (value) {
                        var positions = '';
                        if (value == '1') {
                            positions = '主任';
                        }
                        if (value == '2') {
                            positions = '处长';
                        }
                        if (value == '3') {
                            positions = '助理';
                        }

                        return positions;
                    }
                }, {
                    field: 'mobile',
                    title: '手机号',
                }, {
                    field: 'permissionLevel',
                    title: '密级',
                    formatter: function (value) {
                        var permissionLevel = '';
                        if (value == '1') {
                            permissionLevel = '公开';
                        }
                        if (value == '2') {
                            permissionLevel = '内部';
                        }
                        if (value == '3') {
                            permissionLevel = '秘密';
                        }
                        if (value == '4') {
                            permissionLevel = '机密';
                        }

                        return permissionLevel;
                    }
                }, {
                    field: 'description',
                    title: '描述信息',
                }, {
                    field: 'available',
                    title: '状态',
                    formatter: function (value) {
                        var status = '';
                        if (value) {
                            status = '正常';
                        } else {
                            status = '禁用';
                        }

                        return status;

                    }
                }, {
                    field: 'operate',
                    title: '操作',
                    formatter: function (value, row, index) {
                        var id = row.id;
                        var userName = row.username;
                        var divStr = '';
                        if (row.available){
                            divStr = '<@shiro.hasAnyRoles name="administrator,superadmin"><i class="fa fa-eye-slash danger" style="color: red;"/>&nbsp;<a href="javascript:void(0)" onclick="operateUser('+id+',0,\''+userName+'\');">禁用</a></@shiro.hasAnyRoles>';
                        }else {
                            divStr = '<@shiro.hasAnyRoles name="administrator,superadmin"><i class="fa fa-eye primary" style="color: green"/>&nbsp;<a href="javascript:void(0)" onclick="operateUser('+id+',1,\''+userName+'\');">启用</a></@shiro.hasAnyRoles>';
                        }

                        return '<@shiro.hasAnyRoles name="securitor,superadmin"><i class="glyphicon glyphicon-share-alt"></i>&nbsp;<a href="javascript:selectRoleById(' + row.id + ');">分配角色</a>&nbsp;&nbsp;</@shiro.hasAnyRoles>'+divStr;
                    }
                },]
        })

        //请求服务数据时所传参数
        function queryParams(params) {
            return {
                pageSize: params.limit,
                pageIndex: params.offset / params.limit + 1,
                param: "Your Param"
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
            $('#table').bootstrapTable('refresh', {url: 'users'});
        }
    })
    
    
    function operateUser(uid,status,username) {

        var msg = '';
        if (status == 0){
            msg = '确定禁止用户【'+username+'】登录?'
        }else {
            msg = '确定允许用户【'+username+'】登录?'
        }


        layer.confirm(msg, function () {
            $.post('operateUser', {uid: uid, status: status}, function (result) {
                result = JSON.parse(result)
                if (result && result.msg != 'success') {
                    return layer.msg(result.msg);
                }
                $('#table').bootstrapTable('refresh', {url: 'users'});
                layer.msg('账户状态修改成功。');
            });
        });
    }

    /*
			*根据角色ID选择权限，分配权限操作。
			*/
    function selectRoleById(id) {
        var load = layer.load();
        $.post("findRoleByUserId", {id: id}, function (result) {
            result = result.result;
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
                return so.id('boxRoleForm').html(html.join('')),
                        so.checkBoxInit('[selectAllBox]', '[selectBox]'),
                        $('#selectRole').modal(), $('#selectUserId').val(id), !1;
            } else {
                return layer.msg('没有获取到角色数据，请先添加角色数据。', so.default);
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
    function selectRole() {
        var checked = $("#boxRoleForm  :checked");
        var ids = [], names = [];
        $.each(checked, function () {
            if (this.id != '') {
                ids.push(this.id);
                names.push($.trim($(this).attr('name')));
            }

        });
        var index = layer.confirm("确定操作？", function () {
            var load = layer.load();
            $.post('saveRoles', {rids: ids.join(','), userId: $('#selectUserId').val()}, function (result) {
                result = JSON.parse(result)
                layer.close(load);
                if (result && result.msg != 'success') {
                    return layer.msg(result, so.default), !1;
                }
                layer.msg('添加成功。');
                $('#selectRole').modal('hide');
            });
        });
    }

    var content = '<div class="panel-body"><div class="row"><div class="col-lg-10"><form role="form" id="userForm"><div class="form-group"><label>用户名</label><input class="form-control" name="username" placeholder="请输入用户名"></div><div class="form-group"><label>真实姓名</label><input class="form-control" name="realName" placeholder="请输入真实姓名"></div><div class="form-group"><label>密码</label><input class="form-control" name="password" placeholder="请输入密码"></div><div class="form-group"><label for="select">职务</label><select id="select" name="positions" class="form-control"><option value="-1">请选择职务</option><option value="1">主任</option><option value="2">处长</option><option value="3">助理</option></select></div><div class="form-group"><label for="select">密级</label><select id="select" name="permissionLevel" class="form-control"><option value="4">机密</option><option value="3">秘密</option><option value="2">内部</option><option value="1">公开</option></select></div><div class="form-group"><label>手机号码</label><input class="form-control" name="mobile" placeholder="请输入手机号码"></div><div class="form-group"><label>描述信息</label><input class="form-control" name="description" placeholder="请输入描述信息"></div></form></div></div></div>';


    function createUser() {
        $('.user-body').html(content)

        $('#userForm').bootstrapValidator({
            message: 'This value is not valid',
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                username: {
                    message: '用户名校验失败',
                    validators: {
                        notEmpty: {
                            message: '用户名不能为空'
                        }
                    }
                },
                realName: {
                    message: '真实姓名校验失败',
                    validators: {
                        notEmpty: {
                            message: '真实姓名不能为空'
                        }
                    }
                },
                password: {
                    message: '密码校验失败',
                    validators: {
                        notEmpty: {
                            message: '密码不能为空'
                        }
                    }
                },
                mobile: {
                    message: '手机校验失败',
                    validators: {
                        notEmpty: {
                            message: '手机不能为空'
                        },
                        stringLength: {
                            min: 11,
                            max: 11,
                            message: '请输入11位手机号码'
                        },
                        regexp: {
                            regexp: /^1[3|5|8]{1}[0-9]{9}$/,
                            message: '请输入正确的手机号码'
                        }

                    }
                },
                description: {
                    message: '描述校验失败',
                    validators: {
                        notEmpty: {
                            message: '描述不能为空'
                        }
                    }
                },
                positions: {
                    message: '职位不能为空',
                    validators: {
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
                },
            }
        })
    }


    function saveUser() {


        var bootstrapValidator = $("#userForm").data('bootstrapValidator');
        bootstrapValidator.validate();

        if (!bootstrapValidator.isValid()) {
            return;
        }


        $.post("saveUser", $("#userForm").serialize(), function (result) {
            result = JSON.parse(result);
            if (result.msg == 'success') {
                layer.msg('新建用户成功');
                $("#table").bootstrapTable('refresh')
                $('.modal').map(function () {
                    $(this).modal('hide');
                });
                $(".modal-backdrop").remove();
            } else {
                layer.msg(result.msg)
            }
        });

    }
    function deleteUsers() {
        var selected = $("#table").bootstrapTable('getSelections');
        var uids = [];
        $.each(selected, function (i, item) {
            uids.push(item.id);
        })

        var index = layer.confirm("确定要删除所选用户吗？", function () {
            $.post("deleteUserByIds", {uids: uids.join(',')}, function (result) {
                result = JSON.parse(result);
                if (result.msg == 'success') {
                    layer.msg('删除用户成功');
                    $("#table").bootstrapTable('refresh')
                }
            });
        })

    }
</script>