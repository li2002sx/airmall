//
//  ReceiptList.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

@interface ReceiptList : NSObject

@property(nonatomic)NSInteger DeliveryID;

@property(nonatomic)NSString* DeliveryNo;

@property(nonatomic)NSInteger FlightID;

@property(nonatomic)NSInteger ScheduleID;

@property(nonatomic)NSInteger DeliveryType;

@property(nonatomic)NSInteger DeliveryStatus;

@property(nonatomic)NSInteger NeedCounts;

@property(nonatomic)NSString* ApplicantEmpID;

@property(nonatomic)NSString* ApplicantEmpName;

@property(nonatomic)NSDate* ApplicantTime;

//@property(nonatomic)NSDate* DeliveryTime;

@property(nonatomic)NSInteger ConfirmCounts;

@property(nonatomic)NSString* DeliveryEmpID;

@property(nonatomic)NSString* DeliveryEmpName;

@property(nonatomic)NSDate* DeliveryTime;

@property(nonatomic)NSString* Remark;

@end
