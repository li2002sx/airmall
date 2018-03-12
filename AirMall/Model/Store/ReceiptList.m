//
//  ReceiptList.m
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "ReceiptList.h"

@implementation ReceiptList

+(NSArray *)bg_unionPrimaryKeys{
    
    return @[@"DeliveryNo"];
}

+(NSArray *)bg_ignoreKeys{
    return @[@"Items"];
}

@end
