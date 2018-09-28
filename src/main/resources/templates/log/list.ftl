<link rel="stylesheet" href="static/css/bootstrap-table.min.css">
<link rel="stylesheet" href="static/css/layer.css">
<script src="static/js/bootstrap-table.min.js"></script>
<script src="static/js/bootstrap-table-zh-CN.min.js"></script>
<script src="static/js/layer.js"></script>
<script src="static/js/jquery.form.js"></script>
<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">日志列表</h1>
    </div>
    <!-- /.col-lg-12 -->
</div>

<div class="content">
    <div class="table-responsive">

        <div id="toolbar">
            <div class="form-inline" role="form">
                <div class="form-group">
                    <span>姓名: </span>
                    <input name="operationUsername" class="form-control w70" type="text" placeholder="操作人员"/>
                </div>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <div class="form-group">
                    <span>操作信息: </span>
                    <input name="operationDetail" class="form-control w70" type="text" placeholder="操作信息"/>
                </div>
                &nbsp;&nbsp;
                <div class="form-group">
                    <button class="btn btn-default" type="button" onclick="search()">
                        <i class="fa fa-search"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<table width="100%" class="table table-striped table-bordered table-hover" id="table" data-toolbar="#toolbar">
    <thead>
    <tr>
    <#--<th data-field="id" data-checkbox="true"></th>-->
        <th>operationDescrib</th>
        <th>operationStartTime</th>
        <th>operationIp</th>
        <th>operationUserName</th>
    </tr>
    </thead>
    <tbody>
    </tbody>
</table>


<!-- Page-Level Demo Scripts - Tables - Use for reference -->
<script type="text/javascript">

    function search() {
        $('#table').bootstrapTable('refresh')
    }

    $(document).ready(function () {

        $('#table').bootstrapTable({
            url: 'logs',         //请求后台的URL（*）
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
//            height: 500,                        //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
            uniqueId: "ID",                     //每一行的唯一标识，一般为主键列
            showToggle: false,                    //是否显示详细视图和列表视图的切换按钮
            cardView: false,                    //是否显示详细视图
            detailView: false,                   //是否显示父子表
            responseHandler: responseHandler,//请求数据成功后，渲染表格前的方法

            columns: [
                {
                    field: 'id',
                    title: '编号'
                },
                {
                    field: 'operationDescrib',
                    title: '操作信息',
                    sortable: true
                },
                {
                    field: 'operationStartTime',
                    title: '操作时间'
                },
                {
                    field: 'operationIp',
                    title: '操作IP',
                    sortable: true
                },
                {
                    field: 'operationUserName',
                    title: '操作人员',
                    sortable: true
                }]
        })

        //请求服务数据时所传参数
        function queryParams(params) {
            $('#toolbar').find('input[name]').each(function () {
                params[$(this).attr('name')] = $(this).val();
            });

            params.pageSize = params.limit;
            params.pageIndex = params.offset / params.limit + 1

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
            $('#table').bootstrapTable('refresh', {url: 'logs'});
        }
    })

</script>
