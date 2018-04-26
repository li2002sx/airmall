//
//  StaffDB.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/2.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import "Staff.h"
#import "LogDB.h"
#import "FlightInfo.h"
#import "CommonResult.h"

#define tb_staff @"staff"

@interface StaffDB : NSObject

+(LoginInfoResult*) staffLogin:(NSString*) flightNo flightDate:(NSString*) flightDate empNo:(NSString*) empNo password:(NSString*) password deviceNo:(NSString*)deviceNo;

+(void) updateLastLoginTime:(NSString*) empNo;

+(id) getPreFlightInfo:(NSString*) flightNo tailNo:(NSString*) tailNo acType:(NSString*)acType deptTime:(NSString*) deptTime;

+(NSArray*) getNotFlightList:(NSString*)empNo flightDate:(NSString*) flightDate;

+(LoginInfoResult*) changeFlight:(NSString*) flightNo flightDate:(NSString*) flightDate empNo:(NSString*) empNo deviceNo:(NSString*)deviceNo;

@end
