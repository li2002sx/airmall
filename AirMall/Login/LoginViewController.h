//
//  LoginViewController.h
//  AirMall
//
//  Created by 李胜喜 on 2018/2/27.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "BaseViewController.h"
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
#import "SyncList.h"
#import "Cart.h"

@interface LoginViewController : BaseViewController<PGDatePickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *filedFlightNo;

@property (weak, nonatomic) IBOutlet UITextField *fieldDate;

@property (weak, nonatomic) IBOutlet UITextField *fieldName;

@property (weak, nonatomic) IBOutlet UITextField *fieldPass;

- (IBAction)dateChange:(id)sender;

- (IBAction)loginPressed:(id)sender;

@end
