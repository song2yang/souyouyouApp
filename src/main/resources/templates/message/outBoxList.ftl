<link rel="stylesheet" href="static/css/bootstrap-table.min.css">
<link rel="stylesheet" href="static/css/AdminLTE-without-plugins.css">
<script src="static/js/bootstrap-table.min.js"></script>
<script src="static/js/bootstrap-table-zh-CN.min.js"></script>

<style>
    .fixed-table-pagination{
        display: none!important;
    }
    .spc_span{
        width: 250px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        display: inline-block;
    }
    .fl{
        float: left;
    }
</style>
<div class="content">

    <div class="row">
        <div class="col-lg-12">
            <h1 class="page-header">发件箱</h1>
        </div>
        <!-- /.col-lg-12 -->
    </div>
    <div class="box">

        <!-- /.box-header -->
        <div class="mailbox-controls">
            <!-- Check all button -->
            <button type="button" class="btn btn-default btn-sm checkbox-toggle"><i class="fa fa-square-o"></i>
            </button>
            <div class="btn-group">
                <button type="button" onclick="newMsg()" class="btn btn-default btn-sm"><i class="glyphicon glyphicon-edit"></i></button>
                <button type="button" class="btn btn-default btn-sm"><i class="fa fa-trash-o"></i></button>
                <#--<button type="button" class="btn btn-default btn-sm"><i class="fa fa-reply"></i></button>-->
                <#--<button type="button" class="btn btn-default btn-sm"><i class="fa fa-share"></i></button>-->
            </div>
            <!-- /.btn-group -->
            <button type="button" class="btn btn-default btn-sm"><i class="fa fa-refresh"></i></button>
            <div class="pull-right">
                1-50/200
                <div class="btn-group">
                    <button type="button" class="btn btn-default btn-sm" onclick="prevPage()"><i class="fa fa-chevron-left"></i></button>
                    <button type="button" class="btn btn-default btn-sm" onclick="nextPage()"><i class="fa fa-chevron-right"></i></button>
                </div>
                <!-- /.btn-group -->
            </div>
            <!-- /.pull-right -->
        </div>
        <div class="table-responsive mailbox-messages">
            <table class="table table-no-bordered table-hover table-striped" id="table" data-buttonsToolbar="#toolbar">

            </table>
            <!-- /.table -->
        </div>
        <div class="mailbox-controls">
            <!-- Check all button -->
            <button type="button" class="btn btn-default btn-sm checkbox-toggle"><i class="fa fa-square-o"></i>
            </button>
            <div class="btn-group">
                <button type="button" class="btn btn-default btn-sm"><i class="glyphicon glyphicon-edit"></i></button>
                <button type="button" class="btn btn-default btn-sm"><i class="fa fa-trash-o"></i></button>
                <#--<button type="button" class="btn btn-default btn-sm"><i class="fa fa-reply"></i></button>-->
                <#--<button type="button" class="btn btn-default btn-sm"><i class="fa fa-share"></i></button>-->
            </div>
            <!-- /.btn-group -->
            <button type="button" class="btn btn-default btn-sm"><i class="fa fa-refresh"></i></button>
            <div class="pull-right">
                1-50/200
                <div class="btn-group">
                    <button type="button" class="btn btn-default btn-sm" onclick="prevPage()"><i class="fa fa-chevron-left"></i></button>
                    <button type="button" class="btn btn-default btn-sm" onclick="nextPage()"><i class="fa fa-chevron-right"></i></button>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    function prevPage() {
        $("#table").bootstrapTable('prevPage');
    }


    function nextPage() {
        $("#table").bootstrapTable('nextPage');
    }

    function detail(mid,id) {

        $("#page-wrapper").load("msgDetail?mid="+mid+"&id="+id+"&type=to")

    }

    function newMsg() {
        $("#page-wrapper").load("newMessage")
    }

    $(document).ready(function () {

        function getContacts(uid) {
            var user;
            $.ajax({
                type: "post",
                url: "getContacts",
                data: {uid: uid},
                async: false,
                success: function (result) {
                    user = JSON.parse(result);
                }
            });

            return user;
        }


        function getMessage(mid) {
            var message;
            $.ajax({
                type: "post",
                url: "findMsgByMid",
                data: {mid: mid},
                async: false,
                success: function (result) {
                    message = JSON.parse(result);
                }
            });

            return message;
        }

        $('#table').bootstrapTable({
            url: 'outBoxes',         //请求后台的URL（*）
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
//            height: 600,                        //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
            uniqueId: "ID",                     //每一行的唯一标识，一般为主键列
            showToggle: false,                    //是否显示详细视图和列表视图的切换按钮
            cardView: false,                    //是否显示详细视图
            detailView: false,                   //是否显示父子表
            responseHandler: responseHandler,//请求数据成功后，渲染表格前的方法
            showExport: false,
            exportDataType: "basic",
            showHeader : false,

            columns: [
                {
                    field: 'senderId',
//                    title: '发件人',
                    formatter: function (value, row, index) {
                        console.log(row)
                        var user = getContacts(value);
                        var msg = getMessage(row.msgId);
                        var pIndex = msg.content.indexOf('</p>');
                        var content = msg.content.substring(3,pIndex+4)
                        var date = new Date(msg.createTime.time);
                        var formatDate = date.getFullYear()+'-'+date.getMonth()+'-'+date.getDay()+' '+date.getHours()+':'+date.getMinutes()+':'+date.getSeconds();

                        return  '<td><input type="checkbox"></td><td class="mailbox-star"><a href="#"><i class="fa fa-star-o text-yellow"></i></a></td> ' +
                                '<td class="mailbox-name"><a href="javascrip:void(0)" onclick="detail(' + row.msgId + ','+row.id+')">'+user.username+'</a></td> <td onclick="detail(' + row.msgId + ','+row.id+')" class="mailbox-subject" style="width: 65%"><b class="fl">'+msg.title+'</b> ' +
                                '<span class="spc_span">-'+content+'</span></td><td onclick="detail(' + row.msgId + ','+row.id+')" class="mailbox-attachment"><i class="fa fa-paperclip"></i></td> ' +
                                '<td class="mailbox-date">'+formatDate+'</td>';
                    }
                },

            ]
        })

        //请求服务数据时所传参数
        function queryParams(params) {

            var condition = $("#condition").val();

            params[condition] = $("#searchContent").val();

            params.pageSize = params.limit;
            params.pageIndex = params.offset / params.limit + 1;
            params.typeId = $("#typeId").val()


            return params;
        }

        //请求成功方法
        function responseHandler(result) {
            result = result.result;
            console.log(result)
            //如果没有错误则返回数据，渲染表格
            return {
                total: result[0].totalElements, //总页数,前面的key必须为"total"
                rows: result[0].content //行数据，前面的key要与之前设置的dataField的值一致.
            };
        };

        //刷新表格数据,点击你的按钮调用这个方法就可以刷新
        function refresh() {
            $('#table').bootstrapTable('refresh', {url: 'outBoxes'});
        }
    })


</script>

<style>
    .content-text > p{
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        width: 45%;
    }
</style>