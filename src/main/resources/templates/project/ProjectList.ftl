<link rel="stylesheet" href="static/css/bootstrap-table.min.css">
<link rel="stylesheet" href="static/css/layer.css">
<link rel="stylesheet" href="static/css/fileinput.css">

<script src="static/js/bootstrap-table.min.js"></script>
<script src="static/js/bootstrap-table-zh-CN.min.js"></script>
<script src="static/js/layer.js"></script>
<script src="static/js/jquery.form.js"></script>
<script src="static/js/fileinput.js"></script>

<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">项目列表 </h1>
        <form class="form-inline">
            <div class="form-group">
                <input type="text" class="form-control" style="width: 200px;" placeholder="请输入关键字..." id="keywords"
                       name="keywords">
            </div>

            <div class="form-group">
                <button class="btn btn-default" type="button" onclick="refresh()">
                    <i class="fa fa-search"></i>
                </button>

                <button class="btn btn-default" type="button" data-toggle="modal" data-target="#secondSearchModal">
                    <span class="glyphicon glyphicon-search" aria-hidden="true"></span>精确搜索
                </button>
            </div>

        </form>
    </div>
</div>
    <!-- /.col-lg-12 -->
</div>

<div class="content">
    <div class="table-responsive">
        <div id="toolbar" class="btn-group">
        <@shiro.hasPermission name="project:add">

            <button id="btn_edit" type="button" class="btn btn-primary" onclick="createProject()">
                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>新建
            </button>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="project:delete">
            <button id="btn_delete" type="button" class="btn btn-danger" style="margin-left: 20px;"
                    onclick="DeleteProject()">
                <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除
            </button>
        </@shiro.hasPermission>

            <button id="btn_importProject" type="button" data-toggle="modal" data-target="#importProjModal"
                    onclick="ImportProject()" class="btn btn-primary" style="margin-left: 20px;">
                <span class="glyphicon glyphicon-import" aria-hidden="true"></span>导入项目
            </button>
            <button id="btn_downloadTemplate" type="button"
                    onclick="DownProjectTemplate()" class="btn btn-primary" style="margin-left: 20px;">
                <span class="glyphicon glyphicon-download" aria-hidden="true"></span> 下载模板
            </button>

        </div>

        <table width="100%" class="table table-striped table-bordered table-hover text-nowrap" id="table"
               data-toolbar="#toolbar">
            <thead>
            <tr>
            <#--<th data-field="id" data-checkbox="true"></th>-->
                <th>项目名称</th>
                <th>项目编号</th>
                <th>项目来源</th>
                <th>总经费</th>
                <th>负责人</th>
            </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
</div>
</div>


<!-- Modal 二级搜索-->
<div class="modal fade" id="secondSearchModal" tabindex="-1" role="dialog" aria-labelledby="secondModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="secondModalLabel">精确搜索</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <form>
                        <div class="form-group col-md-12">
                            <select class="form-control" id="conditionList" name="conditionList">
                                <option value="-1" selected="selected">--选择查询条件--</option>
                                <option value="createtime">立项时间</option>
                                <option value="opentime">开题时间</option>
                                <option value="midtime">中期时间</option>
                                <option value="closetime">结题时间</option>
                                <option value="endtime">后期时间</option>
                            </select>
                        </div>
                        <div class="form-group col-md-12">
                            开始时间：<input type="date" class="form-control" id="beginConditionValue"
                                        name="beginConditionValue">
                        </div>
                        <div class="form-group col-md-12">
                            结束时间：<input type="date" class="form-control" id="endConditionValue"
                                        name="endConditionValue">
                        </div>
                    </form>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" onclick="" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="startSS" onclick="refresh()">搜索
                </button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- /.modal -->


<!-- Modal 导入项目-->
<div class="modal fade" id="importProjModal" tabindex="-1" role="dialog" aria-labelledby="importProjModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="importProjModalLabel">导入项目</h4>
            </div>
            <div class="modal-body">

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-default" onclick="" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary"  id="startImport">导入</button>
                <#--data-dismiss="modal"-->
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- /.modal -->

<!-- Page-Level Demo Scripts - Tables - Use for reference -->
<script type="text/javascript">

    var promodalContent = '<form><div class="form-group"><input id="importProjFile" name="importProjFile" type="file" multiple></div></form>';

    function DownProjectTemplate() {
        window.location.href = "downLoadDataTempate?fileName=项目模板.xlsx"

        //<a href="downLoadDataTempate?fileName=专家模板.xlsx">

    }

    function ImportProject() {
        $("#importProjModal .modal-body").html(promodalContent);

        $('#importProjFile').fileinput({//初始化上传文件框
            showUpload: false,
            showRemove: false,
            showBrowse: false,
            uploadAsync: true,
            uploadLabel: "上传",//设置上传按钮的汉字
            uploadClass: "btn btn-primary",//设置上传按钮样式
            showCaption: false,//是否显示标题
            language: "zh",//配置语言
            uploadUrl: "ImportProjectFiles",
            maxFileSize: 0,
            maxFileCount: 1, /*允许最大上传数，可以多个，当前设置单个*/
            enctype: 'multipart/form-data',
            allowedPreviewTypes: ['image', 'html', 'text', 'video', 'audio', 'flash', 'object', 'other'], //allowedFileTypes: ['image', 'video', 'flash'],
            allowedFileExtensions: ["jpg", "png", "jpeg", "gif", "pdf", "xls", "docx", "xlsx", "doc"], /*上传文件格式*/
            msgFilesTooMany: "选择上传的文件数量({n}) 超过允许的最大数值{m}！",
            dropZoneTitle: "请通过拖拽文件放到这里",
            dropZoneClickTitle: "或者点击此区域添加文件",
            uploadExtraData: {},//这个是外带数据
            showBrowse: false,
            browseOnZoneClick: true,
            slugCallback: function (filename) {
                return filename.replace('(', '_').replace(']', '_');
            }
        });

        //上传文件成功，回调函数
        $('#importProjFile').on("fileuploaded", function (event, data, previewId, index) {
            if (data.response.success == "success") {
                //layer.msg(data.response.msg);
                layer.alert(data.response.msg);
                $("#startImport").attr("disabled", "disabled");
                $('.modal').map(function () {
                    $(this).modal('hide');
                });
                $(".modal-backdrop").remove();
                $('#table').bootstrapTable('refresh', {url: 'LoadProjectList'});
            } else {
                layer.msg("项目导入失败，请稍后重试!");
            }

        });

    }

    $('#startImport').on('click', function () {// 提交图片信息 //
        //先上传文件，然后在回调函数提交表单
        $('#importProjFile').fileinput('upload');

    });
    $(document).ready(function () {

        var users =

                $.post("getlallusers", {}, function (result) {
                    users = JSON.parse(result);
//            $.each(result, function (i, item) {
//                if (parseInt(item.id) == value) {
//                    uname=item.username;
//                }
//            })
//            return uname;
                });

        $('#table').bootstrapTable({
            url: 'LoadProjectList',         //请求后台的URL（*）
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
            height: 500,
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
                    title: '项目id',
                    visible: false
                },
                {
                    field: 'proName',
                    title: '项目名称',
                    sortable: true,
                    formatter: function (value, row, index) {
                        //
//                    <i class="glyphicon glyphicon-eye-open"></i>&nbsp;
                        return '<a href="javascript:void(0)" target="_blank" onclick="gotodetail(' + row.id + ')">' + row.proName + '</a>'
                    }
                },
                {
                    field: 'proNo',
                    title: '项目编号',
                    sortable: true
                },
                {
                    field: 'proFrom',
                    title: '项目来源',
                    sortable: true
                },
                {
                    field: 'totalFee',
                    title: '总经费',
                    sortable: true
                },
                {
                    field: 'proLeaders',
                    title: '项目负责人',
                    // sortable: true,
                    // formatter: function (value, row, index) {
                    //     var uname = '';
                    //     $.each(users, function (i, item) {
                    //         if (parseInt(item.id) == parseInt(value)) {
                    //             uname = item.username;
                    //         }
                    //     })
                    //     return uname;
                    // }
                }
                ,
                {
                    field: 'proPhase',
                    title: '项目立项',
                    sortable: true,
                    formatter: function (value, row, index) {
                        if (value == 0) {
                            return "未立项";
                        } else {
                            return "已立项";
                        }
                    }
                },
                // {
                //     field: 'mainDepartment',
                //     title: '承研单位',
                //     sortable: true
                // },
                {
                    field: 'isreportReward',
                    title: '是否报奖',
                    sortable: true,
                    formatter: function (value, row, index) {
                        if (value == 0) {
                            return "否";
                        } else {
                            return "是";
                        }

                    }
                },
                {
                    field: 'reportChannel',
                    title: '报奖渠道',
                    sortable: true,
                    formatter: function (value, row, index) {
                        if (value == 0) {
                            return "院内";
                        } else if (value == 1) {
                            return "集团";
                        } else if (value == 2) {
                            return "地方/行业/学会";
                        }
                        else if (value == 3) {
                            return "国防";
                        }
                        else if (value == 4) {
                            return "国家";
                        } else {
                            return value;
                        }

                    }
                },
                {
                    field: 'classificlevelId',
                    title: '密级',
                    sortable: true,
                    formatter: function (value, row, index) {
                        if (value == 1) {
                            return "公开";
                        } else if (value == 2) {
                            return "内部";
                        } else if (value == 3) {
                            return "秘密";
                        } else if (value == 4) {
                            return "机密";
                        } else {
                            return value;
                        }

                    }
                },
                {
                    field: 'createPhasetime',
                    title: '立项时间',
                    sortable: true
                }
                ,
                {
                    field: 'openPhasetime',
                    title: '开题时间',
                    sortable: true
                }
                ,
                {
                    field: 'midcheckPhasetime',
                    title: '中期检查时间',
                    sortable: true
                }
                ,
                {
                    field: 'closePhasetime',
                    title: '结题时间',
                    sortable: true
                }
                ,
                {
                    field: 'endPhasetime',
                    title: '验收时间',
                    sortable: true
                }
                ,
                {
                    field: 'operate',
                    title: '操作',
                    formatter: function (value, row, index) {
                        //
//                    <i class="glyphicon glyphicon-eye-open"></i>&nbsp;
                        return '<a href="javascript:void(0)" onclick="gotodetail(' + row.id + ')">详细</a>'
                    }
                }
            ]
        })

        //请求服务数据时所传参数
        function queryParams(params) {
            return {
                pageSize: params.limit, //每一页的数据行数，默认是上面设置的10(pageSize)
                pageIndex: params.offset / params.limit + 1, //当前页面,默认是上面设置的1(pageNumber)
                keywords: $("#keywords").val(), //这里是其他的参数，根据自己的需求定义，可以是多个
                conditionText: $("#conditionList").val(),
                beginConditionValue: $("#beginConditionValue").val(),
                endConditionValue: $("#endConditionValue").val(),
                sortOrder: params.order,
                sortName: params.sort

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

        if ($("#conditionList").val() != -1) {
            if (!$("#beginConditionValue").val()) {
                layer.msg('请输入开始的时间！');
                return;
            }

            if (!$("#endConditionValue").val()) {
                layer.msg('请输入结束的时间！');
                return;
            }
        }


        if ($("#beginConditionValue").val() && $("#endConditionValue").val() && $("#conditionList").val() == -1) {
            layer.msg('请输选择查询条件！');
            return;
        }
        $('#table').bootstrapTable('refresh', {url: 'LoadProjectList'});

        $("#conditionList").val(-1);
        $("#beginConditionValue").val("");
        $("#endConditionValue").val("");
    }

    function DeleteProject() {

        var selected = $("#table").bootstrapTable('getSelections');
        if (selected == null || selected.length <= 0) {
            layer.msg('请选择要删除的项目！');
            return;
        }

        var index = layer.confirm("确定要删除所选的项目吗？", function () {
            var pids = [];
            $.each(selected, function (i, item) {
                pids.push(item.id);
            })

            $.post("DeleteProjectByIds", {pids: pids.join(',')}, function (result) {
                result = JSON.parse(result)
                if (result.msg == 'success') {
                    layer.msg('删除项目成功。');
                    $("#table").bootstrapTable('refresh')
                } else {
                    layer.msg('删除项目失败。');
                    layer.close(index);
                }
            });
        });
    }

    function gotodetail(prid) {
        $("#page-wrapper").load("ProjectDetail?pid=" + prid);
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