<div class="panel-body">

    <div class="table-responsive" style="">

        <div id="yantaotabletoolbar" class="btn-group">
        <@shiro.hasPermission name="project:addyantao">
            <button id="btn_addyt" type="button" class="btn btn-primary"
                    data-toggle="modal" data-target="#AddYantaoModal" onclick="showcontent(2)">
                <span class="glyphicon glyphicon-upload" aria-hidden="true"></span>添加研讨记录
            </button>
        </@shiro.hasPermission>
            <button id="btn_editfile" type="button" class="btn btn-primary"
                    style="margin-left: 20px;" onclick="EditYantao()">
                <span class="glyphicon glyphicon-edit" aria-hidden="true"></span>编辑
            </button>
        <@shiro.hasPermission name="project:deleteyantao">
            <button id="btn_delete" type="button" class="btn btn-danger"
                    style="margin-left: 20px;" onclick="DeleteYantao()">
                <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除
            </button>
        </@shiro.hasPermission>
        </div>
        <table width="100%" class="table table-striped table-bordered table-hover"
               id="yantaotable" data-toolbar="#yantaotabletoolbar" style="margin-top:20px;">
        </table>
    </div>
</div>

<!-- Modal 上传电子文件-->
<div class="modal fade" id="yantaoAtModal" tabindex="22" style="z-index: 9999;" role="dialog"
     aria-labelledby="ytatModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="ytatModalLabel">上传文件</h4>
            </div>
            <div class="modal-body">

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" onclick="" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="saveYtfile">保存</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- /.modal -->


<!-- Modal 添加研讨记录-->
<div class="modal fade" id="AddYantaoModal" tabindex="-1" role="dialog" aria-labelledby="myyataoModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
            <#--<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>-->
                <h4 class="modal-title" id="myyataoModalLabel">基本信息</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <form role="form" id="ytdataForm" action="">
                        <input type="hidden" id="yantaoFid" name="yantaoFid">
                        <input type="hidden" id="proId" name="proId" value="${proentity.id}">
                        <input type="hidden" id="yid" name="yid" value="0">
                        <div class="form-group col-lg-12">
                            <label>参与人</label>
                            <select name="joinerIds" id="joinerIds" multiple class="selectpicker form-control"
                                    title='选择参与者(必选)'>
                            </select>
                        </div>
                        <div class="form-group col-lg-12">
                            <label>研讨时间</label>

                            <input class="form-control" type="date" value=""
                                   id="yantaoTime"
                                   name="yantaoTime">

                        </div>
                        <div class="form-group col-lg-12">
                            <label>专家意见</label>
                            <textarea id="expertComments" name="expertComments" class="form-control" rows="5"
                                      cols="38"></textarea>
                        <#--<script type="text/javascript">CKEDITOR.replace('expertComments')</script>-->
                        </div>
                        <div class="form-group col-lg-12">
                            <label>研讨内容</label>
                            <textarea id="yantaoContent" name="yantaoContent" class="form-control" rows="5"
                                      cols="38"></textarea>
                        <#--<script type="text/javascript">CKEDITOR.replace('expertComments')</script>-->
                        </div>
                        <div class="form-group col-lg-12">
                            <label>上传附件</label>
                            <button id="btn_addytattach" type="button" style="" class="btn btn-primary"
                                    data-toggle="modal" onclick="AddYtModalContent()" data-target="#yantaoAtModal">
                                <span class="glyphicon glyphicon-upload" aria-hidden="true"></span>添加附件
                            </button>
                        </div>
                        <div class="form-group col-lg-12" id="ytattachment">

                        </div>

                    </form>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" onclick="CloseModal()" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="saveYtRecord()"
                        id="saveYtRecord">保存
                </button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- /.modal -->
<script language="JavaScript">

    function LoadJoners() {

        $.post("getlallusers", {}, function (result) {

            result = JSON.parse(result);
            var htmlstr = "";
            $.each(result, function (i, item) {
                htmlstr += "<option value='" + item.username + "'>" + item.username + "</option>";
            })

            if (htmlstr != null && htmlstr.length > 0) {
                $("#joinerIds").append(htmlstr);
                $('#joinerIds').selectpicker();

            }
        })
    }

    function EditYantao() {

        var selecteid = $("#yantaotable").bootstrapTable('getSelections');
        if (selecteid == null || selecteid.length <= 0) {
            layer.msg('请选择要编辑的数据！');
            return;
        }

        ShowYtRecord(eval(selecteid)[0]);
        $("#btn_addyt").trigger("click");

    }

    function DeleteYantao() {

        var selecteyid = $("#yantaotable").bootstrapTable('getSelections');


        if (selecteyid == null || selecteyid.length <= 0) {
            layer.msg('请选择要删除的数据！');
            return;
        }

        var index = layer.confirm("确定要删除所选的数据吗？", function () {
            var yids = [];
            $.each(selecteyid, function (i, item) {
                yids.push(item.yid);
            })

            $.post("DeleteYantaoByIds", {
                ytids: yids.join(","),
                proid: $("#id").val()

            }, function (result) {

                result = JSON.parse(result)
                if (result.msg == 'success') {

                    layer.msg('删除成功！');
                    refreshYantaoTable();
                } else {
                    layer.msg('删除失败！');
                }

            });
        });
    }

    function CloseModal() {
        $("#yantaoFid").val("");
        $("#yid").val("");
        //$("#joinerIds").val("");
        $('#joinerIds').selectpicker("val", []);
        $('#joinerIds').selectpicker("refresh");
        $("#yantaoTime").val("");
        $("#expertComments").val("");
        $("#yantaoContent").val("");
        $("#ytattachment").html("");
    }


    function saveYtRecord() {
        if ($("#yid").val() == "") {
            $("#yid").val("0")
        }
        $.post("SaveYtRecored", $("#ytdataForm").serialize(), function (result) {

            result = JSON.parse(result)
            if (result.msg == 'success') {
                layer.msg('保存成功！');
                CloseModal();
                refreshYantaoTable();
            } else {
                layer.msg('保存失败！');
            }
            $('.modal').map(function () {
                $(this).modal('hide');
            });

        });

    }

    function addYtInput(id, fileName, filepath) {
        var childInput = '<div><a  target="_blank" name="mid" data-value="' + id + '"  href="ReviewProjectFiles?fid=' + id + '" class="btn btn-default">' + fileName + '</a><span class="glyphicon glyphicon-remove" style="color: #ff353d" onclick="removeYtInput(this,' + id + ')"></span></div>'
        $("#ytattachment").append(childInput)

    }

    function showcontent(fid) {
        //CloseModal();
    }

    function ShowYtRecord(row) {
        $("#yantaoFid").val("");
        $("#joinerIds").val("");
        $("#yantaoTime").val("");
        $("#expertComments").val("");
        $("#yantaoContent").val("");
        $("#ytattachment").html("");

        $("#yantaoFid").val(row.yantaoFid);
        $("#yid").val(row.yid);
        $("#proId").val(row.proId);


        // $("#joinerIds").val(joiners);
        //var joiners = ;
        $('#joinerIds').selectpicker("val", row.joinerIds.split(","));
        $('#joinerIds').selectpicker("refresh");

        var yantaoTime = new Date(row.yantaoTime);

        var day = ("0" + yantaoTime.getDate()).slice(-2);
        //格式化月，如果小于9，前面补0
        var month = ("0" + (yantaoTime.getMonth() + 1)).slice(-2);
        //拼装完整日期格式
        var today = yantaoTime.getFullYear() + "-" + (month) + "-" + (day);

        $("#yantaoTime").val(today);
        //$("#yantaoTime").val(row.yantaoTime);
        $("#expertComments").val(row.expertComments);
        $("#yantaoContent").val(row.yantaoContent);

        //GetFilesById
        $.post("GetFilesById", {
            fids: row.yantaoFid
        }, function (result) {
            result = JSON.parse(result)
            if (result.msg == 'success' && result.data.length > 0) {
                $.each(result.data, function (i, item) {
                    addYtInput(item.id, item.fileName, item.filePath);
                })
            }

        });

        $("#btn_addyt").trigger("click");
    }

    function removeYtInput(obj, fid) {

        var index = layer.confirm("确认要删除此附件吗？", function () {

            $.post("DeleteFilesByIds", {
                fids: fid,
                pid: $("#id").val(),
                attachfid: 0

            }, function (result) {

                result = JSON.parse(result)
                if (result.msg == 'success') {
                    var yfids = $("#yantaoFid").val().split(',');
                    var yfids1 = [];
                    for (var i = 0; i < yfids.length; i++) {
                        if (parseInt(yfids[i]) != parseInt(fid)) {
                            yfids1.push(yfids[i]);
                        }
                    }
                    $("#yantaoFid").val(yfids1.join(","));
                    //alert($("#yantaoFid").val());
                    obj.parentElement.remove();
                } else {
                    layer.msg('删除失败！');
                }
                layer.close(index);

            });
        });
    }


    var ytmodalContent = '<form style="height:300px;"><div class="form-group"><input id="ytfile" name="ytfile" type="file" multiple></div></form>';


    function AddYtModalContent() {
        $("#saveYtfile").removeAttr("disabled");

        $("#yantaoAtModal .modal-body").html(ytmodalContent);

        $('#ytfile').fileinput({//初始化上传文件框
            showUpload: false,
            showRemove: false,
            uploadAsync: true,
            uploadLabel: "上传",//设置上传按钮的汉字
            uploadClass: "btn btn-primary",//设置上传按钮样式
            showCaption: false,//是否显示标题
            language: "zh",//配置语言
            uploadUrl: "UpLoadYtFiles",
            maxFileSize: 0,
            maxFileCount: -1, /*允许最大上传数，可以多个，当前设置单个*/
            enctype: 'multipart/form-data',
            allowedPreviewTypes: ['image', 'html', 'text', 'video', 'audio', 'flash', 'object', 'other'], //allowedFileTypes: ['image', 'video', 'flash'],
            allowedFileExtensions: ["jpg", "png", "jpeg", "gif", "docx", "pdf", "xls", "xlsx", "doc"], /*上传文件格式*/
            msgFilesTooMany: "选择上传的文件数量({n}) 超过允许的最大数值{m}！",
            dropZoneTitle: "请通过拖拽文件放到这里",
            dropZoneClickTitle: "或者点击此区域添加文件",
            uploadExtraData: {"pid": $("#id").val()},//这个是外带数据
            showBrowse: false,
            browseOnZoneClick: true,
            slugCallback: function (filename) {
                return filename.replace('(', '_').replace(']', '_');
            }
        });

        //上传文件成功，回调函数
        $('#ytfile').on("fileuploaded", function (event, data, previewId, index) {
            if (data.response.success == "success") {
                layer.msg("文件上传成功!");
                $("#saveYtfile").attr("disabled", "disabled");
                if (!$("#yantaoFid").val()) {
                    $("#yantaoFid").val(data.response.ytfileid);
                } else {
                    $("#yantaoFid").val($("#yantaoFid").val() + "," + data.response.ytfileid);
                }
                addYtInput(data.response.ytfileid, data.response.ytfilename, data.response.ytfilepath);
            } else {
                layer.msg("文件上传失败，请稍后重试!");
            }

        });

    }

    $('#saveYtfile').on('click', function () {// 提交图片信息 //
        //先上传文件，然后在回调函数提交表单
        $('#ytfile').fileinput('upload');

    });


    $(document).ready(function () {
        LoadJoners();

        $('#yantaotable').bootstrapTable({
            url: 'LoadYantaoLogList',         //请求后台的URL（*）
            method: 'get',                      //请求方式（*）
            //toolbar: '#toolbar',                //工具按钮用哪个容器
            striped: true,                      //是否显示行间隔色
            cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
            pagination: true,                   //是否显示分页（*）
            sortable: true,                     //是否启用排序
            sortOrder: "asc",                   //排序方式
            queryParams: ytqueryParams,//传递参数（*）
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
                    field: 'yid',
                    title: '编号',
                    visible: false
                },
                {
                    field: 'joinerIds',
                    title: '参与者',
                    sortable: true
                },
                {
                    field: 'yantaoFid',
                    title: '附件',
                    visible: false
                },
                {
                    field: 'proId',
                    title: 'proid',
                    visible: false
                }, {
                    field: 'expertComments',
                    title: '专家意见',
                    sortable: true

                }, {
                    field: 'yantaoContent',
                    title: '研讨内容',
                    sortable: true
                },
                {
                    field: 'yantaoTime',
                    title: '研讨时间',
                    sortable: true,
                    formatter: function (value, row, index) {
                        if (value == null) {
                            return "";
                        }
                        var offlineTimeStr = new Date(value).toLocaleDateString();
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
                }
//                 , {
//                     field: 'operate',
//                     title: '操作',
//                     formatter: function (value, row, index) {
//
// //                    <i class="glyphicon glyphicon-eye-open"></i>&nbsp;
//                         return "<i class='glyphicon glyphicon-share-alt'></i><a onclick='ShowYtRecord(" + JSON.stringify(row) + ")'  href='javascript:void(0)'>查看</a>"
//                     }
//                 }
            ]
        });

//请求服务数据时所传参数
        function ytqueryParams(params) {
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
    })

    function refreshYantaoTable() {
        $('#yantaotable').bootstrapTable('refresh', {url: 'LoadYantaoLogList'});
    }
</script>
