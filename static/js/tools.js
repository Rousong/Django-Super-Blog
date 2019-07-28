define("js/tools.js", function(require, exports, module) {
    var $ = require("jquery");
    var lib = require("lib");
    var form = require("form");
    var saveLocal = require("saveLocal");
    exports.init = init;
    var bmiTpl = function(obj) {
        var __t, __p = "",
            __j = Array.prototype.join,
            print = function() {
                __p += __j.call(arguments, "")
            };
        with(obj || {}) {
            __p += "<p>• 您的身体质量指数(BMI)为<strong>" + ((__t = BMI) == null ? "" : __t) + '</strong></p>\r\n<br />\r\n<table cellpadding="0" cellspacing="0" class="table2 gray-table margin20">\r\n    <tbody><tr class="thead">\r\n      <th colspan="4" style="border-left-width: 0px; border-right-width: 0px;">成年人身体质量指数</th>\r\n	</tr>\r\n    <tr>\r\n      <td class="label" width="25%" style="border-left-width: 0px;"><b>轻体重BMI</b></td>\r\n      <td class="label" width="25%"><b>健康体重BMI</b></td>\r\n      <td class="label" width="25%"><b>超重BMI</b></td> \r\n	  <td class="label" width="25%" style="border-right-width: 0px;"><b>肥胖BMI</b></td>\r\n	</tr>\r\n	<tr>\r\n	  <td style="border-left-width: 0px;">BMI&lt;18.5</td>\r\n	  <td>18.5≤BMI&lt;24</td>\r\n	  <td>24≤BMI&lt;28</td>\r\n	  <td style="border-right-width: 0px;">28≤BMI</td>\r\n	</tr>\r\n</tbody></table>\r\n<br />\r\n<p>• 您的健康体重范围为<strong>' + ((__t = w_rate[0]) == null ? "" : __t) + "</strong>~<strong>" + ((__t = w_rate[1]) == null ? "" : __t) + "</strong>公斤</p>\r\n<br />\r\n<p>• 您的年龄身高对应标准体重为<strong>" + ((__t = standardWeight) == null ? "" : __t) + "</strong>公斤</p>\r\n<br />\r\n<p>• 您的基础代谢率为<strong>" + ((__t = BMR) == null ? "" : __t) + "</strong>大卡</p>\r\n<br />\r\n<p>• 您的中低强度运动心率是<strong>" + ((__t = rate[0]) == null ? "" : __t) + "</strong>次/分钟到<strong>" + ((__t = rate[1]) == null ? "" : __t) + "</strong>次/分钟</p>\r\n";
            if (!hideTip) {
                __p += '\r\n<div class="tips">\r\n	<h3>人体要燃烧脂肪，需要满足三个必要条件：</h3>\r\n	<ol>\r\n		<li>1、该运动要达到中低强度的运动心率；</li>\r\n		<li>2、这种中低强度运动心率的运动要持续20分钟以上；</li>\r\n		<li>3、这种运动必须是大肌肉群的运动，如慢跑、游泳、健身操等。</li>\r\n	</ol>\r\n	<p>低于或高于这个范围，都不算中低强度运动心率，燃烧的也就不是脂肪了~</p>\r\n</div>\r\n'
            }
            __p += "\r\n<br/>"
        }
        return __p
    };
    var _hideTip;
    var M = {
        getBMI: function getBMI(height, weight) {
            var height = height / 100;
            return (weight / (height * height)).toFixed(1)
        },
        getWeight: function getWeight(height, sex) {
            var res;
            if (sex == 1) {
                res = (height - 80) * .7
            } else if (sex == 2) {
                res = (height - 70) * .6
            }
            return res.toFixed(1)
        },
        getBMR: function getBMR(height, weight, sex, age) {
            var res;
            if (sex == 1) {
                res = 66 + 13.7 * weight + 5 * height - 6.8 * age
            } else if (sex == 2) {
                res = 655 + 9.6 * weight + 1.8 * height - 4.7 * age
            }
            return res.toFixed(0)
        },
        getRate: function getRate(age) {
            var rate = [];
            rate[0] = ((220 - age - 60) * .6 + 60).toFixed(1);
            rate[1] = ((220 - age - 60) * .8 + 60).toFixed(1);
            return rate
        },
        getWeightRate: function getWeightRate(weight) {
            var w_rate = [],
                pencent = .1;
            w_rate[0] = (weight * (1 - pencent)).toFixed(1);
            w_rate[1] = (weight * (1 + pencent)).toFixed(1);
            return w_rate
        }
    };
    var V = {
        getStandWeight: function getStandWeight(linkSex, linkHeight, firstFlag) {
            var _ts = this;
            var formData = form.getFormData("#toolsForm");
            var height = linkHeight ? linkHeight : formData.height;
            var sex = linkSex ? linkSex : formData.sex;
            if (!linkSex && !linkHeight && firstFlag) {
                return
            }
            if (!C.checkSubmit(formData)) {
                return
            }
            var resultData = {
                weight: M.getWeight(height, sex)
            };
            var tplHmlt = "<p>• 您的年龄身高对应标准体重为<strong>" + resultData.weight + "</strong>KG（1KG=2斤）</p>";
            saveLocal.formSave("#toolsForm");
            $(".main-result").html(tplHmlt).show()
        },
        getHealthyWeight: function getHealthyWeight(linkSex, linkHeight, firstFlag) {
            var _ts = this;
            var formData = form.getFormData("#toolsForm");
            var height = linkHeight ? linkHeight : formData.height;
            var sex = linkSex ? linkSex : formData.sex;
            if (!linkSex && !linkHeight && firstFlag) {
                return
            }
            if (!C.checkSubmit(formData)) {
                return
            }
            var resultData = {
                rage: M.getWeightRate(M.getWeight(height, sex))
            };
            var tplHmlt = "<p>• 您的健康体重范围为<strong>" + resultData.rage[0] + "</strong>~<strong>" + resultData.rage[1] + "</strong>公斤</p>";
            saveLocal.formSave("#toolsForm");
            $(".main-result").html(tplHmlt).show()
        },
        getBmi: function getBmi() {
            var _ts = this;
            var formData = form.getFormData("#toolsForm");
            if (!C.checkSubmit(formData)) {
                return
            }
            var resultData = {
                weight: M.getBMI(formData.height, formData.weight)
            };
            var tplHmlt = "<p>• 您的身体质量指数(BMI)为<strong>" + resultData.weight + "</strong></p>";
            saveLocal.formSave("#toolsForm");
            $(".main-result").html(tplHmlt).show()
        },
        getBmr: function getBmr() {
            var _ts = this;
            var formData = form.getFormData("#toolsForm");
            if (!C.checkSubmit(formData)) {
                return
            }
            var resultData = {
                bmr: M.getBMR(formData.height, formData.weight, formData.sex, formData.age)
            };
            var tplHmlt = "<p>• 您的基础代谢率为<strong>" + resultData.bmr + "</strong>大卡</p>";
            saveLocal.formSave("#toolsForm");
            $(".main-result").html(tplHmlt).show()
        },
        getFatBurning: function getFatBurning() {
            var _ts = this;
            var formData = form.getFormData("#toolsForm");
            if (!C.checkSubmit(formData)) {
                return
            }
            var resultData = {
                rage: M.getRate(formData.age)
            };
            var tplHmlt = "<p>• 您的中低强度运动心率是<strong>" + resultData.rage[0] + "</strong>次/分钟到<strong>" + resultData.rage[1] + "</strong>次/分钟</p>";
            saveLocal.formSave("#toolsForm");
            $(".main-result").html(tplHmlt).show()
        },
        init: function init() {}
    };
    var C = {
        init: function init() {
            var currentLink = location.href;
            var linkHeight = lib.getParam("height");
            var linkSex = lib.getParam("sex");
            if (linkHeight) {
                $("input[name=height]").val(linkHeight)
            }
            if (linkSex) {
                $("input[type=radio][name=sex][value=" + linkSex + "]").attr("checked", true)
            }
            if (currentLink.indexOf("/tools/StandardWeight") >= 0) {
                V.getStandWeight(linkSex, linkHeight, true)
            }
            if (currentLink.indexOf("/tools/HealthyWeight") >= 0) {
                V.getHealthyWeight(linkSex, linkHeight, true)
            }
            if (currentLink.indexOf("/tools/BMI") >= 0) {
                $("input").each(function() {
                    $(this).bind("keydown", function(e) {
                        var key = e.which;
                        if (key == 13) {
                            V.getBmi()
                        }
                    })
                })
            }
            if (currentLink.indexOf("/tools/OneMinute") >= 0) {
                $("input").each(function() {
                    $(this).bind("keydown", function(e) {
                        var key = e.which;
                        if (key == 13) {
                            C.handleData();
                            return false
                        }
                    })
                })
            }
            $("#getBMI").on("click", function(e) {
                C.handleData();
                return false
            });
            $("#getmybmi").on("click", function(e) {
                V.getBmi()
            });
            $("#getStandardWeight").on("click", function(e) {
                V.getStandWeight("", "", false)
            });
            $("#getHealthyWeight").on("click", function(e) {
                V.getHealthyWeight("", "", false)
            });
            $("#getbmr").on("click", function(e) {
                V.getBmr()
            });
            $("#getFatBurning").on("click", function(e) {
                V.getFatBurning()
            })
        },
        handleData: function handleData() {
            var _ts = this;
            var formData = form.getFormData("#toolsForm");
            if (!_ts.checkSubmit(formData)) {
                return
            }
            var resultData = {
                BMI: M.getBMI(formData.height, formData.weight),
                BMR: M.getBMR(formData.height, formData.weight, formData.sex, formData.age),
                range: "",
                rate: M.getRate(formData.age),
                w_rate: M.getWeightRate(M.getWeight(formData.height, formData.sex)),
                standardWeight: M.getWeight(formData.height, formData.sex),
                hideTip: _hideTip
            };
            saveLocal.formSave("#toolsForm");
            var resultDom = bmiTpl(resultData);
            $(".main-result").html(resultDom).show()
        },
        changeLabelName: function changeLabelName(data) {
            $.each(data, function(index, val) {
                if (val == "sex") {
                    data[index] = "性别"
                }
                if (val == "height") {
                    data[index] = "身高"
                }
                if (val == "weight") {
                    data[index] = "体重"
                }
                if (val == "age") {
                    data[index] = "年龄"
                }
            })
        },
        checkDataType: function checkDataType(data) {
            var type = [],
                reg = /^\d+(\.\d+)*$/;
            $.each(data, function(index, val) {
                if (index == "sex") {
                    return
                }
                if (!reg.test(val)) {
                    type.push(index)
                }
            });
            this.changeLabelName(type);
            if (type.length) {
                var str = "";
                for (var i = 0; i < type.length; i++) {
                    if (i !== 0) {
                        str = str + "、"
                    }
                    str = str + type[i]
                }
                alert("只能在" + str + "填写数字");
                return false
            }
            return true
        },
        checkDataEmpty: function checkDataEmpty(data) {
            var type = [],
                reg = /^\d+(\.\d+)*$/;
            $.each(data, function(index, val) {
                if (!val) {
                    type.push(index)
                }
            });
            this.changeLabelName(type);
            if (type.length) {
                var str = "";
                for (var i = 0; i < type.length; i++) {
                    if (i !== 0) {
                        str = str + "、"
                    }
                    str = str + type[i]
                }
                alert(str + "不能为空");
                return false
            }
            return true
        },
        checkSubmit: function checkSubmit(data) {
            var _ts = this,
                sign = null;
            if (!_ts.checkDataEmpty(data)) {
                return sign
            }
            if (!_ts.checkDataType(data)) {
                return sign
            }
            sign = true;
            return sign
        }
    };
    C.init();
    saveLocal.formInit("#toolsForm");

    function init(hideTip) {
        _hideTip = hideTip
    }
});