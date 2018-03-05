//
//  DamageList.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

@interface DamageList : NSObject

@property(nonatomic)NSInteger ID;

@property(nonatomic)NSInteger FlightID;

@property(nonatomic)NSString* SKU;

@property(nonatomic)NSString* ProductName;

@property(nonatomic)NSInteger Quantity;

@property(nonatomic)NSString* Unit;

@property(nonatomic)float UnitPrice;

@property(nonatomic)NSString* DamagedReason;

@property(nonatomic)NSString* DamagedReasonDesc;

@property(nonatomic)NSInteger EmpID;

@property(nonatomic)NSDate* CreateTime;


@end
