<div class="panel-body">
    <form class="form-inline">
        <div class="form-group">
            <label>选择类型:</label>
            <select class="form-control" style="width: 150px;" id="feetypelist"
                    name="feetypelist">
                <option value="1" selected>已收</option>
                <option value="2">催收</option>
            </select>
        </div>
        <div class="form-group" style="margin-left: 50px;">
        <#--<button id="btn_searchfeetype" type="button" class="btn btn-primary"-->
                    <#--onclick="refreshMoneyTable()">-->
                <#--<span class="glyphicon glyphicon-search" aria-hidden="true"></span>查询-->
            <#--</button>-->
        </div>
    </form>

    <div class="table-responsive" style="margin-top: 20px;" id="yishoudiv">
        <div id="yishoutabletoolbar" class="btn-group">
        <@shiro.hasPermission name="yfee:add">
            <button id="btn_addyfee" type="button" class="btn btn-primary"
                    style="" onclick="AddYFee()">
                <span class="glyphicon glyphicon-book" aria-hidden="true"></span>添加
            </button>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="yfee:edit">
            <button id="btn_edityfee" onclick="EditYFee()" type="button" class="btn btn-primary"
                    style="margin-left: 20px;" onclick="">
                <span class="glyphicon glyphicon-edit" aria-hidden="true"></span>编辑
            </button>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="yfee:export">
            <button id="btn_exportyfee" type="button" class="btn btn-primary"
                    style="margin-left: 20px;" onclick="">
                <span class="glyphicon glyphicon-download" aria-hidden="true"></span>导出
            </button>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="yfee:delete">
            <button id="btn_deleteyfee" type="button" onclick="DeleteFee()" class="btn btn-danger"
                    style="margin-left: 20px;" onclick="">
                <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除
            </button>
        </@shiro.hasPermission>
        </div>

        <table width="100%" class="table table-striped table-bordered table-hover"
               id="yishoutable" data-toolbar="#yishoutabletoolbar" style="margin-top:20px;">
        </table>

    </div>

    <div class="table-responsive" style="margin-top: 20px; display:none" id="cuishoudiv">
        <div id="cuishoutabletoolbar" class="btn-group">
        <@shiro.hasPermission name="cfee:add">
            <button id="btn_addcfee" type="button" class="btn btn-primary"
                    style="" onclick="AddCFee()">
                <span class="glyphicon glyphicon-book" aria-hidden="true"></span>添加
            </button>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="cfee:edit">
            <button id="btn_editcfee" type="button" class="btn btn-primary"
                    style="margin-left: 20px;" onclick="EditYFee()">
                <span class="glyphicon glyphicon-edit" aria-hidden="true"></span>编辑
            </button>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="cfee:export">
            <button id="btn_exportcfee" type="button" class="btn btn-primary"
                    style="margin-left: 20px;" onclick="">
                <span class="glyphicon glyphicon-download" aria-hidden="true"></span>导出
            </button>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="cfee:delete">
            <button id="btn_deletecfee" type="button" onclick="DeleteFee()" class="btn btn-danger"
                    style="margin-left: 20px;" onclick="">
                <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除
            </button>
        </@shiro.hasPermission>
        </div>

        <table width="100%" class="table table-striped table-bordered table-hover"
               id="cuishoutable" data-toolbar="#cuishoutabletoolbar" style="margin-top:20px;">
        </table>
    </div>
</div>

<!-- Modal 添加已收账款-->
<button id="btn_addyishoufee" type="button" class="btn btn-primary"
        style="display:none" data-toggle="modal"
        data-target="#addyishouModal" onclick="">
    <span class="glyphicon glyphicon-book" aria-hidden="true"></span>
</button>
<div class="modal fade" id="addyishouModal" role="dialog" aria-labelledby="yishouModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="yishouModalLabel">已收账款</h4>
            </div>
            <div class="modal-body">
                <div class="row">

                    <form role="form" id="yishouForm" name="yishouForm">
                        <input type="hidden" id="editYishouId" name="editYishouId" value="0">
                        <div class="form-group col-md-12">
                            <label>已收金额</label>
                            <input class="form-control" id="receiveNum" name="receiveNum">
                        </div>

                        <div class="form-group col-md-12">
                            <label>收款时间</label>
                            <input class="form-control" type="date"
                                   id="receiveTime"
                                   name="receiveTime">
                        </div>
                    </form>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" onclick="SaveYishou()" id="saveYishou">保存</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- /.modal -->

<!-- Modal 添加催收记录-->
<button id="btn_addcuishoufee" type="button" class="btn btn-primary"
        style="display:none" data-toggle="modal"
        data-target="#addcuishouModal" onclick="">
    <span class="glyphicon glyphicon-book" aria-hidden="true"></span>
</button>
<div class="modal fade" id="addcuishouModal" role="dialog" aria-labelledby="cuishouModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="cuishouModalLabel">催收记录</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <form role="form" id="cuishouForm" name="cuishouForm">
                        <input type="hidden" id="editCuishouId" name="editCuishouId" value="0">
                        <div class="form-group col-md-12">
                            <label>催收金额</label>
                            <input class="form-control" id="cuishouAmount" name="cuishouAmount">
                        </div>
                        <div class="form-group col-md-12">
                            <label>催收时间</label>
                            <input class="form-control" type="date" value=""
                                   id="cuishouTime"
                                   name="cuishouTime">
                        </div>
                        <div class="form-group col-md-12">
                            <label>预提醒天数</label>
                            <input class="form-control" id="cuishouAlertDays" name="cuishouAlertDays">
                        </div>
                        <div class="form-group col-md-12">
                            <label>答复</label>
                            <textarea class="form-control" id="dafu" name="dafu"></textarea>
                        </div>
                        <div class="form-group col-md-12">
                            <label>对接人</label>
                            <input class="form-control" id="duijierenName" name="duijierenName">
                        </div>
                        <div class="form-group col-md-12">
                            <label>经办人</label>
                            <select id="jingbanName" name="jingbanName" class="form-control">

                                <#list users as user>
                                    <option value="${user.id}">${user.username}</option>
                                </#list>
                                <#--<option th:each="user:${users}" th:value="${user.id}" th:text="${user.username}"></option>-->
                            </select>

                        </div>
                    </form>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" onclick="" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" onclick="SaveCuishou()" id="SaveCuishou">保存</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- /.modal -->