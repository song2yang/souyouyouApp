<link rel="stylesheet" href="static/css/bootstrap-table.min.css">
<link rel="stylesheet" href="static/css/layer.css">
<script src="static/js/bootstrap-table.min.js"></script>
<script src="static/js/bootstrap-table-zh-CN.min.js"></script>
<script src="static/js/layer.js"></script>
<script src="static/js/jquery.form.js"></script>
<script src="static/js/colResizable-1.6.min.js"></script>
<script src="static/js/bootstrap-table-resizable.js"></script>
<div class="row">
    <div class="col-lg-12">
        <input id="menuType" type="hidden" value="${menuType}" />
        <h1 class="page-header">${menuName}</h1>
    </div>
    <!-- /.col-lg-12 -->
</div>


<div class="content">
    <div class="table-responsive">
        <div id="toolbar" class="btn-group">
            <button id="btn_edit" type="button" class="btn btn-primary" onclick="createMenu()" data-target="#createMenu" data-toggle="modal">
                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>新建
            </button>
            <#--<button id="btn_delete" type="button" class="btn btn-danger" onclick="deleteUsers()">-->
                <#--<span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除-->
            <#--</button>-->
        </div>
        <table width="100%" class="table table-striped table-bordered table-hover" id="table" data-toolbar="#toolbar">
            <thead>
            <tr>
                <th>id</th>
                <th>typeName</th>
                <th>typeDesc</th>
                <th>parentTypeid</th>
                <th>createTime</th>
            </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
</div>

<#--弹框-->
<div class="modal fade" id="createMenu" role="dialog"
     aria-labelledby="createMenubel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="createUserLabel">新建菜单</h4>
            </div>
            <div class="menu-body">

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" onclick="saveMenu();" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
</div>



<!-- Page-Level Demo Scripts - Tables - Use for reference -->
<script type="text/javascript">
    $(document).ready(function () {

        $('#table').bootstrapTable({
            url: 'menus',         //请求后台的URL（*）
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
            showToggle: true,                    //是否显示详细视图和列表视图的切换按钮
            cardView: false,                    //是否显示详细视图
            detailView: false,                   //是否显示父子表
            responseHandler: responseHandler,//请求数据成功后，渲染表格前的方法

            columns: [
//                {
//                    field: 'id',
//                    title: '编号'
//                },
                {
                    field: 'typeName',
                    title: '菜单名称',
                    sortable: true
                }, {
                    field: 'typeDesc',
                    title: '菜单描述',
                    sortable: true
                }, {
                    field: 'parentTypeid',
                    title: '上级菜单',
                    formatter: function (value, row, index) {
                        var typeName = "";

                        $.ajax({
                            type: "post",
                            url: "findMenuById",
                            data: {mid:row.id},
                            async: false,
                            success: function (data) {
                                data = JSON.parse(data)
                                typeName = data.typeName;
                            }
                        });
                        return typeName;
                    }
                }, {
                    field: 'createTime',
                    title: '创建时间',
                    formatter: function (value, row, index) {
                        if (value == null) {
                            return "";
                        }
                        var offlineTimeStr = new Date(value.time).toLocaleString();
                        return offlineTimeStr;
                    }
                },{
                    field: 'operate',
                    title: '操作',
                    formatter: function (value, row, index) {
                        return '<i class="glyphicon glyphicon-remove" style="color: red"></i><a href="javascript:deleteMenuById(' + row.id +');">删除</a>'
                    }
                },]
        })

        $("#table").colResizable({resizeMode:'flex'});

        //请求服务数据时所传参数
        function queryParams(params) {
            return {
                pageSize: params.limit, //每一页的数据行数，默认是上面设置的10(pageSize)
                pageIndex: params.offset / params.limit + 1, //当前页面,默认是上面设置的1(pageNumber)
                menuType: $("#menuType").val() //这里是其他的参数，根据自己的需求定义，可以是多个
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

</script>

<script type="text/javascript">

    function createMenu() {
        $.post("menusNoPage", {menuType:$("#menuType").val()}, function (result) {

            result = JSON.parse(result).result;

            var options = "<option value='0'>顶级菜单</option>"
            $(result).each(function(){
                options += '<option value="'+this.id+'">'+this.typeName+'</option>'
            });

            var htmlStr = '<div class="panel-body"><div class="row"><div class="col-lg-12"><form role="form" id="menuForm"><div class="form-group"><input type="hidden" name="type" value="'+$("#menuType").val()+'"/><label for="select">上级菜单</label><select id="select" name="parentTypeid" class="form-control"><option value="-1">请选择父级菜单</option>'+options+'</select></div><div class="form-group"><label>菜单名称</label><input class="form-control" name="typeName" placeholder="请输入菜单名称"></div><div class="form-group"><label>菜单描述</label><input class="form-control" name="typeDesc" placeholder="请输入菜单描述"></div></form></div></div></div>'


            $('.menu-body').html(htmlStr);

            $('#menuForm').bootstrapValidator({
                message: 'This value is not valid',
                feedbackIcons: {
                    valid: 'glyphicon glyphicon-ok',
                    invalid: 'glyphicon glyphicon-remove',
                    validating: 'glyphicon glyphicon-refresh'
                },
                fields: {
                    typeName: {
                        message: '菜单名称校验失败',
                        validators: {
                            notEmpty: {
                                message: '菜单名称不能为空'
                            }
                        }
                    },
                    typeDesc: {
                        message: '菜单描述校验失败',
                        validators: {
                            notEmpty: {
                                message: '菜单描述不能为空'
                            }
                        }
                    },
                    parentTypeid: {
                        message:'菜单描述菜单不能为空',
                        validators: {
                            callback:{
                                callback: function(value, validator) {
                                    if (value == -1){
                                        return false;
                                    }else {
                                        return true;
                                    }
                                }
                            }
                        }
                    },
                }
            });
        });


    }
    
    function saveMenu() {

        var bootstrapValidator = $("#menuForm").data('bootstrapValidator');
        bootstrapValidator.validate();

        if (!bootstrapValidator.isValid()){
            return;
        }

        $.post("saveMenu", $("#menuForm").serialize(), function (result) {
            result = JSON.parse(result);
            if (result.msg == 'success') {
                layer.msg('新建菜单成功');
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
    
    function deleteMenuById(id) {

        $.post('findChildMenu',{id:id},function (result) {


            result = JSON.parse(result);

            if (result.msg != 'success'){
                layer.msg('系统异常');
                return;
            }
            
            if (result.msg == 'success' && result.childrenNames != ''){
                layer.alert("该菜单包含"+result.childrenNames+"子菜单,请先删除子菜单");
//                layer.confirm("该菜单下有"+result.childrenNames+"确定删除？", function () {
//                    var load = layer.load();
//                    deleteMenu(id);
//                });
            }else {
                layer.confirm("确定删除?",function () {
                    deleteMenu(id);
                });
            }

        })

        
    }
    
    function deleteMenu(id) {
        $.post('deleteMenu', {id:id}, function (result) {

            var load = layer.load();
            result = JSON.parse(result)
            layer.close(load);
            if (result && result.msg != 'success') {
                return layer.msg(result, so.default), !1;
            }
            layer.msg('删除成功。');
            $("#table").bootstrapTable('refresh')
            $('#deleteMenu').modal('hide');
        });
    }


</script>