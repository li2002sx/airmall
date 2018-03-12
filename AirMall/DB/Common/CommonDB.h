//
//  CommonDB.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/6.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"
#import "CommonResult.h"

@interface CommonDB : NSObject

+(NSString*) selectList:(NSString*)sql;

+(NSString*) selectListForPage:(NSString*)sql pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

+(NSInteger) selectMaxId:(NSString*)table pk:(NSString*)pk;

@end
