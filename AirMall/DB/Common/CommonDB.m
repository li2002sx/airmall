//
//  CommonDB.m
//  AirMall
//
//  Created by 李胜喜 on 2018/3/6.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "CommonDB.h"

@implementation CommonDB

+(NSString*) selectOne:(NSString*)sql{
    
    SelectOneResult* result = [SelectOneResult new];
    [result setStatus:1];
    
    NSLog(@"sql:%@",sql);
    
    NSArray* arr = bg_executeSql(sql, nil, nil);
    if([arr count] > 0){
        [result setInfo:[arr objectAtIndex:0]];
    }else{
        [result setMessage:@"没有查询到数据"];
    }
    NSString* json = [result yy_modelToJSONObject];
    return json;
}

+(NSString*) selectList:(NSString*)sql pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize{
    
    SelectListResult* result =[SelectListResult new];
    [result setStatus:1];
    
    sql = [sql lowercaseString];
    NSRange range = [sql rangeOfString:@"from"];
    NSString* totalSql = [NSString stringWithFormat:@"select count(*) as count %@",[sql substringFromIndex:range.location]];
    NSLog(@"sql:%@",totalSql);
    NSArray* arr = bg_executeSql(totalSql, nil, nil);
    NSInteger totalCount = [[[arr objectAtIndex:0] valueForKey:@"count"] integerValue];
    [result setTotalCount:totalCount];
    sql = [NSString stringWithFormat:@"%@ limit %ld offset %ld",sql,pageSize,(pageIndex -1)];
    NSLog(@"sql:%@",sql);
    arr = bg_executeSql(sql, nil, nil);
    if([arr count] > 0){
        [result setList:arr];
    }else{
        [result setMessage:@"没有查询到数据"];
    }
    NSString* json = [result yy_modelToJSONObject];
    return json;
}

+(NSInteger) selectMaxId:(NSString*)table pk:(NSString*)pk{
    
    NSString* sql = [NSString stringWithFormat:@"select max(%@) as max from %@",pk,table];
    
    NSArray* arr = bg_executeSql(sql, nil, nil);
    if([arr count] > 0){
        NSInteger max = [[[arr objectAtIndex:0] valueForKey:@"max"] integerValue];
        return max;
    }else{
        return 1;
    }
}

@end
