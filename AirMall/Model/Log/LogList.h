//
//  LogList.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

@interface LogList : NSObject

@property(nonatomic)NSInteger ID;

@property(nonatomic)NSString* EmpNo;

@property(nonatomic)NSString* Category;

@property(nonatomic)NSString* Type;

@property(nonatomic)NSString* Describe;

@property(nonatomic)NSString* States;

@property(nonatomic)NSString* FlightNo;

@property(nonatomic)NSString* FlightDate;

@property(nonatomic)NSString* CreateTime;

@property(nonatomic)NSString* DeviceNo;

@property(nonatomic)NSInteger Syn;

@end
