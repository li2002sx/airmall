//
//  MainViewController.m
//  AirMall
//
//  Created by 李胜喜 on 2018/2/27.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property WebViewJavascriptBridge *bridge;

@property MBProgressHUD *hud;

@property KLCPopupLayout layout;
@property KLCPopup* popup;

@property NSDictionary *tableViewDict;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    id userInfo = [_userInfo objectForKey:user_key];
    _thisFlightNoLabel.text = [NSString stringWithFormat:@"%@%@",[userInfo objectForKey:@"Carrier"],[userInfo objectForKey:@"FlightNo"]];
    _lineCHNLabel.text = [userInfo objectForKey:@"LineCHN"];
    NSDate* deptTime = [CommonUtil convertDateFromString:[userInfo objectForKey:@"DeptTime"]];
    NSDate* arrTime = [CommonUtil convertDateFromString:[userInfo objectForKey:@"ArrTime"]];
    _flightTimeLabel.text = [NSString stringWithFormat:@"%@  -  %@",[CommonUtil convertDateToString:deptTime formatter:@"hh:mm"],[CommonUtil convertDateToString:arrTime formatter:@"hh:mm"]];
    NSArray* timeDiffArr = [CommonUtil timeDiff:deptTime end:arrTime];
    _flightDurationLabel.text = [NSString stringWithFormat:@"%@小时%@分",[timeDiffArr valueForKey:@"hour"],[timeDiffArr valueForKey:@"minute"]];
    _empNameLabel.text = [userInfo objectForKey:@"EmpNo"];
    _empNoLabel.text = [userInfo objectForKey:@"EmpNo"];
    _empJobLabel.text = [userInfo objectForKey:@"EmpType"];
    _lastLoginTimeLabel.text = [userInfo objectForKey:@"LastLoginTime"];
    
    _tableViewDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                      @[@"icon-menu",@"LOGO"],@"0",
                      @[@"icon-hangban-select",@"航班信息"],@"1",
                      @[@"icon-huanban",@"换班交接"],@"2",
                      @[@"icon-goods",@"商品列表"],@"3",
                      @[@"icon-cart",@"订单列表"],@"4",
                      @[@"icon-store",@"库存管理"],@"5",
                      @[@"icon-log",@"日志查询"],@"6",
                      @[@"icon-logout",@"账号退出"],@"7",
                      nil];
    
    _shrinkTableView.dataSource = self;
    _shrinkTableView.delegate = self;
    
    _openTableView.dataSource = self;
    _openTableView.delegate = self;
    
    // Show in popup
    _layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutLeft,KLCPopupVerticalLayoutTop);
    
    _popup = [KLCPopup popupWithContentView:_openView showType:KLCPopupShowTypeSlideInFromLeft dismissType:KLCPopupDismissTypeBounceOutToLeft maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    // Do any additional setup after loading the view from its nib.
    
    _shrinkView.layer.shadowColor = [UIColor colorWithHexString:@"22304d"].CGColor;;//shadowColor阴影颜色
    _shrinkView.layer.shadowOffset = CGSizeMake(3,3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _shrinkView.layer.shadowOpacity = 0.1;//阴影透明度，默认0
    _shrinkView.layer.shadowRadius = 2;//阴影半径，默认3
}

- (void)viewWillAppear:(BOOL)animated {
    if (_bridge) { return; }
    
//    WKWebView* webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:self.view.bounds];
    _webView.navigationDelegate = self;
//    [self.view addSubview:webView];
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge setWebViewDelegate:self];
    
    //获取单条的查询结果
    [_bridge registerHandler:@"selectOne" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString* sql = [data objectForKey:@"sql"];
        NSString* json = [CommonDB selectOne:sql];
        responseCallback(json);
    }];
    
    //获取列表的查询结果
    [_bridge registerHandler:@"selectList" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString* sql = [data objectForKey:@"sql"];
        NSInteger pageIndex = [[data objectForKey:@"pageIndex"] integerValue];
        NSInteger pageSize = [[data objectForKey:@"pageSize"] integerValue];
        NSString* json = [CommonDB selectList:sql pageIndex:pageIndex pageSize:pageSize];
        responseCallback(json);
    }];
    
    //确认收货
    [_bridge registerHandler:@"receive" handler:^(id data, WVJBResponseCallback responseCallback) {
        ReceiptParam* receiptParam = [ReceiptParam yy_modelWithJSON:data];
        NSString* json = [ReceiptDB receive:receiptParam userDict:_userDict];
        responseCallback(json);
    }];
    
    //补货申请
    [_bridge registerHandler:@"replenish" handler:^(id data, WVJBResponseCallback responseCallback) {
        ReplenishParam* replenishParam = [ReplenishParam yy_modelWithJSON:data];
        NSString* json = [ReceiptDB replenish:replenishParam userDict:_userDict];
        responseCallback(json);
    }];
    
    //盘点生成交接单
    [_bridge registerHandler:@"inventory" handler:^(id data, WVJBResponseCallback responseCallback) {
        InventoryParam* inventoryParam = [InventoryParam yy_modelWithJSON:data];
        NSString* json = [ReceiptDB inventory:inventoryParam userDict:_userDict];
        responseCallback(json);
    }];
    
    //交接确认
    [_bridge registerHandler:@"transfer" handler:^(id data, WVJBResponseCallback responseCallback) {
        TransferParam* transferParam = [TransferParam yy_modelWithJSON:data];
        NSString* json = [ReceiptDB transfer:transferParam userDict:_userDict];
        responseCallback(json);
    }];
    
    //加入购物车
    [_bridge registerHandler:@"addCart" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString* sku = [data valueForKey:@"sku"];
        NSInteger* quantity = [[data valueForKey:@"quantity"] integerValue];
        NSString* json = [OrderDB addCart:sku num:quantity];
        responseCallback(json);
    }];
    
    //修改购物车商品数量
    [_bridge registerHandler:@"updateNum" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString* sku = [data valueForKey:@"sku"];
        NSInteger* updateType = [[data valueForKey:@"updateType"] integerValue];
        NSString* json = [OrderDB updateNum:sku updateType:updateType];
        responseCallback(json);
    }];
    
    //删除购物车商品
    [_bridge registerHandler:@"deleteCartSku" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString* sku = [data valueForKey:@"sku"];
        NSString* json = [OrderDB deleteCartSku:sku];
        responseCallback(json);
    }];
    
    //创建订单
    [_bridge registerHandler:@"createOrder" handler:^(id data, WVJBResponseCallback responseCallback) {
        CreateOrderParam* createOrderParam = [CreateOrderParam yy_modelWithJSON:data];
        NSString* json = [OrderDB createOrder:createOrderParam userDict:_userDict];
        responseCallback(json);
    }];
    
    //    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
    //        NSLog(@"testObjcCallback called: %@", data);
    //        responseCallback(@"Response from testObjcCallback");
    //    }];
    
    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    
//    [self renderButtons:_webView];
    [self loadHtmlPage:@"Pages/Index"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tableViewDict count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == _shrinkTableView){
        
        static NSString *ShrinkMenuCellIdentifier = @"ShrinkMenuTableViewCell";
        ShrinkMenuTableViewCell *shrinkMenuCell = (ShrinkMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ShrinkMenuCellIdentifier];
        if (shrinkMenuCell == nil){
            shrinkMenuCell= [[[NSBundle mainBundle]loadNibNamed:ShrinkMenuCellIdentifier owner:nil options:nil] firstObject];
        }
        NSInteger row = [indexPath row];
        NSArray *arr = [_tableViewDict valueForKey:[NSString stringWithFormat:@"%ld",row]];
        UIImage *image = [UIImage imageNamed:[arr objectAtIndex:0]];
        [shrinkMenuCell.iconImageView setImage:image];
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
            [openMenuCell.iconImageView setImage:image];
            image = [UIImage imageNamed:@"menu-logo"];
            [openMenuCell.logoImageView setImage:image];
            [openMenuCell.logoImageView setHidden:NO];
            [openMenuCell.nameLabel setHidden:YES];
        }else{
            NSArray *arr = [_tableViewDict valueForKey:[NSString stringWithFormat:@"%ld",row]];
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
    if(tableView == _shrinkTableView){
        if(row == 0){
            [_popup showWithLayout:_layout];
        }else if(row == 1){
             [self loadHtmlPage:@"Pages/Index"];
        }else{
            [self loadHtmlPage:@"Index"];
        }
    }else if(tableView == _openTableView){
        if(row == 0){
            [_popup dismiss:YES];
        }
    }
    if(row == 7){
        LoginViewController *loginView= [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [CommonUtil showHud:@"正在加载" andView:webView andHud:_hud];
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [_hud hideAnimated:YES];
    NSLog(@"webViewDidFinishLoad");
}

- (void)renderButtons:(WKWebView*)webView {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(10, 400, 100, 35);
    callbackButton.titleLabel.font = font;
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(110, 400, 100, 35);
    reloadButton.titleLabel.font = font;
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
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Html/%@",path] ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [_webView loadHTMLString:appHtml baseURL:baseURL];
    
//    NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"Html/index.html" withExtension:nil];
//    NSURLRequest *request = [NSURLRequest requestWithURL:filePath];
//    [webView loadRequest:request];
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

- (IBAction)logoutPressed:(id)sender {
    

}
- (IBAction)btnMenuPressed:(id)sender {
    
    [_popup showWithLayout:_layout duration:2.0];
//    if([_menuView isHidden]){
//        [popup show];
//    }else{
//        [popup dismiss:YES];
//    }
}

- (IBAction)btnFrashPressed:(id)sender {
//    [_popup dismiss:YES];
}
@end
