//
//  DamageList.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"
#import "DamageItem.h"
#import "DamagedProductPicture.h"

@interface DamageList : NSObject

@property(nonatomic)NSString* DamagedNo;

@property(nonatomic)NSString* FlightNo;

@property(nonatomic)NSString* FlightDate;

@property(nonatomic)NSString* EmpNo;

@property(nonatomic)NSString* DeviceNo;

@property(nonatomic)NSInteger DamagedCounts;

@property(nonatomic)NSString* CreateTime;

@property(nonatomic)NSString* Remark;

@property NSArray<DamageItem*>* Items;

@property NSArray<DamagedProductPicture *>* Pictures;

@property(nonatomic)NSInteger Syn;

@end
