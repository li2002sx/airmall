//
//  OrderDB.m
//  AirMall
//
//  Created by 李胜喜 on 2018/3/7.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "OrderDB.h"

@implementation OrderDB

+(Cart*) getCartBySku:(NSString*)sku{
    
    Cart* cart = nil;
    NSString* where = [NSString stringWithFormat:@"where Sku='%@'",sku];
    NSArray* arr = [ProductList bg_find:@"Cart" where:where];
    if([arr count]>0){
        cart = [arr objectAtIndex:0];
    }
    return cart;
}

+(NSString*) addCart:(NSString*)sku num:(NSInteger)num{
    
    AddCartResult* result = [AddCartResult new];
    [result setStatus:0];
    
    NSInteger carId = 0;
    Cart* cart = [self getCartBySku:sku];
    if(cart == nil){
        NSString* update = [NSString stringWithFormat:@"set Quantity=%ld where sku='%@'",num,sku];
        [Cart bg_update:@"Cart" where:update];
        [result setStatus:1];
        [result setCartId:cart.CartID];
    }else{
        ProductItem* productItem = [ProductDB getSkuBySku:sku];
        if(productItem != nil){
            cart = [Cart new];
            cart.Sku = sku;
            cart.Price = productItem.Price;
            cart.Discount = productItem.Discount;
            cart.ProductItemID = productItem.ItemID;
            cart.ProductID = productItem.ProductID;
            cart.Quantity = num;
            [Cart bg_save];
            carId =  [CommonDB selectMaxId:@"Cart" pk:@"CartID"];
            [result setStatus:1];
            [result setCartId:cart.CartID];
        }else{
            [result setMessage:@"没有找到SKU"];
        }
    }
 
    NSString* json = [result yy_modelToJSONObject];
    return json;
}

+(NSString*) deleteCartSku:(NSString*) sku{
    
    CommonResult* commonResult = [CommonResult new];
    
    NSString* where = [NSString stringWithFormat:@"where Sku='%@'",sku];
    BOOL result = [Cart bg_delete:@"Cart" where:where];
    if(result){
         commonResult.status = 1;
    }else{
        commonResult.status = 0;
        commonResult.message = @"删除失败";
    }
    NSString* json = [commonResult yy_modelToJSONObject];
    return json;
}

+(NSString*) updateNum:(NSString*) sku updateType:(NSInteger)updateType{
    
    CommonResult* commonResult = [CommonResult new];
    NSString* update = [NSString stringWithFormat:@"set Quantity=Quantity+%ld where sku='%@'",updateType,sku];
    BOOL result = [Cart bg_update:@"Cart" where:update];
    if(result){
        commonResult.status = 1;
    }else{
        commonResult.status = 0;
        commonResult.message = @"修改数量失败";
    }
    NSString* json = [commonResult yy_modelToJSONObject];
    return json;
}

+(NSString*) createOrder:(CreateOrderParam*)createOrderParam userDict:(NSDictionary*) userDict{
    
    NSString* empId = [userDict valueForKey:@"EmpID"];
    NSString* flightId = [userDict valueForKey:@"FlightID"];
    
    CommonResult* commonResult = [CommonResult new];
    NSArray* arr = [Cart bg_findAll:@"Cart"];
    if([arr count] > 0){
        float totalPrice = 0;
        float totalDiscountPrice = 0;
        for(Cart* cart in arr){
            totalPrice += cart.Price;
            totalDiscountPrice += cart.Discount;
            
            NSString* where = [NSString stringWithFormat:@"where FlightID='%@' and Sku='%@' and Qty >= %ld",flightId,cart.Sku,cart.Quantity];
            NSArray* arr = [Inventory bg_find:@"Inventory" where:where];
            if([arr count]==0){
                commonResult.status = 0;
                commonResult.message = [NSString stringWithFormat:@"sku:%@ 库存不够",cart.Sku];
                break;
            }
        }
        NSString* sql =[NSString stringWithFormat:@"INSERT INTO SalesOrder (OrderPrice,DiscountPrice,PaymentPrice,Status,FirstName,LastName,PaymentType,EmpID,CreateTime,PayTime,Remark)VALUES (%ld,%ld,%ld,'1','%@','%@','现金','%@',datetime('now','localtime'),datetime('now','localtime'),'%@')",totalPrice,totalDiscountPrice,totalPrice-totalDiscountPrice,createOrderParam.firstName,createOrderParam.lastName,empId,createOrderParam.remark];
        bg_executeSql(sql, nil, nil);
        NSInteger orderId = [CommonDB selectMaxId:@"SalesOrder" pk:@"OrderID"];
        for(Cart* cart in arr){
            sql=[NSString stringWithFormat:@"INSERT INTO SalesOrderItem (UnitPrice,DiscountFee,OrderID,ProductID,Sku,SkuName,Barcode,Quantity) VALUES (%ld,%ld,%ld,%ld,'%@','%@','',%ld)",cart.Price,cart.Discount,orderId,cart.ProductID,cart.Sku,cart.Sku,cart.Quantity];
            bg_executeSql(sql, nil, nil);
             NSString* update = [NSString stringWithFormat:@"set Qty= Qty- %ld where FlightID='%@' and Sku='%@'",cart.Quantity,flightId,cart.Sku];
            [Inventory bg_update:@"Inventory" where:update];
        }
        [Cart bg_delete:@"Cart" where:nil];
        commonResult.status = 1;
    }else{
        commonResult.status = 0;
        commonResult.message = @"请添加商品到购物车";
    }
    
    NSString* json = [commonResult yy_modelToJSONObject];
    return json;
}

@end
