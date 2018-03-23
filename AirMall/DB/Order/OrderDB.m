//
//  OrderDB.m
//  AirMall
//
//  Created by 李胜喜 on 2018/3/7.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "OrderDB.h"

@implementation OrderDB

+(Cart*) getCartBySku:(NSString*)sku diningCarNo:(NSString*)diningCarNo{
    
    Cart* cart = nil;
    NSString* where = [NSString stringWithFormat:@"where Sku='%@' and DiningCarNo = '%@'",sku,diningCarNo];
    NSArray* arr = [Cart bg_find:@"Cart" where:where];
    if([arr count]>0){
        NSString* json = [[arr objectAtIndex:0] yy_modelToJSONObject];
        cart = [Cart yy_modelWithJSON:json];
    }
    return cart;
}

+(NSString*) addCart:(NSString*)sku diningCarNo:(NSString*)diningCarNo num:(NSInteger)num{
    
    AddCartResult* result = [AddCartResult new];
    [result setStatus:0];
    
    Cart* cart = [self getCartBySku:sku diningCarNo:diningCarNo];
    if(cart != nil){
        NSString* update = [NSString stringWithFormat:@"set Quantity=Quantity+%ld where sku='%@' and diningCarNo = '%@'",num,sku,diningCarNo];
        [Cart bg_update:@"Cart" where:update];
        [result setStatus:1];
        [result setMessage:@"加入购物车成功"];
    }else{
        ProductItem* productItem = [ProductDB getProductItemBySku:sku];
        ProductList* product = [ProductDB getProductById:productItem.ProductID];
        if(productItem != nil){
            NSString* sql = [NSString stringWithFormat:@"INSERT INTO Cart (DiningCarNo,ProductID,ProductItemID,Sku,Barcode,ProductName,Unit,Price,Discount,Quantity) VALUES ('%@',%ld,%ld,'%@','%@','%@','%@',%.2f,%.2f,%ld)",diningCarNo,product.ProductID,productItem.ProductItemID,sku,productItem.Barcode,product.ProductName,product.Unit,productItem.Price,productItem.Discount,num];
            bg_executeSql(sql, nil, nil);
//            carId =  [CommonDB selectMaxId:@"Cart" pk:@"CartID"];
            [result setStatus:1];
            [result setMessage:@"加入购物车成功"];
        }else{
            [result setMessage:@"没有找到对应的商品信息"];
        }
    }
 
    NSString* json = [result yy_modelToJSONObject];
    return json;
}

+(NSString*) deleteCartSku:(NSString*) sku diningCarNo:(NSString*)diningCarNo{
    
    CommonResult* commonResult = [CommonResult new];
    [commonResult setStatus:0];
    
    NSString* where = [NSString stringWithFormat:@"where Sku='%@' and DiningCarNo = '%@'",sku,diningCarNo];
    BOOL result = [Cart bg_delete:@"Cart" where:where];
    if(result){
        [commonResult setStatus:1];
        [commonResult setMessage:@"删除商品成功"];
    }else{
        [commonResult setMessage:@"删除商品失败"];
    }
    NSString* json = [commonResult yy_modelToJSONObject];
    return json;
}

+(NSString*) updateNum:(NSString*) sku diningCarNo:(NSString*)diningCarNo updateType:(NSInteger)updateType{
    
    CommonResult* commonResult = [CommonResult new];
    [commonResult setStatus:0];
    NSString* update = [NSString stringWithFormat:@"set Quantity=Quantity+%ld where sku='%@' and DiningCarNo = '%@'",updateType,sku,diningCarNo];
    BOOL result = [Cart bg_update:@"Cart" where:update];
    if(result){
        [commonResult setStatus:1];
        [commonResult setMessage:@"修改商品数量成功"];
    }else{
        [commonResult setMessage:@"修改商品数量失败"];
    }
    NSString* json = [commonResult yy_modelToJSONObject];
    return json;
}

+(NSString*) clearCart{
    CommonResult* commonResult = [CommonResult new];
    [Cart bg_delete:@"Cart" where:nil];
    [commonResult setStatus:1];
    [commonResult setMessage:@"清空购物车成功"];
    NSString* json = [commonResult yy_modelToJSONObject];
    return json;
}

+(NSString*) createOrder:(CreateOrderParam*)createOrderParam userDict:(NSDictionary*) userDict{
    
    OrderResult* orderResult = [OrderResult new];
    [orderResult setStatus:0];
    
    NSString* empNo = [userDict valueForKey:@"EmpNo"];
    NSString* empName = [userDict valueForKey:@"EmpName"];
    NSString* flightNo = [userDict valueForKey:@"FlightNo"];
    NSString* flightDate = [userDict valueForKey:@"FlightDate"];
    NSString* deviceNo = [userDict valueForKey:@"DeviceNo"];
    
    NSString* orderNo = [ReceiptDB createNo:@"O" flightNo:flightNo flightDate:flightDate];
    
    NSString* sql = nil;
    
    NSMutableArray* skuArr = [NSMutableArray new];
    
    NSArray* arr = [Cart bg_findAll:@"Cart"];
    
    if([arr count] > 0){
        
        for(id item in arr){
            [skuArr addObject:[NSString stringWithFormat:@"'%@'",[item valueForKey:@"Sku"]]];
        }
        
        NSMutableDictionary* skuDicts = [ProductDB getProductItemListBySkus:skuArr];
        NSMutableDictionary* productDicts = [ProductDB getProductListBySkus:skuArr];
        
        if([skuDicts count] > 0 && [productDicts count] > 0){
         
            bool canOrder = true;
            float totalPrice = 0;
            float totalDiscountPrice = 0;
            int totalQuantity = 0;
            for(Cart* item in arr){
                NSString* json = [item yy_modelToJSONString];
                Cart* cart = [Cart yy_modelWithJSON:json];
                
                NSString* sku = cart.Sku;
                NSString* diningCarNo = cart.DiningCarNo;
                
                ProductItem* productItem = [skuDicts valueForKey:sku];
                ProductList* product = [productDicts objectForKey:@(productItem.ProductID)];
                
                totalQuantity += cart.Quantity;
                totalPrice += cart.Price * cart.Quantity;
                totalDiscountPrice += cart.Discount * cart.Quantity;
                
                NSString* where = [NSString stringWithFormat:@"where FlightNo='%@' and FlightDate='%@' and Sku='%@' and Qty >= %ld",flightNo,flightDate,sku,cart.Quantity];
                NSArray* arr = [Inventory bg_find:@"Inventory" where:where];
                if([arr count] == 0){
                    orderResult.status = 0;
                    orderResult.message = [NSString stringWithFormat:@"sku:%@ 库存不够",cart.Sku];
                    canOrder = false;
                    break;
                }
                
                sql=[NSString stringWithFormat:@"INSERT INTO SalesOrderItem (OrderNo,DiningCarNo,ProductID,ProductItemID,Sku,DiningCarNo,Barcode,ProductName,Unit,UnitPrice,DiscountFee,Quantity,Remark) VALUES ('%@','%@',%ld,%ld,'%@','%@','%@','%@','%@',%.2f,%.2f,%ld,'')",orderNo,diningCarNo,product.ProductID,productItem.ProductItemID,sku,diningCarNo,productItem.Barcode,product.ProductName,product.Unit,cart.Price,cart.Discount,cart.Quantity];
                bg_executeSql(sql, nil, nil);
                
                NSString* update = [NSString stringWithFormat:@"set Qty= Qty- %ld where FlightNo='%@' and FlightDate='%@' and Sku='%@'",cart.Quantity,flightNo,flightDate,sku];
                [Inventory bg_update:@"Inventory" where:update];
                
            }
            if(canOrder){
                NSString* sql =[NSString stringWithFormat:@"INSERT INTO SalesOrder(OrderNo,FlightNo,FlightDate,OrderStatus,CustomerID,FirstName,LastName,ReceiverMobile,PaymentType,OrderPrice,DiscountPrice,PaymentPrice,EmpNo,DeviceNo,CreateTime,PayTime,Remark)VALUES ('%@','%@','%@',1,0,'%@','%@','%@','现金支付',%.2f,%.2f,%f,'%@','%@',datetime('now','localtime'),datetime('now','localtime'),'%@')",orderNo,flightNo,flightDate,createOrderParam.firstName,createOrderParam.lastName,createOrderParam.mobile,totalPrice,totalDiscountPrice,totalPrice-totalDiscountPrice,empNo,deviceNo,createOrderParam.remark];
                bg_executeSql(sql, nil, nil);
                
                [Cart bg_delete:@"Cart" where:nil];
                
                LogList* log = [LogList new];
                log.EmpNo = empNo;
                log.FlightNo = flightNo;
                log.FlightDate = [userDict valueForKey:@"FlightDate"];
                log.Category = @"操作信息";
                log.DeviceNo = deviceNo;
                log.Type = @"创建订单";
                log.Describe = [NSString stringWithFormat:@"创建订单 %@ 数量 %d, 金额 %.2f",orderNo,totalQuantity,totalPrice];
                [LogDB createLog:log];
                
                [orderResult setStatus:1];
                [orderResult setOrderNo:orderNo];
                [orderResult setMessage:@"创建订单成功"];
            }
        }else{
             [orderResult setMessage:@"没有找到对应的商品信息"];
        }
    }else{
        orderResult.message = @"购物车中没有商品";
    }
    
    NSString* json = [orderResult yy_modelToJSONObject];
    return json;
}

@end
