//
//  OrderDB.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/7.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import "BGFMDB.h"
#import "CommonResult.h"
#import "ProductDB.h"
#import "Cart.h"
#import "CommonDB.h"
#import "Inventory.h"
#import "LogDB.h"
#import "ReceiptDB.h"

@interface OrderDB : NSObject

+(Cart*) getCartBySku:(NSString*)sku;

+(NSString*) addCart:(NSString*)sku num:(NSInteger)num userDict:(NSDictionary*) userDict;

+(NSString*) deleteCartSku:(NSString*) sku;

+(NSString*) updateNum:(NSString*) sku updateType:(NSInteger)updateType;

+(NSString*) clearCart;

+(NSString*) createOrder:(CreateOrderParam*)createOrderParam userDict:(NSDictionary*) userDict;

@end
