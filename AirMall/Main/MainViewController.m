//
//  MainViewController.m
//  AirMall
//
//  Created by 李胜喜 on 2018/2/27.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController (){
    
    AppDelegate* _appDelegate;
    
    NSInteger _synCount;
    
    NSInteger _networkingStatus;
    NSInteger _signal;
    
    NSArray* _signalTextArr;
    
    dispatch_source_t _timer;
    
    NSMutableArray* _imageArr;
    
    BOOL _dataDwonOver;
    BOOL _picDownOver;
}

@property WebViewJavascriptBridge *bridge;

@property MBProgressHUD *hud;

@property KLCPopupLayout layout;
@property KLCPopup* popup;

@property NSMutableArray *tableViewArr;

@property UIView* topLayerView;

@property UIView* leftLayerView;

@property BOOL hasNotTrans;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifi:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    _synCount = 0;
    
    _dataDwonOver = false;
    _picDownOver = false;
    
    _userDict = [NSKeyedUnarchiver unarchiveObjectWithData:[_userInfo objectForKey:_UserKey]];
    _thisFlightNoLabel.text = [NSString stringWithFormat:@"%@%@",[_userDict objectForKey:@"Carrier"],[_userDict objectForKey:@"FlightNo"]];
    id preFilghtNo = [_userDict objectForKey:@"PreFlightNo"];
    if(preFilghtNo != nil){
        _preFlightNoLabel.text = [NSString stringWithFormat:@"%@%@",[_userDict objectForKey:@"Carrier"],[_userDict objectForKey:@"PreFlightNo"]];
    }
    _lineCHNLabel.text = [_userDict objectForKey:@"LineCHN"];
    NSDate* deptTime = [CommonUtil convertDateTimeFromString:[NSString stringWithFormat:@"%@ %@:00",[_userDict objectForKey:@"FlightDate"],[_userDict objectForKey:@"DeptTime"]]];
    NSDate* arrTime = [CommonUtil convertDateTimeFromString:[NSString stringWithFormat:@"%@ %@:00",[_userDict objectForKey:@"FlightDate"],[_userDict objectForKey:@"ArrTime"]]];
    _flightTimeLabel.text = [NSString stringWithFormat:@"%@  -  %@",[CommonUtil convertDateToString:deptTime formatter:@"hh:mm"],[CommonUtil convertDateToString:arrTime formatter:@"hh:mm"]];
    NSArray* timeDiffArr = [CommonUtil timeDiff:deptTime end:arrTime];
    _flightDurationLabel.text = [NSString stringWithFormat:@"%@小时%@分",[timeDiffArr valueForKey:@"hour"],[timeDiffArr valueForKey:@"minute"]];
    id empName = [_userDict objectForKey:@"EmpName"];
    if([empName isEqual:[NSNull null]]){
        _empNameLabel.text = [_userDict objectForKey:@"EmpNo"];
    }else{
        _empNameLabel.text = empName;
    }
    _empNoLabel.text = [_userDict objectForKey:@"EmpNo"];
    _empJobLabel.text = [_userDict objectForKey:@"EmpType"];
    _lastLoginTimeLabel.text = [_userDict objectForKey:@"LastLoginTime"];
    
    id avatarBase64 = [_userDict objectForKey:@"Avatar"];
    if(![avatarBase64 isEqual:[NSNull null]]){
        UIImage* avatarImage = [CommonUtil dataURL2Image:avatarBase64];
        [_empPhotoImageView setImage:avatarImage];
        //  把头像设置成圆形
        _empPhotoImageView.layer.cornerRadius=_empPhotoImageView.frame.size.width/2;//裁成圆角
        _empPhotoImageView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
        //  给头像加一个圆形边框
        //        _empPhotoImageView.layer.borderWidth = 1.5f;//宽度
        //        _empPhotoImageView.layer.borderColor = [UIColor whiteColor].CGColor;//颜色
    }
//    if(avatarBase64 != [NSNull null] && [avatarBase64 length] > 0){
//
//    }
    
    _tableViewArr = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:@"icon-menu",@"LOGO",@"", nil],[NSMutableArray arrayWithObjects:@"icon-hangban-select",@"航班信息",@"Index", nil],[NSMutableArray arrayWithObjects:@"icon-huanban",@"换班交接",@"AssociateManage", nil],[NSMutableArray arrayWithObjects:@"icon-goods",@"商品列表",@"ProductList", nil],[NSMutableArray arrayWithObjects:@"icon-cart",@"订单列表",@"OrderList", nil],[NSMutableArray arrayWithObjects:@"icon-store",@"库存管理",@"Query", nil],[NSMutableArray arrayWithObjects:@"icon-log",@"日志查询",@"Log", nil],[NSMutableArray arrayWithObjects:@"icon-logout",@"账号退出",@"", nil], nil];
//      ,[NSMutableArray arrayWithObjects:@"icon-log",@"DEMO",@"", nil]
    
    _hasNotTrans = [self hasNotTransfer];
    
    _shrinkTableView.dataSource = self;
    _shrinkTableView.delegate = self;
    _shrinkTableView.scrollEnabled = NO;
    
    _openTableView.dataSource = self;
    _openTableView.delegate = self;
    _shrinkTableView.scrollEnabled = NO;
    
    
    // Show in popup
    _layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutLeft,KLCPopupVerticalLayoutTop);
    
    _popup = [KLCPopup popupWithContentView:_openView showType:KLCPopupShowTypeSlideInFromLeft dismissType:KLCPopupDismissTypeSlideOutToLeft maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    // Do any additional setup after loading the view from its nib.
    
    _shrinkView.layer.shadowColor = [UIColor colorWithHexString:@"22304d"].CGColor;;//shadowColor阴影颜色
    _shrinkView.layer.shadowOffset = CGSizeMake(3,3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _shrinkView.layer.shadowOpacity = 0.1;//阴影透明度，默认0
    _shrinkView.layer.shadowRadius = 2;//阴影半径，默认3
    
    _webView.scrollView.bounces = false;
    
//    [self loadHtmlUrl:@"index.html"];
    [self loadHtmlPage:@"Index"];
    
    [self initLayer];
    [self brigeInit];
}

- (void)brigeInit{
    
    if (_bridge) { return; }
    
    //    WKWebView* webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:self.view.bounds];
    _webView.navigationDelegate = self;
    //    [self.view addSubview:webView];
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge setWebViewDelegate:self];
    
    //启动拍照
    [_bridge registerHandler:@"scan" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *result) {
            _appDelegate.openCamera = NO;
            [_bridge callHandler:@"getScanResult" data:@{ @"info":result } responseCallback:^(id response) {
                NSLog(@"result responded: %@", response); //传入data 参数，并且拿到js的回调，自行处理自己的逻辑
            }];
            NSLog(@"%@",result);
        }];
        
        [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
        
        _appDelegate.openCamera = YES;
//        [self presentViewController:scanner animated:YES completion:nil];
        [self showDetailViewController:scanner sender:nil];
        //        responseCallback(json);
    }];
    
    //上传
    [_bridge registerHandler:@"upload" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self selectPhoto];
        //        responseCallback(json);
    }];
    
    //显示菜单
    [_bridge registerHandler:@"showMenu" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString* index = [data objectForKey:@"index"];
        [self updateTableViewIcon:[index integerValue]];
    }];
    
    //显示遮罩
    [_bridge registerHandler:@"showCover" handler:^(id data, WVJBResponseCallback responseCallback) {
        [_topLayerView setHidden:NO];
        [_leftLayerView setHidden:NO];
    }];
    
    //隐藏遮罩
    [_bridge registerHandler:@"hideCover" handler:^(id data, WVJBResponseCallback responseCallback) {
        [_topLayerView setHidden:YES];
        [_leftLayerView setHidden:YES];
    }];
    
    //登录信息
    [_bridge registerHandler:@"loginInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        LoginInfoResult* result = [LoginInfoResult new];
        result.status = 1;
        result.message = @"查询成功";
        result.userInfo = _userDict;
        NSString* json = [result yy_modelToJSONString];
        NSLog(@"%@",json);
        responseCallback(json);
        [self createLog:@"loginInfo" data:data result:json];
    }];
    
    //获取单条或多条数据查询结果
    [_bridge registerHandler:@"selectList" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString* sql = [data objectForKey:@"sql"];
        NSString* json = [CommonDB selectList:sql];
        responseCallback(json);
        [self createLog:@"selectList" data:data result:json];
    }];
    
    //获取列表的查询结果
    [_bridge registerHandler:@"selectListForPage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString* sql = [data objectForKey:@"sql"];
        NSInteger pageIndex = [[data objectForKey:@"pageIndex"] integerValue];
        NSInteger pageSize = [[data objectForKey:@"pageSize"] integerValue];
        NSString* json = [CommonDB selectListForPage:sql pageIndex:pageIndex pageSize:pageSize];
        responseCallback(json);
        [self createLog:@"loginInfo" data:data result:json];
    }];
    
    //确认收货
    [_bridge registerHandler:@"receive" handler:^(id data, WVJBResponseCallback responseCallback) {
        ReceiptParam* receiptParam = [ReceiptParam yy_modelWithJSON:data];
        NSString* json = [ReceiptDB receive:receiptParam userDict:_userDict];
        responseCallback(json);
        [self createLog:@"selectListForPage" data:data result:json];
    }];
    
    //补货申请
    [_bridge registerHandler:@"replenish" handler:^(id data, WVJBResponseCallback responseCallback) {
        ReplenishParam* replenishParam = [ReplenishParam yy_modelWithJSON:data];
        NSString* json = [ReceiptDB replenish:replenishParam userDict:_userDict];
        responseCallback(json);
        [self createLog:@"loginInfo" data:data result:json];
    }];
    
    //盘点生成交接单
    [_bridge registerHandler:@"inventory" handler:^(id data, WVJBResponseCallback responseCallback) {
        InventoryParam* inventoryParam = [InventoryParam yy_modelWithJSON:data];
        NSString* json = [ReceiptDB inventory:inventoryParam userDict:_userDict];
        _hasNotTrans = [self hasNotTransfer];
        responseCallback(json);
        [self createLog:@"inventory" data:data result:json];
    }];
    
    //交接确认
    [_bridge registerHandler:@"transfer" handler:^(id data, WVJBResponseCallback responseCallback) {
        TransferParam* transferParam = [TransferParam yy_modelWithJSON:data];
        NSString* json = [ReceiptDB transfer:transferParam userDict:_userDict];
        _hasNotTrans = [self hasNotTransfer];
        responseCallback(json);
        [self createLog:@"transfer" data:data result:json];
    }];
    
    //加入购物车
    [_bridge registerHandler:@"addCart" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString* sku = [data valueForKey:@"sku"];
        NSInteger quantity = [[data valueForKey:@"quantity"] integerValue];
        NSString* diningCarNo = [data valueForKey:@"diningCarNo"];
        NSString* json = [OrderDB addCart:sku diningCarNo:diningCarNo num:quantity];
        responseCallback(json);
        [self createLog:@"addCart" data:data result:json];
    }];
    
    //修改购物车商品数量
    [_bridge registerHandler:@"updateNum" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString* sku = [data valueForKey:@"sku"];
        NSString* diningCarNo = [data valueForKey:@"diningCarNo"];
        NSInteger updateType = [[data valueForKey:@"updateType"] integerValue];
        NSString* json = [OrderDB updateNum:sku diningCarNo:diningCarNo updateType:updateType];
        responseCallback(json);
        [self createLog:@"updateNum" data:data result:json];
    }];
    
    //删除购物车商品
    [_bridge registerHandler:@"deleteCartSku" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString* sku = [data valueForKey:@"sku"];
        NSString* diningCarNo = [data valueForKey:@"diningCarNo"];
        NSString* json = [OrderDB deleteCartSku:sku diningCarNo:diningCarNo];
        responseCallback(json);
        [self createLog:@"deleteCartSku" data:data result:json];
    }];
    
    //清空购物车商品
    [_bridge registerHandler:@"clearCart" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString* json = [OrderDB clearCart];
        responseCallback(json);
        [self createLog:@"clearCart" data:data result:json];
    }];
    
    //创建订单
    [_bridge registerHandler:@"createOrder" handler:^(id data, WVJBResponseCallback responseCallback) {
        CreateOrderParam* createOrderParam = [CreateOrderParam yy_modelWithJSON:data];
        NSString* json = [OrderDB createOrder:createOrderParam userDict:_userDict];
        responseCallback(json);
        [self createLog:@"createOrder" data:data result:json];
    }];
    
    //    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
    //        NSLog(@"testObjcCallback called: %@", data);
    //        responseCallback(@"Response from testObjcCallback");
    //    }];
    
    //    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    
    //    [self renderButtons:_webView];
    //    [self loadHtmlPage:@"Pages/Index"];
}

- (void) createLog:(NSString*) method data:(id) data result:(NSString*)result{
    
    LogList* log = [LogList new];
    log.EmpNo = [_userDict valueForKey:@"EmpNo"];
    log.FlightNo = [_userDict valueForKey:@"FlightNo"];
    log.FlightDate = [_userDict valueForKey:@"FlightDate"];
    log.Category = @"操作信息";
    log.DeviceNo = [_userDict valueForKey:@"DeviceNo"];
    log.Type = @"操作信息";
    NSString* param = [data yy_modelToJSONString];
    log.Describe = [NSString stringWithFormat:@"method:%@ \n param:%@ \n result:%@",method,[param stringByReplacingOccurrencesOfString:@"\n" withString:@" "],result];
    [LogDB createLog:log];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    [IQKeyboardManager sharedManager].enable = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tableViewArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == _shrinkTableView){
        
        static NSString *ShrinkMenuCellIdentifier = @"ShrinkMenuTableViewCell";
        ShrinkMenuTableViewCell *shrinkMenuCell = (ShrinkMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ShrinkMenuCellIdentifier];
        if (shrinkMenuCell == nil){
            shrinkMenuCell= [[[NSBundle mainBundle]loadNibNamed:ShrinkMenuCellIdentifier owner:nil options:nil] firstObject];
        }
        NSInteger row = [indexPath row];
        NSArray *arr = [_tableViewArr objectAtIndex:row];
        UIImage *image = [UIImage imageNamed:[arr objectAtIndex:0]];
        [shrinkMenuCell.iconImageView setImage:image];
        if(row == 0){
            shrinkMenuCell.iconImageView.frame = CGRectMake(10,9,30,30);
        }
        shrinkMenuCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return shrinkMenuCell;
    }else if(tableView == _openTableView){
        
        static NSString *OpenMenuCellIdentifier = @"OpenMenuTableViewCell";
        OpenMenuTableViewCell *openMenuCell = (OpenMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:OpenMenuCellIdentifier];
        if (openMenuCell == nil){
            openMenuCell= [[[NSBundle mainBundle]loadNibNamed:OpenMenuCellIdentifier owner:nil options:nil] firstObject];
        }
        NSInteger row = [indexPath row];
        if(row == 0){
            UIImage *image = [UIImage imageNamed:@"icon-close"];
            openMenuCell.iconImageView.frame = CGRectMake(10,9,30,30);
            [openMenuCell.iconImageView setImage:image];
            image = [UIImage imageNamed:@"menu-logo"];
            [openMenuCell.logoImageView setImage:image];
            [openMenuCell.logoImageView setHidden:NO];
            [openMenuCell.nameLabel setHidden:YES];
        }else{
            NSArray *arr = [_tableViewArr objectAtIndex:row];
            UIImage *image = [UIImage imageNamed:[arr objectAtIndex:0]];
            [openMenuCell.imageView setImage:image];
            openMenuCell.nameLabel.text = [arr objectAtIndex:1];
        }
        openMenuCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return openMenuCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
//    if(row == 7){
//        [_userInfo setValue:@"" forKey:_UserKey];
//        LoginViewController *loginView= [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    if(tableView == _shrinkTableView){
        if(row == 0){
            [_popup showWithLayout:_layout];
//            [_shrinkView setHidden:YES];
        }else if(row < 7){
            if(row > 2 && _hasNotTrans){
                 [CommonUtil showOnlyText:self.view tips:@"还有未完成的交接单"];
            }else{
                NSArray *arr = [_tableViewArr objectAtIndex:row];
//                [self loadHtmlUrl:[arr objectAtIndex:2]];
                 [self loadHtmlPage:[arr objectAtIndex:2]];
                [self updateTableViewIcon: row];
            }
        }else if(row == 7){
             [self logout];
        }else{
            [self loadHtmlPage:@"Index"];
        }
    }else if(tableView == _openTableView){
        if(row == 0){

        }else if(row < 7){
            NSArray *arr = [_tableViewArr objectAtIndex:row];
//            [self loadHtmlUrl:[arr objectAtIndex:2]];
              [self loadHtmlPage:[arr objectAtIndex:2]];
            [self updateTableViewIcon: row];
        }else if(row == 7){
            [self logout];
        }else{
            [self loadHtmlPage:@"Index"];
        }
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.20 * NSEC_PER_SEC));
//
//        __weak typeof(self) weakSelf = self;
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            [weakSelf.shrinkView setHidden:NO];
//        });
        [_popup dismiss:YES];
    }
}

-(BOOL) hasNotTransfer{
    BOOL result = [ReceiptDB hasNotTrans: [_userDict objectForKey:@"PreFlightNo"] flightDate: [_userDict objectForKey:@"FlightDate"] tailNo: [_userDict objectForKey:@"TailNo"] acType: [_userDict objectForKey:@"ACType"]];
    return result;
}

-(void) logout{

     SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    //Using Block
    [alert addButton:@"确定" actionBlock:^(void) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    alert.showAnimationType= SCLAlertViewShowAnimationSlideInToCenter;
    [alert showNotice:self title:@"提示" subTitle:@"确定要退出登录吗？" closeButtonTitle:@"取消" duration:0.0f];
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要退出吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.navigationController popViewControllerAnimated:YES];
////        NSLog(@"OK Action");
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
////        NSLog(@"Cancel Action");
//    }];
//
//    [alertController addAction:okAction];           // A
//    [alertController addAction:cancelAction];
//
//    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)updateTableViewIcon:(NSInteger) row{
    
    for(NSInteger i=0;i<[_tableViewArr count];i++){
        NSMutableArray* arr = [_tableViewArr objectAtIndex:i];
        NSString* iconString = [arr objectAtIndex:0];
        iconString = [iconString stringByReplacingOccurrencesOfString:@"-select" withString:@""];
        if(i == row){
            iconString = [iconString stringByAppendingString:@"-select"];
        }
        [arr replaceObjectAtIndex:0 withObject:iconString];
    }
    [_shrinkTableView reloadData];
    [_openTableView reloadData];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonUtil showLoading:@"正在加载" andHud:_hud];
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [_hud hideAnimated:YES];
    NSLog(@"webViewDidFinishLoad");
}

- (void)callHandler:(id)sender {
    
    id data = @{ @"liveId": @"10000" };
    [_bridge callHandler:@"live" data:data responseCallback:^(id response) {
        NSLog(@"live responded: %@", response);
    }];
    
    //    id data = @{ @"greetingFromObjC": @"Hi there, JS!" };
    //    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
    //        NSLog(@"testJavascriptHandler responded: %@", response);
    //    }];
}

- (void)loadHtmlPage:(NSString*)path {
    
//    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
//    htmlPath = [[NSBundle bundleWithPath:htmlPath] pathForResource:@"index" ofType:@"html" inDirectory:@"Pages"];
//    htmlPath = [htmlPath stringByAppendingPathComponent:@"Pages"];
//    htmlPath = [htmlPath stringByAppendingPathComponent:path];
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Html/Pages/%@",path] ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [_webView loadHTMLString:appHtml baseURL:baseURL];
    
//    NSURL *pathUrl = [[NSURL alloc] initWithString:htmlPath];
//    NSURLRequest *request = [NSURLRequest requestWithURL:pathUrl];
//    [_webView loadRequest:request];
}

- (void)loadHtmlUrl:(NSString*)page {

    NSString* url = [NSString stringWithFormat:@"%s%@",_BaseUrl,page];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)initLayer{
    _topLayerView = [UIView new];
    _topLayerView.frame = CGRectMake(0,0,_ScreenWidth,70);
    [_topLayerView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6]];
    [_topLayerView setHidden:YES];
    [self.view addSubview:_topLayerView];
    
    
    _leftLayerView = [UIView new];
    _leftLayerView.frame = CGRectMake(0,70,50,_ScreenHeight);
    [_leftLayerView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6]];
    [_leftLayerView setHidden:YES];
    [self.view addSubview:_leftLayerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBackPressed:(id)sender {
    if([_webView canGoBack]){
        [_webView goBack];
        NSString * realUrl = _webView.URL.absoluteString;
        NSLog(@"realUrl:%@",realUrl);
        for(int i = 0;i<[_tableViewArr count];i++){
            NSArray* arr = [_tableViewArr objectAtIndex:i];
            id url = [arr objectAtIndex:2];
            if([realUrl containsString:url]){
                [self updateTableViewIcon:i];
                break;
            }
        }
    }
}

- (void)selectPhoto {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择图片来源" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         [self shootPiicturePrVideo];
    }];
    [alertController addAction:photoAction];
    
    UIAlertAction *selectPhotoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self selectExistingPictureOrVideo];
    }];
    [alertController addAction:selectPhotoAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//从相机上选择
- (void)shootPiicturePrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}
//从相册中选择
- (void)selectExistingPictureOrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    _lastChosenMediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([_lastChosenMediaType isEqual:(NSString *) kUTTypeImage])
    {
        UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        chosenImage = [CommonUtil imageCompressForSize:chosenImage targetSize:CGSizeMake(_ScreenWidth, _ScreenHeight)];
        
        NSString *imageBase64 = [CommonUtil image2DataURL:chosenImage];
        
        [_bridge callHandler:@"getUploadResult" data:@{ @"info":imageBase64 } responseCallback:^(id response) {
            NSLog(@"result responded: %@", response); //传入data 参数，并且拿到js的回调，自行处理自己的逻辑
        }];
    }
    if([self.lastChosenMediaType isEqual:(NSString *) kUTTypeMovie]){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"系统只支持图片格式" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] &&[mediatypes count]>0){
        NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.mediaTypes=mediatypes;
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=sourceType;
        NSString *requiredmediatype=(NSString *)kUTTypeImage;
        NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
        [picker setMediaTypes:arrmediatypes];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (BOOL)shouldAutorotate{
    
    return NO;
}

- (IBAction)synButtomPressed:(id)sender{
    
    [_synButtom setEnabled:NO];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonUtil showLoading:@"数据同步中" andHud:_hud];
    
    _synCount = 0;
    
    [ReceiptDB createReportFile];
    [self uploadData];
    
    [self downData:@"data"];
    [self downData:@"picture"];
}


- (IBAction)frashButtomPressed:(id)sender {
    [_popup dismiss:YES];
    [_webView reload];
}

- (void)analysisData:(NSString*)fileType{
    
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *zipPath = [NSString stringWithFormat:@"%@/%@.zip",tmpDir,fileType];
    NSString *unzipPath = [NSString stringWithFormat:@"%@/%@/",tmpDir,fileType];
    [SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath];
    
    //文件操作对象
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if([fileType isEqualToString:@"data"]){
        //目录迭代器
        NSDirectoryEnumerator *direnum = [manager enumeratorAtPath:unzipPath];
        //遍历目录迭代器，获取各个文件路径
        NSString *fileName;
        while (fileName = [direnum nextObject]) {
            NSString* json = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@%@",unzipPath,fileName] encoding:NSUTF8StringEncoding error:nil];
            json = [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            json = [json stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            json = [json stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            
            if([fileName isEqualToString:@"Employee.json"]){
                
                [Staff bg_clear:@"Staff"];
                NSArray* staffArr =  [NSArray yy_modelArrayWithClass:[Staff class] json:json];
                for(Staff* staff in staffArr){
                    [staff bg_save];
                }
                
            }else if([fileName isEqualToString:@"FlightInfo.json"]){
                
                [FlightInfo bg_clear:@"FlightInfo"];
                NSArray* flightArr =  [NSArray yy_modelArrayWithClass:[FlightInfo class] json:json];
                for(FlightInfo* flight in flightArr){
                    [flight bg_save];
                }
                
            }else if([fileName isEqualToString:@"ProductList.json"]){
                
                [ProductList bg_clear:@"ProductList"];
                [ProductItem bg_clear:@"ProductItem"];
                [ProductAttribute bg_clear:@"ProductAttribute"];
                [ProductPicture bg_clear:@"ProductPicture"];
                NSArray* productArr =  [NSArray yy_modelArrayWithClass:[ProductList class] json:json];
                for(ProductList* product in productArr){
                    [product bg_save];
                    for(id item in product.Items){
                        ProductItem* productItem =  [ProductItem yy_modelWithDictionary:item];
                        [productItem bg_save];
                        for(id attribute in productItem.Attributes){
                            ProductAttribute* productAttribute = [ProductAttribute yy_modelWithDictionary:attribute];
                            productAttribute.ProductItemID = productItem.ProductItemID;
                            [productAttribute bg_save];
                        }
                    }
                    for(id picture in product.Pictures){
                        ProductPicture* productPicture = [ProductPicture yy_modelWithDictionary:picture];
                        [productPicture bg_save];
                        [_imageArr addObject:productPicture.PictureUrl];
                    }
                }
                
            }else if([fileName isEqualToString:@"ReceiptList.json"]){
                
                NSArray* receiptArr =  [NSArray yy_modelArrayWithClass:[ReceiptList class] json:json];
                for(ReceiptList* receipt in receiptArr){
                    NSString* where = [NSString stringWithFormat:@"where DeliveryNo = '%@'",receipt.DeliveryNo];
                    NSArray * arr = [ReceiptList bg_find:@"ReceiptList" where:where];
                    if([arr count] == 0){
                        [receipt bg_save];
                        for(id item in receipt.Items){
                            ReceiptItem* receiptItem = [ReceiptItem yy_modelWithDictionary:item];
                            [receiptItem bg_save];
                        }
                    }else{
                        ReceiptList* rec = [arr objectAtIndex:0];
                        if(rec.DeliveryStatus == 0 && rec.DeliveryType == 1){
                            [ReceiptList bg_delete:@"ReceiptList" where:where];
                            [ReceiptItem bg_delete:@"ReceiptItem" where:where];
                            [receipt bg_save];
                            for(id item in receipt.Items){
                                ReceiptItem* receiptItem = [ReceiptItem yy_modelWithDictionary:item];
                                [receiptItem bg_save];
                            }
                        }
                    }
                }

            }else if([fileName isEqualToString:@"HandoverMaster.json"]){
                NSArray* handoverArr =  [NSArray yy_modelArrayWithClass:[HandoverMaster class] json:json];
                for(HandoverMaster* handover in handoverArr){
                    NSString* where = [NSString stringWithFormat:@"where HandoverNo = '%@'",handover.HandoverNo];
                    NSArray * arr = [ReceiptList bg_find:@"HandoverMaster" where:where];
                    if([arr count] == 0){
                        [handover bg_save];
                        for(id item in handover.Items){
                            HandoverItem* handoverItem = [HandoverItem yy_modelWithDictionary:item];
                            [handoverItem bg_save];
                        }
                    }
                }
            }else if([fileName isEqualToString:@"ScheduleInfo.json"]){
            
                [ScheduleInfo bg_clear:@"ScheduleInfo"];
                NSArray* scheduleArr =  [NSArray yy_modelArrayWithClass:[ScheduleInfo class] json:json];
                for(ScheduleInfo* schedule in scheduleArr){
                    [schedule bg_save];
                }
            }
            _synCount++;
//            if(_synCount == 6){
//
//            }
        }
        [manager removeItemAtPath:unzipPath error:nil];
        _dataDwonOver = true;
        
    }else if([fileType isEqualToString:@"picture"]){
        
        for(NSString* imageStr in _imageArr){
            NSString* imagePath = [unzipPath stringByAppendingString:imageStr];
            //            NSString* imagePath = [unzipPath stringByAppendingString:[imageStr stringByReplacingOccurrencesOfString:@"jpg" withString:@"jpeg"]];
            UIImage *image=[[UIImage alloc]initWithContentsOfFile:imagePath];
            NSString *imageBase64 = [CommonUtil image2DataURL:image];
            NSString* update = [NSString stringWithFormat:@"set PictureUrl = '%@' where PictureUrl='%@'",imageBase64,imageStr];
            [ProductPicture bg_update:@"ProductPicture" where:update];
        }
        [manager removeItemAtPath:unzipPath error:nil];
        _picDownOver = true;
    }
    [manager removeItemAtPath:zipPath error:nil];
     if(_dataDwonOver){
        [_synButtom setEnabled:YES];
        [self synSucc:@"数据同步成功"];
    }
}

- (void)downData:(NSString*)fileType{
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setObject:_identifierNumber forKey:@"DeviceNo"];
    [dict setObject:fileType forKey:@"FileType"];
    
    [NetworkUtil post:@"api/ipad/downloadquery" params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary* response = [NetworkUtil responseConfiguration:responseObject];
        bool isSucc = [[response objectForKey:@"IsSuccess"] boolValue];
        if(isSucc){
            NSMutableDictionary* param = [NSMutableDictionary new];
            id data = [response objectForKey:@"Data"];
            [param setObject:_identifierNumber forKey:@"DeviceNo"];
            NSString* fileBatchNo = [[data valueForKey:@"FileBatchNo"] objectAtIndex:0];
            [param setObject:fileBatchNo forKey:@"FileBatchNo"];
            
            NSString* fileType = [[data valueForKey:@"FileType"] objectAtIndex:0];
            [param setObject:fileType forKey:@"FileType"];
            
            NSString* fileFullPath = [[data valueForKey:@"FileFullPath"] objectAtIndex:0];
            [param setObject:fileFullPath forKey:@"FileFullPath"];
            
            [NetworkUtil post:@"api/ipad/download" params:param success:^(NSURLSessionDataTask *task, id response) {
                
                NSString *tmpDir = NSTemporaryDirectory();
                NSString *path = [NSString stringWithFormat:@"%@/%@.zip",tmpDir,fileType];
                
                NSError *error = nil;
                BOOL written = [response writeToFile:path options:0 error:&error];
                
                if (written){
                    [param removeObjectForKey:@"FileFullPath"];
                    [param removeObjectForKey:@"Signature"];
                    [NetworkUtil post:@"api/ipad/downloadnotify" params:param success:^(NSURLSessionDataTask *task, id response) {
                        response = [NetworkUtil responseConfiguration:responseObject];
                        NSLog(@"%@ notify:%@",fileType,[response yy_modelToJSONString]);
                    } fail:^(NSURLSessionDataTask *task, NSError *error) {
                        NSLog(@"error");
                        [self synFail:@"通知下载文件失败"];
                    }];
                    [self analysisData:fileType];
                }
                NSLog(@"success");
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"error");
                [self synFail:@"下载文件失败"];
            }];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error");
        [self synFail:@"调用接口失败"];
    }];
}


- (void)uploadData{
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setObject:_identifierNumber forKey:@"DeviceNo"];
    
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *uploadPath = [tmpDir stringByAppendingPathComponent:@"upload"];
    NSString *uploadZipPath = [NSString stringWithFormat:@"%@/upload.zip",tmpDir];
    
    //文件操作对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:uploadZipPath]){
        
        NSData *zipData = [NSData dataWithContentsOfFile:uploadZipPath];
        
        [NetworkUtil upload:@"api/ipad/upload" params:nil fileData:zipData name:@"upload" fileName:@"upload.zip" mimeType:@"application/zip" progress:^(NSProgress *progress) {
            
            NSLog(@"上传进度：%f",1.0 * progress.completedUnitCount / progress.totalUnitCount);
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary* response = [NetworkUtil responseConfiguration:responseObject];
            bool isSucc = [[response objectForKey:@"IsSuccess"] boolValue];
            if(isSucc){
                [fileManager removeItemAtPath:uploadPath error:nil];
                [fileManager removeItemAtPath:uploadZipPath error:nil];
            }
            NSLog(@"success");
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            //            [self process:arr type:1];
            NSLog(@"error:%@",error);
            [self synFail:@"上报文件失败"];
        }];
    } else {
        
    }
}

-(void)synSucc:(NSString*) tip{
    
    [_synButtom setEnabled:YES];
    [_hud hideAnimated:YES];
    [CommonUtil showOnlyText:self.view tips:tip];
}

-(void) synFail:(NSString*) tip{
    
    [_hud hideAnimated:YES];
    [_synButtom setEnabled:YES];
    [CommonUtil showOnlyText:self.view tips:tip];
}

-(void) noSignal{
    [_synButtom setEnabled:NO];
}

- (void)notifi:(NSNotification *)notifi{
    NSDictionary *dic = notifi.userInfo;
    //获取网络状态
    NSInteger status = [[dic objectForKey:@"AFNetworkingReachabilityNotificationStatusItem"] integerValue];
    _networkingStatus = status;
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            [self noSignal];
            [self resumeTimer];
            NSLog(@"无法获取网络状态");
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            [self pauseTimer];
            [self setWWANSignal];
            NSLog(@"移动蜂窝网络");
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            [self pauseTimer];
            [self getSignalStrength];
            NSLog(@"Wifi上网");
            break;
        case AFNetworkReachabilityStatusNotReachable:
            [self noSignal];
            [self resumeTimer];
            NSLog(@"无网络连接");
            break;
        default:
            break;
    }
}

- (void)setWWANSignal{
    [_synButtom setEnabled:YES];
}

- (void)getSignalStrength{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSString *dataNetworkItemView = nil;
    int signalStrength = 3;
    if(subviews != nil){
        for (id subview in subviews) {
            if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
                dataNetworkItemView = subview;
                break;
            }
        }
        signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
    }
    _signal = signalStrength;
    [_synButtom setEnabled:YES];
//    if(_signal < 2){
//        [CommonUtil showOnlyText:self.view tips:@"当前WIFI信号差，请切换到4G网络"];
//    }else{
//        [_synButtom setEnabled:YES];
//    }
    NSLog(@"signal %d", signalStrength);
    if(_signal > 0){
        [self pauseTimer];
    }
}

-(void) startGCDTimer{
//    NSTimeInterval period = 2.0; //设置时间间隔
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
//    __weak typeof(self) weakSelf = self;
//    dispatch_source_set_event_handler(_timer, ^{
//        //在这里执行事件
//        [weakSelf getSignalStrength];
//        NSLog(@"每2秒执行test");
//    });
//
//    dispatch_resume(_timer);
}


-(void) pauseTimer{
    if(_timer){
        dispatch_suspend(_timer);
    }
}

-(void) resumeTimer{
    if(_timer){
        dispatch_resume(_timer);
    }else{
        [self startGCDTimer];
    }
}

-(void) stopTimer{
    if(_timer){
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //    [IQKeyboardManager sharedManager].enable = YES;
    //注销监听者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingReachabilityDidChangeNotification object:nil];
//    [self stopTimer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //在其他离开改页面的方法同样加上下面代码
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end
