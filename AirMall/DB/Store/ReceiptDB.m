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
        
        sql = [NSString stringWithFormat:@"select * from Inventory where FlightID =%@ and Sku='%@'",flightId,sku.sku];
        NSArray* arr = bg_executeSql(sql, nil, nil);
        if([arr count] > 0){
           sql = [NSString stringWithFormat:@"update Inventory set Qty=Qty+%ld where FlightID =%@ and Sku='%@'",sku.confirmCount - sku.damagedCount,flightId,sku.sku];
            bg_executeSql(sql, nil, nil);
        }else{
            sql=[NSString stringWithFormat:@"insert Inventory(FlightID,ProductID,ProductItemID,Sku,Qty) values(%@,%ld,%ld,%@,%ld)",flightId,@(1),@(1),sku.sku,sku.confirmCount - sku.damagedCount];
            bg_executeSql(sql, nil, nil);
        }
        
        sql = [NSString stringWithFormat:@"INSERT INTO DamageList(FlightID,SKU,ProductName,Quantity,Unit,UnitPrice,DamagedReason,DamagedReasonDesc,EmpID,CreateTime) VALUES (%ld,'%@','%@',%ld,'%@',%@,'%@','%@',%@,datetime('now','localtime'))",deliveryId,sku.sku,@"123",sku.damagedCount,@"台",@(11350),sku.damagedReason,sku.damagedReasonDesc,empId];
        bg_executeSql(sql, nil, nil);
        NSInteger damageId = [CommonDB selectMaxId:@"DamageList" pk:@"ID"];
        
        sql= [NSString stringWithFormat:@"INSERT INTO DamageItem(DamageID,ImageUrl,CreateTime) values(%ld,'%@',datetime('now', 'localtime'))",damageId,sku.imageBase64];
        bg_executeSql(sql, nil, nil);
    }
    
    sql = [NSString stringWithFormat:@"update ReceiptList set ConfirmCounts=%ld where DeliveryID = %ld",totalConfirmCount,receiptParam.deliveryID];
    bg_executeSql(sql, nil, nil);
    
    NSString* json = [result yy_modelToJSONObject];
    return json;
}

+(NSString*) replenish:(ReplenishParam*) replenishParam userDict:(NSDictionary*) userDict{
    CommonResult* result = [CommonResult new];
    [result setStatus:1];
    
    NSString* empId = [userDict valueForKey:@"EmpID"];
    NSString* empNo = [userDict valueForKey:@"EmpNo"];
    NSString* flightId = [userDict valueForKey:@"FlightID"];
    NSString* scheduleId = [userDict valueForKey:@"ScheduleID"];
    
    NSString* sql = [NSString stringWithFormat:@"INSERT INTO ReceiptList (DeliveryNo,FlightID,ScheduleID,DeliveryType,DeliveryStatus,NeedCounts,ApplicantEmpID,ApplicantEmpName,ApplicantTime,ConfirmCounts,DeliveryEmpID,DeliveryEmpName,DeliveryTime,Remark) VALUES ('%@','%@','%@',2,'正常','0','%@','%@',datetime('now', 'localtime'),'0','','','','')",@"123456",flightId,scheduleId,empNo,empNo];
    bg_executeSql(sql, nil, nil);
    NSInteger deliveryId = [CommonDB selectMaxId:@"ReceiptList" pk:@"DeliveryID"];
    
    NSInteger totalNeedCount = 0;
    for(ReplenishSku* item in replenishParam.replenishList){
        NSString* skuJson = [item yy_modelToJSONString];
        ReplenishSku* sku = [ReplenishSku yy_modelWithJSON:skuJson];
        NSString* sql = [NSString stringWithFormat:@"INSERT INTO ReceiptItem(DeliveryID,DiningCarNo,ProductID,Sku,Barcode,SkuName,Unit,NeedCounts,ConfirmCounts,DamagedCounts,DamagedReason) VALUES(%ld,'',%ld,'%@','%@','%@','%@',%ld,0,0,'')",deliveryId,@(1),sku.sku,@"123456",@"123456",@"台",sku.needCount];
        bg_executeSql(sql, nil, nil);
        totalNeedCount += sku.needCount;
    }
    
    sql = [NSString stringWithFormat:@"update ReceiptList set NeedCounts=%ld where DeliveryID = %ld",totalNeedCount,deliveryId];
    bg_executeSql(sql, nil, nil);
    
    NSString* json = [result yy_modelToJSONObject];
    return json;
    
}

+(NSString*) inventory:(InventoryParam*) inventoryParam userDict:(NSDictionary*) userDict{
   
    CommonResult* result = [CommonResult new];
    [result setStatus:1];
    
    NSString* empId = [userDict valueForKey:@"EmpID"];
    NSString* empNo = [userDict valueForKey:@"EmpNo"];
    NSString* flightId = [userDict valueForKey:@"FlightID"];

    NSString* sql = [NSString stringWithFormat:@"INSERT INTO HandoverMaster (HandoverNo,PreFlightID,FlightID,Type,Status,HandoverCounts,HandoverDamagedCounts,HandoverEmpId,HandoverEmpName, HandoverTime,UndertakeCounts,UndertakeDamagedCounts,UndertakeEmpId,UndertakeEmpName,UndertakeTime,Remark)VALUES ('%@','%@',0 ,'%@','%@',0,0,'%@','%@',datetime('now','localtime'),'0','0','0','0','0','')",@"1",flightId,@"常规",@"未交接",empId,empNo];
    bg_executeSql(sql, nil, nil);
    NSInteger handoverId = [CommonDB selectMaxId:@"HandoverMaster" pk:@"HandoverID"];
    
    NSInteger totalHandoverCount = 0;
    for(InventorySku* item in inventoryParam.inventoryList){
        NSString* skuJson = [item yy_modelToJSONString];
        InventorySku* sku = [InventorySku yy_modelWithJSON:skuJson];
        NSString* sql = [NSString stringWithFormat:@"INSERT INTO HandoverItem (HandoverID,DiningCarNo,ProductID,Sku,Barcode,SkuName,Unit,HandoverCounts,HandoverDamagedCounts,UndertakeCounts,UndertakeDamagedCounts,Remark) VALUES (%ld,'%@',%@, '%@','%@','%@','%@',%ld,0,'0','0','')",handoverId,@"123",@(1),sku.sku,@"123456",@"123456",@"台",sku.handoverCount];
        bg_executeSql(sql, nil, nil);
        totalHandoverCount += sku.handoverCount;
    }
    
    sql = [NSString stringWithFormat:@"update HandoverMaster set HandoverCounts=%ld where HandoverID = %ld",totalHandoverCount,handoverId];
    bg_executeSql(sql, nil, nil);
    
    NSString* json = [result yy_modelToJSONObject];
    return json;
}

+(NSString*) transfer:(TransferParam*) transferParam userDict:(NSDictionary*) userDict{
    
    CommonResult* result = [CommonResult new];
    [result setStatus:1];
    NSString* empId = [userDict valueForKey:@"EmpID"];
    NSString* empNo = [userDict valueForKey:@"EmpNo"];
    NSString* flightId = [userDict valueForKey:@"FlightID"];
    NSInteger handoverId = transferParam.handoverID;
    
    NSString* sql = [NSString stringWithFormat:@"UPDATE HandoverMaster SET FlightID = '%@',Status = '%@',UndertakeEmpId = '%@',UndertakeEmpName = '%@',UndertakeTime = datetime('now','localtime'),Remark = '%@' WHERE HandoverID = %ld",flightId,@"已交接",empId,empNo,@""];
    
    NSInteger totalTransferCount = 0;
    NSInteger totalTransferDamagedCount = 0;
    for(TransferSku* item in transferParam.transferList){
        NSString* skuJson = [item yy_modelToJSONString];
        TransferSku* sku = [TransferSku yy_modelWithJSON:skuJson];
        sql = [NSString stringWithFormat:@"UPDATE HandoverItem SET UndertakeCounts = %ld,UndertakeDamagedCounts = %ld,Remark = '%@' WHERE HandoverID = %ld AND Sku = '%@'",sku.handoverCount,sku.damagedCount,sku.damagedReasonDesc,handoverId,sku.sku];
        bg_executeSql(sql, nil, nil);
        totalTransferCount += sku.handoverCount;
        totalTransferDamagedCount += sku.damagedCount;
        
        sql = [NSString stringWithFormat:@"select * from Inventory where FlightID =%@ and Sku='%@'",flightId,sku.sku];
        NSArray* arr = bg_executeSql(sql, nil, nil);
        if([arr count] > 0){
            sql = [NSString stringWithFormat:@"update Inventory set Qty=Qty+%ld where FlightID =%@ and Sku='%@'",sku.handoverCount - sku.damagedCount,flightId,sku.sku];
            bg_executeSql(sql, nil, nil);
        }else{
            sql=[NSString stringWithFormat:@"insert Inventory(FlightID,ProductID,ProductItemID,Sku,Qty) values(%@,%ld,%ld,%@,%ld)",flightId,@(1),@(1),sku.sku,sku.handoverCount - sku.damagedCount];
            bg_executeSql(sql, nil, nil);
        }
        
        sql = [NSString stringWithFormat:@"INSERT INTO DamageList(FlightID,SKU,ProductName,Quantity,Unit,UnitPrice,DamagedReason,DamagedReasonDesc,EmpID,CreateTime) VALUES (%ld,'%@','%@',%ld,'%@',%@,'%@','%@',%@,datetime('now','localtime'))",flightId,sku.sku,@"123",sku.damagedCount,@"台",@(11350),sku.damagedReason,sku.damagedReasonDesc,empId];
        bg_executeSql(sql, nil, nil);
        NSInteger damageId = [CommonDB selectMaxId:@"DamageList" pk:@"ID"];
        
        sql= [NSString stringWithFormat:@"INSERT INTO DamageItem(DamageID,ImageUrl,CreateTime) values(%ld,'%@',datetime('now', 'localtime'))",damageId,sku.imageBase64];
        bg_executeSql(sql, nil, nil);
    }
    
    sql = [NSString stringWithFormat:@"update HandoverMaster set UndertakeCounts=%ld, UndertakeDamagedCounts = %ld,UndertakeEmpId = '%@',UndertakeEmpName = '%@',UndertakeTime = datetime('now', 'localtime'), where HandoverID = %ld",totalTransferCount,totalTransferDamagedCount,handoverId,empId,empNo];
    bg_executeSql(sql, nil, nil);
    
    NSString* json = [result yy_modelToJSONObject];
    return json;
}

@end
