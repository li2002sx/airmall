//
//  StaffDB.m
//  AirMall
//
//  Created by 李胜喜 on 2018/3/2.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "StaffDB.h"

@implementation StaffDB

+(LoginInfoResult*)staffLogin:(NSString*) flightNo flightDate:(NSString*) flightDate empNo:(NSString*) empNo password:(NSString*) password deviceNo:(NSString*)deviceNo{
//    Staff* staff = nil;
    LoginInfoResult* loginInfoResult = [LoginInfoResult new];
    [loginInfoResult setStatus:0];
    NSString* sql = [NSString stringWithFormat:@"select a.EmpNo,a.EmpName,a.EmpPassword,a.EmpPhone,a.Avatar,a.EmpType,a.IsActive,a.CreateTime,c.* from Staff as a join ScheduleInfo as b on b.EmpNo = a.EmpNo join FlightInfo as c on c.FlightNo = b.FlightNo and c.FlightDate = b.FlightDate where a.EmpNo = '%@' and c.Carrier || c.FlightNo = '%@' and date(c.FlightDate) = '%@' order by a.EmpNo desc limit 1", empNo,flightNo,flightDate];
   
    NSArray* arr = bg_executeSql(sql, nil, nil);
    if([arr count] > 0){
        id result = [arr objectAtIndex:0];
        NSString* empPassword = [result valueForKey:@"EmpPassword"];
        if([empPassword isEqualToString:password]){
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
            [loginInfoResult setStatus:1];
            [loginInfoResult setUserInfo:result];
        }else{
           [loginInfoResult setMessage:@"您的登录密码有误，请检查"];
        }
    }else{
        [loginInfoResult setMessage:@"没有找到员工对应的航班信息"];
    }
    return loginInfoResult;
}

+(void) updateLastLoginTime:(NSString*) empNo{
    NSString* sql = [NSString stringWithFormat:@"update Staff set LastLoginTime = datetime('now', 'localtime') where EmpNo = '%@'", empNo];
    id result = bg_executeSql(sql, nil, nil);
    NSLog(@"%@",result);
}

+(id) getPreFlightInfo:(NSString*) flightNo tailNo:(NSString*) tailNo acType:(NSString*)acType deptTime:(NSString*) deptTime{
    
//    AND DeptTime < strftime('%%Y/%%m/%%d %%H:%%M:%%S', 'now', 'localtime')
    
    id result = nil;
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM FlightInfo WHERE TailNo = '%@' AND ACType = '%@' AND FlightDate || DeptTime < '%@' ORDER BY FlightDate || DeptTime DESC limit 1", tailNo, acType, deptTime];
    
    NSArray* arr = bg_executeSql(sql, nil, nil);
    if([arr count] > 0){
        result = [arr objectAtIndex:0];
    }
    return result;
}

+(NSArray*) getNotFlightList:(NSString*)empNo flightDate:(NSString*) flightDate tailNo:(NSString*) tailNo acType:(NSString*)acType{
    
    NSString* sql = [NSString stringWithFormat:@"select b.* from ScheduleInfo a join FlightInfo b on a.FlightDate = b.FlightDate and a.FlightNo = b.FlightNo where a.EmpNo = '%@' and a.FlightDate = '%@' and TailNo = '%@' and ACType='%@' order by DeptTime asc,b.FlightNo asc", empNo, flightDate,tailNo,acType];
    
    NSArray* arr = bg_executeSql(sql, nil, nil);
    return arr;
}

+(LoginInfoResult*) changeFlight:(NSString*) flightNo flightDate:(NSString*) flightDate empNo:(NSString*) empNo deviceNo:(NSString*)deviceNo{
    LoginInfoResult* loginInfoResult = [LoginInfoResult new];
    [loginInfoResult setStatus:0];
    NSString* sql = [NSString stringWithFormat:@"select a.EmpNo,a.EmpName,a.EmpPhone,a.Avatar,a.EmpType,a.IsActive,a.CreateTime,c.* from Staff as a join ScheduleInfo as b on b.EmpNo = a.EmpNo join FlightInfo as c on c.FlightNo = b.FlightNo and c.FlightDate = b.FlightDate where a.EmpNo = '%@' and c.Carrier || c.FlightNo = '%@' and date(c.FlightDate) = '%@' order by a.EmpNo desc limit 1", empNo,flightNo,flightDate];
    
    NSArray* arr = bg_executeSql(sql, nil, nil);
    if([arr count] > 0){
        id result = [arr objectAtIndex:0];
        LogList* log = [LogList new];
        log.EmpNo = [result valueForKey:@"EmpNo"];
        log.FlightNo = [result valueForKey:@"FlightNo"];
        log.FlightDate = [result valueForKey:@"FlightDate"];
        log.Category = @"操作信息";
        log.Type = @"切换航班";
        log.DeviceNo = deviceNo;
        log.Describe = [NSString stringWithFormat:@"账户：%@ 切换航班：%@",empNo,flightNo];
        [LogDB createLog:log];
        [loginInfoResult setStatus:1];
        [loginInfoResult setUserInfo:result];
    }else{
        [loginInfoResult setMessage:@"没有找到员工对应的航班信息"];
    }
    return loginInfoResult;
}

@end
