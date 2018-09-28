<script language="JavaScript">
    function SaveKeyWord() {
            $.post("SaveKeyWord", {
                tid: $("#keywordTid").val(),
                mid: $("#keywordMid").val(),
                keywords: $("#keywordConent").val(),
                isprivate:$("input[type='radio']:checked").val()
        }, function (result) {
                result = JSON.parse(result)
                if (result.msg == 'ok') {
                    layer.msg('添加标签成功。');
                } else {
                    layer.msg('添加标签失败。');

                }

                $('.modal').map(function () {
                    $(this).modal('hide');
                });
                $(".modal-backdrop").remove();
            });

    }
</script>

<div class="modal fade" id="addKeywordModal" role="dialog" aria-labelledby="addKeywordModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="addKeywordModalLabel">添加标签</h4>
            </div>
            <div class="modal-body">
                <div class="row">

                    <form role="form" id="keywordForm" name="keywordForm">
                        <#--<input type="hidden" id="keyword_proid" name="keyword_proid" value="${proentity.id!}">-->
                        <div class="form-group col-md-12">
                            <label>标签内容</label>
                            <input class="form-control" id="keywordConent" name="keywordConent">
                        </div>
                        <div class="form-group col-md-12">
                            <div><label>标签类型</label></div>
                            <label class="radio-inline">
                                <input type="radio" id="privateKey" value="1" name="keywordType" checked="checked">私有
                            </label>
                            <label class="radio-inline">
                                <input type="radio" id="publicKey" value="0"  name="keywordType">公有
                            </label>


                        </div>
                    </form>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" onclick="SaveKeyWord()" id="saveKeyword">保存</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

