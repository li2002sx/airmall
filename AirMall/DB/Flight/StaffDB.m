//
//  StaffDB.m
//  AirMall
//
//  Created by 李胜喜 on 2018/3/2.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "StaffDB.h"

@implementation StaffDB

+(Staff*) getStaffByNoAndPass:(NSString*) no password:(NSString*) password{
    
    Staff* staff = nil;
    
    NSString* sql = [NSString stringWithFormat:@"select * from staff where EmpNo = '%@' and EmpPassword = '%@' order by EmpID desc limit 1", no, password];
   
    NSArray* arr = bg_executeSql(sql, nil, nil);
    if([arr count] > 0){
        NSString* json = [[arr objectAtIndex:0] yy_modelToJSONObject];
        staff = [Staff yy_modelWithJSON:json];
    }
    return staff;
}

@end
