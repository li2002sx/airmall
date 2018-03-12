//
//  LogDB.m
//  AirMall
//
//  Created by Jankie on 2018/3/8.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "LogDB.h"

@implementation LogDB

+(void) createLog:(LogList*)log{
    
    NSString* sql = [NSString stringWithFormat:@"INSERT INTO LogList (EmpNo,Category,Type,Describe,States,FlightNo,FlightDate,CreateTime,DeviceNo) VALUES ('%@','%@','%@','%@','正常','%@','%@', datetime('now','localtime'),'%@')",log.EmpNo,log.Category,log.Type,log.Describe,log.FlightNo,log.FlightDate,log.DeviceNo];
    bg_executeSql(sql, nil, nil);
}

@end
