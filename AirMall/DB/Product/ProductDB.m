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

+(ProductItem*) getProductItemBySku:(NSString*) sku{
    
    ProductItem* productItem = nil;
    NSString* where = [NSString stringWithFormat:@"where Sku='%@'",sku];
    NSArray* arr = [ProductItem bg_find:@"ProductItem" where:where];
    if([arr count]>0){
        NSString* json = [[arr objectAtIndex:0] yy_modelToJSONObject];
        productItem = [ProductItem yy_modelWithJSON:json];
    }
    return productItem;
}

+(NSArray*) getProductItemListBySkus:(NSArray*) skuArr{
    
    NSString* skus = [skuArr componentsJoinedByString:@","];
    NSString* where = [NSString stringWithFormat:@"where Sku in (%@)",skus];
    NSArray* arr = [ProductItem bg_find:@"ProductItem" where:where];
    
    return arr;
}

@end
