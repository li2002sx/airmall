//
//  SalesOrder.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"
#import "SalesOrderItem.h"

@interface SalesOrder : NSObject

@property(nonatomic)NSString* OrderNo;

@property(nonatomic)NSString* FlightNo;

@property(nonatomic)NSDate* FlightDate;

@property(nonatomic)NSInteger OrderStatus;

@property(nonatomic)NSInteger CustomerID;

@property(nonatomic)NSString* FirstName;

@property(nonatomic)NSString* LastName;

@property(nonatomic)NSString* ReceiverMobile;

@property(nonatomic)NSString* ReceiveAddress;

@property(nonatomic)NSString* Express;

@property(nonatomic)NSString* SenderNo;

@property(nonatomic)NSString* PaymentType;

@property(nonatomic)float OrderPrice;

@property(nonatomic)float DiscountPrice;

@property(nonatomic)float PaymentPrice;

@property(nonatomic)NSString* EmpNo;

@property(nonatomic)NSString* DeviceNo;

@property(nonatomic)NSString* CreateTime;

@property(nonatomic)NSString* PayTime;

@property(nonatomic)NSString* Remark;

@property NSArray<SalesOrderItem*>* Items;

@property(nonatomic)NSInteger Syn;

@end
