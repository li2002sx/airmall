//
//  HandoverMaster.m
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "HandoverMaster.h"

@implementation HandoverMaster

+(NSArray *)bg_unionPrimaryKeys{
    
    return @[@"HandoverNo"];
}

+(NSArray *)bg_ignoreKeys{
    return @[@"Items"];
}

@end
