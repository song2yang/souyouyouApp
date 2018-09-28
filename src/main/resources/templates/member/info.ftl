<link href="static/css/bootstrap-datetimepicker.min.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="static/css/bootstrap-table.min.css">
<link rel="stylesheet" href="static/css/layer.css">
<link rel="stylesheet" href="static/css/fileinput.css">


<script src="static/js/bootstrap-datetimepicker.js"></script>
<script src="static/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script src="static/js/bootstrap-table.min.js"></script>
<script src="static/js/bootstrap-table-zh-CN.min.js"></script>
<script src="static/js/layer.js"></script>
<script src="static/js/fileinput.js"></script>
<script src="static/js/locales/zh.js"></script>
<script src="static/js/jquery.form.js"></script>
<script src="static/js/formValidator.js"></script>


<script type="text/javascript" src="static/js/ckeditor/ckeditor.js"></script>
<div class="content">

    <div class="row">
        <div class="col-lg-12">
            <h1 class="page-header">用户信息</h1>
        </div>
        <!-- /.col-lg-12 -->
    </div>


    <form class="form-horizontal" id="expertForm">

        <div class="form-group">
            <label for="name" class="col-sm-2 control-label">用户名</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="username" name="username" value="${userInfo.username!}"
                       readonly>
            </div>
        </div>


        <div class="form-group">
            <label for="name" class="col-sm-2 control-label">真实姓名</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="realName" name="realName" value="${userInfo.realName!}"
                       readonly>
            </div>
        </div>


        <div class="form-group">
            <label for="name" class="col-sm-2 control-label">职务</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="positions" name="positions" value="" readonly>
            </div>
        </div>


        <div class="form-group">
            <label for="name" class="col-sm-2 control-label">手机号</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="mobile" name="mobile" value="${userInfo.mobile!}" readonly>
            </div>
        </div>


        <div class="form-group">
            <label for="name" class="col-sm-2 control-label">密级</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="permissionLevel" name="permissionLevel" value="" readonly>
            </div>
        </div>


        <div class="form-group">
            <label for="name" class="col-sm-2 control-label">描述信息</label>
            <div class="col-sm-4">
                <input type="text" class="form-control" id="description" name="description"
                       value="${userInfo.description!}" readonly>
            </div>
        </div>

        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
                <a href="javascript:void(0)" class="btn btn-primary" data-target="#updatePwd" data-toggle="modal">修改密码</a>
            </div>
        </div>

    </form>

</div>


<div class="modal fade" id="updatePwd" role="dialog"
     aria-labelledby="updatePwdLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="updatePwdLabel">新建用户</h4>
            </div>

            <div class="panel-body">
                <div class="row">
                    <div class="col-lg-10">
                        <form role="form" id="pwdForm">
                            <div class="form-group">
                                <label>原始密码</label>
                                <input class="form-control" type="password" name="oldPwd" id="oldPwd" placeholder="请输入原始密码"/>
                            </div>
                            <div class="form-group">
                                <label>新密码</label>
                                <input class="form-control" type="password" name="newPwd" id="newPwd" placeholder="请输入新密码"/>
                            </div>
                            <div class="form-group">
                                <label>确认密码</label>
                                <input class="form-control" type="password" name="repeatPwd" id="repeatPwd" placeholder="请输入确认密码"/>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" onclick="updatePwd();" class="btn btn-primary">确定</button>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">

    switch (${userInfo.permissionLevel!}) {
        case 1:
            $('#permissionLevel').val("公开");
            break;
        case 2:
            $('#permissionLevel').val("内部");
            break;
        case 3:
            $('#permissionLevel').val("秘密");
            break;
        case 4:
            $('#permissionLevel').val("机密");
            break;
    }


    switch (${userInfo.positions!}) {
        case 1:
            $('#positions').val("主任");
            break;
        case 2:
            $('#positions').val("处长");
            break;
        case 3:
            $('#positions').val("助理");
            break;
    }

    function updatePwd() {


        var form = new FormData(document.getElementById("pwdForm"));

        if ($('#newPwd').val() != $('#repeatPwd').val()){
            layer.msg("新密码和确认密码不一致");
            return;
        }else {
            $.ajax({
                url: "updatePassword",
                type: "post",
                data: form,
                processData: false,
                contentType: false,
                success: function (data) {
                    debugger
                    console.log(data)
                    data = JSON.parse(data);
                    if (data.msg == 'success'){
                        layer.msg("密码修改成功");
                        $('.modal').map(function () {
                            $(this).modal('hide');
                        });
                        $(".modal-backdrop").remove();
                    }else {
                        layer.msg(data.msg);
                        $('#pwdForm')[0].reset()
                        return;
                    }
//                    $("#page-wrapper").load("expertList")
                },
                error: function (data) {
                    layer.err("新建专家失败")
                }
            });
        }


    }


</script>
