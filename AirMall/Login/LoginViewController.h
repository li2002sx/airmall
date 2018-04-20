//
//  LoginViewController.h
//  AirMall
//
//  Created by 李胜喜 on 2018/2/27.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "BaseViewController.h"
#import "YYWebImage.h"
#import "MainViewController.h"
#import "PGDatePickManager.h"
#import "StaffDB.h"
#import "FlightInfo.h"
#import "ScheduleInfo.h"
#import "ProductList.h"
#import "ProductItem.h"
#import "SalesOrder.h"
#import "SalesOrderItem.h"
#import "DamageList.h"
#import "DamageItem.h"
#import "Inventory.h"
#import "ReceiptList.h"
#import "ReceiptItem.h"
#import "HandoverMaster.h"
#import "HandoverItem.h"
#import "LogList.h"
#import "Cart.h"
#import "FlightPerformance.h"
#import "LastReturnOrder.h"
#import "LastReturnOrderItem.h"
#import "SynInfoTableViewCell.h"
#import "SSZipArchive.h"
#import "Reachability.h"

@interface LoginViewController : BaseViewController<PGDatePickerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *wifiImageView;

@property (weak, nonatomic) IBOutlet UILabel *wifiLabel;

@property (weak, nonatomic) IBOutlet UIButton *synButtom;

- (IBAction)synButtomPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *loginSwitch;
- (IBAction)loginSwitchPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIProgressView *synProgressView;

@property (weak, nonatomic) IBOutlet UIView *synDataView;

@property (weak, nonatomic) IBOutlet UITableView *synTableView;

@property (weak, nonatomic) IBOutlet UILabel *finishLabel;

@property (weak, nonatomic) IBOutlet UITextField *filedFlightNo;

@property (weak, nonatomic) IBOutlet UITextField *fieldDate;

@property (weak, nonatomic) IBOutlet UITextField *fieldName;

@property (weak, nonatomic) IBOutlet UITextField *fieldPass;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet UIButton *changeDateButton;

- (IBAction)dateChange:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;


- (IBAction)loginPressed:(id)sender;

@end
