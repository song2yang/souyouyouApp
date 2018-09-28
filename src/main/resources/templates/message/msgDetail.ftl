<link rel="stylesheet" href="static/css/bootstrap-table.min.css">
<link rel="stylesheet" href="static/css/AdminLTE-without-plugins.css">
<link rel="stylesheet" href="static/css/layer.css">
<script src="static/js/bootstrap-table.min.js"></script>
<script src="static/js/bootstrap-table-zh-CN.min.js"></script>
<script src="static/js/layer.js"></script>
<!-- Bootstrap Core CSS -->
<link href="static/css/bootstrap.min.css" rel="stylesheet">

<!-- MetisMenu CSS -->


<div class="content">

    <div class="row">
        <div class="col-lg-12">
            <h1 class="page-header">${msgGroup.groupName}</h1>
            <input type="hidden" id="msgGroupId" value="${msgGroup.id}">
        </div>
        <!-- /.col-lg-12 -->
    </div>

    <div class="row">
        <!-- /.col-lg-8 -->
        <div class="col-lg-12">
            <!-- /.panel -->
            <!-- /.panel -->
            <div class="chat-panel panel panel-default">
                <div class="panel-heading">
                    <i class="fa fa-comments fa-fw"></i> ${msgGroup.groupUsers}
                    <div class="btn-group pull-right">
                        <button type="button" class="btn btn-default btn-xs" onclick="getMessage()">
                            <i class="fa fa-refresh fa-fw"></i>
                        </button>
                        <#--<ul class="dropdown-menu slidedown">-->
                            <#--<li>-->
                                <#--<a href="javascript:void(0)" onclick="getMessage()">-->
                                    <#--<i class="fa fa-refresh fa-fw"></i> Refresh-->
                                <#--</a>-->
                            <#--</li>-->
                            <#--<li>-->
                                <#--<a href="#">-->
                                    <#--<i class="fa fa-check-circle fa-fw"></i> Available-->
                                <#--</a>-->
                            <#--</li>-->
                            <#--<li>-->
                                <#--<a href="#">-->
                                    <#--<i class="fa fa-times fa-fw"></i> Busy-->
                                <#--</a>-->
                            <#--</li>-->
                            <#--<li>-->
                                <#--<a href="#">-->
                                    <#--<i class="fa fa-clock-o fa-fw"></i> Away-->
                                <#--</a>-->
                            <#--</li>-->
                            <#--<li class="divider"></li>-->
                            <#--<li>-->
                                <#--<a href="#">-->
                                    <#--<i class="fa fa-sign-out fa-fw"></i> Sign Out-->
                                <#--</a>-->
                            <#--</li>-->
                        <#--</ul>-->
                    </div>
                </div>
                <!-- /.panel-heading -->
                <div class="panel-body">
                    <ul class="chat" id="chat">

                    </ul>
                </div>
                <!-- /.panel-body -->
                <div class="panel-footer">
                    <div class="input-group">
                        <input id="btn-input" type="text" class="form-control input-sm" placeholder="在此输入您要发送的消息..."/>
                        <span class="input-group-btn">
                            <button class="btn btn-warning btn-sm" id="btn-chat">
                                发送
                            </button>
                        </span>
                    </div>
                </div>
                <!-- /.panel-footer -->
            </div>
            <!-- /.panel .chat-panel -->
        </div>
        <!-- /.col-lg-4 -->
    </div>
</div>
<script>
    $(document).ready(function () {
        getMessage()
    });
    $('#btn-chat').click(function () {
        var postData = {
            msgGroupId: $("#msgGroupId").val(),
            msgContent: $("#btn-input").val()
        }
        $.post("newMsg", postData, function (result) {

            result = JSON.parse(result);

            if (result.msg == 'success') {
                getMessage();
                $('#btn-input').val("");
                layer.msg("消息发送成功!");
            } else {
                layer.msg("消息发送失败,请稍候再试!");
                return;
            }


        })
    });


    function getMessage() {

        $.post("getMessage", {msgGroupId: $("#msgGroupId").val()}, function (result) {

            result = JSON.parse(result);

            if (result.msg == 'success') {
                $('#chat').html("");
                result.data.forEach(function (val, index) {

                    var lis = "";
                    if (val.userId == result.userId) {
                        lis += '<li class="right clearfix">' +
                                '<span class="chat-img pull-right">' +
                                '<img src="http://placehold.it/50/55C1E7/fff" alt="User Avatar" class="img-circle" /></span>' +
                                '<div class="chat-body clearfix"><div class="header"><strong class="primary-font">' + val.userName + '</strong>' +
                                '<small class="pull-right text-muted"><i class="fa fa-clock-o fa-fw"></i>' + val.sendTime + '</small></div>' +
                                '<p>' + val.content + '</p>' +
                                '</div></li>';
                    } else {
                        lis += '<li class="left clearfix">' +
                                '<span class="chat-img pull-left">' +
                                '<img src="http://placehold.it/50/55C1E7/fff" alt="User Avatar" class="img-circle" /></span>' +
                                '<div class="chat-body clearfix"><div class="header"><strong class="primary-font">' + val.userName + '</strong>' +
                                '<small class="pull-right text-muted"><i class="fa fa-clock-o fa-fw"></i>' + val.sendTime + '</small></div>' +
                                '<p>' + val.content + '</p>' +
                                '</div></li>';
                    }


                    $('#chat').append(lis);


                })
            } else {
                layer.msg("消息发送失败,请稍候再试!");
                return;
            }


        })

    }
</script>
