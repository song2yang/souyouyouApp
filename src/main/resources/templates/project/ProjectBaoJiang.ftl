<div class="panel-body">
    <form class="form-inline">
        <div class="form-group">
            <label>选择奖励阶段:</label>
            <select class="form-control" style="width: 150px;" id="bjtypelist"
                    name="bjtypelist">
                <option value="1" selected>拟鉴定</option>
                <option value="2">拟报奖</option>
                <option value="3">已获奖</option>
            </select>
        </div>
        <div class="form-group" style="margin-left: 50px;">
        <#--<button id="btn_searchfeetype" type="button" class="btn btn-primary"-->
        <#--onclick="refreshMoneyTable()">-->
        <#--<span class="glyphicon glyphicon-search" aria-hidden="true"></span>查询-->
        <#--</button>-->
        </div>
    </form>

    <div class="row">
        <!--鉴定-->
        <div class="table-responsive" style="margin-top: 20px;" id="jddiv">
            <div id="jdtabletoolbar" class="btn-group">
            <#--<@shiro.hasPermission name="bjjd:add">-->
                <button id="btn_addjd" type="button" class="btn btn-primary"
                        style="" data-toggle="modal"
                        data-target="#addjdModal">
                    <span class="glyphicon glyphicon-book" aria-hidden="true"></span>添加
                </button>
            <#--</@shiro.hasPermission>-->
            <#--<@shiro.hasPermission name="bjjd:edit">-->
            <#--<button id="btn_edityjd" onclick="EditJd()" type="button" class="btn btn-primary"-->
            <#--style="margin-left: 20px;" onclick="">-->
            <#--<span class="glyphicon glyphicon-edit" aria-hidden="true"></span>编辑-->
            <#--</button>-->
            <#--</@shiro.hasPermission>-->
            <#--<@shiro.hasPermission name="bjjd:delete">-->
                <button id="btn_deleteyfee" type="button" onclick="DeleteJdByIds()" class="btn btn-danger"
                        style="margin-left: 20px;">
                    <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除
                </button>
            <#--</@shiro.hasPermission>-->
            </div>

            <table width="100%" class="table table-striped table-bordered table-hover"
                   id="jdtable" data-toolbar="#jdtabletoolbar" style="margin-top:20px;">
            </table>

        </div>
        <!--报奖-->
        <div class="table-responsive" style="margin-top: 20px; display:none" id="nbjdiv">
            <div id="nbjtabletoolbar" class="btn-group">
            <#--<@shiro.hasPermission name="bjbj:add">-->
                <button id="btn_addnbj" type="button" class="btn btn-primary"
                        style="" data-toggle="modal"
                        data-target="#bjModal">
                    <span class="glyphicon glyphicon-book" aria-hidden="true"></span>添加
                </button>
            <#--</@shiro.hasPermission>-->
            <#--<@shiro.hasPermission name="bjbj:edit">-->
            <#--<button id="btn_editcfee" type="button" class="btn btn-primary"-->
            <#--style="margin-left: 20px;" onclick="EditYFee()">-->
            <#--<span class="glyphicon glyphicon-edit" aria-hidden="true"></span>编辑-->
            <#--</button>-->
            <#--</@shiro.hasPermission>-->

            <#--<@shiro.hasPermission name="bjbj:delete">-->
                <button id="btn_deletenbj" type="button" onclick="DeleteBjByIds()" class="btn btn-danger"
                        style="margin-left: 20px;" onclick="">
                    <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除
                </button>
            <#--</@shiro.hasPermission>-->
            </div>

            <table width="100%" class="table table-striped table-bordered table-hover"
                   id="nbjtable" data-toolbar="#nbjtabletoolbar" style="margin-top:20px;">
            </table>

        </div>
        <!--获奖-->
        <div class="table-responsive" style="margin-top: 20px; display:none" id="hjdiv">
            <div id="hjtabletoolbar" class="btn-group">
            <#--<@shiro.hasPermission name="bjhj:add">-->
                <button id="btn_addhj" type="button" class="btn btn-primary"
                        style="" data-toggle="modal"
                        data-target="#hjModal">
                    <span class="glyphicon glyphicon-book" aria-hidden="true"></span>添加
                </button>
            <#--</@shiro.hasPermission>-->
            <#--<@shiro.hasPermission name="bjbj:edit">-->
            <#--<button id="btn_editcfee" type="button" class="btn btn-primary"-->
            <#--style="margin-left: 20px;" onclick="EditYFee()">-->
            <#--<span class="glyphicon glyphicon-edit" aria-hidden="true"></span>编辑-->
            <#--</button>-->
            <#--</@shiro.hasPermission>-->

            <#--<@shiro.hasPermission name="bjhj:delete">-->
                <button id="btn_deletehj" type="button" onclick="DeleteHjByIds()" class="btn btn-danger"
                        style="margin-left: 20px;">
                    <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除
                </button>
            <#--</@shiro.hasPermission>-->
            </div>

            <table width="100%" class="table table-striped table-bordered table-hover"
                   id="hjtable" data-toolbar="#hjtabletoolbar" style="margin-top:20px;">
            </table>
        </div>

    </div>
    <!-- Modal 添加拟鉴定-->
    <div class="modal fade" id="addjdModal" role="dialog" aria-labelledby="jdModalLabel"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="jdModalLabel">添加拟鉴定</h4>
                </div>
                <div class="modal-body">
                    <div class="row">

                        <form role="form" id="jdForm" name="jdForm">
                            <input type="hidden" id="jdproid" name="jdproid" value="${proentity.id}">
                            <div class="form-group col-md-12">
                                <label>鉴定时间</label>
                                <input class="form-control" type="date" id="jianDingTime" name="jianDingTime">
                            </div>

                            <div class="form-group col-md-12">
                                <label>主持鉴定部门</label>
                                <select id="zhuchiBumen" name="zhuchiBumen" class="form-control">
                                    <option value="集团公司科技部">集团公司科技部</option>
                                    <option value="集团公司军工部">集团公司军工部</option>
                                    <option value="集团公司质安部">集团公司质安部</option>
                                </select>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                    </button>
                    <button type="button" class="btn btn-primary" onclick="SaveJd()" id="saveJd">保存</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!-- /.modal -->

    <!-- Modal 添加拟报奖记录-->
    <div class="modal fade" id="bjModal" role="dialog" aria-labelledby="bjModalLabel"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="bjModalLabel">添加拟报奖</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form role="form" id="bjForm" name="bjForm">
                            <input type="hidden" id="bjproid" name="bjproid" value="${proentity.id}">
                            <div class="form-group col-md-12">
                                <label>奖励类别</label>
                                <select id="bjjltype" name="bjjltype" class="form-control">
                                    <option value="国防奖">国防奖</option>
                                    <option value="集团奖">集团奖</option>
                                    <option value="学会奖">学会奖</option>
                                    <option value="其他奖">其他奖</option>
                                </select>
                            </div>
                            <div class="form-group col-md-12">
                                <label>申请等级</label>
                                <select id="bjdjtype" name="bjdjtype" class="form-control">
                                    <option value="一等">一等</option>
                                    <option value="二等">二等</option>
                                    <option value="三等">三等</option>
                                </select>
                            </div>
                            <div class="form-group col-md-12">
                                <label>报奖时间</label>
                                <input class="form-control" type="date" id="bjtime" name="bjtime">
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" onclick="" data-dismiss="modal">关闭
                    </button>
                    <button type="button" class="btn btn-primary" onclick="SaveBj()" id="SaveBj">保存</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!-- /.modal -->
    <!-- Modal 添加已获奖记录-->
    <div class="modal fade" id="hjModal" role="dialog" aria-labelledby="hjModalLabel"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="hjModalLabel">添加已获奖</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form role="form" id="hjForm" name="hjForm">
                            <input type="hidden" id="hjproid" name="hjproid" value="${proentity.id}">
                            <div class="form-group col-md-12">
                                <label>奖励类别</label>
                                <select id="hjjltype" name="hjjltype" class="form-control">
                                    <option value="国防奖">国防奖</option>
                                    <option value="集团奖">集团奖</option>
                                    <option value="学会奖">学会奖</option>
                                    <option value="其他奖">其他奖</option>
                                </select>
                            </div>
                            <div class="form-group col-md-12">
                                <label>获奖等级</label>
                                <select id="hjdjtype" name="hjdjtype" class="form-control">
                                    <option value="一等">一等</option>
                                    <option value="二等">二等</option>
                                    <option value="三等">三等</option>
                                </select>
                            </div>
                            <div class="form-group col-md-12">
                                <label>获奖时间</label>
                                <input class="form-control" type="date" id="hjtime" name="hjtime">
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" onclick="" data-dismiss="modal">关闭
                    </button>
                    <button type="button" class="btn btn-primary" onclick="SaveHj()" id="SaveHj">保存</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!-- /.modal -->

    <script type="text/javascript">


        $("#bjtypelist").on("change", function () {
            if ($(this).val() == "1") {
                $("#jddiv").show()
                $("#nbjdiv").hide()
                $("#hjdiv").hide()
            } else if ($(this).val() == "2") {
                $("#jddiv").hide()
                $("#nbjdiv").show()
                $("#hjdiv").hide()
            } else {
                $("#jddiv").hide()
                $("#nbjdiv").hide()
                $("#hjdiv").show()
            }
        });

        function DeleteHjByIds() {

            var selecteyid = $("#hjtable").bootstrapTable('getSelections');
            if (selecteyid == null || selecteyid.length <= 0) {
                layer.msg('请选择要删除的数据！');
                return;
            }
            var index = layer.confirm("确定要删除所选的数据吗？", function () {

                var hjids = [];
                $.each(selecteyid, function (i, item) {
                    hjids.push(item.id);
                })

                $.post("DeleteHjByIds", {
                    hjids: hjids.join(',')
                }, function (result) {
                    result = JSON.parse(result)
                    if (result.msg == 'success') {
                        layer.msg('删除成功！');
                        refreshhjTable();
                    }
                });
            });

        }


        function DeleteBjByIds() {

            var selecteyid = $("#nbjtable").bootstrapTable('getSelections');
            if (selecteyid == null || selecteyid.length <= 0) {
                layer.msg('请选择要删除的数据！');
                return;
            }
            var index = layer.confirm("确定要删除所选的数据吗？", function () {

                var bjids = [];
                $.each(selecteyid, function (i, item) {
                    bjids.push(item.id);
                })

                $.post("DeleteBjByIds", {
                    bjids: bjids.join(',')
                }, function (result) {
                    result = JSON.parse(result)
                    if (result.msg == 'success') {
                        layer.msg('删除成功！');
                        refreshbjTable();
                    }
                });
            });

        }


        function DeleteJdByIds() {

            var selecteyid = $("#jdtable").bootstrapTable('getSelections');
            if (selecteyid == null || selecteyid.length <= 0) {
                layer.msg('请选择要删除的数据！');
                return;
            }
            var index = layer.confirm("确定要删除所选的数据吗？", function () {

                var ids = [];
                $.each(selecteyid, function (i, item) {
                    ids.push(item.id);
                })

                $.post("DeleteJdByIds", {
                    jdids: ids.join(',')
                }, function (result) {
                    result = JSON.parse(result)
                    if (result.msg == 'success') {
                        layer.msg('删除成功！');
                        refreshJdTable();
                    }
                });
            });

        }

        function SaveHj() {
            $.post("SaveHuojiang",
                    {
                        hjproid: $("#hjproid").val(),
                        hjjltype: $("#hjjltype").val(),
                        hjdjtype: $("#hjdjtype").val(),
                        hjtime: $("#hjtime").val()
                    }
                    , function (result) {
                        result = JSON.parse(result)
                        if (result.msg == 'success') {
                            layer.msg('保存成功！');
                            refreshhjTable();
                        } else {
                            layer.msg('保存失败！');
                        }
                        $('.modal').map(function () {
                            $(this).modal('hide');
                        });
                        $(".modal-backdrop").remove();
                        $("#hjjltype").val('');
                        $("#hjdjtype").val('');
                        $("#hjtime").val('');
                    });
        }

        function SaveJd() {
            $.post("SaveJianDing",
                    {
                        jdProid: $("#jdproid").val(),
                        jiandingTime: $("#jianDingTime").val(),
                        zhuchiBumen: $("#zhuchiBumen").val()
                    }
                    , function (result) {
                        result = JSON.parse(result)
                        if (result.msg == 'success') {
                            layer.msg('保存成功！');
                            refreshJdTable();
                        } else {
                            layer.msg('保存失败！');
                        }
                        $('.modal').map(function () {
                            $(this).modal('hide');
                        });
                        $(".modal-backdrop").remove();
                        $("#jianDingTime").val('');
                        $("#zhuchiBumen").val('');
                    });
        }


        function SaveBj() {
            $.post("SaveBaojiang",
                    {
                        bjproid: $("#bjproid").val(),
                        bjjltype: $("#bjjltype").val(),
                        bjdjtype: $("#bjdjtype").val(),
                        bjtime: $("#bjtime").val()
                    }
                    , function (result) {
                        result = JSON.parse(result)
                        if (result.msg == 'success') {
                            layer.msg('保存成功！');
                            refreshbjTable();
                        } else {
                            layer.msg('保存失败！');
                        }
                        $('.modal').map(function () {
                            $(this).modal('hide');
                        });
                        $(".modal-backdrop").remove();
                        $("#bjjltype").val('');
                        $("#bjdjtype").val('');
                        $("#bjtime").val('');
                    });
        }

        $(document).ready(function () {
            $('#jdtable').bootstrapTable({
                url: 'LoadJianDingList',         //请求后台的URL（*）
                method: 'get',                      //请求方式（*）
                //toolbar: '#toolbar',                //工具按钮用哪个容器
                striped: true,                      //是否显示行间隔色
                cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
                pagination: true,                   //是否显示分页（*）
                sortable: true,                     //是否启用排序
                sortOrder: "asc",                   //排序方式
                queryParams: queryParamsBaoJiang,//传递参数（*）
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
                        field: 'jianDingTime',
                        title: '拟鉴定时间',
                        sortable: true,
                        width: '400px',
                        formatter: function (value, row, index) {
                            if (value == null) {
                                return "";
                            }
                            var offlineTimeStr = new Date(value.time).toLocaleDateString();
                            return offlineTimeStr;
                        }
                    }, {
                        field: 'zhuchiBumen',
                        title: '主持鉴定部门',
                        width: '450px',
                        sortable: true
                    }]
            });

            $('#nbjtable').bootstrapTable({
                url: 'LoadNiBaoJiangList',         //请求后台的URL（*）
                method: 'get',                      //请求方式（*）
                //toolbar: '#toolbar',                //工具按钮用哪个容器
                striped: true,                      //是否显示行间隔色
                cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
                pagination: true,                   //是否显示分页（*）
                sortable: true,                     //是否启用排序
                sortOrder: "asc",                   //排序方式
                queryParams: queryParamsBaoJiang,//传递参数（*）
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
                        field: 'jiangLiType',
                        title: '奖励类型',
                        width: '300px',
                        sortable: true
                    }, {
                        field: 'shenbaoDengji',
                        title: '申报等级',
                        width: '300px',
                        sortable: true
                    },
                    {
                        field: 'baojiangDate',
                        title: '报奖时间',
                        width: '300px',
                        sortable: true,
                        formatter: function (value, row, index) {
                            if (value == null) {
                                return "";
                            }
                            var offlineTimeStr = new Date(value.time).toLocaleDateString();
                            return offlineTimeStr;
                        }
                    }]
            });


            $('#hjtable').bootstrapTable({
                url: 'LoadHuoJiangList',         //请求后台的URL（*）
                method: 'get',                      //请求方式（*）
                //toolbar: '#toolbar',                //工具按钮用哪个容器
                striped: true,                      //是否显示行间隔色
                cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
                pagination: true,                   //是否显示分页（*）
                sortable: true,                     //是否启用排序
                sortOrder: "asc",                   //排序方式
                queryParams: queryParamsBaoJiang,//传递参数（*）
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
                        field: 'jiangliType',
                        title: '奖励类型',
                        width: '300px',
                        sortable: true
                    }, {
                        field: 'huojiangDengji',
                        title: '获奖等级',
                        width: '300px',
                        sortable: true
                    },
                    {
                        field: 'huojiangDate',
                        title: '获奖时间',
                        width: '300px',
                        sortable: true,
                        formatter: function (value, row, index) {
                            if (value == null) {
                                return "";
                            }
                            var offlineTimeStr = new Date(value.time).toLocaleDateString();
                            return offlineTimeStr;
                        }
                    }]
            });


//请求服务数据时所传参数
            function queryParamsBaoJiang(params) {
                return {
                    pageSize: params.limit, //每一页的数据行数，默认是上面设置的10(pageSize)
                    pageIndex: params.offset / params.limit + 1, //当前页面,默认是上面设置的1(pageNumber)
                    proid: $("#id").val()
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


        function refreshJdTable() {
            $('#jdtable').bootstrapTable('refresh', {url: 'LoadJianDingList'});
        }

        function refreshbjTable() {
            $('#nbjtable').bootstrapTable('refresh', {url: 'LoadNiBaoJiangList'});
        }

        function refreshhjTable() {
            $('#hjtable').bootstrapTable('refresh', {url: 'LoadHuoJiangList'});
        }
    </script>