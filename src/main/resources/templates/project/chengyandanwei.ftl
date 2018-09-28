<div class="panel-body">
    <#--<form class="form-inline">-->
        <#--<div class="form-group">-->
            <#--<label>选择单位类型:</label>-->
            <#--<select class="form-control" style="width: 150px;" id="danweitypelist"-->
                    <#--name="danweitypelist" onchange="refreshCyDanweiTable()">-->
                <#--<option value="1" selected>主承研单位</option>-->
                <#--<option value="2">联合承研单位</option>-->
                <#--<option value="3">外协单位</option>-->
            <#--</select>-->
        <#--</div>-->
        <#--<div class="form-group" style="margin-left: 50px;">-->
        <#--&lt;#&ndash;<button id="btn_searchfeetype" type="button" class="btn btn-primary"&ndash;&gt;-->
        <#--&lt;#&ndash;onclick="refreshMoneyTable()">&ndash;&gt;-->
        <#--&lt;#&ndash;<span class="glyphicon glyphicon-search" aria-hidden="true"></span>查询&ndash;&gt;-->
        <#--&lt;#&ndash;</button>&ndash;&gt;-->
        <#--</div>-->
    <#--</form>-->

    <div class="table-responsive"  id="danweidiv">
        <div id="danweitabletoolbar" class="btn-group">
        <#--<@shiro.hasPermission name="cydanwei:add">-->
            <button id="btn_cydanwei" type="button" class="btn btn-primary"
                    style="" onclick="AddCyDanwei()">
                <span class="glyphicon glyphicon-book" aria-hidden="true"></span>添加
            </button>
        <#--</@shiro.hasPermission>-->
        <#--<@shiro.hasPermission name="cydanwei:edit">-->
            <button id="btn_cydanwei" onclick="EditCyDanwei()" type="button" class="btn btn-primary"
                    style="margin-left: 20px;">
                <span class="glyphicon glyphicon-edit" aria-hidden="true"></span>编辑
            </button>
        <#--</@shiro.hasPermission>-->
        <#--<@shiro.hasPermission name="cydanwei:delete">-->
            <button id="btn_cydanwei" type="button" onclick="DeleteDanwei()" class="btn btn-danger"
                    style="margin-left: 20px;" onclick="">
                <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除
            </button>
        <#--</@shiro.hasPermission>-->
            <div>
                <label>研究周期：${proentity.yanjiuZhouQi!}个月</label>
            </div>
        </div>

        <table width="100%" class="table table-striped table-bordered table-hover"
               id="danweitable" data-toolbar="#danweitabletoolbar" style="margin-top:20px;">
        </table>

    </div>

</div>


<!-- Modal 添加催收记录-->
<button id="btn_addcydanwei" type="button" class="btn btn-primary"
        style="display:none" data-toggle="modal"
        data-target="#addcydanweiModal" onclick="">
    <span class="glyphicon glyphicon-book" aria-hidden="true"></span>
</button>
<div class="modal fade" id="addcydanweiModal" role="dialog" aria-labelledby="cydanweiModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="cydanweiModalLabel">承研单位</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <form role="form" id="cydanweiForm" name="cydanweiForm">
                        <input type="hidden" id="proid" name="proid" value="${proentity.id}">
                        <input type="hidden" id="editDanweiId" name="editDanweiId" value="0">
                        <div class="form-group col-md-6">
                            <label>单位类型</label>
                            <select id="type" name="type" class="form-control">
                                <#--<option value="0">请选择</option>-->
                                <option value="1">主承研单位</option>
                                <option value="2">联合承研单位</option>
                                <option value="3">外协单位</option>
                            </select>
                        </div>
                        <div class="form-group col-md-6">
                            <label>单位名称</label>
                            <input class="form-control"
                                   id="danweiName"
                                   name="danweiName">
                        </div>
                        <div class="form-group col-md-6">
                            <label>承研经费</label>
                            <input class="form-control" id="fee" name="fee">
                        </div>
                        <div class="form-group col-md-6">
                            <label>合同签订时间</label>
                            <input class="form-control" type="date" id="contractTime" name="contractTime">
                        </div>
                        <div class="form-group col-md-6">
                            <label>验收时间</label>
                            <input class="form-control" type="date" id="yanshouTime" name="yanshouTime">
                        </div>
                        <div class="form-group col-md-6">
                            <label>联系人</label>
                            <input class="form-control" id="contractName" name="contractName">
                        </div>
                        <div class="form-group col-md-6">
                            <label>联系电话</label>
                            <input class="form-control" id="mobile" name="mobile">
                        </div>

                        <div class="form-group col-md-12">
                            <label>内容</label>
                            <textarea class="form-control" rows="5" id="content"
                                      name="content"></textarea>
                        </div>
                    </form>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" onclick="" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" onclick="SaveDanwei()" id="SaveDanwei">保存</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- /.modal -->
<script type="text/javascript" language="JavaScript">


    function AddCyDanwei() {
        $("#type").val("0");
        $("#editDanweiId").val("0");
        $("#danweiName").val("");
        $("#contractName").val("");
        $("#mobile").val("");

        $("#btn_addcydanwei").trigger("click");
    }

    function DeleteDanwei() {

        var selected = $("#danweitable").bootstrapTable('getSelections');
        if (selected == null || selected.length <= 0) {
            layer.msg('请选择要删除的单位！');
            return;
        }

        var index = layer.confirm("确定要删除所选的单位吗？", function () {
            var pids = [];
            $.each(selected, function (i, item) {
                pids.push(item.id);
            })

            $.post("DeleteCyDanweiList", {cids: pids.join(',')}, function (result) {
                result = JSON.parse(result)
                if (result.msg == 'success') {
                    layer.msg('删除成功。');
                    $("#danweitable").bootstrapTable('refresh')
                } else {
                    layer.msg('删除失败。');
                    layer.close(index);
                }
            });
        });
    }

    function EditCyDanwei() {
        var selecteid;

        selecteid = $("#danweitable").bootstrapTable('getSelections');

        if (selecteid == null || selecteid.length <= 0) {
            layer.msg('请选择要编辑的数据！');
            return;
        }

        $("#type").val(selecteid[0].type);
        $("#editDanweiId").val(selecteid[0].id);
        $("#danweiName").val(selecteid[0].danweiName);
        $("#contractName").val(selecteid[0].contractName);
        $("#mobile").val(selecteid[0].mobile);
        $("#fee").val(selecteid[0].fee);
        $("#contractTime").val(selecteid[0].contractTime);
        $("#yanshouTime").val(selecteid[0].yanshouTime);
        $("#content").val(selecteid[0].content);
        $("#btn_addcydanwei").trigger("click");
    }


    function SaveDanwei() {

        if ($("#type").val() == 0) {
            layer.msg("请选择单位类型！");
            return;
        }

        if (!$("#danweiName").val()) {
            layer.msg("请输入单位名称！");
            return;
        }

        if (!$("#contractName").val()) {
            layer.msg("请输入联系人！");
            return;
        }

        if (!$("#mobile").val()) {
            layer.msg("请输入联系电话！");
            return;
        }

        $.post("SaveCyDanwei",
                {
                    type: $("#type").val(),
                    danweiName: $("#danweiName").val(),
                    proid: $("#proid").val(),
                    contractName: $("#contractName").val(),
                    mobile: $("#mobile").val(),
                    editDanweiId: $("#editDanweiId").val(),
                    fee:$("#fee").val(),
                    contractTime:$("#contractTime").val(),
                    yanshouTime:$("#yanshouTime").val(),
                    content:$("#content").val()
                }
                , function (result) {
                    result = JSON.parse(result)
                    if (result.msg == 'success') {
                        layer.msg('保存成功！');
                        refreshCyDanweiTable();
                    } else {
                        layer.msg('保存失败！');
                    }
                    $('.modal').map(function () {
                        $(this).modal('hide');
                    });
                    $(".modal-backdrop").remove();

                });
    }


    $(document).ready(function () {
        $('#danweitable').bootstrapTable({
            url: 'GetCyDanweiList',         //请求后台的URL（*）
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
                    title: '编号',
                    visible: false
                },
                {
                    field: 'danweiName',
                    title: '单位名称',
                    sortable: true
                }, {
                    field: 'contractName',
                    title: '联系人',
                    sortable: true
                },
                {
                    field: 'mobile',
                    title: '联系电话',
                    sortable: true
                },
                {
                    field: 'fee',
                    title: '承研经费',
                    sortable: true
                },
                {
                    field: 'contractTime',
                    title: '合同签订时间',
                    sortable: true
                },
                {
                    field: 'yanshouTime',
                    title: '验收时间',
                    sortable: true
                },
                {
                    field: 'type',
                    title: '单位类型',
                    sortable: true,
                    formatter: function (value, row, index) {
                        if (value == 1) {
                            return "主承研单位";
                        } else if (value == 2) {
                            return "联合承研单位";
                        } else {
                            return "外协单位";
                        }
                    }
                }]
        });


//请求服务数据时所传参数
        function queryParams(params) {
            return {
                pageSize: params.limit, //每一页的数据行数，默认是上面设置的10(pageSize)
                pageIndex: params.offset / params.limit + 1, //当前页面,默认是上面设置的1(pageNumber)
                proid: $("#proid").val()
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
    });
    
    function refreshCyDanweiTable() {

        $('#danweitable').bootstrapTable('refresh', {url: 'GetCyDanweiList'});
    }

</script>