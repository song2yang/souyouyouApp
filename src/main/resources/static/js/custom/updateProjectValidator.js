/**
 * Created by souyouyou on 2018/3/21.
 */

$(document).ready(function () {
    $('#updateprojectForm').bootstrapValidator({
        message: 'This value is not valid',
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            proName: {
                message: '项目名称校验失败',
                validators: {
                    notEmpty: {
                        message: '项目名称不能为空'
                    }
                }
            },
            proNo: {
                message: '项目编号校验失败',
                validators: {
                    notEmpty: {
                        message: '项目编号不能为空'
                    }
                }
            },
            proFrom: {
                message: '项目来源校验失败',
                validators: {
                    notEmpty: {
                        message: '项目来源不能为空'
                    }
                }
            },
            proJoiners: {
                message: '项目参与者校验失败',
                validators: {
                    notEmpty: {
                        message: '项目参与者不能为空'
                    }
                }
            },
            mainDepartment: {
                message: '乘研单位校验失败',
                validators: {
                    notEmpty: {
                        message: '乘研单位不能为空'
                    }
                }
            },
            createPhasetime: {
                message: '立项时间校验失败',
                validators: {
                    notEmpty: {
                        message: '立项时间不能为空'
                    }
                }
            },
            cpAlertdays: {
                message: '立项提前通知时间校验失败',
                validators: {
                    notEmpty: {
                        message: '立项提前通知时间不能为空'
                    }
                }
            },
            openPhasetime: {
                message: '开题时间校验失败',
                validators: {
                    notEmpty: {
                        message: '开题时间不能为空'
                    }
                }
            },
            opAlertdays: {
                message: '开题提前通知时间校验失败',
                validators: {
                    notEmpty: {
                        message: '开题提前通知时间不能为空'
                    }
                }
            },
            midcheckPhasetime: {
                message: '中期检查时间校验失败',
                validators: {
                    notEmpty: {
                        message: '中期检查时间不能为空'
                    }
                }
            },
            mpAlertdays: {
                message: '中期检查提前通知时间校验失败',
                validators: {
                    notEmpty: {
                        message: '中期检查提前通知时间不能为空'
                    }
                }
            },
            closePhasetime: {
                message: '结题时间校验失败',
                validators: {
                    notEmpty: {
                        message: '结题时间不能为空'
                    }
                }
            },
            closepAlertdays: {
                message: '结题提前通知时间校验失败',
                validators: {
                    notEmpty: {
                        message: '结题提前通知时间不能为空'
                    }
                }
            },
            endPhasetime: {
                message: '验收时间校验失败',
                validators: {
                    notEmpty: {
                        message: '验收时间不能为空'
                    }
                }
            },
            epAlertdays: {
                message: '后期管理提前通知时间校验失败',
                validators: {
                    notEmpty: {
                        message: '后期管理提前通知时间不能为空'
                    }
                }
            },
            totalFee: {
                message: '总经费校验失败',
                validators: {
                    notEmpty: {
                        message: '总经费不能为空'
                    },
                    regexp: {
                        regexp: /^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$/,
                        message: '请输入数字'
                    }
                }
            },
            isreportReward: {
                message: '是否报奖不能为空',
                validators: {
                    callback: {
                        callback: function (value, validator) {
                            if (value == -1) {
                                return false;
                            } else {
                                return true;
                            }
                        }
                    }
                }
            },
            reportChannel: {
                message: '报奖渠道不能为空',
                validators: {
                    callback: {
                        callback: function (value, validator) {
                            if (value == -1) {
                                return false;
                            } else {
                                return true;
                            }
                        }
                    }
                }
            },
            proPhase: {
                message: '是否立项不能为空',
                validators: {
                    callback: {
                        callback: function (value, validator) {
                            if (value == -1) {
                                return false;
                            } else {
                                return true;
                            }
                        }
                    }
                }
            },
            proLeaders: {
                message: '项目负责人不能为空',
                validators: {
                    callback: {
                        callback: function (value, validator) {
                            if (value == -1) {
                                return false;
                            } else {
                                return true;
                            }
                        }
                    }
                }
            },
            proJoiners: {
                message: '项目参与人不能为空',
                validators: {
                    callback: {
                        callback: function (value, validator) {
                            if (value == -1) {
                                return false;
                            } else {
                                return true;
                            }
                        }
                    }
                }
            },
            classificlevelId: {
                message: '密级不能为空',
                validators: {
                    callback: {
                        callback: function (value, validator) {
                            if (value == -1) {
                                return false;
                            } else {
                                return true;
                            }
                        }
                    }
                }
            }
        }
    });
});