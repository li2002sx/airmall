//
//  LoginViewController.m
//  AirMall
//
//  Created by 李胜喜 on 2018/2/27.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController (){
    
    MBProgressHUD *_hud;
    NSArray* _processContentArr;
    NSMutableDictionary* _tableViewDict;
    NSInteger _synCount;
    
    NSInteger _networkingStatus;
    NSInteger _signal;
    
    NSArray* _signalTextArr;
    
    NSMutableArray* _imageArr;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifi:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    _versionLabel.text = [NSString stringWithFormat:@"v%@",currentVersion];
    
    _tableViewDict = [NSMutableDictionary new];
    _synTableView.dataSource = self;
    _synTableView.delegate = self;
    
    _signalTextArr = @[@"无",@"差",@"中",@"优"];
    
    _synCount = 0;
    
    _processContentArr = @[@[@"flight",@"航班数据"],@[@"product",@"商品数据"],@[@"staff",@"用户数据"],@[@"schedule",@"排班数据"],@[@"receipt",@"收货数据"],@[@"upload",@"数据上报"]];
    
    [self initTable];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tableViewDict count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SynInfoCellIdentifier = @"SynInfoTableViewCell";
    SynInfoTableViewCell *synInfoCell = (SynInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SynInfoCellIdentifier];
    if (synInfoCell == nil){
        synInfoCell= [[[NSBundle mainBundle]loadNibNamed:SynInfoCellIdentifier owner:nil options:nil] firstObject];
    }
    if([_tableViewDict count] > 0){
        NSInteger row = [indexPath row];
        NSArray *arr = [_tableViewDict objectForKey:[[_processContentArr objectAtIndex:row] objectAtIndex:0]];
        synInfoCell.leftIconImageView.image = [UIImage imageNamed:arr[0]];
        synInfoCell.titleLabel.text = arr[1];
        synInfoCell.statusLabel.text = arr[2];
        synInfoCell.timeLabel.text = arr[3];
    }
    
//    [synInfoCell.leftIconImageView addSubview:imageView];
    synInfoCell.backgroundColor = [UIColor clearColor];
    synInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return synInfoCell;
}

- (YYAnimatedImageView*) createLoadingImageView{
    
    YYImage *yyImage = [YYImage imageNamed:@"gif-loading.gif"];
    YYAnimatedImageView *yyImageView = [[YYAnimatedImageView alloc] initWithImage:yyImage];
    yyImageView.frame = CGRectMake(0, 0, 15, 15);

    return yyImageView;
}

- (IBAction)dateChange:(id)sender {
    
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackgroud = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType1;
    datePicker.isHiddenMiddleText = false;
    datePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:false completion:nil];
}

- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDate* date = [calendar dateFromComponents:dateComponents];
    NSString* flightDate = [CommonUtil convertDateToString:date formatter:@"yyyy-MM-dd"];
    _fieldDate.text = flightDate;
    NSLog(@"dateComponents = %@", dateComponents);
}

- (IBAction)loginPressed:(id)sender {
    
//    [ReceiptDB createReportFile];
    [self uploadData];
    
    NSString *flightNo = _filedFlightNo.text;
    if ([flightNo length] <= 3) {
        [CommonUtil showOnlyText:self.view tips:@"航班号不能为空"];
        return;
    }
    
    NSString *flightDate = _fieldDate.text;
    if ([flightDate length] <= 3) {
        [CommonUtil showOnlyText:self.view tips:@"航班日期不能为空"];
        return;
    }
    
    NSString *empNo = _fieldName.text;
    if ([empNo length] <= 0) {
        [CommonUtil showOnlyText:self.view tips:@"员工号不能为空"];
        return;
    }

    NSString *password = _fieldPass.text;
    if ([password length] < 1) {
        [CommonUtil showOnlyText:self.view tips:@"密码不能为空"];
        return;
    }
    
    password = [[CommonUtil md5:password] uppercaseString];
    
    id result = [StaffDB staffLogin:flightNo flightDate:flightDate empNo:empNo password:password deviceNo:_identifierNumber];
    if(result != nil){
        [StaffDB updateLastLoginTime:empNo];
        [result setObject:[CommonUtil convertDateToString:[NSDate new] formatter:@"yyyy年M月d HH:mm:ss"] forKey:@"LastLoginTime"];
        [result setObject:_identifierNumber forKey:@"DeviceNo"];
        [_userInfo setValue:result forKey:_UserKey];
        
    MainViewController *mainView= [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];

//    [self presentViewController:mainView animated:YES completion:nil];
        
    [self.navigationController pushViewController:mainView animated:YES];
        
//      NSLog(@"%@", [staff yy_modelToJSONObject]);
    }else{
        [CommonUtil showOnlyText:self.navigationController.view tips:@"没有找到对应的信息，请检查输入！"];
    }
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

-(void) process:(NSMutableArray*) arr type:(NSInteger)type{
    if(type == 0){
        [arr replaceObjectAtIndex:0 withObject:@"icon-loading"];
        [arr replaceObjectAtIndex:2 withObject:@"正在同步"];
    }else{
        [arr replaceObjectAtIndex:0 withObject:@"icon-succ"];
        [arr replaceObjectAtIndex:2 withObject:@"已完成"];
        [arr replaceObjectAtIndex:3 withObject:[CommonUtil convertDateToString:[NSDate new] formatter:@"yyyy.MM.dd HH:mm:ss"]];
        _synCount++;
        if(_synCount==[_processContentArr count]){
            [_synButtom setEnabled:YES];
            [_finishLabel setHidden:NO];
        }
    }
    
    [_synTableView reloadData];
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
                
                NSMutableArray* arr = [_tableViewDict objectForKey:@"staff"];
                [self process:arr type:0];
                
                [Staff bg_clear:@"Staff"];
                NSArray* staffArr =  [NSArray yy_modelArrayWithClass:[Staff class] json:json];
                for(Staff* staff in staffArr){
                     [staff bg_save];
                }
                
                [self process:arr type:1];
                
            }else if([fileName isEqualToString:@"FlightInfo.json"]){

                NSMutableArray* arr = [_tableViewDict objectForKey:@"flight"];
                [self process:arr type:0];
                
                [FlightInfo bg_clear:@"FlightInfo"];
                NSArray* flightArr =  [NSArray yy_modelArrayWithClass:[FlightInfo class] json:json];
                for(FlightInfo* flight in flightArr){
                    [flight bg_save];
                }
                
                [self process:arr type:1];
                
            }else if([fileName isEqualToString:@"ProductList.json"]){
                
                NSMutableArray* arr = [_tableViewDict objectForKey:@"product"];
                [self process:arr type:0];
                
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
                            [productAttribute bg_save];
                        }
                    }
                    for(id picture in product.Pictures){
                        ProductPicture* productPicture = [ProductPicture yy_modelWithDictionary:picture];
                        [productPicture bg_save];
                        [_imageArr addObject:productPicture.PictureUrl];
                    }
                }
                
                [self process:arr type:1];
                
            }else if([fileName isEqualToString:@"ReceiptList.json"]){
                
                NSMutableArray* arr = [_tableViewDict objectForKey:@"receipt"];
                [self process:arr type:0];
                
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
                    }
                }
                [self process:arr type:1];
            }else if([fileName isEqualToString:@"ScheduleInfo.json"]){
                
                NSMutableArray* arr = [_tableViewDict objectForKey:@"schedule"];
                [self process:arr type:0];
                
                [ScheduleInfo bg_clear:@"ScheduleInfo"];
                NSArray* scheduleArr =  [NSArray yy_modelArrayWithClass:[ScheduleInfo class] json:json];
                for(ScheduleInfo* schedule in scheduleArr){
                    [schedule bg_save];
                }
                [self process:arr type:1];
            }
        }
        [manager removeItemAtPath:unzipPath error:nil];
        
    }else if([fileType isEqualToString:@"picture"]){
        
        for(NSString* imageStr in _imageArr){
            NSString* imagePath = [unzipPath stringByAppendingString:[imageStr stringByReplacingOccurrencesOfString:@"jpg" withString:@"jpeg"]];
            UIImage *image=[[UIImage alloc]initWithContentsOfFile:imagePath];
            NSString *imageBase64 = [CommonUtil image2DataURL:image];
            NSString* update = [NSString stringWithFormat:@"set PictureUrl = '%@' where PictureUrl='%@'",imageBase64,imageStr];
            [ProductPicture bg_update:@"ProductPicture" where:update];
        }
        [manager removeItemAtPath:unzipPath error:nil];
    }
    [manager removeItemAtPath:zipPath error:nil];
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
                     }];
                    [self analysisData:fileType];
                }
                NSLog(@"success");
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"error");
            }];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error");
    }];
}


- (void)uploadData{
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setObject:_identifierNumber forKey:@"DeviceNo"];
    
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *uploadZipPath = [NSString stringWithFormat:@"%@/upload.zip",tmpDir];
    
    //文件操作对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSMutableArray* arr = [_tableViewDict objectForKey:@"upload"];
    [self process:arr type:0];
    
    if([fileManager fileExistsAtPath:uploadZipPath]){
        
        NSData *zipData = [NSData dataWithContentsOfFile:uploadZipPath];
        
        [NetworkUtil upload:@"api/ipad/upload" params:nil fileData:zipData name:@"upload" fileName:@"upload.zip" mimeType:@"application/zip" progress:^(NSProgress *progress) {
            
            NSLog(@"上传进度：%f",1.0 * progress.completedUnitCount / progress.totalUnitCount);
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary* response = [NetworkUtil responseConfiguration:responseObject];
            bool isSucc = [[response objectForKey:@"IsSuccess"] boolValue];
            if(isSucc){
               [self process:arr type:1];
            }
            NSLog(@"success");
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            [self process:arr type:1];
            NSLog(@"error:%@",error);
        }];
    } else {
        [self process:arr type:1];
    }
}

-(void) processStart:(NSString*) key text:(NSString*)text{
    NSMutableArray* arr = [[NSMutableArray alloc] initWithObjects:@"icon-tongxu",text,@"正在通讯",@"", nil];
    [_tableViewDict setObject:arr forKey:key];
    [_synTableView reloadData];
}

- (IBAction)synButtomPressed:(id)sender {
    
    [_synButtom setEnabled:NO];
    [_finishLabel setHidden:YES];
    
    _synCount = 0;
    
    _tableViewDict = [NSMutableDictionary new];
    [_synTableView reloadData];
    
    _imageArr = [NSMutableArray new];
    
    for(NSArray* arr in _processContentArr){
        [self processStart:[arr objectAtIndex:0] text:[arr objectAtIndex:1]];
    }
    [self processStart:@"upload" text:@"数据上报"];
    [self uploadData];
    
    [self downData:@"data"];
    [self downData:@"picture"];
    
}

-(void) noSignal{
    _wifiImageView.image = [UIImage imageNamed:@"icon-wifi-0"];
    _wifiLabel.text = @"无";
    [CommonUtil showOnlyText:self.view tips:@"当前无网络连接"];
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
            NSLog(@"无法获取网络状态");
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            NSLog(@"移动蜂窝网络");
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            [self getSignalStrength];
            NSLog(@"Wifi上网");
            break;
        case AFNetworkReachabilityStatusNotReachable:
            [self noSignal];
            NSLog(@"无网络连接");
            break;
        default:
            break;
        }
}

- (void)getSignalStrength{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSString *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    int signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
    _signal = signalStrength;
    _wifiImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon-wifi-%ld",_signal]];
    if(_signal < 2){
        [CommonUtil showOnlyText:self.view tips:@"当前WIFI信号差，请切换到4G网络"];
    }else{
        [_synButtom setEnabled:YES];
    }
    _wifiLabel.text = [_signalTextArr objectAtIndex:_signal];
    
    NSLog(@"signal %d", signalStrength);
}

-(void)initTable{
    
    Inventory* inventory = [Inventory new];
    [inventory bg_createTable];
    
//    ReceiptList* receiptList = [ReceiptList new];
//    [receiptList bg_createTime];
//
//    ReceiptItem* receiptItem = [ReceiptItem new];
//    [receiptItem bg_createTime];
    
    HandoverMaster* handoverMaster = [HandoverMaster new];
    [handoverMaster bg_createTable];
    
    HandoverItem* handoverItem = [HandoverItem new];
    [handoverItem bg_createTable];
    
    LogList* logList = [LogList new];
    [logList bg_createTable];

    DamageList* damageList = [DamageList new];
    [damageList bg_createTable];
    
    DamageItem* damageItem = [DamageItem new];
    [damageItem bg_createTable];
    
    DamagedProductPicture* damagedProductPicture = [DamagedProductPicture new];
    [damagedProductPicture bg_createTable];
    
    SalesOrder* salesOrder = [SalesOrder new];
    [salesOrder bg_createTable];
    
    SalesOrderItem* salesOrderItem = [SalesOrderItem new];
    [salesOrderItem bg_createTable];

    Cart* cart = [Cart new];
    [cart bg_createTable];
}
@end
