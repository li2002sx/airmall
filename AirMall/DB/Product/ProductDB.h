//
//  ProductDB.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/7.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductList.h"
#import "ProductItem.h"

@interface ProductDB : NSObject

+(ProductList*) getProductById:(NSInteger) productId;

+(NSArray*) getProductListByIds:(NSArray*) productIdArr;

+(ProductItem*) getSkuBySku:(NSString*) sku;

+(NSArray*) getSkuListBySkus:(NSArray*) skuArr;

@end