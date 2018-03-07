$(function() {
  var tableinfo_shouhuo_list = tableInfo_shouhuo_list();
  var tableinfo_shouhuo_detail = tableInfo_shouhuo_detail();

  initTableData('#shouhuo-list-table', tableinfo_shouhuo_list);
  initTableData('#shouhuo-detail-table', tableinfo_shouhuo_detail);

  $(".confirm-modal").click(function() {
    $(".shouhuo-modal").css("display", "flex");
  });

  $(".btn-barcode").click(function() {
    $(".codebar-modal").css("display", "flex");
  })

});

function tableInfo_shouhuo_list() {
  var columnItem = function() {
    return [
      {
        field: 'no',
        title: '收货单号'
      }, {
        field: 'code',
        title: '机号'
      }, {
        field: 'name',
        title: '类型'
      }, {
        field: 'unit',
        title: '站点'
      }, {
        field: 'num',
        title: '线路'
      }, {
        field: 'sell',
        title: '应收总数'
      }, {
        field: 'destroy',
        title: '实收总数'
      }, {
        field: 'k1',
        title: '申请人'
      }, {
        field: 'k2',
        title: '申请时间'
      }, {
        field: 'k3',
        title: '配送时间'
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
        name: "意大利原装Ray-ban雷朋 太阳眼镜",
        unit: "个",
        num: "20",
        sell: "0",
        destroy: "1",
        k1: 'asdasd',
        k2: 'asdasd',
        k3: 'asdasd',
        k4: 'asdasd'
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
        title: '应收数量'
      }, {
        field: 'sell',
        title: '实收数量'
      }, {
        field: 'destroy',
        title: '破损数'
      }, {
        field: 'k1',
        title: '状态'
      }, {
        field: 'operate',
        title: '操作',
        formatter: function(a, b, c) {
          return '<input type="checkbox">';
        }
      }, {
        field: 'k2',
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
        destroy: "1",
        k1: "asd",
        k2: "zxc"
      })
    }
    return dataArr;
  }

  return {columnItem: columnItem(), getTableData: getTableData()}
}
