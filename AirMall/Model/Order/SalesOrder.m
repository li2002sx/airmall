//
//  SalesOrder.m
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "SalesOrder.h"

@implementation SalesOrder

+(NSArray *)bg_unionPrimaryKeys{
    
    return @[@"OrderNo"];
}

+(NSArray *)bg_ignoreKeys{
    return @[@"Items"];
}

@end
