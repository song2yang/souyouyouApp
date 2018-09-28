/**
 * Created by souyouyou on 2018/3/21.
 */

$(function () {
    $('form').bootstrapValidator({
        message: 'This value is not valid',
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            title: {
                message: '标题校验失败',
                validators: {
                    notEmpty: {
                        message: '标题不能为空'
                    }
                }
            },
            birth: {
                message: '出生日期校验失败',
                validators: {
                    notEmpty: {
                        message: '出生日期不能为空'
                    }
                }
            },
            username: {
                message: '用户名校验失败',
                validators: {
                    notEmpty: {
                        message: '用户名不能为空'
                    }
                }
            },
            name: {
                message: '姓名校验失败',
                validators: {
                    notEmpty: {
                        message: '姓名不能为空'
                    }
                }
            },
            profile: {
                message: '个人简介校验失败',
                validators: {
                    notEmpty: {
                        message: '个人简介不能为空'
                    }
                }
            },
            email: {
                validators: {
                    notEmpty: {
                        message: '邮箱地址不能为空'
                    },
                    emailAddress:{
                        message: '邮箱地址格式错误'
                    }
                }
            },
            sxzhuanye: {
                validators: {
                    notEmpty: {
                        message: '所学专业不能为空'
                    }
                }
            },
            cszhuanye: {
                validators: {
                    notEmpty: {
                        message: '从事专业不能为空'
                    }
                }
            },
            zhiwu: {
                validators: {
                    notEmpty: {
                        message: '职务不能为空'
                    }
                }
            },
            szdanwei: {
                validators: {
                    notEmpty: {
                        message: '所在单位不能为空'
                    }
                }
            },
            szbumen: {
                validators: {
                    notEmpty: {
                        message: '所在部门不能为空'
                    }
                }
            },
            sslingyu: {
                validators: {
                    notEmpty: {
                        message: '单位所属领域不能为空'
                    }
                }
            },
            address: {
                validators: {
                    notEmpty: {
                        message: '通讯地址不能为空'
                    }
                }
            },
            postcode: {
                validators: {
                    notEmpty: {
                        message: '邮编不能为空'
                    }
                }
            },
            mobile: {
                validators: {
                    notEmpty: {
                        message: '手机不能为空'
                    },
                    stringLength: {
                        min: 11,
                        max: 11,
                        message: '请输入11位手机号码'
                    },
                    regexp: {
                        regexp: /^1[3|5|8]{1}[0-9]{9}$/,
                        message: '请输入正确的手机号码'
                    }
                }
            },
            phone: {
                validators: {
                    notEmpty: {
                        message: '座机不能为空'
                    }
                }
            },
            faxcode: {
                validators: {
                    notEmpty: {
                        message: '传真不能为空'
                    }
                }
            },
            pycishu: {
                validators: {
                    notEmpty: {
                        message: '专家聘用次数不能为空'
                    }
                }
            },
            classificlevelId: {
                message:'密级不能为空',
                validators: {
                    callback:{
                        callback: function(value, validator) {
                            if (value == -1){
                                return false;
                            }else {
                                return true;
                            }
                        }
                    }
                }
            },
            receverId: {
                message:'收信人不能为空',
                validators: {
                    callback:{
                        callback: function(value, validator) {
                            if (value == -1){
                                return false;
                            }else {
                                return true;
                            }
                        }
                    }
                }
            },
            education: {
                message:'学历不能为空',
                validators: {
                    callback:{
                        callback: function(value, validator) {
                            if (value == -1){
                                return false;
                            }else {
                                return true;
                            }
                        }
                    }
                }
            },
            classiclevelId: {
                message:'密级不能为空',
                validators: {
                    callback:{
                        callback: function(value, validator) {
                            if (value == -1){
                                return false;
                            }else {
                                return true;
                            }
                        }
                    }
                }
            },
            ziliaoFrom: {
                message:'来源不能为空',
                validators: {
                    callback:{
                        callback: function(value, validator) {
                            if (value == -1){
                                return false;
                            }else {
                                return true;
                            }
                        }
                    }
                }
            },
            isShare: {
                message:'是否共享不能为空',
                validators: {
                    callback:{
                        callback: function(value, validator) {
                            if (value == -1){
                                return false;
                            }else {
                                return true;
                            }
                        }
                    }
                }
            },
            zhicheng: {
                message:'职称不能为空',
                validators: {
                    callback:{
                        callback: function(value, validator) {
                            if (value == -1){
                                return false;
                            }else {
                                return true;
                            }
                        }
                    }
                }
            },
            zjpingjia: {
                message:'最佳评价不能为空',
                validators: {
                    callback:{
                        callback: function(value, validator) {
                            if (value == -1){
                                return false;
                            }else {
                                return true;
                            }
                        }
                    }
                }
            },
            gender: {
                message:'性别不能为空',
                validators: {
                    callback:{
                        callback: function(value, validator) {
                            if (value == -1){
                                return false;
                            }else {
                                return true;
                            }
                        }
                    }
                }
            }
        }
    });
});


function viewFile(mid) {
    $.ajax({
        type : "post",
        url : "viewFile",
        data : {mid:mid},
        async : false,
        success : function(data){
            data = JSON.parse(data);
            console.log(data)

            var paperContent = '<div class="panel-body"><div class="row"><div class="col-lg-6"><form role="form"id="paperForm">' +
                '<div class="form-group"><label>密级</label><input class="form-control"name="fileName" value="'+data.fileName+'" readonly/></div>' +
                '<div class="form-group"><label>文件名</label><input class="form-control"name="fileName" value="'+data.fileName+'" readonly/></div>' +
                '<div class="form-group"><label>责任人</label><input class="form-control"name="zrr" value="'+data.zrr+'" readonly/></div></form></div></div></div>'

            layer.open({
                type: 1,
                title:'附件信息',
                area: ['500px', '360px'],
                btn: ['关闭'],
                content: paperContent
            });

        }
    });

}




