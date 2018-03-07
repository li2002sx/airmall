//
//  ProductDB.m
//  AirMall
//
//  Created by 李胜喜 on 2018/3/7.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "ProductDB.h"

@implementation ProductDB

+(ProductList*) getProductById:(NSInteger) productId{
    
    ProductList* product = nil;
    NSString* where = [NSString stringWithFormat:@"where ProductID=%ld",productId];
    NSArray* arr = [ProductList bg_find:@"ProductList" where:where];
    if([arr count]>0){
        product = [arr objectAtIndex:0];
    }
    return product;
}

+(NSArray*) getProductListByIds:(NSArray*) productIdArr{
    
    NSString* productIds = [productIdArr componentsJoinedByString:@","];
    NSString* where = [NSString stringWithFormat:@"where ProductID in (%@)",productIds];
    NSArray* arr = [ProductList bg_find:@"ProductList" where:where];
    
    return arr;
}

+(ProductItem*) getSkuBySku:(NSString*) sku{
    
    ProductItem* productItem = nil;
    NSString* where = [NSString stringWithFormat:@"where Sku='%@'",sku];
    NSArray* arr = [ProductList bg_find:@"ProductItem" where:where];
    if([arr count]>0){
        productItem = [arr objectAtIndex:0];
    }
    return productItem;
}

+(NSArray*) getSkuListBySkus:(NSArray*) skuArr{
    
    NSString* skus = [skuArr componentsJoinedByString:@","];
    NSString* where = [NSString stringWithFormat:@"where Sku in (%@)",skus];
    NSArray* arr = [ProductList bg_find:@"ProductItem" where:where];
    
    return arr;
}

@end
