<nav class="navbar navbar-default navbar-static-top" role="navigation"
     style="margin-bottom: 0; background-image: url('static/img/banner.jpg')">
    <div class="navbar-header">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="index.html"><span style="color: white; font-weight: bold">知识共享管理平台</span></a>
    </div>
    <!-- /.navbar-header -->

    <ul class="nav navbar-top-links navbar-right">
        <li class="dropdown" style="display: inline;float: left;">
            <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                <i class="fa fa-bell fa-fw"></i> <i class="fa fa-caret-down"></i>
            </a>
            <ul class="dropdown-menu dropdown-alerts">


            </ul>
            <!-- /.dropdown-user -->
        </li>
        <!-- /.dropdown -->

        <li class="dropdown" style="display: inline;float: left;">
            <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                <i class="fa fa-user fa-fw"></i> <i class="fa fa-caret-down"></i>
            </a>
            <ul class="dropdown-menu dropdown-user">
                <li><a href="#"><i class="fa fa-user fa-fw"></i> <@shiro.principal property="realName"/></a>
                </li>
                <li><a href="#" onclick='$("#page-wrapper").load("userInfo?uId=<@shiro.principal property="id"/>")'><i class="fa fa-gear fa-fw"></i> 设置</a>
                </li>
                <li class="divider"></li>
                <li><a href="sign_out"><i class="fa fa-sign-out fa-fw"></i> 退出</a>
                </li>
            </ul>
            <!-- /.dropdown-user -->
        </li>
    </ul>
    <!-- /.navbar-top-links -->
    <#include "left.ftl">
    <!-- /.navbar-static-side -->
</nav>
<!-- /.modal -->
<link rel="stylesheet" href="static/css/bootstrap-table.min.css">
<script src="static/js/bootstrap-table.min.js"></script>
<script src="static/js/bootstrap-table-zh-CN.min.js"></script>
<script src="static/js/layer.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
        $.post("getNotify", {}, function (result) {

            result = JSON.parse(result);

            if (result.msg == "success") {

                if (result.result.length > 0 ){
                    $('.fa-bell').css('color','red');
                    $.each( result.result, function( index, val ) {
//                        <span class="pull-right text-muted small">12 minutes ago</span>
                        var liStr = '<li class="divider"></li> <li> <a onclick="notifyDetail('+this.fileId+','+this.fileClassify+')"> <div> <i class="fa fa-twitter fa-fw"></i>'+this.content+' </div></a></li>'
                        $('.dropdown-alerts').html(liStr);
                    } );
                }else {
                    var liStr = '<li class="divider"></li> <li> <a href="#"> <div> <i class="fa fa-twitter fa-fw"></i><b>暂无通知</b> </div></a></li>'

                    $('.dropdown-alerts').html(liStr)
                }
            }
        });
    })
    
    
    function notifyDetail(fileId,fileClassify) {
        $.ajax({
            type: "post",
            url: "findTidByFileId",
            data: {fileId: fileId},
            async: false,
            success: function (data) {
                /**
                * 1 项目文件
                * 2 案例库文件
                * 3 资料库文件
                * 4 专家库
                * 5 公告库
                 **/
                switch (fileClassify){
                    case 1:
                        $("#page-wrapper").load("ProjectDetail?pid=" + data);
                        break;
                    case 2:
                        $("#page-wrapper").load("createAnliPage?aid=" + data);
                        break;
                    case 3:
                        $("#page-wrapper").load("createData?zid=" + data);
                        break;
                    case 5:
                        $("#page-wrapper").load("createAnnoucePage?aid=" + data);
                        break;
                }
            }
        });

        
    }

</script>