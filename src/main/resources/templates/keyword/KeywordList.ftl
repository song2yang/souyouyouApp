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
        <h1 class="page-header">标签列表 </h1>
    </div>
    <!-- /.col-lg-12 -->
</div>


<div class="content">
    <div class="table-responsive">
        <div id="toolbar">
            <form class="form-inline">

                <div class="form-group">
                    <select id="isPrivate" name="isPrivate" class="form-control">
                        <option value="1" selected="selected">私有</option>
                        <option value="0">公有</option>
                    </select>
                </div>

                <@shiro.hasPermission name="keyword:delete">
                    <div class="form-group">
                        <a href="javascript:void(0)" class="btn btn-danger" onclick="DeleteKeyword()">删除</a>
                    </div>
                </@shiro.hasPermission>


            </form>
        </div>
    </div>

    <table width="100%" class="table table-striped table-bordered table-hover" id="table" data-toolbar="#toolbar">
        <thead>
        <tr>
            <th data-field="id" data-checkbox="true"></th>
            <th>标签内容</th>
            <th>所属模块</th>
            <th>创建者</th>
            <th>创建时间</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
</div>
</div>


<!-- Page-Level Demo Scripts - Tables - Use for reference -->
<script type="text/javascript">
    $(document).ready(function () {

        $('#table').bootstrapTable({
            url: 'LoadKeyWord',         //请求后台的URL（*）
            method: 'get',                      //请求方式（*）
            toolbar: '#toolbar',                //工具按钮用哪个容器
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
            showRefresh: false,                  //是否显示刷新按钮
            minimumCountColumns: 2,             //最少允许的列数
            clickToSelect: true,                //是否启用点击选中行
            height: 500,                        //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
            uniqueId: "id",                     //每一行的唯一标识，一般为主键列
            showToggle: false,                    //是否显示详细视图和列表视图的切换按钮
            cardView: false,                    //是否显示详细视图
            detailView: false,                   //是否显示父子表
            responseHandler: responseHandler,//请求数据成功后，渲染表格前的方法

            columns: [
                {
                    field: 'check',
                    checkbox: true
                },
                {
                    field: 'id',
                    title: '标签id',
                    visible: false
                },
                {
                    field: 'keywordValue',
                    title: '标签内容',
                    sortable: true,
                    formatter: function (value, row, index) {
                        //
//                    <i class="glyphicon glyphicon-eye-open"></i>&nbsp;
                        return '<a href="javascript:void(0)" target="_blank" onclick="gotoTarget(' + row.entityId + ','+row.modules+')">' + row.keywordValue + '</a>'
                    }
                },
                {
                    field: 'modules',
                    title: '所属模块',
                    sortable: true,
                    formatter: function (value, row, index) {
                        if (value == 1) {

                            return "项目";

                        } else if (value == 2) {
                            return "资料";
                        } else if (value == 3) {
                            return "案例";
                        } else if (value == 4) {
                            return "专家";
                        } else {
                            return "公告";
                        }
                    }
                },
                {
                    field: 'userName',
                    title: '创建者',
                    sortable: true
                },
                {
                    field: 'createTime',
                    title: '创建时间',
                    sortable: true,
                    formatter: function (value, row, index) {
                        if (value == null) {
                            return "";
                        }
                        var offlineTimeStr = new Date(value.time).toLocaleDateString();
                        return offlineTimeStr;
                    }
                }
            ]
        })

        $("#table").colResizable({resizeMode:'flex'});

        //请求服务数据时所传参数
        function queryParams(params) {
            return {
                pageSize: params.limit, //每一页的数据行数，默认是上面设置的10(pageSize)
                pageIndex: params.offset / params.limit + 1, //当前页面,默认是上面设置的1(pageNumber)
                isprivate: $("#isPrivate").val()
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

    })

    //刷新表格数据,点击你的按钮调用这个方法就可以刷新
    function refresh() {
        $('#table').bootstrapTable('refresh', {url: 'LoadKeyWord'});
    }

    $("#isPrivate").change(function () {
        refresh();

    })

    function DeleteKeyword() {

        var selected = $("#table").bootstrapTable('getSelections');
        if (selected == null || selected.length <= 0) {
            layer.msg('请选择要删除的标签！');
            return;
        }

        var index = layer.confirm("确定要删除所选的标签吗？", function () {
            var kids = [];
            $.each(selected, function (i, item) {
                kids.push(item.id);
            })

            $.post("DeleteKeyWordByIds", {kids: kids.join(',')}, function (result) {
                result = JSON.parse(result)
                if (result.msg == 'ok') {
                    layer.msg('删除标签成功。');
                    $("#table").bootstrapTable('refresh')
                } else {
                    layer.msg('删除标签失败。');
                    layer.close(index);
                }
            });
        });
    }

    function gotoTarget(eid,tid) {

        if (tid == 1) {
            $("#page-wrapper").load("ProjectDetail?pid=" + eid);
        } else if (tid == 2) {
            $("#page-wrapper").load("createData?zid=" + eid);
        } else if (tid == 3) {
            $("#page-wrapper").load("createAnliPage?aid=" + eid);
        } else if (tid == 4) {
            $("#page-wrapper").load("expert?eid=" + eid);
        } else if (tid == 5){
            $("#page-wrapper").load("createAnnoucePage?aid=" + eid);
        }
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

    function createProject() {
        tab(12);
    }

</script>