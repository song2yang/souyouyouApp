<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>

    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <meta name="description" content=""/>
    <meta name="author" content=""/>

    <title>知识共享管理平台</title>

    <!-- jQuery -->
    <script src="static/js/jquery.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="static/js/bootstrap.min.js"></script>


    <!-- MetisMenu CSS -->
    <link href="static/css/metisMenu.min.css" rel="stylesheet"/>

    <!-- Custom CSS -->
    <link href="static/css/sb-admin-2.css" rel="stylesheet"/>

    <!-- Morris Charts CSS -->
    <link href="static/css/morris.css" rel="stylesheet"/>


    <!-- Bootstrap Core CSS -->
    <link href="static/css/bootstrap.css" rel="stylesheet"/>


    <!-- Custom Fonts -->
    <link href="static/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>


    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>

    <script src="static/js/html5shiv.js"></script>
    <script src="static/js/respond.min.js"></script>


    <![endif]-->
    <style>
        .spc_span{
            padding: 0px 10px;
            width: 100px;
            display: block;
            line-height: 30px;
            margin-top: -5px;
            margin-right: -10px;
        }
        .disno{
            display: none;
        }
    </style>
</head>

<body>

<div id="wrapper">

    <!-- Navigation -->
<#include "header.ftl">

    <!--<div th:include="templates/header" ></div>-->
    <div id="page-wrapper">
        <ul>
        </ul>
        <#include "main.ftl">
    </div>
    <!-- /#page-wrapper -->

</div>
<!-- /#wrapper -->



<!-- Metis Menu Plugin JavaScript -->
<#--<script src="static/js/metisMenu.min.js"></script>-->

<!-- Morris Charts JavaScript -->
<script src="static/js/raphael.min.js"></script>
<#--&lt;#&ndash;<!--<#&#45;&#45;<script src="static/js/morris.min.js"></script>&ndash;&gt;&ndash;&gt;&ndash;&gt;-->
<#--&lt;#&ndash;<!--<#&#45;&#45;<script src="static/js/morris-data.js"></script>&ndash;&gt;&ndash;&gt;&ndash;&gt;-->

<#--<!-- Custom Theme JavaScript &ndash;&gt;-->
<script src="static/js/sb-admin-2.js"></script>
<script src="static/js/nav.js"></script>


<script>
//    $(function () {
//        $("#side-menu>li>a").removeClass('active');
//    })
    $(".spc_span").off("click").on("click",function(e){
        e.preventDefault();
        if($(this).parent().parent().hasClass('active')){
            $(this).parent().parent().removeClass("active");
            $(this).parent().next().hide();
        }else{
            $(this).parent().parent().siblings('li').removeClass('active').children('.nav').hide();
            $(this).parent().parent().addClass("active");
            $(this).parent().next().show();
        }

    })
</script>

    </body>

</html>
