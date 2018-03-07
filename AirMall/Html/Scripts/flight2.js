$(function() {
  var tableinfo_huanban = tableInfo_huanban();
  initTableData('#huanban-table', tableinfo_huanban, 8);
  $(".confirm-modal").click(function() {
    $(".shouhuo-modal").css("display", "flex");
  });

  $(".btn-barcode").click(function() {
    $(".codebar-modal").css("display", "flex");
  })

  $(".modal-close").click(function() {
    $(".msg-info-modal").hide();
  });
});

function tableInfo_huanban() {
  var columnItem = function() {
    return [
      {
        field: 'no',
        title: '餐车号'
      }, {
        field: 'name',
        title: '商品中文名'
      }, {
        field: 'unit',
        title: '单位'
      }, {
        field: 'num',
        title: '结余数'
      }, {
        field: 'sell',
        title: '实际数'
      }, {
        field: 'destroy',
        title: '破损'
      }, {
        field: 'k1',
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
        k1: "asd"
      })
    }
    return dataArr;
  }

  return {columnItem: columnItem(), getTableData: getTableData()}
}
