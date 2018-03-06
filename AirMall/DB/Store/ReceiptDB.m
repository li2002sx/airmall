//
//  ReceiptDB.m
//  AirMall
//
//  Created by 李胜喜 on 2018/3/6.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "ReceiptDB.h"

@implementation ReceiptDB

+(NSString*) receive:(ReceiptParam*) receiptParam userDict:(NSDictionary*) userDict{
    
    CommonResult* result = [CommonResult new];
    [result setStatus:1];
    NSString* empId = [userDict valueForKey:@"EmpID"];
    NSString* empNo = [userDict valueForKey:@"EmpNo"];
    NSString* flightId = [userDict valueForKey:@"FlightID"];
    NSInteger deliveryId = receiptParam.deliveryID;
    NSString* sql = [NSString stringWithFormat:@"update ReceiptList set DeliveryEmpID=%@,DeliveryEmpName='%@',DeliveryTime=datetime('now', 'localtime') where DeliveryID = %ld",empId,empNo,deliveryId];
    bg_executeSql(sql, nil, nil);
    
    NSInteger totalConfirmCount = 0;
    for(ReceiptSku* item in receiptParam.deliveryList){
        NSString* skuJson = [item yy_modelToJSONString];
        ReceiptSku* sku = [ReceiptSku yy_modelWithJSON:skuJson];
        sql = [NSString stringWithFormat:@"update ReceiptItem set Sku = '%@',ConfirmCounts=%ld,DamagedCounts=%ld,DamagedReason='%@',Remark='%@' where DeliveryID = %ld and sku = '%@'",sku.sku,sku.confirmCount,sku.damagedCount,sku.damagedReason,sku.damagedReasonDesc,deliveryId,sku.sku];
        bg_executeSql(sql, nil, nil);
        totalConfirmCount += sku.confirmCount;
        
        sql = [NSString stringWithFormat:@"select * from Inventory where FlightID =%@ ,Sku=%@",flightId,sku.sku];
        NSArray* arr = bg_executeSql(sql, nil, nil);
        if([arr count] > 0){
           sql = [NSString stringWithFormat:@"update Inventory set Qty=Qty+%ld where FlightID =%@ ,Sku=%@",sku.confirmCount - sku.damagedCount,flightId,sku.sku];
            bg_executeSql(sql, nil, nil);
        }else{
            sql=[NSString stringWithFormat:@"insert Inventory(FlightID,ProductID,ProductItemID,Sku,Qty) values(%@,%ld,%ld,%@,%ld)",flightId,@(1),@(1),sku.sku,sku.confirmCount - sku.damagedCount];
            bg_executeSql(sql, nil, nil);
        }
        
        sql = [NSString stringWithFormat:@"insert DamageList(FlightID,SKU,ProductName,Quantity,Unit,UnitPrice,DamagedReason,DamagedReasonDesc,EmpID,CreateTime) values(%ld,%@,%@,%ld,%@,%@,%@,%@,datetime('now', 'localtime'))",deliveryId,sku.sku,@"123",sku.damagedCount,@"台",@(11350),sku.damagedReason,sku.damagedReasonDesc,empId];
        id damage =  bg_executeSql(sql, nil, nil);
        NSString * damageId = [damage valueForKey:@"id"];
        
        sql= [NSString stringWithFormat:@"insert DamageItem(DamageID,ImageUrl,CreateTime) values(%@,%@,datetime('now', 'localtime'))",damageId,sku.imageBase64];
        bg_executeSql(sql, nil, nil);
    }
    
    sql = [NSString stringWithFormat:@"update ReceiptList set ConfirmCounts=%ld where DeliveryID = %ld",totalConfirmCount,receiptParam.deliveryID];
    bg_executeSql(sql, nil, nil);
    
    NSString* json = [result yy_modelToJSONObject];
    
    return json;
}

@end
