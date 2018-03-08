//
//  StaffDB.m
//  AirMall
//
//  Created by 李胜喜 on 2018/3/2.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "StaffDB.h"

@implementation StaffDB

+(id)staffLogin:(NSString*) flightNo flightDate:(NSString*) flightDate empNo:(NSString*) empNo password:(NSString*) password{
//    Staff* staff = nil;
    id result = nil;
    NSString* sql = [NSString stringWithFormat:@"select a.*,b.*,c.* from Staff as a join ScheduleInfo as b on b.EmpID = a.EmpID join FlightInfo as c on c.FlightID = b.FlightID where EmpNo = '%@' and EmpPassword = '%@' and c.Carrier || c.FlightNo = '%@' and date(c.FlightDate) = '%@' order by a.EmpID desc limit 1", empNo, password,flightNo,flightDate];
   
    NSArray* arr = bg_executeSql(sql, nil, nil);
    if([arr count] > 0){
        result = [arr objectAtIndex:0];
//        NSString* json = [[arr objectAtIndex:0] yy_modelToJSONObject];
//        staff = [Staff yy_modelWithJSON:json];
        LogList* log = [LogList new];
        log.EmpID = [[result valueForKey:@"EmpID"] integerValue];
        log.FlightID = [[result valueForKey:@"FlightID"] integerValue];
        log.Category = @"登录信息";
        log.Type = @"登录";
        log.Describe = [NSString stringWithFormat:@"账户：%@ 登录",[result valueForKey:@"EmpNo"]];
        [LogDB createLog:log];
    }
    return result;
}

+(void) updateLastLoginTime:(NSString*) empNo{
    NSString* sql = [NSString stringWithFormat:@"update Staff set LastLoginTime = datetime('now', 'localtime') where EmpNo = '%@'", empNo];
    id result = bg_executeSql(sql, nil, nil);
    NSLog(@"%@",result);
}

@end
