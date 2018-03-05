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

@property(nonatomic)NSInteger EmpID;

@property(nonatomic)NSString* Category;

@property(nonatomic)NSString* Type;

@property(nonatomic)NSString* Describe;

@property(nonatomic)NSString* States;

@property(nonatomic)NSInteger FlightID;

@property(nonatomic)NSDate* CreateTime;

@end
