<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <meta name="description" content=""/>
    <meta name="author" content=""/>

    <title>知识共享管理平台</title>

    <!-- Bootstrap Core CSS -->
    <link href="static/css/bootstrap.min.css" rel="stylesheet"/>

    <!-- MetisMenu CSS -->
    <link href="static/css/metisMenu.min.css" rel="stylesheet"/>

    <!-- Custom CSS -->
    <link href="static/css/sb-admin-2.css" rel="stylesheet"/>

    <!-- Custom Fonts -->

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="static/js/html5shiv.js"></script>
    <script src="static/js/respond.min.js"></script>
    <![endif]-->

</head>

<body style="background-image: url('static/img/loginbg.jpg')">

<div class="container">
    <div class="row">
        <div class="col-md-4 col-md-offset-4">
            <div class="login-panel panel panel-default" style="margin-top: 60%">
                <div class="panel-heading">
                    <h3 class="panel-title">登录</h3>
                    <div class="panel-body">
                        <form action="sign_in" id="loginForm">
                            <fieldset>
                                <div class="form-group">
                                    <input class="form-control" placeholder="请输入用户名" name="username" type="text" autofocus="autofocus" value="superadmin" required="required"/>
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="请输入密码" name="password" type="password" value="123456"/>
                                </div>
                                <div class="alert alert-error" style="display: none">
                                    <a class="close" href="javascript:void(0)" onclick="close1()">×</a>
                                    <strong style="color: red;"></strong>
                                </div>
                                <!-- Change this to a button or input when using this as a form -->
                                <input type="button" class="btn btn-lg btn-success btn-block" onclick="login()" id="loginBtn" value="登录"/>
                            </fieldset>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- jQuery -->
    <script src="static/js/jquery.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="static/js/bootstrap.min.js"></script>

    <!-- Metis Menu Plugin JavaScript -->
    <script src="static/js/metisMenu.min.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="static/js/sb-admin-2.js"></script>

    <script type="text/javascript">

        function close1() {
            $('.alert').hide()
        }

        if ( document.getElementById('wrapper') != null){
            window.top.location = "login";
        }


        $("#loginBtn").click(login);

        document.onkeydown = function(e){
            var ev = document.all ? window.event : e;
            if(ev.keyCode==13) {
                document.getElementById('loginBtn').click = login();
            }
        };

        
        function login() {
            $.post("sign_in",$("#loginForm").serialize(),function(result){
                debugger
                result = JSON.parse(result);
                if(result && (result.msg == 'success'||result.msg[0] == 'success')){
                    window.location.href = "index";
                }else {
                    $(".alert-error").removeAttr("style");
                    $("strong").text(result.msg)
                }
            });
        }
        
    </script>

</div>
</body>

</html>
