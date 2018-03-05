//
//  SalesOrder.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

@interface SalesOrder : NSObject

@property(nonatomic)NSInteger OrderID;

@property(nonatomic)NSInteger Status;

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

@property(nonatomic)NSInteger EmpID;

@property(nonatomic)NSDate* CreateTime;

@property(nonatomic)NSDate* PayTime;

@property(nonatomic)NSString* Remark;

@end
