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
    
    NSString* sql = [NSString stringWithFormat:@"INSERT INTO LogList (EmpID,Category,Type,Describe,States,FlightID,CreateTime) VALUES ('%ld','%@','%@','%@','正常','%ld', datetime('now','localtime'))",(long)log.EmpID,log.Category,log.Type,log.Describe,(long)log.FlightID];
    bg_executeSql(sql, nil, nil);
}

@end
