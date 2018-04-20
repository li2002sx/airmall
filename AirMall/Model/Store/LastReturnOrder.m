//
//  LastReturnOrder.m
//  AirMall
//
//  Created by 李胜喜 on 2018/4/20.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "LastReturnOrder.h"

@implementation LastReturnOrder

+(NSArray *)bg_unionPrimaryKeys{
    
    return @[@"ReturnOrderNo"];
}

+(NSArray *)bg_ignoreKeys{
    return @[@"Items"];
}

@end
