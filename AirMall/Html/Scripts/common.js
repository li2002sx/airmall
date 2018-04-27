var flightInfo = null,
    sqlFliteFlight = "";
$(function () {
    $(".header-close .iconfont").on("click", function () {
        $(this).parents(".appmodal").hide();
    });

    $("#modal-msg .btn-cancel").on("click", function () {
        $("#modal-msg").hide();
    });

    $(document).on("click", ".del-photo", function () {
        $(this).parents(".photo-item").remove();
    });

    $(".file-mask").click(function () {
        if ($(this).parents(".photo-wrapper").find(".photo-item").length > 5) {
            return;
        }
        appJsBridge.callHandler('upload', null, function (result) {

        });
        appJsBridge.registerHandler('getUploadResult', function (data, callback) {
            var imgItem = '<div class="photo-item">' +
                '<div class="photo-img-wrapper">' +
                '<img src="' + data.info + '" alt="">' +
                '</div>' +
                '<div class="del-photo">' +
                '<span class="iconfont icon-guanbi"></span>' +
                '</div>' +
                '</div>';

            $(this).parent().before(imgItem);
        });
    });
});

function getLoginInfo(callback) {
    appJsBridge.callHandler("loginInfo", null, function (result) {
        result = JSON.parse(result);
        if (result.status == 1) {
            flightInfo = result.userInfo;
            sqlFliteFlight = " and FlightNo='" + flightInfo.FlightNo + "' and FlightDate ='" + flightInfo.FlightDate + "'";
            if (callback) {
                callback();
            }
        } else {
            toast("提示", "获取航班信息失败!");
        }
    });
}

//加减数字框
function initNumbox(callback) {
    //$(document).on('click', '.point-r', function (event) {
    //    var maxnum = $(this).parent().attr("max");
    //    var num = $(this).prev().val();
    //    if (maxnum && maxnum != "") {
    //        if (num * 1 < maxnum * 1) {

    //            $(this).prev().val(num * 1 + 1);
    //        }
    //    } else {
    //        $(this).prev().val(num * 1 + 1);
    //    }        
    //});

    //$(document).on('click', '.point-l', function (event) {
    //    var minnum = $(this).parent().attr("min");
    //    var num = $(this).next().val();
    //    if (minnum && minnum != "") {
    //        if (num * 1 > minnum * 1) {
    //            $(this).next().val(num * 1 - 1);
    //        }
    //    } else {
    //        $(this).next().val(num * 1 - 1);
    //    }
    //});

    $(document).on("click", ".btn-point", function () {
        var $this = $(this);
        var maxnum = $this.parent().attr("max");
        var minnum = $this.parent().attr("min");
        var point = Number($this.data("point"));
        var num = Number($(this).siblings(".calc-input").val()) || 0;

        num += point;

        if (maxnum && num > maxnum) {
            num = maxnum;
            return;
        } else if (minnum && num < minnum) {
            num = minnum;
            return;
        } else if (!minnum && num < 0) {
            num = 0;
            return;
        }


        if (callback) {
            callback($this, point)
        }

        $(this).siblings(".calc-input").val(num);
    })

    //$(document).on('keyup change keydown', '.calc-input', function (event) {
    //    var num = $(this).val();
    //    var max = $(this).parent().attr("max");
    //    var min = $(this).parent().attr("min");
    //    if (!$.isNumeric(num)) {
    //        $(this).val(num.substring(0, num.length - 1));
    //    }
    //    if (max && max != "") {
    //        if (num * 1 > max * 1) {
    //            $(this).val(max);
    //        }
    //    }
    //    if (min && min != "") {
    //        if (num * 1 < min * 1) {
    //            $(this).val(min);
    //        }
    //    }
    //});
}

//Alert重写
function AppAlert(title, msg, callback) {
    $("#modal-msg .appmodal-header span").html(title);
    $("#modal-msg .appmodal-body span").html(msg);
    $("#modal-msg .btn-cancel").hide();
    $("#modal-msg").show();

    $("#modal-msg .btn-confirm").off("click").on("click", function () {
        $("#modal-msg").hide();
        if (callback) {
            callback();
        }
    });
}

//confirm重写
function AppConfirm(title, msg, callback) {
    $("#modal-msg .appmodal-header span").html(title);
    $("#modal-msg .appmodal-body span").html(msg);
    $("#modal-msg .btn-cancel").show();
    $("#modal-msg").show();
    $("#modal-msg .btn-confirm").off("click").on("click", function () {
        $("#modal-msg").hide();
        callback();
    });
}

//判断调用原生接口是否成功
function toast(msg) {
    $(".toast .toast-msg").text(msg);
    $(".toast").show();
    var t = setTimeout(function () {
        $(".toast").hide(1000);
        clearTimeout(t);
    }, 1000);

}

//判断调用原生接口是否成功
function checkSuccess(data, callback, tip) {
    if (data.status == 1) {
        callback(data);
    } else {
        if (tip) {
            toast(tip);
        } else {
            if (data.message!="没有查到数据") {
                toast(data.message);
            }
            
        }
    }
}

//滚动到底部加载更多数据
function initScroll(selector, scrollparam, pageSize, callback) {
    var currIndex = 1,//当前页
        flag = 1;//是否正在加载,0为正在加载,1为加载完毕
    var param = {
        sql: scrollparam.sql, //语句
        pageIndex: 1,//当前分页
        pageSize: pageSize, //每页条数
        type: scrollparam.type
    }
    appJsBridge.callHandler("selectListForPage", param, function (res) {
        checkSuccess(res, function () {
            var html = template('s_' + selector, res);
            $("#" + selector).html(html);

            if (callback) {
                callback(res);
            }

            var pageTotal = Math.ceil(res.totalCount / pageSize);
            $("#" + selector).off("scroll").on("scroll", function () {
                if (flag === 0) {
                    return;
                }
                var h = $(this).height();
                var sh = $(this)[0].scrollHeight;
                var st = $(this)[0].scrollTop;
                if (h + st + 20 >= sh) {
                    if (pageTotal == currIndex) {
                        return;
                    }

                    flag = 0;
                    currIndex += 1;
                    param.pageIndex += 1;
                    $(".icon-pageloading").addClass("show");

                    appJsBridge.callHandler("selectListForPage", param, function (res) {
                        var html = template('s_' + selector, res);
                        $("#" + selector).append(html);
                        if (callback) {
                            callback(res);
                        }
                        $(".icon-pageloading").removeClass("show");
                        flag = 1;
                    });
                }
            });
        });
    });



}
var validator = {
    isMobile: function (selector) {
        var phone = $(selector).val();
        var regMobile = /^1[3|4|5|7|8][0-9]\d{8}$/;
        if (!regMobile.test(phone)) {
            $(selector).nextAll(".errortip.mobile").show();
            return false;
        } else {
            $(selector).nextAll(".errortip.mobile").hide();
            return true;
        }
    },
    isRequired: function (selector) {
        if ($(selector).val().trim() === "") {

            $(selector).nextAll(".tip.required").show();
            return false;
        } else {

            $(selector).nextAll(".tip.required").hide();
            return true;
        }
    }
}

//==== 缓存操作类函数

/**
 * localStorage保存数据
 * @param String key  保存数据的key值
 * @param String value  保存的数据
 */
function setLocVal(key, value) {
    if (typeof value === 'object') {
        value = JSON.stringify(value);
    }
    window.localStorage[key] = value;
}

/**
 * 根据key取localStorage的值
 * @param Stirng key 保存的key值
 */
function getLocVal(key) {
    if (window.localStorage[key]) {
        return window.localStorage[key];
    } else {
        return "";
    }
}

/**
 * 清除缓存
 * @param Striong key  保存数据的key，如果不传清空所有缓存数据
 */
function clearLocVal(key) {
    if (key) {
        var result = window.localStorage[key];
        window.localStorage.removeItem(key);
        return result;
    } else {
        window.localStorage.clear();
    }
}

/**
 * sessionStorage保存数据
 * @param String key  保存数据的key值
 * @param String value  保存的数据
 */
function setSessionVal(key, value) {
    if (typeof value === 'object') {
        value = JSON.stringify(value);
    }

    window.localStorage[key] = value;
}

/**
 * 根据key取sessionStorage的值
 * @param Stirng key 保存的key值
 */
function getSessionVal(key) {
    if (window.localStorage[key]) {
        return window.localStorage[key];
    } else {
        return "";
    }
}

/**
 * 清除缓存
 * @param Striong key  保存数据的key，如果不传清空所有缓存数据
 */
function clearSessionVal(key) {
    if (key) {
        var result = window.localStorage[key];
        window.localStorage.removeItem(key);
        return result !== undefined ? result : "";
    } else {
        window.localStorage.clear();
        return "";
    }
}

//==== 日期处理类函数

/**
 * 根据时间戳获取年、月、日
 * @param String str 时间戳
 * @param Boolean f 是否在原来的基础上*1000，true要*，false或不填就不*
 */
function makeDate(date, f) {
    var d;
    if (typeof date === String) {
        var t = (f) ? parseInt(date) : parseInt(date) * 1000;
        d = new Date(t);
    } else {
        d = date;
    }
    var year = d.getFullYear();
    var month = setNum(d.getMonth() + 1);
    var day = setNum(d.getDate());
    return year + "-" + month + "-" + day;
}

function makeTime(date, hasSecond, f) {
    var d;
    if (typeof date === String) {
        var t = (f) ? parseInt(date) : parseInt(date) * 1000;
        d = new Date(t);
    } else {
        d = date;
    }
    var result = d.getHours() + ':' + d.getMinutes();
    if (hasSecond) {
        result = result + ':' + d.getSeconds();
    }
    return result;
}
/**
 * 对日期进行加减运算，当需要做减法时，days为负数
 */
function addDate(date, days) {
    var d = date;
    if (typeof date !== Date) {
        d = new Date(date);
    }
    d.setDate(d.getDate() + days);
    var month = d.getMonth() + 1;
    var day = d.getDate();
    if (month < 10) {
        month = "0" + month;
    }
    if (day < 10) {
        day = "0" + day;
    }
    var val = new Date(d.getFullYear() + "-" + month + "-" + day);
    return val;
}

function getTime(date) {
    var time = date.split(" ");
    if (time[1][1] == ":") {
        return time[1].substring(0, 4);
    } else {
        return time[1].substring(0, 5);
    }

}

function getdate(date) {
    return date.substring(0, 10);
}

function getovertime(sdate, edate) {
    var startdate = new Date(sdate.replace((/\-/g, "/")));
    var enddate = new Date(edate.replace((/\-/g, "/")));
    var date3 = startdate.getTime() - enddate.getTime();
    var days = Math.floor(date3 / (24 * 3600 * 1000));//相差天数
    var leave1 = date3 % (24 * 3600 * 1000);    //计算天数后剩余的毫秒数
    var hours = Math.floor(leave1 / (3600 * 1000));//相差小时数
    var leave2 = leave1 % (3600 * 1000);        //计算小时数后剩余的毫秒数
    var minutes = Math.floor(leave2 / (60 * 1000));//相差分钟数
}

//根据QueryString参数名称获取值
function getQueryStringByName(name) {
    var result = location.search.match(new RegExp("[?&]" + name + "=([^&]+)", "i"));
    if (result === null || result.length < 1) {
        return "";
    }
    return result[1];
}

/**
 * 数字加千分位符号
 * @param {} 数字 
 * @param {} 是否保留两位小数 
 * @returns {带千分位的数字} 
 */
function formatNumber(number, isFixed) {
    if (!number && isFixed) {
        return "0.00";
    }
    if (!number) {
        return 0;
    }
    if (isFixed)
        number = Number(number).toFixed(2);
    number = number.toString();
    //number = number.replace(/,/g, "");
    var digit = number.indexOf("."); // 取得小数点的位置
    var int = number.substr(0, digit); // 取得小数中的整数部分
    var i;
    var mag = new Array();
    var word;
    if (number.indexOf(".") == -1) { // 整数时
        i = number.length; // 整数的个数
        while (i > 0) {
            word = number.substring(i, i - 3); // 每隔3位截取一组数字
            i -= 3;
            mag.unshift(word); // 分别将截取的数字压入数组
        }
        number = mag;
    } else { // 小数时
        i = int.length; // 除小数外，整数部分的个数
        while (i > 0) {
            word = int.substring(i, i - 3); // 每隔3位截取一组数字
            i -= 3;
            mag.unshift(word);
        }
        number = mag + number.substring(digit);
    }

    return number;
}

//var appJsBridge = {
//    callHandler: function (method, param, callback) {
//        switch (method) {
//            case "loginInfo": //获取登录信息
//                callback(this.loginInfo);
//                break;
//            case "selectList": //查询列表
//                switch (param.type) {
//                    case "shoppingCart":
//                        callback(this.shoppingCart);
//                        break;
//                    case "dinnercarList":
//                        callback(this.dinnercarList);
//                        break;
//                    case "orderListAdd":
//                        callback(this.orderListAdd);
//                        break;
//                    case "prodobj":
//                        callback(this.prodobj);
//                        break;
//                    case "prodStockList":
//                        callback(this.prodStockList);
//                        break;
//                    case "productlist":
//                        callback(this.productlist);
//                        break;
//                    case "productDetail":
//                        callback(this.productDetail);
//                        break;
//                    case "handoverDetail":
//                        callback(this.handoverDetail);
//                        break;
//                    case "inquiryDetail":
//                        callback(this.inquiryDetail);
//                        break;
//                    case "replenishmentDetail":
//                        callback(this.replenishmentDetail);
//                        break;
//                    case "replenishmentList":
//                        callback(this.replenishmentList);
//                        break;
//                    case "getflightInfo":
//                        callback(this.fInfo);
//                        break;
//                    case "getstock":
//                        callback(this.stockinfo);
//                        break;
//                    case "getorder":
//                        callback(this.getorder);
//                        break;
//                    case "getprice":
//                        callback(this.getprice);
//                        break;
//                    case "prolist":
//                        callback(this.prolist);
//                        break;
//                    case "getproduct":
//                        callback(this.getproduct);
//                        break;
//                    case "getHandoverInfo":
//                        callback(this.handoverInfo);
//                        break;
//                    case "prodtotal":
//                        callback(this.prodtotal);
//                        break;
//                    case "prodDeliveryList":
//                        callback(this.prodDeliveryList);
//                        break;
//                    case "getindex":
//                        callback(this.getindex);
//                        break;
//                    case "getPerformance":
//                        callback(this.getPerformance);
//                        break;
//                    default:
//                        var data = {
//                            status: 1,
//                            message: "",
//                            list: [{ DeliveryNo:21431321}]
//                        }
//                        callback(data);
//                        break;
//                }
//                break;
//            case "selectListForPage": //查询分页列表
//                switch (param.type) {
//                    case "productlist":
//                        callback(this.productlist);
//                        break;
//                    case "log":
//                        callback(this.log);
//                        break;
//                    case "orderList":
//                        callback(this.orderList);
//                        break;
//                    case "receivingOrderList":
//                        callback(this.receivingOrderList);
//                        break;
//                    case "receivingOrderDetail":
//                        callback(this.receivingOrderDetail);
//                        break;
//                    case "changeShifts":
//                        callback(this.changeShifts);
//                        break;
//                    case "stockseach":
//                        callback(this.stockseach);
//                        break;
//                    case "handoverSearch":
//                        callback(this.handoverSearch);
//                        break;
//                    case "inquirySearch":
//                        callback(this.inquirySearch);
//                        break;
//                    case "replenishmentSearch":
//                        callback(this.replenishmentSearch);
//                        break;
//                    case "replenishmentList":
//                        callback(this.replenishmentList);
//                        break;
//                    default:
//                        callback(300);
//                        break;
//                }
//                break;
//            default:
//                var rdata = { status: 1, message: "" }
//                callback(rdata);
//                break;
//        }
//    },
//    registerHandler: function (method, param, callback) {
//        return data;
//    },
//    loginInfo: {
//        status: 1,
//        message: "",
//        userInfo: { "LineEng": "KMG-WUH-WNZ", "TailNo": "B2333", "Carrier": "MU", "CreateTime": "2018-03-06 10:11:00", "EmpPhone": "13810583852", "AirCrewAmoubt": 13, "DeptTime": "2018-03-06 10:12:32", "ArrTime": "2018-03-06 16:19:12", "IntOrDom": "I", "FlightDate": "2018-03-09 10:23:00", "EmpType": "乘务长", "FlightProp": "客班", "ActualArrTime": "2018-03-06 13:13:22", "ScheduleID": 1, "ActualDeptTime": "2018-03-06 08:00:00", "FlightID": 1, "ACType": "319", "IsActive": 1, "LineCHN": "上海虹桥-西安咸阳-嘉峪关 ", "LastLoginTime": "2018\b年3月10 14:55:52", "EmpNo": "00001", "FirstClassAmount": 23, "EmpID": 1, "FlightNo": "2494" }
//    },
//    dinnercarList: {
//        status: 1,
//        message: "",
//        list: [
//            { DiningCarNo: "001" }, { DiningCarNo: "002" }, { DiningCarNo: "003" }, { DiningCarNo: "004" }, { DiningCarNo: "005" }
//        ]
//    },
//    handoverInfo: {
//        status: 1,
//        message: "",
//        list: [
//            {
//                PreFlightNo: "KN78211",
//                HandoverNo: "201803152323"
//            }
//        ]
//    },
//    stockinfo: {
//        status: 1,
//        message: "",
//        list: [
//            {
//                InvQty: "99",
//                SalesQty: "5",
//                DamageQty: "0"
//            }
//        ]
//    },
//    getindex: {
//        status: 1,
//        message: "",
//        list: [
//            {
//                FirstClassAmount: "120",
//                EconomyClassAmount: "30",
//                TotalPrice: "1367",
//                TotalNumber: "1078",
//                DeptTime: "2018/01/20"
//            }
//        ]
//    },
//    prodtotal: {
//        status: 1,
//        message: 0,
//        list: [
//        {
//            TotalQty: 300
//        }]
//    },
//    prodobj: {
//        status: 1,
//        message: "",
//        list: [
//            {
//                ProductID: 111,
//                Sku: 321232131,
//                DiningCarNo: 001,
//                Barcode: 21323,
//                ProductName: "真丝丝巾",
//                HandoverCounts: 15,
//                HandoverDamagedCounts: 3,
//                UndertakeCounts: 4,
//                UndertakeDamagedCounts: 4,
//                IsCheck: 0
//            }]
//    },
//    getprice: {
//        status: 1,
//        message: "",
//        list: [
//            {
//                SellTotalPrice: "897512",
//                SoldTotalPrice: "9857",
//            }]
//    },
//    prolist: {
//        status: 1,
//        message: "",
//        list: [{
//            OrderNo: "109687455662",
//            ProductName: "欧美真丝丝巾",
//            Quantity: "2",
//            PaymentPrice: "725",
//            PictureUrl: "../Images/photo-1.png"
//        }, {
//            OrderNo: "109687455662",
//            ProductName: "欧美真丝丝巾",
//            Quantity: "2",
//            PaymentPrice: "725",
//            PictureUrl: "../Images/photo-1.png"
//        }]
//    },
//    getorder: {
//        status: 1,
//        message: "",
//        list: [
//            {
//                FirstName: "小",
//                LastName: "马哥",
//                PictureUrl: "../Images/orderlist-1.png",
//                EmpNo: "03913",
//                OrderStatus: "已完成",
//                CreateTime: "2018/01/20 11:44:09",
//                PayTime: "2018/01/20 11:45:09",
//                PaymentType: "现金",
//                OrderPrice: "310",
//                DiscountPrice: "10",
//                PaymentPrice: "300",
//                ReceiverMobile: "18923486543",
//                Remark: "无",
//                OrderNo: "109685342627",
//                ProductName: "欧美真丝丝巾",
//                Quantity: "2"
//            }]
//    },
//    getproduct: {
//        status: 1,
//        message: "",
//        list: [
//            {
//                ProductName: "意大利原装Ray-ban雷朋太阳镜",
//                RemainderNumber: "200",
//                PhysicalNumber: "0",
//                DiningCarNo: "001",
//                UndertakeCounts: "40",
//            }]
//    },
//    fInfo: {
//        status: 1,
//        message: "",
//        list: [
//            {
//                FlightNo: "KN32897",
//                FlightDate: "",
//                Carrier: "",
//                LineEng: "",
//                LineCHN: "南苑机场-上海虹桥",
//                TailNo: "",
//                ACType: "",
//                DeptTime: "2018-03-15 20:22",
//                ArrTime: "2018-03-15 22:32",
//                ActualDeptTime: "",
//                ActualArrTime: "",
//                IntOrDom: "",
//                FlightProp: "",
//                AirCrewAmount: "",
//                FirstClassAmount: "123",
//                EconomyClassAmount: "193",
//                MileAge: ""
//            }
//        ]
//    },
//    prodStockList: {
//        status: 1,
//        message: "",
//        totalCount: "20",
//        list: [
//            {
//                ProductID: 111,
//                Sku: 321232131,
//                DiningCarNo: 001,
//                Barcode: 21323,
//                ProductName: "真丝丝巾",
//                HandoverCounts: 15,
//                HandoverDamagedCounts: 3,
//                UndertakeCounts: 4,
//                UndertakeDamagedCounts: 4,
//                IsCheck: 0
//            }, {
//                ProductID: 121,
//                Sku: 321232133,
//                DiningCarNo: 002,
//                Barcode: 21323,
//                ProductName: "太阳眼镜",
//                HandoverCounts: 15,
//                HandoverDamagedCounts: 3,
//                UndertakeCounts: 4,
//                UndertakeDamagedCounts: 4,
//                IsCheck: 0
//            }, {
//                ProductID: 113,
//                Sku: 321232431,
//                DiningCarNo: 005,
//                Barcode: 21323,
//                ProductName: "意大利原装Ray-ban雷朋太阳镜",
//                HandoverCounts: 15,
//                HandoverDamagedCounts: 3,
//                UndertakeCounts: 4,
//                UndertakeDamagedCounts: 4,
//                IsCheck: 0
//            }, {
//                ProductID: 191,
//                Sku: 321332131,
//                DiningCarNo: 003,
//                Barcode: 21323,
//                ProductName: "汽水",
//                HandoverCounts: 15,
//                HandoverDamagedCounts: 3,
//                UndertakeCounts: 4,
//                UndertakeDamagedCounts: 4,
//                IsCheck: 0
//            }, {
//                ProductID: 151,
//                Sku: 321334331,
//                DiningCarNo: 003,
//                Barcode: 21323,
//                ProductName: "可乐",
//                HandoverCounts: 15,
//                HandoverDamagedCounts: 3,
//                UndertakeCounts: 4,
//                UndertakeDamagedCounts: 4,
//                IsCheck: 0
//            }, {
//                ProductID: 101,
//                Sku: 324532131,
//                DiningCarNo: 004,
//                Barcode: 21323,
//                ProductName: "啃得起",
//                HandoverCounts: 15,
//                HandoverDamagedCounts: 3,
//                UndertakeCounts: 4,
//                UndertakeDamagedCounts: 4,
//                IsCheck: 0
//            }, {
//                ProductID: 110,
//                Sku: 321892131,
//                DiningCarNo: 001,
//                Barcode: 21323,
//                ProductName: "金拱门",
//                HandoverCounts: 15,
//                HandoverDamagedCounts: 3,
//                UndertakeCounts: 4,
//                UndertakeDamagedCounts: 4,
//                IsCheck: 0
//            }, {
//                ProductID: 167,
//                Sku: 321232091,
//                DiningCarNo: 002,
//                Barcode: 21323,
//                ProductName: "真功夫",
//                HandoverCounts: 15,
//                HandoverDamagedCounts: 3,
//                UndertakeCounts: 4,
//                UndertakeDamagedCounts: 4,
//                IsCheck: 0
//            }

//        ]
//    },
//    orderListAdd:{
//        status: 1,
//        message: "",
//        totalCount: 32,
//        list: [{
//            Sku: "123123",
//            ProductName: "真丝丝巾11",
//            Price: "121",
//            Qty: "10",
//            Pictures: [{
//                PictureType: 2,
//                PictureUrl: "../Images/photo-1.png"
//            }, {
//                PictureType: 1,
//                PictureUrl: "../Images/prd-1.png"
//            }, {
//                PictureType: 2,
//                PictureUrl: "../Images/prd-1.png"
//            }, {
//                PictureType: 2,
//                PictureUrl: "../Images/product-1.png"
//            }]
//        }, {
//            Sku: "123123",
//            ProductName: "真丝丝巾11",
//            Price: "121",
//            Qty: "10",
//            Pictures: [{
//                PictureType: 2,
//                PictureUrl: "../Images/photo-1.png"
//            }, {
//                PictureType: 1,
//                PictureUrl: "../Images/prd-1.png"
//            }, {
//                PictureType: 2,
//                PictureUrl: "../Images/prd-1.png"
//            }, {
//                PictureType: 2,
//                PictureUrl: "../Images/product-1.png"
//            }]
//        }, {
//            Sku: "123123",
//            ProductName: "真丝丝巾11",
//            Price: "121",
//            Qty: "10",
//            Pictures: [{
//                PictureType: 2,
//                PictureUrl: "../Images/photo-1.png"
//            }, {
//                PictureType: 1,
//                PictureUrl: "../Images/prd-1.png"
//            }, {
//                PictureType: 2,
//                PictureUrl: "../Images/prd-1.png"
//            }, {
//                PictureType: 2,
//                PictureUrl: "../Images/product-1.png"
//            }]
//        }, {
//            Sku: "123123",
//            ProductName: "真丝丝巾11",
//            Price: "121",
//            Qty: "10",
//            Pictures: [{
//                PictureType: 2,
//                PictureUrl: "../Images/photo-1.png"
//            }, {
//                PictureType: 1,
//                PictureUrl: "../Images/prd-1.png"
//            }, {
//                PictureType: 2,
//                PictureUrl: "../Images/prd-1.png"
//            }, {
//                PictureType: 2,
//                PictureUrl: "../Images/product-1.png"
//            }]
//        }, {
//            Sku: "123123",
//            ProductName: "真丝丝巾11",
//            Price: "121",
//            Qty: "10",
//            Pictures: [{
//                PictureType: 2,
//                PictureUrl: "../Images/photo-1.png"
//            }, {
//                PictureType: 1,
//                PictureUrl: "../Images/prd-1.png"
//            }, {
//                PictureType: 2,
//                PictureUrl: "../Images/prd-1.png"
//            }, {
//                PictureType: 2,
//                PictureUrl: "../Images/product-1.png"
//            }]
//        }]
//    },
//    productlist: {
//        status: 1,
//        message: "",
//        totalCount: 32,
//        list: [{
//            ProductID: 0,
//            Sku: "123123",
//            ProductName: "真丝丝巾11",
//            Price: "121",
//            Discount: "9.8",
//            Qty: "10",
//            Unit: "件",
//            Pictures: [{
//                PictureType: 2,
//                PictureUrl: "../Images/photo-1.png"
//            }, {
//                PictureType: 1,
//                PictureUrl: "../Images/prd-1.png"
//            }, {
//                PictureType: 2,
//                PictureUrl: "../Images/prd-1.png"
//            }, {
//                PictureType: 2,
//                PictureUrl: "../Images/product-1.png"
//            }]
//        }, {
//            ProductID: 1,
//            Sku: "123123",
//            ProductName: "真丝丝巾1",
//            Price: "121",
//            Discount: "9.8",
//            Qty: "10",
//            Unit: "件",
//            Pictures: [{
//                PictureType: 2,
//                PictureUrl: "../Images/photo-1.png"
//            }, {
//                PictureType: 1,
//                PictureUrl: "../Images/prd-1.png"
//            }, {
//                PictureType: 2,
//                PictureUrl: "../Images/prd-1.png"
//            }, {
//                PictureType: 2,
//                PictureUrl: "../Images/product-1.png"
//            }]
//        }, {
//            ProductID: 2,
//            Sku: "123123",
//            ProductName: "真丝丝巾2",
//            Price: "121",
//            Discount: "9.8",
//            Qty: "10",
//            Unit: "件",
//            Pictures: [{
//                PictureType: 2,
//                PictureUrl: "../Images/photo-1.png"
//            }, {
//                PictureType: 1,
//                PictureUrl: "../Images/prd-1.png"
//            }, {
//                PictureType: 2,
//                PictureUrl: "../Images/prd-1.png"
//            }, {
//                PictureType: 2,
//                PictureUrl: "../Images/product-1.png"
//            }]
//        }]
//    },
//    log: {
//        status: 1,
//        message: "",
//        totalCount: 32,
//        list: [{
//            ID: 1001,
//            EmpNo: "64721",
//            Type: "管理登录",
//            Describe: "无描述无描述无描述无描述无描述无描述无描述无描述无描述无描述",
//            FlightDate: "2018.3.05"
//        }, {
//            ID: 1001,
//            EmpNo: "64721",
//            Type: "管理登录",
//            Describe: "无描述无描述无描述无描述无描述无描述无描述无描述无描述无描述无描述无描述无描述无描述无描述无描述",
//            FlightDate: "2018.3.05"
//        }, {
//            ID: 1001,
//            EmpNo: "64721",
//            Type: "管理登录",
//            Describe: "无描述",
//            FlightDate: "2018.3.05"
//        }, {
//            ID: 1001,
//            EmpNo: "64721",
//            Type: "管理登录",
//            Describe: "无描述",
//            FlightDate: "2018.3.05"
//        }]
//    },
//    orderList: {
//        status: 1,
//        message: "",
//        totalCount: 29,
//        list: [{
//            OrderNo: "109687455662",
//            EmpNo: "03913",
//            PayTime: "2018/01/20",
//            PaymentPrice: "899",
//            FirstName: "小",
//            LastName: "马哥",
//            ReceiverMobile: "18965487663",
//            OrderStatus: "0",
//        }, {
//            OrderNo: "109687455662",
//            EmpNo: "03913",
//            PayTime: "2018/01/20",
//            PaymentPrice: "899",
//            FirstName: "小",
//            LastName: "马哥",
//            ReceiverMobile: "18965487663",
//            OrderStatus: "1",
//        }, {
//            OrderNo: "109687455662",
//            EmpNo: "03913",
//            PayTime: "2018/01/20",
//            PaymentPrice: "899",
//            FirstName: "小",
//            LastName: "马哥",
//            ReceiverMobile: "18965487663",
//            OrderStatus: "0",
//        }, {
//            OrderNo: "109687455662",
//            EmpNo: "03913",
//            PayTime: "2018/01/20",
//            PaymentPrice: "899",
//            FirstName: "小",
//            LastName: "马哥",
//            ReceiverMobile: "18965487663",
//            OrderStatus: "1",
//        }, {
//            OrderNo: "109687455662",
//            EmpNo: "03913",
//            PayTime: "2018/01/20",
//            PaymentPrice: "899",
//            FirstName: "小",
//            LastName: "马哥",
//            ReceiverMobile: "18965487663",
//            OrderStatus: "1",
//        }, {
//            OrderNo: "109687455662",
//            EmpNo: "03913",
//            PayTime: "2018/01/20",
//            PaymentPrice: "899",
//            FirstName: "小",
//            LastName: "马哥",
//            ReceiverMobile: "18965487663",
//            OrderStatus: "1",
//        }, {
//            OrderNo: "109687455662",
//            EmpNo: "03913",
//            PayTime: "2018/01/20",
//            PaymentPrice: "899",
//            FirstName: "小",
//            LastName: "马哥",
//            ReceiverMobile: "18965487663",
//            OrderStatus: "1",
//        }, {
//            OrderNo: "109687455662",
//            EmpNo: "03913",
//            PayTime: "2018/01/20",
//            PaymentPrice: "899",
//            FirstName: "小",
//            LastName: "马哥",
//            ReceiverMobile: "18965487663",
//            OrderStatus: "0",
//        }, {
//            OrderNo: "109687455662",
//            EmpNo: "03913",
//            PayTime: "2018/01/20",
//            PaymentPrice: "899",
//            FirstName: "小",
//            LastName: "马哥",
//            ReceiverMobile: "18965487663",
//            OrderStatus: "0",
//        }, {
//            OrderNo: "109687455662",
//            EmpNo: "03913",
//            PayTime: "2018/01/20",
//            PaymentPrice: "899",
//            FirstName: "小",
//            LastName: "马哥",
//            ReceiverMobile: "18965487663",
//            OrderStatus: "0",
//        }
//        ]
//    },
//    receivingOrderList: {
//        status: 1,
//        message: "",
//        totalCount: 30,
//        list: [{
//            DeliveryNo: "No201873183",
//            TailNo: "A380",
//            ApplicantEmpName: "张三",
//            ApplicantTime: "2018.3.05",
//            DeliveryTime: "2018.3.05",
//            ConfirmCounts: "2130",
//            NeedCounts: "2130",
//            Remark: "无",
//            DeliveryType: 1,
//            LineCHN: "上海虹桥-西安咸阳-嘉峪关",

//        }, {

//            DeliveryNo: "No201873183",
//            TailNo: "A380",
//            ApplicantEmpName: "张三",
//            ApplicantTime: "2018.3.05",
//            DeliveryTime: "2018.3.05",
//            ConfirmCounts: "2130",
//            NeedCounts: "2130",
//            Remark: "无",
//            DeliveryType: 1,
//            LineCHN: "上海虹桥-西安咸阳-嘉峪关",

//        }, {

//            DeliveryNo: "No201873183",
//            TailNo: "A380",
//            ApplicantEmpName: "张三",
//            ApplicantTime: "2018.3.05",
//            DeliveryTime: "2018.3.05",
//            ConfirmCounts: "2130",
//            NeedCounts: "2130",
//            Remark: "无",
//            DeliveryType: 1,
//            LineCHN: "上海虹桥-西安咸阳-嘉峪关",

//        }, {

//            DeliveryNo: "No201873183",
//            TailNo: "A380",
//            ApplicantEmpName: "张三",
//            ApplicantTime: "2018.3.05",
//            DeliveryTime: "2018.3.05",
//            ConfirmCounts: "2130",
//            NeedCounts: "2130",
//            Remark: "无",
//            DeliveryType: 1,
//            LineCHN: "上海虹桥-西安咸阳-嘉峪关",

//        }]
//    },
//    receivingOrderDetail: {
//        status: 1,
//        message: "",
//        totalCount: 30,
//        list: [{
//            PK_DeliveryID: 0,
//            DiningCarNo: "1001",
//            Sku: "69875324",
//            ProductName: "意大利原装Ray-ban雷朋太阳镜",
//            Remainer: "30",
//            Real: "20",
//            DamagedCounts: "10",
//            Remark: "无"
//        }, {
//            PK_DeliveryID: 0,
//            DiningCarNo: "1001",
//            Sku: "69875324",
//            ProductName: "意大利原装Ray-ban雷朋太阳镜",
//            Remainer: "30",
//            Real: "20",
//            DamagedCounts: "10",
//            Remark: "无"
//        }, {
//            PK_DeliveryID: 0,
//            DiningCarNo: "1001",
//            Sku: "69875324",
//            ProductName: "意大利原装Ray-ban雷朋太阳镜",
//            Remainer: "30",
//            Real: "20",
//            DamagedCounts: "10",
//            Remark: "无"
//        }, {
//            PK_DeliveryID: 0,
//            DiningCarNo: "1001",
//            Sku: "69875324",
//            ProductName: "意大利原装Ray-ban雷朋太阳镜",
//            Remainer: "30",
//            Real: "20",
//            DamagedCounts: "10",
//            Remark: "无"
//        }, {
//            PK_DeliveryID: 0,
//            DiningCarNo: "1001",
//            Sku: "69875324",
//            ProductName: "意大利原装Ray-ban雷朋太阳镜",
//            Remainer: "30",
//            Real: "20",
//            DamagedCounts: "10",
//            Remark: "无"
//        }, {
//            PK_DeliveryID: 0,
//            DiningCarNo: "1001",
//            Sku: "69875324",
//            ProductName: "意大利原装Ray-ban雷朋太阳镜",
//            Remainer: "30",
//            Real: "20",
//            DamagedCounts: "10",
//            Remark: "无"
//        }]
//    },
//    productDetail: {
//        status: 1,
//        message: "",
//        list: [{
//            ProductID: 0,
//            Sku: "11111",
//            Price: "200",
//            Discount: "9.8",
//            ProductName: "畅销天然真丝丝巾60*60",
//            Qty: 118,
//            Unit:"件",
//            Attributes: [{
//                AttributeName: "颜色",
//                AttributeValue: "印花",
//            }, {
//                AttributeName: "尺寸",
//                AttributeValue: "L",
//            }],
//            Pictures: [{
//                PictureType: 2,
//                PictureUrl: "../Images/photo-1.png"
//            }, {
//                PictureType: 1,
//                PictureUrl: "../Images/prd-1.png"
//            }, {
//                PictureType: 2,
//                PictureUrl: "../Images/prd-1.png"
//            }, {
//                PictureType: 2,
//                PictureUrl: "../Images/product-1.png"
//            }]

//        }]
//    },
//    changeShifts: {
//        status: 1,
//        message: "",
//        totalCount: 32,
//        list: [{
//            FK_ProductID: 0,
//            Sku: "69876543",
//            ProductName: "意大利原装Ray-ban雷朋太阳镜",
//            Remainer: "30",
//            Real: "20",
//            Breakage: "10"
//        }, {
//            FK_ProductID: 1,
//            ImageUrl: "barcode.png",
//            Sku: "69876543",
//            ProductName: "意大利原装Ray-ban雷朋太阳镜",
//            Remainer: "30",
//            Real: "20",
//            Breakage: "10"
//        }, {
//            FK_ProductID: 2,
//            ImageUrl: "barcode.png",
//            Sku: "69876543",
//            ProductName: "意大利原装Ray-ban雷朋太阳镜",
//            Remainer: "30",
//            Real: "20",
//            Breakage: "10"
//        }, {
//            FK_ProductID: 3,
//            ImageUrl: "barcode.png",
//            Sku: "69876543",
//            ProductName: "意大利原装Ray-ban雷朋太阳镜",
//            Remainer: "30",
//            Real: "20",
//            Breakage: "10"
//        }, {
//            FK_ProductID: 4,
//            ImageUrl: "barcode.png",
//            Sku: "69876543",
//            ProductName: "意大利原装Ray-ban雷朋太阳镜",
//            Remainer: "30",
//            Real: "20",
//            Breakage: "10"
//        }, {
//            FK_ProductID: 5,
//            ImageUrl: "barcode.png",
//            Sku: "69876543",
//            ProductName: "意大利原装Ray-ban雷朋太阳镜",
//            Remainer: "30",
//            Real: "20",
//            Breakage: "10"
//        }

//        ]
//    },
//    stockseach: {
//        status: 1,
//        message: "",
//        totalCount: 32,
//        list: [{
//            DiningCarNo: "001",
//            Sku: "69876543",
//            ProductName: "意大利原装Ray-ban雷朋太阳镜",
//            Qty: "30",
//            SalesQty: "20",
//            DamageQty: "10"
//        }, {
//                DiningCarNo: "001",
//                Sku: "69876543",
//                ProductName: "意大利原装Ray-ban雷朋太阳镜",
//                Qty: "30",
//                SalesQty: "20",
//                DamageQty: "10"
//            }, {
//                DiningCarNo: "001",
//                Sku: "69876543",
//                ProductName: "意大利原装Ray-ban雷朋太阳镜",
//                Qty: "30",
//                SalesQty: "20",
//                DamageQty: "10"
//            }, {
//                DiningCarNo: "001",
//                Sku: "69876543",
//                ProductName: "意大利原装Ray-ban雷朋太阳镜",
//                Qty: "30",
//                SalesQty: "20",
//                DamageQty: "10"
//            }, {
//                DiningCarNo: "001",
//                Sku: "69876543",
//                ProductName: "意大利原装Ray-ban雷朋太阳镜",
//                Qty: "30",
//                SalesQty: "20",
//                DamageQty: "10"
//            }, {
//                DiningCarNo: "001",
//                Sku: "69876543",
//                ProductName: "意大利原装Ray-ban雷朋太阳镜",
//                Qty: "30",
//                SalesQty: "20",
//                DamageQty: "10"
//            }]
//    },
//    handoverSearch: {
//        status: 1,
//        message: "",
//        totalCount: 32,
//        list: [{
//            FlightNo: "KN832221",
//            HandoverNo: "No201873183",
//            HandoverCounts: "2190",
//            FlightDate: "2018.3.7",
//            HandoverEmpName: "张三",
//            UndertakeCounts: "2190",
//            LineCHN: "上海虹桥-南苑北",
//            UndertakeEmpName: "李四",
//            UndertakeTime: "2018.3.7",
//            Remark: "无",
//        }, {
//            FlightNo: "KN832221",
//            HandoverNo: "No201873183",
//            HandoverCounts: "2190",
//            FlightDate: "2018.3.7",
//            HandoverEmpName: "张三",
//            UndertakeCounts: "2190",
//            LineCHN: "上海虹桥-南苑北",
//            UndertakeEmpName: "李四",
//            UndertakeTime: "2018.3.7",
//            Remark: "无",
//        },
//            {
//                FlightNo: "KN832221",
//                HandoverNo: "No201873183",
//                HandoverCounts: "2190",
//                FlightDate: "2018.3.7",
//                HandoverEmpName: "张三",
//                UndertakeCounts: "2190",
//                LineCHN: "上海虹桥-南苑北",
//                UndertakeEmpName: "李四",
//                UndertakeTime: "2018.3.7",
//                Remark: "无",
//            }, {
//                FlightNo: "KN832221",
//                HandoverNo: "No201873183",
//                HandoverCounts: "2190",
//                FlightDate: "2018.3.7",
//                HandoverEmpName: "张三",
//                UndertakeCounts: "2190",
//                LineCHN: "上海虹桥-南苑北",
//                UndertakeEmpName: "李四",
//                UndertakeTime: "2018.3.7",
//                Remark: "无",
//            }, {
//                FlightNo: "KN832221",
//                HandoverNo: "No201873183",
//                HandoverCounts: "2190",
//                FlightDate: "2018.3.7",
//                HandoverEmpName: "张三",
//                UndertakeCounts: "2190",
//                LineCHN: "上海虹桥-南苑北",
//                UndertakeEmpName: "李四",
//                UndertakeTime: "2018.3.7",
//                Remark: "无",
//            }
//        ]
//    },
//    inquirySearch: {
//        status: 1,
//        message: "",
//        totalCount: 30,
//        list: [{
//            FlightNo: "KN832221",
//            DeliveryNo: "No201873183",
//            NeedCounts: "2190",
//            FlightDate: "2018.3.7",
//            ConfirmCounts: "2190",
//            LineCHN: "上海虹桥-南苑北",
//            DeliveryConfirmTime: "2018.3.7",
//            ApplicantEmpName: "张三",
//            DeliveryEmpName: "李四",
//            Remark: "无",
//            DeliveryType: "1"
//        }, {
//            FlightNo: "KN832221",
//            DeliveryNo: "No201873183",
//            NeedCounts: "2190",
//            FlightDate: "2018.3.7",
//            ConfirmCounts: "2190",
//            LineCHN: "上海虹桥-南苑北",
//            ApplicantEmpName: "张三",
//            DeliveryEmpName: "李四",
//            DeliveryConfirmTime: "2018.3.7",
//            Remark: "无",
//            DeliveryType: "2"
//        }, {
//            FlightNo: "KN832221",
//            DeliveryNo: "No201873183",
//            NeedCounts: "2190",
//            FlightDate: "2018.3.7",
//            ConfirmCounts: "2190",
//            LineCHN: "上海虹桥-南苑北",
//            ApplicantEmpName: "张三",
//            DeliveryEmpName: "李四",
//            DeliveryConfirmTime: "2018.3.7",
//            Remark: "无",
//            DeliveryType: "0"
//        }, {
//            FlightNo: "KN832221",
//                DeliveryNo: "No201873183",
//            NeedCounts: "2190",
//            FlightDate: "2018.3.7",
//            ConfirmCounts: "2190",
//            LineCHN: "上海虹桥-南苑北",
//            ApplicantEmpName: "张三",
//            DeliveryEmpName: "李四",
//            DeliveryConfirmTime: "2018.3.7",
//            Remark: "无",
//            DeliveryType: "1"
//        }, {
//            FlightNo: "KN832221",
//            DeliveryNo: "No201873183",
//            NeedCounts: "2190",
//            FlightDate: "2018.3.7",
//            ConfirmCounts: "2190",
//            LineCHN: "上海虹桥-南苑北",
//            ApplicantEmpName: "张三",
//            DeliveryEmpName: "李四",
//            DeliveryConfirmTime: "2018.3.7",
//            Remark: "无",
//            DeliveryType: "2"
//        }
//        ]
//    },
//    replenishmentSearch: {
//        status: 1,
//        message: "",
//        totalCount: 20,
//        list: [{
//            DeliveryStatus:0,
//            FlightNo: "KN832221",
//            DeliveryNo: "No201873183",
//            ApplicantTime: "2190",
//            FlightDate: "2018.3.7",
//            ApplicantEmpName: "张三",
//            DeliveryConfirmTime: "2190",
//            LineCHN: "上海虹桥-南苑北",
//            DeliveryEmpName: "李四",
//            Remark: "无",
//            NeedCounts: "2310",
//        }, {
//            DeliveryStatus: 1,
//            FlightNo: "KN832221",
//            HandoverNo: "No201873183",
//            ApplicantTime: "2190",
//            FlightDate: "2018.3.7",
//            DeliveryConfirmTime: "2190",
//            LineCHN: "上海虹桥-南苑北",
//            DeliveryEmpName: "李四",
//            Remark: "无"
//            }, {
//            DeliveryStatus: 2,
//            FlightNo: "KN832221",
//            HandoverNo: "No201873183",
//            ApplicantTime: "2190",
//            FlightDate: "2018.3.7",
//            DeliveryConfirmTime: "2190",
//            LineCHN: "上海虹桥-南苑北",
//            DeliveryEmpName: "李四",
//            Remark: "无"
//            }, {
//            DeliveryStatus: 3,
//            FlightNo: "KN832221",
//            HandoverNo: "No201873183",
//            ApplicantTime: "2190",
//            FlightDate: "2018.3.7",
//            DeliveryConfirmTime: "2190",
//            LineCHN: "上海虹桥-南苑北",
//            DeliveryEmpName: "李四",
//            Remark: "无"
//            }, {
//            DeliveryStatus: 1,
//            FlightNo: "KN832221",
//            HandoverNo: "No201873183",
//            ApplicantTime: "2190",
//            FlightDate: "2018.3.7",
//            DeliveryConfirmTime: "2190",
//            LineCHN: "上海虹桥-南苑北",
//            DeliveryEmpName: "李四",
//            Remark: "无"
//        }
//        ]
//    },
//    shoppingCart: {
//        status: 1,
//        message: "",
//        list: [{
//            ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//            Price: 123,
//            Quantity: 1,
//            Sku: 0
//        }, {
//            ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//            Price: 123.11,
//            Quantity: 2,
//            Sku: 1
//        }, {
//            ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//            Price: 123.55,
//            Quantity: 3,
//            Sku: 2
//        }, {
//            ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//            Price: 123.66,
//            Quantity: 4,
//            Sku: 3
//        }, {
//            ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//            Price: 123.66,
//            Quantity: 4,
//            Sku: 4
//        }, {
//            ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//            Price: 123.66,
//            Quantity: 4,
//            Sku: 5
//        }, {
//            ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//            Price: 99.12,
//            Quantity: 2,
//            Sku: 5
//        }]
//    },
//    inquiryDetail: {
//        status: 1,
//        message: "",
//        totalCount: 30,
//        list: [{
//            Sku: "69785423",
//            ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//            NeedCounts: 20,
//            ConfirmCounts: 20,
//            Remark: "无"
//        },
//            {
//                Sku: "69785423",
//                ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//                NeedCounts: 20,
//                ConfirmCounts: 20,
//                Remark: "无"
//            }, {
//                Sku: "69785423",
//                ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//                NeedCounts: 20,
//                ConfirmCounts: 20,
//                Remark: "无"
//            }, {
//                Sku: "69785423",
//                ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//                NeedCounts: 20,
//                ConfirmCounts: 20,
//                Remark: "无"
//            }, {
//                Sku: "69785423",
//                ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//                NeedCounts: 20,
//                ConfirmCounts: 20,
//                Remark: "无"
//            }, {
//                Sku: "69785423",
//                ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//                NeedCounts: 20,
//                ConfirmCounts: 20,
//                Remark: "无"
//            }]
//    },
//    replenishmentDetail: {
//        status: 1,
//        message: "",
//        totalCount: 30,
//        list: [{
//            Sku: "69785423",
//            ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//            NeedCounts: 20,
//            ConfirmCounts: 20,
//        }, {
//            Sku: "69785423",
//            ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//            NeedCounts: 20,
//            ConfirmCounts: 20,
//        }, {
//            Sku: "69785423",
//            ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//            NeedCounts: 20,
//            ConfirmCounts: 20,
//        }, {
//            Sku: "69785423",
//            ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//            NeedCounts: 20,
//            ConfirmCounts: 20,
//        },
//            {
//                Sku: "69785423",
//                ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//                NeedCounts: 20,
//                ConfirmCounts: 20,
//            },
//            {
//                Sku: "69785423",
//                ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//                NeedCounts: 20,
//                ConfirmCounts: 20,
//            }, {
//                Sku: "69785423",
//                ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//                NeedCounts: 20,
//                ConfirmCounts: 20,
//            }, {
//                Sku: "69785423",
//                ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//                NeedCounts: 20,
//                ConfirmCounts: 20,
//            }
//        ]
//    },
//    replenishmentList:{
//        status: 1,
//        message: "",
//        totalCount: 30,
//        list: [{
//            Sku: "69785423",
//            ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//            NeedCounts: 20,
//            ConfirmCounts: 20,
//        }, {
//            Sku: "69785423",
//            ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//            NeedCounts: 20,
//            ConfirmCounts: 20,
//        }, {
//            Sku: "69785423",
//            ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//            NeedCounts: 20,
//            ConfirmCounts: 20,
//        }, {
//            Sku: "69785423",
//            ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//            NeedCounts: 20,
//            ConfirmCounts: 20,
//        },
//            {
//                Sku: "69785423",
//                ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//                NeedCounts: 20,
//                ConfirmCounts: 20,
//            },
//            {
//                Sku: "69785423",
//                ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//                NeedCounts: 20,
//                ConfirmCounts: 20,
//            }, {
//                Sku: "69785423",
//                ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//                NeedCounts: 20,
//                ConfirmCounts: 20,
//            }, {
//                Sku: "69785423",
//                ProductName: "150030 意大利原装Ray-ban 雷朋太阳镜",
//                NeedCounts: 20,
//                ConfirmCounts: 20,
//            }
//        ]
//    },
//    handoverDetail: {
//        status: 1,
//        message: "",
//        totalCount: 30,
//        list: [{
//            PreFlightNo: "KN833",
//            Sku: "69876543",
//            ProductName: "意大利原装Ray-ban雷朋太阳镜",
//            HandoverCounts: "200",
//            HandoverDamagedCounts: "20",
//            UndertakeCounts: "20",
//            UndertakeDamagedCounts: "0"
//        }, {
//                PreFlightNo: "KN833",
//                Barcode: "69876543",
//                ProductName: "意大利原装Ray-ban雷朋太阳镜",
//                HandoverCounts: "20",
//                HandoverDamagedCounts: "0",
//            }, {
//                PreFlightNo: "KN833",
//                Barcode: "69876543",
//                ProductName: "意大利原装Ray-ban雷朋太阳镜",
//                HandoverCounts: "20",
//                HandoverDamagedCounts: "0",
//            }, {
//                PreFlightNo: "KN833",
//                Barcode: "69876543",
//                ProductName: "意大利原装Ray-ban雷朋太阳镜",
//                HandoverCounts: "20",
//                HandoverDamagedCounts: "0",
//            }, {
//                PreFlightNo: "KN833",
//                Barcode: "69876543",
//                ProductName: "意大利原装Ray-ban雷朋太阳镜",
//                HandoverCounts: "20",
//                HandoverDamagedCounts: "0",
//            }, {
//                PreFlightNo: "KN833",
//                Barcode: "69876543",
//                ProductName: "意大利原装Ray-ban雷朋太阳镜",
//                HandoverCounts: "20",
//                HandoverDamagedCounts: "0",
//            }]
//    },
//    prodDeliveryList: {
//        status: 1,
//        message: "",
//        list: [
//            {
//                DeliveryNo: "32123121",
//                DeliveryStatus:1,
//                DiningCarNo: "001",
//                ProductID: "231",
//                Sku: "31231",
//                ProductName: "太阳眼镜",
//                NeedCounts: "31",
//                ConfirmCounts: "29",
//                DamagedCounts: "2",
//                DamagedReason: "XXX",
//                Remark: "XXXXXXXX",
//                IsCheck:0

//            }, {
//                DeliveryStatus: 1,
//                DeliveryNo: "32133121",
//                DiningCarNo: "001",
//                ProductID: "231",
//                Sku: "31231",
//                ProductName: "太阳眼镜",
//                NeedCounts: "31",
//                ConfirmCounts: "29",
//                DamagedCounts: "2",
//                DamagedReason: "XXX",
//                Remark: "XXXXXXXX",
//                IsCheck: 0

//            }, {
//                DeliveryNo: "32135121",
//                DiningCarNo: "002",
//                ProductID: "231",
//                Sku: "31231",
//                ProductName: "太阳眼镜",
//                NeedCounts: "31",
//                ConfirmCounts: "29",
//                DamagedCounts: "2",
//                DamagedReason: "XXX",
//                Remark: "XXXXXXXX",
//                IsCheck: 0

//            }, {
//                DeliveryNo: "32131621",
//                DiningCarNo: "003",
//                ProductID: "231",
//                Sku: "31231",
//                ProductName: "太阳眼镜",
//                NeedCounts: "31",
//                ConfirmCounts: "29",
//                DamagedCounts: "2",
//                DamagedReason: "XXX",
//                Remark: "XXXXXXXX",
//                IsCheck: 0

//            }, {
//                DeliveryNo: "32138121",
//                DiningCarNo: "005",
//                ProductID: "231",
//                Sku: "31231",
//                ProductName: "太阳眼镜",
//                NeedCounts: "31",
//                ConfirmCounts: "29",
//                DamagedCounts: "2",
//                DamagedReason: "XXX",
//                Remark: "XXXXXXXX",
//                IsCheck: 0

//            }, {
//                DeliveryNo: "32131921",
//                DiningCarNo: "003",
//                ProductID: "231",
//                Sku: "31231",
//                ProductName: "太阳眼镜",
//                NeedCounts: "31",
//                ConfirmCounts: "29",
//                DamagedCounts: "2",
//                DamagedReason: "XXX",
//                Remark: "XXXXXXXX",
//                IsCheck: 0

//            }, {
//                DeliveryNo: "321312001",
//                DiningCarNo: "003",
//                ProductID: "231",
//                Sku: "31231",
//                ProductName: "太阳眼镜",
//                NeedCounts: "31",
//                ConfirmCounts: "29",
//                DamagedCounts: "2",
//                DamagedReason: "XXX",
//                Remark: "XXXXXXXX",
//                IsCheck: 0

//            }, {
//                DeliveryNo: "321313321",
//                DiningCarNo: "004",
//                ProductID: "231",
//                Sku: "31231",
//                ProductName: "太阳眼镜",
//                NeedCounts: "31",
//                ConfirmCounts: "29",
//                DamagedCounts: "2",
//                DamagedReason: "XXX",
//                Remark: "XXXXXXXX",
//                IsCheck: 0

//            }, {
//                DeliveryNo: "321312221",
//                DiningCarNo: "002",
//                ProductID: "231",
//                Sku: "31231",
//                ProductName: "太阳眼镜",
//                NeedCounts: "31",
//                ConfirmCounts: "29",
//                DamagedCounts: "2",
//                DamagedReason: "XXX",
//                Remark: "XXXXXXXX",
//                IsCheck: 0

//            }
//        ]
//    },
//    getPerformance: {
//        status: 1,
//        message: "",
//        list: [
//            {
//                TargetPerformance:2000,
//                SalesCommission: 0.1,
//                T1: 1,
//                T2: 2,
//                T3: 3,
//                T4: 40000,
//                T5: 1000000,
//                T6: 10000006,
//                T7: 10000007,
//                T8: 10000008,
//                T9: 10000009,
//                T10: 100000010,

//            }
//        ]
//    }
//}
