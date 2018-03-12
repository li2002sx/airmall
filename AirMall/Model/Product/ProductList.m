//
//  ProductList.m
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "ProductList.h"

@implementation ProductList

+(NSArray *)bg_unionPrimaryKeys{
    
    return @[@"ProductID"];
}

+(NSArray *)bg_ignoreKeys{
    return @[@"Items",@"Pictures"];
}

@end
