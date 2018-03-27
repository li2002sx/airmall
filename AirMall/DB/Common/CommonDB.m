//
//  CommonDB.m
//  AirMall
//
//  Created by 李胜喜 on 2018/3/6.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "CommonDB.h"

@implementation CommonDB

+(NSString*) selectList:(NSString*)sql{
    
    SelectListResult* result = [SelectListResult new];
    [result setStatus:0];
    
    NSString* sqlLower = [sql lowercaseString];
    if([sqlLower hasPrefix:@"select"]){
//        NSLog(@"sql:%@",sql);
        
        NSArray* arr = bg_executeSql(sql, nil, nil);
        if([arr count] > 0){
            [result setList:arr];
            [result setStatus:1];
        }else{
            [result setMessage:@"没有查询到数据"];
        }
    }else{
         [result setMessage:@"不是查询语句，请校验"];
    }
    NSString* json = [result yy_modelToJSONObject];
    return json;
}

+(NSString*) selectListForPage:(NSString*)sql pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize{
    
    SelectListForPageResult* result =[SelectListForPageResult new];
    [result setStatus:0];
    
    NSString* sqlLower = [sql lowercaseString];
    sql = [sql stringByReplacingOccurrencesOfString:@"FROM" withString:@"from"];
    if([sqlLower hasPrefix:@"select"]){
        NSRange range = [sql rangeOfString:@"from"];
        NSString* totalSql = [NSString stringWithFormat:@"select count(*) as count %@",[sql substringFromIndex:range.location]];
//        NSLog(@"sql:%@",totalSql);
        NSArray* arr = bg_executeSql(totalSql, nil, nil);
        if([arr count] > 0){
            NSInteger totalCount = [[[arr objectAtIndex:0] valueForKey:@"count"] integerValue];
            [result setTotalCount:totalCount];
            sql = [NSString stringWithFormat:@"%@ limit %ld offset %ld",sql,pageSize,(pageIndex -1) * pageSize];
            NSLog(@"sql:%@",sql);
            arr = bg_executeSql(sql, nil, nil);
            if([arr count] > 0){
                [result setList:arr];
                 [result setStatus:1];
            }else{
                [result setMessage:@"没有查询到数据"];
            }
        }else{
            [result setMessage:@"查询异常，请检查输入"];
        }
    }else{
        [result setMessage:@"不是查询语句，请校验"];
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
