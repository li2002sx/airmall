$(function() {
  var tableinfo_cukun = tableInfo_cukun();
  var tableinfo_jiaojiedan_list = tableInfo_jiaojiedan_list();
  var tableinfo_jiaojiedan_detail = tableInfo_jiaojiedan_detail();
  var tableinfo_shouhuo_list = tableInfo_shouhuo_list();
  var tableinfo_shouhuo_detail = tableInfo_shouhuo_detail();
  var tableinfo_buhuo_list = tableInfo_buhuo_list();
  var tableinfo_buhuo_detail = tableInfo_buhuo_detail();
  var tableinfo_pandian = tableInfo_pandian();

  initTableData('#stock-check-table', tableinfo_cukun,8);

  initTableData('#jiaojiedan-list-table', tableinfo_jiaojiedan_list);
  initTableData('#jiaojiedan-detail-table', tableinfo_jiaojiedan_detail);

  initTableData('#shouhuo-list-table', tableinfo_shouhuo_list);
  initTableData('#shouhuo-detail-table', tableinfo_shouhuo_detail);

  initTableData('#buhuo-list-table', tableinfo_buhuo_list);
  initTableData('#buhuo-detail-table', tableinfo_buhuo_detail);

  initTableData('#pandian-table', tableinfo_pandian);

  $(".btn-list-edit").click(function() {
    //$("#ModalAdd").modal("show");
    var index = $(this).parents("tr").data("index");

    var rowData = $('#autoPregressionTest-table').bootstrapTable('getData')[index]
    console.log(rowData)
  });

  $(".tab-list-wrapper li").click(function() {
    var selector = $(this).data("target");
    $(this).addClass('checked').siblings().removeClass('checked');
    $("." + selector).show().siblings().hide();
  });

  $(".btn-pandian").click(function(){
    $(".page-pandian").css("display","flex");
  });

  $(".btn-return").click(function(){
    $(".page-pandian").hide();
  });

  $(".confirm-modal").click(function(){
    $(".shouhuo-modal").css("display","flex");
  })
});

function tableInfo_cukun() {
  var columnItem = function() {
    return [
      {
        field: 'no',
        title: '餐车号'
      }, {
        field: 'code',
        title: '商品条码'
      }, {
        field: 'name',
        title: '商品中文名'
      }, {
        field: 'unit',
        title: '单位'
      }, {
        field: 'num',
        title: '库存'
      }, {
        field: 'sell',
        title: '已售'
      }, {
        field: 'destroy',
        title: '破损'
      }, {
        field: 'operate',
        title: '操作',
        formatter: function(a, b, c) {
          return '<input type="checkbox">';
        }
      }
    ]
  }

  var getTableData = function() {
    var dataArr = [];
    for (var i = 0; i < 10; i++) {
      dataArr.push({
        no: 1001 + i,
        code: "6987471742",
        name: "意大利原装Ray-ban雷朋 太阳眼镜",
        unit: "个",
        num: "20",
        sell: "0",
        destroy: "1"
      })
    }
    return dataArr;
  }

  return {columnItem: columnItem(), getTableData: getTableData()}
}

function tableInfo_jiaojiedan_list() {
  var columnItem = function() {
    return [
      {
        field: 'no',
        title: '交接单号'
      }, {
        field: 'code',
        title: '航班号'
      }, {
        field: 'name',
        title: '航班日期'
      }, {
        field: 'unit',
        title: '站点'
      }, {
        field: 'num',
        title: '线路'
      }, {
        field: 'sell',
        title: '交接总数'
      }, {
        field: 'destroy',
        title: '承接总数'
      }, {
        field: 'k1',
        title: '交接人'
      }, {
        field: 'k2',
        title: '承接人'
      }, {
        field: 'k3',
        title: '承接事件'
      }, {
        field: 'k4',
        title: '备注'
      }
    ]
  }

  var getTableData = function() {
    var dataArr = [];
    for (var i = 0; i < 10; i++) {
      dataArr.push({
        no: 1001 + i,
        code: "6987471742",
        name: "2011/01/01-2011/02/02",
        unit: "个",
        num: "20",
        sell: "0",
        destroy: "1",
        k1:'as',
        k2:'as',
        k3:'as',
        k4:'as'
      })
    }
    return dataArr;
  }

  return {columnItem: columnItem(), getTableData: getTableData()}
}
function tableInfo_jiaojiedan_detail() {
  var columnItem = function() {
    return [
      {
        field: 'no',
        title: '交接单号'
      }, {
        field: 'code',
        title: '前序航班号'
      }, {
        field: 'name',
        title: '商品条码'
      }, {
        field: 'unit',
        title: '商品中文名'
      }, {
        field: 'num',
        title: '单位'
      }, {
        field: 'sell',
        title: '结余数'
      }, {
        field: 'destroy',
        title: '交接数'
      }, {
        field: 'operate',
        title: '货损数'
      }
    ]
  }

  var getTableData = function() {
    var dataArr = [];
    for (var i = 0; i < 10; i++) {
      dataArr.push({
        no: 1001 + i,
        code: "6987471742",
        name: "意大利原装Ray-ban雷朋 太阳眼镜",
        unit: "个",
        num: "20",
        sell: "0",
        destroy: "1"
      })
    }
    return dataArr;
  }

  return {columnItem: columnItem(), getTableData: getTableData()}
}

function tableInfo_shouhuo_list() {
  var columnItem = function() {
    return [
      {
        field: 'no',
        title: '收货单号'
      }, {
        field: 'code',
        title: '航班号'
      }, {
        field: 'name',
        title: '航班日期'
      }, {
        field: 'unit',
        title: '单据类型'
      }, {
        field: 'num',
        title: '站点'
      }, {
        field: 'sell',
        title: '线路'
      }, {
        field: 'destroy',
        title: '应收总数'
      }, {
        field: 'operate',
        title: '实收总数'
      }, {
        field: 'k1',
        title: '创建人'
      }, {
        field: 'k2',
        title: '收货人'
      }, {
        field: 'k3',
        title: '收货确认时间'
      }
    ]
  }

  var getTableData = function() {
    var dataArr = [];
    for (var i = 0; i < 10; i++) {
      dataArr.push({
        no: 1001 + i,
        code: "6987471742",
        name: "意大利原装Ray-ban雷朋 太阳眼镜",
        unit: "个",
        num: "20",
        sell: "0",
        destroy: "1",
        k1:"1asd",
        k2:"1asd",
        k3:"1asd",
      })
    }
    return dataArr;
  }

  return {columnItem: columnItem(), getTableData: getTableData()}
}
function tableInfo_shouhuo_detail() {
  var columnItem = function() {
    return [
      {
        field: 'no',
        title: '收货单号'
      }, {
        field: 'code',
        title: '商品条码'
      }, {
        field: 'name',
        title: '商品中文名'
      }, {
        field: 'unit',
        title: '单位'
      }, {
        field: 'num',
        title: '应收数'
      }, {
        field: 'sell',
        title: '实收数'
      }, {
        field: 'others',
        title: '备注'
      }
    ]
  }

  var getTableData = function() {
    var dataArr = [];
    for (var i = 0; i < 10; i++) {
      dataArr.push({
        no: 1001 + i,
        code: "6987471742",
        name: "意大利原装Ray-ban雷朋 太阳眼镜",
        unit: "个",
        num: "20",
        sell: "0",
        others: "无"
      })
    }
    return dataArr;
  }

  return {columnItem: columnItem(), getTableData: getTableData()}
}

function tableInfo_buhuo_list() {
  var columnItem = function() {
    return [
      {
        field: 'no',
        title: '补货单号'
      }, {
        field: 'code',
        title: '状态'
      }, {
        field: 'name',
        title: '站点'
      }, {
        field: 'unit',
        title: '线路'
      }, {
        field: 'num',
        title: '申请总数'
      }, {
        field: 'sell',
        title: '补货申请人'
      }, {
        field: 'destroy',
        title: '申请时间'
      }, {
        field: 'k1',
        title: '收货人'
      }, {
        field: 'k2',
        title: '收货时间'
      }
    ]
  }

  var getTableData = function() {
    var dataArr = [];
    for (var i = 0; i < 10; i++) {
      dataArr.push({
        no: 1001 + i,
        code: "6987471742",
        name: "意大利原装Ray-ban雷朋 太阳眼镜",
        unit: "个",
        num: "20",
        sell: "0",
        destroy: "1",
        k1:"asd",
        k2:"asdxc"
      })
    }
    return dataArr;
  }

  return {columnItem: columnItem(), getTableData: getTableData()}
}
function tableInfo_buhuo_detail() {
  var columnItem = function() {
    return [
      {
        field: 'no',
        title: '商品条码'
      }, {
        field: 'code',
        title: '商品中文名'
      },{
        field: 'unit',
        title: '单位'
      }, {
        field: 'num',
        title: '需补货数'
      }, {
        field: 'sell',
        title: '收货数'
      }
    ]
  }

  var getTableData = function() {
    var dataArr = [];
    for (var i = 0; i < 10; i++) {
      dataArr.push({
        no: 1001 + i,
        code: "6987471742",
        unit: "个",
        num: "20",
        sell: "0"
      })
    }
    return dataArr;
  }

  return {columnItem: columnItem(), getTableData: getTableData()}
}

function tableInfo_pandian() {
  var columnItem = function() {
    return [
      {
        field: 'no',
        title: '商品条码'
      },{
        field: 'name',
        title: '商品中文名'
      }, {
        field: 'unit',
        title: '单位'
      }, {
        field: 'num',
        title: '库存'
      }, {
        field: 'sell',
        title: '已售'
      }, {
        field: 'destroy',
        title: '破损'
      }, {
        field: 'k1',
        title: '盘点库存'
      }, {
        field: 'k2',
        title: '状态'
      }, {
        field: 'operate',
        title: '操作',
        formatter: function(a, b, c) {
          return '<input type="checkbox">';
        }
      }
    ]
  }

  var getTableData = function() {
    var dataArr = [];
    for (var i = 0; i < 10; i++) {
      dataArr.push({
        no: 1001 + i,
        name: "意大利原装Ray-ban雷朋 太阳眼镜",
        unit: "个",
        num: "20",
        sell: "0",
        destroy: "1",
        k1:"asd",
        k2:"xzcxc"
      })
    }
    return dataArr;
  }

  return {columnItem: columnItem(), getTableData: getTableData()}
}
