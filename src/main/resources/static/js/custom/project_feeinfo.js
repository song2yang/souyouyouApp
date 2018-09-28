/**
 * Created by ghl on 2018/3/12.
 */

function AddYFee() {
    $("#receiveTime").val("");
    $("#editYishouId").val("0");
    $("#receiveNum").val("");
    $("#btn_addyishoufee").trigger("click");
}

function AddCFee() {
    $("#cuishouAmount").val("");
    $("#cuishouTime").val("");
    $("#cuishouAlertDays").val("");
    $("#dafu").val("");
    $("#duijierenName").val("");
    $("#jingbanName").val("");
    $("#editCuishouId").val("0");
    $("#btn_addcuishoufee").trigger("click");
}

function EditYFee() {
    var selecteid;
    if ($("#feetypelist").val() == 1) {
        selecteid = $("#yishoutable").bootstrapTable('getSelections');
    } else {
        selecteid = $("#cuishoutable").bootstrapTable('getSelections');
    }

    if (selecteid == null || selecteid.length <= 0) {
        layer.msg('请选择要编辑的数据！');
        return;
    }

    if ($("#feetypelist").val() == 1) {
        $("#btn_addyishoufee").trigger("click");
        $("#receiveNum").val(selecteid[0].receivedNum);
        // $("#receiveTime").val(.toLocaleDateString());
        var receiveTime = new Date(selecteid[0].receivedTime.time);
        var day = ("0" + receiveTime.getDate()).slice(-2);
        //格式化月，如果小于9，前面补0
        var month = ("0" + (receiveTime.getMonth() + 1)).slice(-2);
        //拼装完整日期格式
        var today = receiveTime.getFullYear() + "-" + (month) + "-" + (day);
        $("#receiveTime").val(today);
        $("#editYishouId").val(selecteid[0].id);

    } else {
        $("#cuishouAmount").val(selecteid[0].cuishouAmount);

        var cuishouTime = new Date(selecteid[0].cuishouTime.time);

        var day = ("0" + cuishouTime.getDate()).slice(-2);
        //格式化月，如果小于9，前面补0
        var month = ("0" + (cuishouTime.getMonth() + 1)).slice(-2);
        //拼装完整日期格式
        var today = cuishouTime.getFullYear() + "-" + (month) + "-" + (day);
        $("#cuishouTime").val(today);
        $("#cuishouAlertDays").val(selecteid[0].alertDays);
        $("#dafu").val(selecteid[0].dafu);
        $("#duijierenName").val(selecteid[0].duijierenName);
        $("#jingbanName").val(selecteid[0].jingbanrenId);
        $("#editCuishouId").val(selecteid[0].id);
        $("#btn_addcuishoufee").trigger("click");
    }

}

function DeleteFee() {
    ytype = $("#feetypelist").val();
    var selecteyid;
    if (ytype == 1) {
        selecteyid = $("#yishoutable").bootstrapTable('getSelections');
    } else {
        selecteyid = $("#cuishoutable").bootstrapTable('getSelections');
    }

    if (selecteyid == null || selecteyid.length <= 0) {
        layer.msg('请选择要删除的数据！');
        return;
    }

    var index = layer.confirm("确定要删除所选的数据吗？", function () {
        var yids = [];
        $.each(selecteyid, function (i, item) {
            yids.push(item.id);
        })

        $.post("DeleteMoneyByIdsAndType", {
            yids: yids.join(','),
            ytype: ytype,
            proid: $("#id").val()
        }, function (result) {
            result = JSON.parse(result)
            if (result.msg == 'success') {
                layer.msg('删除成功！');
                if (ytype == 1)
                    refreshYishouTable();
                else
                    refreshCuishouTable();
            }
        });
    });
}

function refreshMoneyTable() {

    if ($("#feetypelist").val() == "1") {
        refreshYishouTable()

    } else {
        refreshCuishouTable()
    }

}

$("#feetypelist").on("change", function () {
    if ($(this).val() == "1") {
        $("#yishoudiv").show()
        $("#cuishoudiv").hide()
    } else {
        $("#yishoudiv").hide()
        $("#cuishoudiv").show()
    }
});

function SaveYishou() {

    if (!$("#receiveNum").val()) {
        layer.msg("请输入已收金额！");
        return;
    }

    if (!$("#receiveTime").val()) {
        layer.msg("请输入收款时间！");
        return;
    }

    if (parseFloat($("#receiveNum").val()) > parseFloat($("#totalFee").val())) {

        layer.msg("输入的已收金额不能大于总金额");

    } else {
        $.post("SaveYiShou",
            {
                receiveNum: $("#receiveNum").val(),
                receiveTime: $("#receiveTime").val(),
                proid: $("#id").val(),
                editYishouId: $("#editYishouId").val()
            }
            , function (result) {
                result = JSON.parse(result)
                if (result.msg == 'success') {
                    layer.msg('保存成功！');
                    refreshYishouTable();
                } else {
                    layer.msg('保存失败！');
                }
                $('.modal').map(function () {
                    $(this).modal('hide');
                });
                $(".modal-backdrop").remove();
                $("#receiveNum").val('');
                $("#receiveTime").val('');
                $("#editYishouId").val('');

            });
    }
}

function SaveCuishou() {
    if (!$("#cuishouAmount").val()) {
        layer.msg('请输入催收金额！');
        return;
    }

    if (!$("#cuishouTime").val()) {
        layer.msg('请输入催收时间！');
        return;
    }

    if (!$("#cuishouAlertDays").val()) {
        layer.msg('请输入提醒时间！');
        return;
    }

    if (!$("#duijierenName").val()) {
        layer.msg('请输入对接人姓名！');
        return;
    }

    if (!$("#jingbanName").val()) {
        layer.msg('请输入经办人姓名！');
        return;
    }
    $.post("SaveCuiShou",
        {
            cuishouAmount: $("#cuishouAmount").val(),
            cuishouTime: $("#cuishouTime").val(),
            cuishouAlertDays: $("#cuishouAlertDays").val(),
            dafu: $("#dafu").val(),
            duijierenName: $("#duijierenName").val(),
            jingbanName: $("#jingbanName").val(),
            proid: $("#id").val(),
            editCuishouId: $("#editCuishouId").val()
        }
        , function (result) {
            result = JSON.parse(result)
            if (result.msg == 'success') {
                layer.msg('保存成功！');
                refreshCuishouTable();
            } else {
                layer.msg('保存失败！');
            }
            $('.modal').map(function () {
                $(this).modal('hide');
            });
            $(".modal-backdrop").remove();

            $("#cuishouAmount").val('');
            $("#cuishouTime").val('');
            $("#cuishouAlertDays").val('');
            $("#dafu").val('');
            $("#duijierenName").val('');
            $("#jingbanName").val('');
            $("#editCuishouId").val('');
        });

}

$(document).ready(function () {
    $('#yishoutable').bootstrapTable({
        url: 'LoadReceiveLogList',         //请求后台的URL（*）
        method: 'get',                      //请求方式（*）
        //toolbar: '#toolbar',                //工具按钮用哪个容器
        striped: true,                      //是否显示行间隔色
        cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        pagination: true,                   //是否显示分页（*）
        sortable: true,                     //是否启用排序
        sortOrder: "asc",                   //排序方式
        queryParams: queryParamsMoney,//传递参数（*）
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
                field: 'receivedNum',
                title: '已收金额',
                sortable: true,
                formatter: function (value, row, index) {
                    return value + "元";
                }
            }, {
                field: 'userName',
                title: '创建者',
                sortable: true
            },
            {
                field: 'receivedTime',
                title: '收款时间',
                sortable: true,
                formatter: function (value, row, index) {
                    if (value == null) {
                        return "";
                    }
                    var offlineTimeStr = new Date(value.time).toLocaleDateString();
                    return offlineTimeStr;
                }
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
            }]
    });

    $('#cuishoutable').bootstrapTable({
        url: 'LoadCuishouLogList',         //请求后台的URL（*）
        method: 'get',                      //请求方式（*）
        //toolbar: '#toolbar',                //工具按钮用哪个容器
        striped: true,                      //是否显示行间隔色
        cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        pagination: true,                   //是否显示分页（*）
        sortable: true,                     //是否启用排序
        sortOrder: "asc",                   //排序方式
        queryParams: queryParamsMoney,//传递参数（*）
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
                field: 'cuishouAmount',
                title: '催收金额',
                sortable: true,
                formatter: function (value, row, index) {
                    return value + "元";
                }
            }, {
                field: 'cuishouTime',
                title: '催收时间',
                sortable: true,
                formatter: function (value, row, index) {
                    if (value == null) {
                        return "";
                    }
                    var offlineTimeStr = new Date(value.time).toLocaleDateString();
                    return offlineTimeStr;
                }
            },
            {
                field: 'alertDays',
                title: '预通知天数',
                sortable: true
            },
            {
                field: 'jingbanrenId',
                title: '经办人id',
                sortable: true,
                visible: false
            },
            {
                field: 'jingbanrenName',
                title: '经办人',
                sortable: true

            },
            {
                field: 'duijierenName',
                title: '对接人',
                sortable: true
            },
            {
                field: 'dafu',
                title: '答复',
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
            }]
    });


//请求服务数据时所传参数
    function queryParamsMoney(params) {
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


//刷新表格数据,点击你的按钮调用这个方法就可以刷新
function refreshYishouTable() {
    $('#yishoutable').bootstrapTable('refresh', {url: 'LoadReceiveLogList'});
}

function refreshCuishouTable() {
    $('#cuishoutable').bootstrapTable('refresh', {url: 'LoadCuishouLogList'});
}