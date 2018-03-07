$(function() {
  var tableinfo_log = tableInfo_log();
  initTableData('#log-table', tableinfo_log,8);


  $(".tab-list-wrapper li").click(function() {
    var selector = $(this).data("target");
    $(this).addClass('checked').siblings().removeClass('checked');
    $("." + selector).show().siblings().hide();
  })
});

function tableInfo_log() {
  var columnItem = function() {
    return [
      {
        field: 'no',
        title: '编号'
      }, {
        field: 'code',
        title: '用户ID'
      }, {
        field: 'name',
        title: '类型'
      }, {
        field: 'unit',
        title: '描述'
      }, {
        field: 'num',
        title: '状态'
      }, {
        field: 'sell',
        title: '时间'
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
      })
    }
    return dataArr;
  }

  return {columnItem: columnItem(), getTableData: getTableData()}
}
