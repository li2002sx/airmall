//
//  StaffDB.m
//  AirMall
//
//  Created by 李胜喜 on 2018/3/2.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "StaffDB.h"

@implementation StaffDB

+(id)staffLogin:(NSString*) flightNo flightDate:(NSString*) flightDate empNo:(NSString*) empNo password:(NSString*) password deviceNo:(NSString*)deviceNo{
//    Staff* staff = nil;
    id result = nil;
    NSString* sql = [NSString stringWithFormat:@"select a.EmpNo,a.EmpName,a.EmpPhone,a.EmpType,a.IsActive,a.CreateTime,c.* from Staff as a join ScheduleInfo as b on b.EmpNo = a.EmpNo join FlightInfo as c on c.FlightNo = b.FlightNo and c.FlightDate = b.FlightDate where a.EmpNo = '%@' and EmpPassword = '%@' and c.Carrier || c.FlightNo = '%@' and date(c.FlightDate) = '%@' order by a.EmpNo desc limit 1", empNo, password,flightNo,flightDate];
   
    NSArray* arr = bg_executeSql(sql, nil, nil);
    if([arr count] > 0){
        result = [arr objectAtIndex:0];
//        NSString* json = [[arr objectAtIndex:0] yy_modelToJSONObject];
//        staff = [Staff yy_modelWithJSON:json];
        LogList* log = [LogList new];
        log.EmpNo = [result valueForKey:@"EmpNo"];
        log.FlightNo = [result valueForKey:@"FlightNo"];
        log.FlightDate = [result valueForKey:@"FlightDate"];
        log.Category = @"登录信息";
        log.Type = @"登录";
        log.DeviceNo = deviceNo;
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

+(id) getPreFlightInfo:(NSString*) flightNo tailNo:(NSString*) tailNo acType:(NSString*)acType {
    
//    AND DeptTime < strftime('%%Y/%%m/%%d %%H:%%M:%%S', 'now', 'localtime')
    
    id result = nil;
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM FlightInfo WHERE TailNo = '%@' AND ACType = '%@' AND FlightNo < '%@' ORDER BY FlightNo ASC limit 1", tailNo, acType, flightNo];
    
    NSArray* arr = bg_executeSql(sql, nil, nil);
    if([arr count] > 0){
        result = [arr objectAtIndex:0];
    }
    return result;
}

@end
