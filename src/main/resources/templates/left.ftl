<div class="navbar-default sidebar" role="navigation">
    <div class="sidebar-nav navbar-collapse">
        <ul class="nav" id="side-menu">
        <#--<li class="sidebar-search">-->
        <#--<div class="input-group custom-search-form">-->
        <#--<input type="text" class="form-control" placeholder="Search...">-->
        <#--<span class="input-group-btn">-->
        <#--<button class="btn btn-default" type="button">-->
        <#--<i class="fa fa-search"></i>-->
        <#--</button>-->
        <#--</span>-->
        <#--</div>-->
        <#--<!-- /input-group &ndash;&gt;-->
        <#--</li>-->
            <li class="sidebar-search">
                <div class="input-group custom-search-form">
                    <input type="text" id="globalsearch"  name="globalsearch" class="form-control" placeholder="请输入搜索关键字...">
                    <span class="input-group-btn">
                                <button class="btn btn-default" id="btnstartsearch"  onclick="StartSearch()" type="button">
                                    <i class="fa fa-search"></i>
                                </button>
                            </span>
                </div>
                <!-- /input-group -->
            </li>
            <li>
                <a href="index"><i class="fa fa-laptop fa-fw"></i> 首页</a>
            </li>
            <li>
                <a href="javascript:void(0)" onclick="tab(1)"><i class="fa fa-cubes fa-fw"></i> 项目管理<#--<span
                        class="fa arrow"></span>--></a>
            <#--<ul class="nav nav-second-level">-->
            <#--<li>-->
            <#--<a href="javascript:void(0)" onclick="tab(1)"> 项目列表</a>-->
            <#--</li>-->
            <#--</ul>-->
                <!-- /.nav-second-level -->
            </li>
            <li id="data"></li>
            <li id="anli"></li>
            <li id="expert"></li>
            <li id="announce"></li>
            <li>
                <a href="javascrip:void(0)" onclick="tab(6)"><i class="fa fa-envelope fa-fw"></i> 工作群聊<#--<span
                        class="spc_span fa arrow"></span>--></a>
                <#--<ul class="nav nav-1-level">-->
                    <#--<li>-->
                        <#--<a href="javascript:void(0)" onclick="tab(6)">收件箱</a>-->
                    <#--</li>-->
                    <#--<li>-->
                        <#--<a href="javascript:void(0)" onclick="tab(7)">发件箱</a>-->
                    <#--</li>-->
                    <#--<li>-->
                        <#--<a href="javascript:void(0)" onclick="tab(8)">草稿箱</a>-->
                    <#--</li>-->
                <#--</ul>-->
                <!-- /.nav-second-level -->
            </li>
        <@shiro.hasAnyRoles name="administrator,securitor,superadmin">
            <li>
                <a href="javascript:void(0)" onclick="tab(9)"><i class="fa fa-users fa-fw"></i> 用户管理<#--<span
                        class="fa arrow"></span>--></a>
            <#--<ul class="nav nav-second-level">-->
            <#--<li>-->
            <#--<a href="javascript:void(0)" onclick="tab(9)"> 用户列表</a>-->
            <#--</li>-->
            <#--</ul>-->
                <!-- /.nav-second-level -->
            </li>
        </@shiro.hasAnyRoles>

        <@shiro.hasAnyRoles name="securitor,superadmin">
            <li>
                <a href="javascript:void(0)" onclick="tab(10)"><i class="fa fa-github-alt fa-fw"></i> 角色管理<#--<span
                        class="fa arrow"></span>--></a>
            <#--<ul class="nav nav-second-level">-->
            <#--<li>-->
            <#--<a href="javascript:void(0)" onclick="tab(10)"> 角色列表</a>-->
            <#--</li>-->
            <#--</ul>-->
            </li>
        </@shiro.hasAnyRoles>

        <@shiro.hasRole name="superadmin">
            <li>
                <a href="javascript:void(0)" onclick="tab(11)"><i class="fa fa-gear fa-fw"></i> 权限管理<#--<span
                        class="fa arrow"></span>--></a>
            <#--<ul class="nav nav-second-level">-->
            <#--<li>-->
            <#--<a href="javascript:void(0)" onclick="tab(11)"> 权限列表</a>-->
            <#--</li>-->
            <#--</ul>-->
            </li>
        </@shiro.hasRole>

            <li>
                <a href="javascript:void(0)" onclick="tab(13)"><i class="fa fa-gear fa-wordpress"></i> 标签管理<#--<span
                        class="fa arrow"></span>--></a>
            </li>


        <#--<li>-->
        <#--<a href="#"><i class="fa fa-database fa-fw"></i> 属性管理<span class="fa arrow"></span></a>-->
        <#--<ul class="nav nav-second-level">-->
        <#--<li>-->
        <#--<a href="javascript:void(0)" onclick="tab(12)">资料类型</a>-->
        <#--</li>-->
        <#--<li>-->
        <#--<a href="javascript:void(0)" onclick="tab(13)">案例类型</a>-->
        <#--</li>-->
        <#--<li>-->
        <#--<a href="javascript:void(0)" onclick="tab(14)">专家类型</a>-->
        <#--</li>-->
        <#--<li>-->
        <#--<a href="javascript:void(0)" onclick="tab(15)">公告类型</a>-->
        <#--</li>-->
        <#--</ul>-->
        <#--</li>-->
        <@shiro.hasAnyRoles name="comptroller,superadmin">
            <li>
                <a href="javascript:void(0)" onclick="tab(16)"><i class="fa fa-file fa-fw"></i> 日志管理<#--<span
                        class="fa arrow"></span>--></a>
            <#--<ul class="nav nav-second-level">-->
            <#--<li>-->
            <#--<a href="javascript:void(0)" onclick="tab(16)">日志列表</a>-->
            <#--</li>-->
            <#--</ul>-->
            </li>
        </@shiro.hasAnyRoles>
        <@shiro.hasAnyRoles name="administrator,superadmin">
            <li>
                <a href="#"><i class="fa fa-chain fa-fw"></i> 菜单管理<span class="spc_span fa arrow"></span></a>
                <ul class="nav nav-1-level ">
                    <li>
                        <a href="javascript:void(0)" onclick="menu(1)">案例菜单</a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="menu(2)">资料菜单</a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="menu(3)">专家菜单</a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="menu(4)">公告菜单</a>
                    </li>
                </ul>
            </li>
        </@shiro.hasAnyRoles>
            <@shiro.hasAnyRoles name="comptroller,superadmin">
            <li>
                <a href="#"><i class="fa fa-chain fa-fw"></i> 审核管理<span class="spc_span fa arrow"></span></a>
                <ul class="nav nav-1-level ">
                    <li>
                        <a href="javascript:void(0)" onclick="review(1)">项目文件</a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="review(2)">案例库文件</a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="review(3)">资料库文件</a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="review(5)">公告文件</a>
                    </li>
                </ul>
            </li>
            </@shiro.hasAnyRoles>
        </ul>
    </div>
    <!-- /.sidebar-collapse -->
</div>
<div>
<button id="btn_searchresult" type="button" style="display: none" class="btn btn-primary"
        data-toggle="modal" data-target="#searchResultModal">
    <span class="glyphicon glyphicon-upload" aria-hidden="true"></span>搜索结果
</button>
<div class="modal fade" id="searchResultModal" tabindex="1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">搜索结果</h4>
            </div>
            <div class="modal-body">
                <table width="100%" class="table table-striped table-bordered table-hover text-nowrap"
                       id="searchResultTable" data-toolbar="">
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
</div>

<script src="static/js/jquery.min.js"></script>

<script>
    var dataMenu = new Object();
    var anliMenu = new Object();
    var announceMenu = new Object();
    var expertMenu = new Object();
    var dataTitle = '<a href="javascript:void(0)"><span onclick="tab(2)"><i class="fa fa-folder fa-fw"></i> 资料库</span><span class="spc_span fa arrow"></span></a>';
    dataMenu.title = dataTitle;
    dataMenu.id = 'data';
    dataMenu.type = '2';
    dataMenu.target = 'dataList';
    var anliTitle = '<a href="javascript:void(0)"><span onclick="tab(3)"><i class="fa fa-suitcase fa-fw"></i> 案例库</span><span class="spc_span fa arrow"></span></a>';
    anliMenu.title = anliTitle;
    anliMenu.id = 'anli';
    anliMenu.type = '1';
    anliMenu.target = 'anliList';
    var announceTitle = '<a href="javascript:void(0)"><span onclick="tab(5)"><i class="fa fa-wechat fa-fw"></i> 内部园地</span><span class="spc_span fa arrow"></span></a>';
    announceMenu.title = announceTitle;
    announceMenu.id = 'announce';
    announceMenu.type = '4';
    announceMenu.target = 'announceList';
    var expertTitle = '<a href="javascript:void(0)"><span onclick="tab(4)"><i class="fa fa-user-plus fa-fw"></i> 专家库</span><span class="spc_span fa arrow"></span></a>';
    expertMenu.title = expertTitle;
    expertMenu.id = 'expert';
    expertMenu.type = '3';
    expertMenu.target = 'expertList';

    var menuArr = [];
    menuArr.push(dataMenu);
    menuArr.push(anliMenu);
    menuArr.push(announceMenu);
    menuArr.push(expertMenu);


    menuArr.forEach(function (value, index, arr) {


        var levels = 0;
        var subHtml = addSubMenu(arr[index].type, 0, levels, arr[index].target);

        var html = arr[index].title + subHtml;
//        console.log(html)
//        console.log(arr[index].id)
        $("#" + arr[index].id).html(html);

    });


    function addSubMenu(type, parentId, levels, target) {
        ++levels;
        var subHtml = [];
        $.ajax({
            type: "post",
            url: "findMenuByTypeAndParentId",
            data: {type: type, parentId: parentId},
            async: false,
            success: function (result) {
                result = JSON.parse(result).result;
                if (result && result.length > 0) {
                    subHtml.push('<ul class="nav nav-' + levels + '-level">');

                    $.each(result, function () {

                        subHtml.push('<li>');
                        subHtml.push('<a href="javascript:void(0)"><span onclick="type(\'' + target + '\',' + this.id + ')">' + this.typeName + '</span><span class="spc_span fa arrow"></span></a>');
                        subHtml.push(addSubMenu(type, this.id, levels, target));
                        subHtml.push('</li>');

                    });

                    subHtml.push('</ul>');

                }
            }
        });

        return subHtml.join('');

    }


    function type(target, id) {
        $("#page-wrapper").load(target + "?typeId=" + id);
    }

    function StartSearch() {

        if (!$("#globalsearch").val()) {
            layer.msg("请输入搜索关键字!");
            return;
        }

        $('#myModalLabel').html('以下为您显示结果为  【'+$("#globalsearch").val()+'】 的搜索内容');

        // $.post("StartSearch", {target: $("#globalsearch").val()}, function (result) {
        //     result = JSON.parse(result)
        //     if (result.msg == 'ok') {
        //
        //         $("#searchResultTable").bootstrapTable('refresh')
        //     } else {
        //         layer.msg('查询失败，请稍后重试！');
        //     }
        // });

        //ShowSearchResultTable();

        refreshsearchResultTable();

        $("#btn_searchresult").trigger("click");




    }

    function gotoSearchdetail(resultKey, resultType, miniResultType) {
        if (resultType == "project") {
            $("#page-wrapper").load("ProjectDetail?pid=" + resultKey);
        } else if (resultType == "anli") {
            $("#page-wrapper").load("createAnliPage?aid=" + resultKey);
        } else if (resultType == "ziliao") {
            $("#page-wrapper").load("createData?zid=" + resultKey);
        } else if (resultType == "expert") {
            $("#page-wrapper").load("expert?eid=" + resultKey);
        } else if (resultType == "announce") {
            $("#page-wrapper").load("createAnnoucePage?aid=" + resultKey);
        } else if (resultType == "keyword") {

            gotoSearchdetail(resultKey, miniResultType);
        }

    }

    //请求服务数据时所传参数
    function queryParams(params) {
        return {
            pageSize: params.limit, //每一页的数据行数，默认是上面设置的10(pageSize)
            pageIndex: params.offset / params.limit + 1, //当前页面,默认是上面设置的1(pageNumber)
            target: $("#globalsearch").val()
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

    $(document).ready(function () {

        $('#searchResultTable').bootstrapTable({
            url: 'StartSearch',         //请求后台的URL（*）
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
            pageSize: 1000,                       //每页的记录行数（*）
            pageList: [1000, 25, 50, 100],        //可供选择的每页的行数（*）
            search: false,                       //是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
            strictSearch: false,
            showColumns: false,                  //是否显示所有的列
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
                    field: 'id',
                    title: '序号',
                    visible: true
                },
                {
                    field: 'resultName',
                    title: '名称',
                    //sortable: true,
                    formatter: function (value, row, index) {

                        return "<a href='javascript:void(0)' target='_blank' onclick='gotoSearchdetail(" + row.resultKey + ",\"" + row.resultType + "\",\"" + row.miniResultType + "\")'>" + value + "</a>"
                    }

                }, {
                    field: 'resultType',
                    title: '位置',
                    formatter: function (value, row, index) {
                        if (value == "project" || row.miniResultType == "project") {
                            return "项目";
                        } else if (value == "anli" || row.miniResultType == "anli") {
                            return "案例";
                        } else if (value == "ziliao" || row.miniResultType == "ziliao") {
                            return "资料";
                        } else if (value == "expert" || row.miniResultType == "expert") {
                            return "专家";
                        } else if (value == "announce" || row.miniResultType == "announce") {
                            return "公告";
                        } else {
                            return "未知";
                        }
                    }

                }]
        })


    });

    //刷新表格数据,点击你的按钮调用这个方法就可以刷新
    function refreshsearchResultTable() {
        $('#searchResultTable').bootstrapTable('refresh', {url: 'StartSearch'});
        setTimeout(function () {
            $('.modal-backdrop').remove()
        },200)
    }
</script>
