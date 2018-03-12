//
//  ReceiptList.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"
#import "ReceiptItem.h"

@interface ReceiptList : NSObject

@property(nonatomic)NSString* DeliveryNo;

@property(nonatomic)NSString* FlightNo;

@property(nonatomic)NSString* FlightDate;

@property(nonatomic)NSInteger DeliveryType;

@property(nonatomic)NSInteger DeliveryStatus;

@property(nonatomic)NSInteger NeedCounts;

@property(nonatomic)NSString* ApplicantEmpNo;

@property(nonatomic)NSString* ApplicantEmpName;

@property(nonatomic)NSString* ApplicantDeviceNo;

@property(nonatomic)NSString* ApplicantTime;

@property(nonatomic)NSString* DeliveryTime;

@property(nonatomic)NSInteger ConfirmCounts;

@property(nonatomic)NSString* DeliveryEmpNo;

@property(nonatomic)NSString* DeliveryEmpName;

@property(nonatomic)NSString* DeliveryDeviceNo;

@property(nonatomic)NSString* DeliveryConfirmTime;

@property(nonatomic)NSString* Remark;

@property NSArray<ReceiptItem*>* Items;

@property(nonatomic)NSInteger Syn;

@end
