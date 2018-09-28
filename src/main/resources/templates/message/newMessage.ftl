<link rel="stylesheet" href="static/css/bootstrap-select.css">
<link rel="stylesheet" href="static/css/layer.css">

<script type="text/javascript" src="static/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="static/js/bootstrap-select.js"></script>
<script src="static/js/jquery.form.js"></script>
<script src="static/js/layer.js"></script>
<script src="static/js/formValidator.js"></script>

<div class="content">

    <div class="row" style="margin-left: 2%;width: 73%;">
        <div class="col-lg-12">
            <h1 class="page-header">新建消息${senderId!}</h1>
        </div>
        <!-- /.box-header -->
        <form id="messageForm" enctype="multipart/form-data">
            <div class="box-body">

                <div class="form-group">
                    <input name="title" type="text" class="form-control" placeholder="请输入标题" value="${msg.title!}"/>
                </div>
                <div class="form-group">
                    <select id="receverId" name="receverId" class="selectpicker form-control" multiple
                            required data-live-search="true">
                        <#--<option value="-1">请选择收信人</option>-->
                    <#foreach user in users>
                        <option value="${user.id?c}">${user.username!}</option>
                    </#foreach>
                    </select>
                </div>
                <div class="form-group">
                <textarea id="ckeditor" name="ckeditor" class="form-control" rows="10" cols="38"
                          style="height: 300px"></textarea>
                    <script type="text/javascript">CKEDITOR.replace('ckeditor')</script>
                    <input type="hidden" name="content" id="content">
                    <input type="hidden" name="senderStatus" id="senderStatus">
                </div>
                <div class="form-group">
                    <div class="btn btn-default btn-file">
                        <i class="fa fa-paperclip"></i> Attachment
                        <input type="file" id="attachment" multiple name="attachment">
                    </div>
                    <#--<p class="help-block">Max. 32MB</p>-->
                </div>
            </div>
            <!-- /.box-body -->
            <div class="box-footer">
                <div class="pull-right">
                    <button type="button" id="send" class="btn btn-primary"><i class="fa fa-envelope-o"></i> 发送</button>
                    <button type="button" id="draft" class="btn btn-default"><i class="fa fa-pencil"></i> 存草稿</button>
                </div>

            </div>
        </form>
        <!-- /.box-footer -->
    </div>
</div>

<script>
    $(document).ready(function () {
        $('#receverId').selectpicker();

    })

    CKEDITOR.instances.ckeditor.setData('${msg.content!}');

    /*多选下拉框回填历史选择*/
    var ridsStr = '${uhm.receverIds!}';

    var receverIds = [];
    if (ridsStr != ''){
        ridsArr = ridsStr.split('');
        $.each(ridsArr,function () {
            if (this != '[' && this != ']'){
                receverIds.push(this);
            }
        })
        $('.selectpicker').selectpicker('val', receverIds);//默认选中
        $('.selectpicker').selectpicker('refresh');
    }





    function submitForm() {
        var content = CKEDITOR.instances.ckeditor.getData();
        $("#content").val(content)

        var bootstrapValidator = $("#messageForm").data('bootstrapValidator');
        bootstrapValidator.validate()

        if (!bootstrapValidator.isValid())
            return;

        if (content == ''){
            layer.msg("请输入摘要");
            return;
        }

        var options = {
            url: 'sendMessage',   //同action
            type: 'post',
            beforeSend: function (xhr) {//请求之前

            },
            success: function (data) {
                data = JSON.parse(data)
                if (data.msg == "success") {
                    $("#page-wrapper").load("inBoxList")
                } else {
                    layer.msg("消息发送失败,请稍候重试!");
                }

            },

            complete: function (xhr) {//请求完成


            },
            error: function (xhr, status, msg) {
                layer.msg('玩命加载中..');

            }
        };
        $("#messageForm").ajaxSubmit(options);
    }

    $('#send').on('click', function () {
        $('#senderStatus').val(1);
        submitForm();

    });
    
    
    $('#draft').on('click', function () {
        $('#senderStatus').val(0);
        submitForm();
    })
</script>