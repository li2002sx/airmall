//
//  ReceiptDB.m
//  AirMall
//
//  Created by 李胜喜 on 2018/3/6.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "ReceiptDB.h"

@implementation ReceiptDB

+(NSString*) createNo:(NSString*) type flightNo:(NSString*)flightNo flightDate:(NSString*)flightDate{
    
    int num = (arc4random() % 10000);
    NSString* randomNumber = [NSString stringWithFormat:@"%.4d", num];
    NSString* date = [CommonUtil convertDateToString:[CommonUtil convertDateFromString:flightDate] formatter:@"yyyyMMdd"];
    NSString* no = [NSString stringWithFormat:@"%@%@%@%@",type,flightNo,date,randomNumber];
    return no;
}

+(NSString*) receive:(ReceiptParam*) receiptParam userDict:(NSDictionary*) userDict{
    
    CommonResult* result = [CommonResult new];
    [result setStatus:0];
    
    if([receiptParam.deliveryList count]>0){
        NSString* empNo = [userDict valueForKey:@"EmpNo"];
        NSString* empName = [userDict valueForKey:@"EmpName"];
        NSString* flightNo = [userDict valueForKey:@"FlightNo"];
        NSString* flightDate = [userDict valueForKey:@"FlightDate"];
        NSString* deviceNo = [userDict valueForKey:@"DeviceNo"];
        
        NSString* deliveryNo = receiptParam.deliveryNo;
        NSString* sql = nil;
        NSString* where = [NSString stringWithFormat:@"where DeliveryNo = '%@'",deliveryNo];
        NSArray* receiptArr = [ReceiptList bg_find:@"ReceiptList" where:where];
        if([receiptArr count]>0){
            ReceiptList* receipt = [receiptArr objectAtIndex:0];
            if(receipt.DeliveryStatus == 0){
                NSMutableArray* logStrArray = [NSMutableArray new];
                
                NSString* damagedNo = [self createNo:@"B" flightNo:flightNo flightDate:flightDate];
                
                NSMutableArray* skuArr = [NSMutableArray new];
                for(id item in receiptParam.deliveryList){
                    [skuArr addObject:[NSString stringWithFormat:@"'%@'",[item objectForKey:@"sku"]]];
                }
                
                NSMutableDictionary* skuDicts = [ProductDB getProductItemListBySkus:skuArr];
                NSMutableDictionary* productDicts = [ProductDB getProductListBySkus:skuArr];
                if([skuDicts count] > 0 && [productDicts count] > 0){
                    
                    NSInteger totalConfirmCount = 0;
                    NSInteger totalDamagedCount = 0;
                    for(id item in receiptParam.deliveryList){
                        NSString* json = [item yy_modelToJSONString];
                        ReceiptSku* receiptSku = [ReceiptSku yy_modelWithJSON:json];
                        
                        NSString* sku = receiptSku.sku;
                        NSInteger confirmCount = receiptSku.confirmCount;
                        NSInteger damagedCount = receiptSku.damagedCount;
                        NSString* diningCarNo = receiptSku.diningCarNo;
                        
                        ProductItem* productItem = [skuDicts valueForKey:sku];
                        ProductList* product = [productDicts objectForKey:@(productItem.ProductID)];
                        
                        NSString* where = [NSString stringWithFormat:@"set ConfirmCounts=%ld,DamagedCounts=%ld,DamagedReason='%@',Remark='%@' where DeliveryNo = '%@' and sku = '%@'",confirmCount,damagedCount,receiptSku.damagedReason,receiptSku.damagedReasonDesc,deliveryNo,sku];
                        [ReceiptItem bg_update:@"ReceiptItem" where:where];
                        
                        totalConfirmCount += confirmCount;
                        totalDamagedCount += damagedCount;
                        
                        NSString* logStr = [NSString stringWithFormat:@"SKU:%@ 确认收货:%ld 破损:%ld",sku,confirmCount,damagedCount];
                        [logStrArray addObject:logStr];
                        
                        where = [NSString stringWithFormat:@"where FlightNo ='%@' and FlightDate='%@' and Sku='%@' and DiningCarNo = '%@'",flightNo,flightDate,sku,diningCarNo];
                        NSArray* arr = [Inventory bg_find:@"Inventory" where:where];
                        if([arr count] > 0){
                            where = [NSString stringWithFormat:@"set Qty=Qty+%ld where FlightNo ='%@' and FlightDate='%@' and Sku='%@' and DiningCarNo = '%@'",confirmCount - damagedCount,flightNo,flightDate,sku,diningCarNo];
                            [Inventory bg_update:@"Inventory" where:where];
                        }else{
                            sql=[NSString stringWithFormat:@"INSERT INTO Inventory(FlightNo,FlightDate,ProductID,ProductItemID,Sku,DiningCarNo,Barcode,ProductName,Unit,Qty) values('%@','%@',%ld,%ld,'%@','%@','%@','%@','%@',%ld)",flightNo,flightDate,product.ProductID,productItem.ProductItemID,sku,diningCarNo,productItem.Barcode,product.ProductName,product.Unit,confirmCount - damagedCount];
                            bg_executeSql(sql, nil, nil);
                        }
                        if(damagedCount>0){
                            sql= [NSString stringWithFormat:@"INSERT INTO DamageItem(DamagedNo,ProductID,ProductItemID,Sku,Barcode,ProductName,Unit,Quantity,DamagedReason,Remark) values('%@',%ld,%ld,'%@','%@','%@','%@',%ld,'%@','%@')",damagedNo,product.ProductID,productItem.ProductItemID,sku,productItem.Barcode,product.ProductName,product.Unit,damagedCount,receiptSku.damagedReason,receiptSku.damagedReasonDesc];
                            bg_executeSql(sql, nil, nil);
                            
                            if([receiptSku.imageBase64s count] > 0){
                                for(NSString* image in receiptSku.imageBase64s){
                                    sql= [NSString stringWithFormat:@"INSERT INTO DamagedProductPicture(DamagedNo,ProductID,ProductItemID,Sku,PictureUrl) values('%@',%ld,%ld,'%@','%@')",damagedNo,product.ProductID,productItem.ProductItemID,sku,image];
                                    bg_executeSql(sql, nil, nil);
                                }
                            }
                        }
                    }
                    
                    if(totalDamagedCount > 0){
                        sql = [NSString stringWithFormat:@"INSERT INTO DamageList(DamagedNo,FlightNo,FlightDate,EmpNo,DeviceNo,DamagedCounts,CreateTime,Remark) VALUES ('%@','%@','%@','%@','%@',%ld,datetime('now','localtime'),'%@')",damagedNo,flightNo,flightDate,empNo,deviceNo,totalDamagedCount,@""];
                        bg_executeSql(sql, nil, nil);
                    }
                    
                    NSString* where = [NSString stringWithFormat:@"set DeliveryStatus = 1, ConfirmCounts=%ld,DamagedCounts=%ld,DeliveryEmpNo='%@',DeliveryEmpName='%@',DeliveryDeviceNo='%@',DeliveryConfirmTime=datetime('now', 'localtime') where DeliveryNo = '%@'",totalConfirmCount,totalDamagedCount,empNo,empName,deviceNo,deliveryNo];
                    [ReceiptList bg_update:@"ReceiptList" where:where];
                    
                    LogList* log = [LogList new];
                    log.EmpNo = empNo;
                    log.FlightNo = flightNo;
                    log.FlightDate = [userDict valueForKey:@"FlightDate"];
                    log.Category = @"操作信息";
                    log.DeviceNo = deviceNo;
                    log.Type = @"收货";
                    log.Describe = [logStrArray componentsJoinedByString:@", "];
                    [LogDB createLog:log];
                    
                    [result setStatus:1];
                    [result setMessage:@"确认收货成功"];
                    
                }else{
                    [result setMessage:@"没有找到对应的商品信息"];
                }
            }else{
                [result setMessage:@"改收货单已收货"];
            }
        }else{
            [result setMessage:@"没有找到收货单"];
        }
    }else{
        [result setMessage:@"确认收货SKU不能为空"];
    }
    
    NSString* json = [result yy_modelToJSONObject];
    return json;
}

+(NSString*) replenish:(ReplenishParam*) replenishParam userDict:(NSDictionary*) userDict{
    CommonResult* result = [CommonResult new];
    [result setStatus:0];
    
    if([replenishParam.replenishList count]>0){
        NSString* empNo = [userDict valueForKey:@"EmpNo"];
        NSString* empName = [userDict valueForKey:@"EmpName"];
        NSString* flightNo = [userDict valueForKey:@"FlightNo"];
        NSString* flightDate = [userDict valueForKey:@"FlightDate"];
        NSString* deviceNo = [userDict valueForKey:@"DeviceNo"];
        
        NSString* deliveryNo = [self createNo:@"D" flightNo:flightNo flightDate:flightDate];
        
        NSMutableArray* skuArr = [NSMutableArray new];
        for(id item in replenishParam.replenishList){
            [skuArr addObject:[NSString stringWithFormat:@"'%@'",[item objectForKey:@"sku"]]];
        }
        
        NSMutableDictionary* skuDicts = [ProductDB getProductItemListBySkus:skuArr];
        NSMutableDictionary* productDicts = [ProductDB getProductListBySkus:skuArr];
        if([skuDicts count] > 0 && [productDicts count] > 0){
            NSMutableArray* logStrArray = [NSMutableArray new];
            NSString* sql = nil;
            
            NSInteger totalNeedCount = 0;
            for(id item in replenishParam.replenishList){
                NSString* json = [item yy_modelToJSONString];
                ReplenishSku* replenishSku = [ReplenishSku yy_modelWithJSON:json];
                
                NSString* sku = replenishSku.sku;
                NSInteger needCount = replenishSku.needCount;
                NSString* diningCarNo = replenishSku.diningCarNo;
                
                ProductItem* productItem = [skuDicts valueForKey:sku];
                ProductList* product = [productDicts objectForKey:@(productItem.ProductID)];
                
                
                sql = [NSString stringWithFormat:@"INSERT INTO ReceiptItem(DeliveryNo,DiningCarNo,ProductID,ProductItemID,Sku,Barcode,ProductName,Unit,NeedCounts,ConfirmCounts,DamagedCounts,DamagedReason,Remark) VALUES('%@','%@',%ld,%ld,'%@','%@','%@','%@',%ld,0,0,'','','')",deliveryNo,diningCarNo,product.ProductID,productItem.ProductItemID,sku,productItem.Barcode,product.ProductName,product.Unit,needCount];
                bg_executeSql(sql, nil, nil);
                totalNeedCount += needCount;
                
                NSString* logStr = [NSString stringWithFormat:@"SKU:%@ 申请补货数:%ld",sku,needCount];
                [logStrArray addObject:logStr];
            }
            
            sql = [NSString stringWithFormat:@"INSERT INTO ReceiptList (DeliveryNo,FlightNo,FlightDate,DeliveryType,DeliveryStatus,NeedCounts,ApplicantEmpNo,ApplicantEmpName,ApplicantDeviceNo,ApplicantTime,ConfirmCounts,DeliveryEmpNo,DeliveryEmpName,DeliveryDeviceNo,DeliveryConfirmTime,Remark) VALUES ('%@','%@','%@',2,'0',%ld,'%@','%@','%@',datetime('now','localtime'),'0','','','','','')",deliveryNo,flightNo,flightDate,totalNeedCount,empNo,empName,deviceNo];
            bg_executeSql(sql, nil, nil);
            
            LogList* log = [LogList new];
            log.EmpNo = empNo;
            log.FlightNo = flightNo;
            log.FlightDate = [userDict valueForKey:@"FlightDate"];
            log.Category = @"操作信息";
            log.DeviceNo = deviceNo;
            log.Type = @"申请补货";
            log.Describe = [logStrArray componentsJoinedByString:@", "];
            [LogDB createLog:log];
            
            [result setStatus:1];
            [result setMessage:@"申请补货成功"];
            
        }else{
            [result setMessage:@"没有找到对应的商品信息"];
        }
    }else{
        [result setMessage:@"申请补货的商品不能为空"];
    }
    
    NSString* json = [result yy_modelToJSONObject];
    return json;
}

+(NSString*) inventory:(InventoryParam*) inventoryParam userDict:(NSDictionary*) userDict{
   
    CommonResult* result = [CommonResult new];
    [result setStatus:0];
    
    if([inventoryParam.inventoryList count]>0){
     
        NSString* empNo = [userDict valueForKey:@"EmpNo"];
        NSString* empName = [userDict valueForKey:@"EmpName"];
        NSString* flightNo = [userDict valueForKey:@"FlightNo"];
        NSString* flightDate = [userDict valueForKey:@"FlightDate"];
        NSString* tailNo = [userDict valueForKey:@"TailNo"];
        NSString* acType = [userDict valueForKey:@"ACType"];
        NSString* deviceNo = [userDict valueForKey:@"DeviceNo"];
        
        NSString* handoverNo = [self createNo:@"H" flightNo:flightNo flightDate:flightDate];
        
        NSMutableArray* skuArr = [NSMutableArray new];
        for(id item in inventoryParam.inventoryList){
            [skuArr addObject:[NSString stringWithFormat:@"'%@'",[item objectForKey:@"sku"]]];
        }
        
        NSMutableDictionary* skuDicts = [ProductDB getProductItemListBySkus:skuArr];
        NSMutableDictionary* productDicts = [ProductDB getProductListBySkus:skuArr];
        
        if([skuDicts count] > 0 && [productDicts count] > 0){
         
            NSMutableArray* logStrArray = [NSMutableArray new];
            NSString* sql = nil;
            
            NSInteger totalHandoverCount = 0;
            NSInteger totalDamagedCount = 0;
            for(id item in inventoryParam.inventoryList){
                NSString* json = [item yy_modelToJSONString];
                InventorySku* inventorySku = [InventorySku yy_modelWithJSON:json];
                
                NSString* sku = inventorySku.sku;
                NSInteger handoverCount = inventorySku.handoverCount;
                NSInteger damagedCount = inventorySku.damagedCount;
                NSString* diningCarNo = inventorySku.diningCarNo;
                
                ProductItem* productItem = [skuDicts valueForKey:sku];
                ProductList* product = [productDicts objectForKey:@(productItem.ProductID)];
                
                sql = [NSString stringWithFormat:@"INSERT INTO HandoverItem (HandoverNo,DiningCarNo,ProductID,ProductItemID,Sku,Barcode, ProductName,Unit,HandoverCounts,HandoverDamagedCounts,UndertakeCounts,UndertakeDamagedCounts,Remark) VALUES ('%@','%@',%ld,%ld,'%@','%@','%@','%@',%ld,%ld,0,0,'')",handoverNo,diningCarNo,product.ProductID,productItem.ProductItemID,sku,productItem.Barcode,product.ProductName,product.Unit,handoverCount,damagedCount];
                bg_executeSql(sql, nil, nil);
                totalHandoverCount += handoverCount;
                totalDamagedCount+= damagedCount;
                
                NSString* logStr = [NSString stringWithFormat:@"SKU:%@ 交接盘点:%ld 破损:%ld",sku,handoverCount,damagedCount];
                [logStrArray addObject:logStr];
            }
            
            sql = [NSString stringWithFormat:@"INSERT INTO HandoverMaster (HandoverNo,PreFlightNo,FlightNo,FlightDate,TailNo,ACType,Status,HandoverCounts,HandoverDamagedCounts,HandoverEmpNo,HandoverEmpName,HandoverDeviceNo, HandoverTime,UndertakeCounts,UndertakeDamagedCounts,UndertakeEmpNo,UndertakeEmpName,HandoverDeviceNo,UndertakeTime,Remark)VALUES ('%@','%@','','%@','%@','%@',0,%ld,%ld,'%@','%@','%@',datetime('now','localtime'),0,0,'','','','','')",handoverNo,flightNo,flightDate,tailNo,acType,totalHandoverCount,totalDamagedCount,empNo,empName,deviceNo];
            bg_executeSql(sql, nil, nil);
            
            LogList* log = [LogList new];
            log.EmpNo = empNo;
            log.FlightNo = flightNo;
            log.FlightDate = [userDict valueForKey:@"FlightDate"];
            log.Category = @"操作信息";
            log.DeviceNo = deviceNo;
            log.Type = @"盘点交接";
            log.Describe = [logStrArray componentsJoinedByString:@", "];
            [LogDB createLog:log];
            
            [result setStatus:1];
            [result setMessage:@"提交盘点单成功"];
            
        }else{
           [result setMessage:@"没有找到对应的商品信息"];
        }
    }else{
         [result setMessage:@"盘点的商品不能为空"];
    }
    
    NSString* json = [result yy_modelToJSONObject];
    return json;
}

+(NSString*) transfer:(TransferParam*) transferParam userDict:(NSDictionary*) userDict{
    
    CommonResult* result = [CommonResult new];
    [result setStatus:0];
    
    if([transferParam.transferList count]>0){
     
        NSString* empNo = [userDict valueForKey:@"EmpNo"];
        NSString* empName = [userDict valueForKey:@"EmpName"];
        NSString* flightNo = [userDict valueForKey:@"FlightNo"];
        NSString* flightDate = [userDict valueForKey:@"FlightDate"];
        NSString* deviceNo = [userDict valueForKey:@"DeviceNo"];
        
        NSString* handoverNo = transferParam.handoverNo;
        
        NSString* where = [NSString stringWithFormat:@"where HandoverNo = '%@'",handoverNo];
        NSArray* handoverArr = [ReceiptList bg_find:@"HandoverMaster" where:where];
        if([handoverArr count]>0){
            HandoverMaster* handove = [handoverArr objectAtIndex:0];
            if(handove.Status == 0){
         
                NSMutableArray* logStrArray = [NSMutableArray new];
                NSString* sql = nil;
                
                NSString* damagedNo = [self createNo:@"B" flightNo:flightNo flightDate:flightDate];
                
                NSMutableArray* skuArr = [NSMutableArray new];
                for(id item in transferParam.transferList){
                    [skuArr addObject:[NSString stringWithFormat:@"'%@'",[item objectForKey:@"sku"]]];
                }
                
                NSMutableDictionary* skuDicts = [ProductDB getProductItemListBySkus:skuArr];
                NSMutableDictionary* productDicts = [ProductDB getProductListBySkus:skuArr];
                 if([skuDicts count] > 0 && [productDicts count] > 0){
                     NSInteger totalTransferCount = 0;
                     NSInteger totalDamagedCount = 0;
                     for(id item in transferParam.transferList){
                         NSString* json = [item yy_modelToJSONString];
                         TransferSku* transferSku = [TransferSku yy_modelWithJSON:json];
                         
                         NSString* sku = transferSku.sku;
                         NSInteger handoverCount = transferSku.handoverCount;
                         NSInteger damagedCount = transferSku.damagedCount;
                         NSString* diningCarNo = transferSku.diningCarNo;
                         
                         ProductItem* productItem = [skuDicts valueForKey:sku];
                         ProductList* product = [productDicts objectForKey:@(productItem.ProductID)];
                         
                         NSString* where = [NSString stringWithFormat:@"set UndertakeCounts=%ld,UndertakeDamagedCounts=%ld,Remark='%@' where HandoverNo = '%@' and sku = '%@' and DiningCarNo = '%@'",handoverCount,damagedCount,transferSku.damagedReasonDesc,handoverNo,sku,diningCarNo];
                         [HandoverItem bg_update:@"HandoverItem" where:where];
                         
                         totalTransferCount += handoverCount;
                         totalDamagedCount += damagedCount;
                         
                         NSString* logStr = [NSString stringWithFormat:@"SKU:%@ 确认承接:%ld 破损:%ld",sku,handoverCount,damagedCount];
                         [logStrArray addObject:logStr];
                         
                         where = [NSString stringWithFormat:@"where FlightNo ='%@' and FlightDate='%@' and Sku='%@' and DiningCarNo = '%@'",flightNo,flightDate,sku,diningCarNo];
                         NSArray* arr = [Inventory bg_find:@"Inventory" where:where];
                         if([arr count] > 0){
                             where = [NSString stringWithFormat:@"set Qty=Qty+%ld where FlightNo ='%@' and FlightDate='%@' and Sku='%@' and DiningCarNo = '%@'",handoverCount - damagedCount,flightNo,flightDate,sku,diningCarNo];
                             [Inventory bg_update:@"Inventory" where:where];
                         }else{
                             sql=[NSString stringWithFormat:@"INSERT INTO Inventory(FlightNo,FlightDate,ProductID,ProductItemID,Sku,DiningCarNo,Barcode,ProductName,Unit,Qty) values('%@','%@',%ld,%ld,'%@','%@','%@','%@','%@',%ld)",flightNo,flightDate,product.ProductID,productItem.ProductItemID,sku,diningCarNo,productItem.Barcode,product.ProductName,product.Unit,handoverCount - damagedCount];
                             bg_executeSql(sql, nil, nil);
                         }
                         if(damagedCount>0){
                             sql= [NSString stringWithFormat:@"INSERT INTO DamageItem(DamagedNo,ProductID,ProductItemID,Sku,Barcode,ProductName,Unit,Quantity,DamagedReason,Remark) values('%@',%ld,%ld,'%@','%@','%@','%@',%ld,'%@','%@')",damagedNo,product.ProductID,productItem.ProductItemID,sku,productItem.Barcode,product.ProductName,product.Unit,damagedCount,transferSku.damagedReason,transferSku.damagedReasonDesc];
                             bg_executeSql(sql, nil, nil);
                             
                             if([transferSku.imageBase64s count] > 0){
                                 for(NSString* image in transferSku.imageBase64s){
                                     sql= [NSString stringWithFormat:@"INSERT INTO DamagedProductPicture(DamagedNo,ProductID,ProductItemID,Sku,PictureUrl) values('%@',%ld,%ld,'%@','%@')",damagedNo,product.ProductID,productItem.ProductItemID,sku,image];
                                     bg_executeSql(sql, nil, nil);
                                 }
                             }
                         }
                     }
                     
                     if(totalDamagedCount > 0){
                         sql = [NSString stringWithFormat:@"INSERT INTO DamageList(DamagedNo,FlightNo,FlightDate,EmpNo,DeviceNo,DamagedCounts,CreateTime,Remark) VALUES ('%@','%@','%@','%@','%@',%ld,datetime('now','localtime'),'%@')",damagedNo,flightNo,flightDate,empNo,deviceNo,totalDamagedCount,@""];
                         bg_executeSql(sql, nil, nil);
                     }
                     
                     NSString* where = [NSString stringWithFormat:@"set FlightNo='%@',Status =1,UndertakeCounts=%ld,UndertakeDamagedCounts=%ld,UndertakeEmpNo='%@',UndertakeEmpName='%@',UndertakeDeviceNo='%@',UndertakeTime=datetime('now', 'localtime'),Remark='' where HandoverNo='%@'",flightNo,totalTransferCount,totalDamagedCount,empNo,empName,deviceNo,handoverNo];
                     [HandoverMaster bg_update:@"HandoverMaster" where:where];
                     
                     LogList* log = [LogList new];
                     log.EmpNo = empNo;
                     log.FlightNo = flightNo;
                     log.FlightDate = [userDict valueForKey:@"FlightDate"];
                     log.Category = @"操作信息";
                     log.DeviceNo = deviceNo;
                     log.Type = @"确认承接";
                     log.Describe = [logStrArray componentsJoinedByString:@", "];
                     [LogDB createLog:log];
                     
                     [result setStatus:1];
                     [result setMessage:@"确认收货成功"];
                     
                 }else{
                     [result setMessage:@"没有找到对应的商品信息"];
                 }
            }else{
                [result setMessage:@"该交接单已经承接完成"];
            }
        }else{
            [result setMessage:@"没有找到交接单"];
        }
    }else{
         [result setMessage:@"确认承接的商品信息不能为空"];
    }
    
    NSString* json = [result yy_modelToJSONObject];
    return json;
}

+(void)createReportFile{
    
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *uploadPath = [tmpDir stringByAppendingPathComponent:@"upload"];
    NSString *uploadZipPath = [NSString stringWithFormat:@"%@/upload.zip",tmpDir];
    
    //文件操作对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:uploadPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {
        [fileManager createDirectoryAtPath:uploadPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = nil;
    
    filePath = [NSString stringWithFormat:@"%@/DamageList.json",uploadPath];
    [fileManager removeItemAtPath:filePath error:nil];
    NSString* where = [NSString stringWithFormat:@"where syn is null"];
    NSArray* damageArr = [DamageList bg_find:@"DamageList" where:where];
    if([damageArr count] > 0){
        
        for(DamageList* damage in damageArr){
            where = [NSString stringWithFormat:@"where DamagedNo = '%@'",damage.DamagedNo];
            NSArray* damageItemArr = [DamageItem bg_find:@"DamageItem" where:where];
            [damage setItems:damageItemArr];
            
            NSArray* damagePictureArr = [DamagedProductPicture bg_find:@"DamagedProductPicture" where:where];
            [damage setPictures:damagePictureArr];
        }
        
        [fileManager createFileAtPath:filePath contents:[[damageArr yy_modelToJSONString] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        
        where = [NSString stringWithFormat:@"update syn = 1 where syn is null"];
        [DamageList bg_update:@"DamageList" where:where];
    }
    
    filePath = [NSString stringWithFormat:@"%@/HandoverMaster.json",uploadPath];
    [fileManager removeItemAtPath:filePath error:nil];
    where = [NSString stringWithFormat:@"where syn is null"];
    NSArray* handoverArr = [HandoverMaster bg_find:@"HandoverMaster" where:where];
    if([handoverArr count] > 0){
        
        for(HandoverMaster* handover in handoverArr){
            where = [NSString stringWithFormat:@"where HandoverNo = '%@'",handover.HandoverNo];
            NSArray* handoverItemArr = [HandoverItem bg_find:@"HandoverItem" where:where];
            [handover setItems:handoverItemArr];
        }
        
        [fileManager createFileAtPath:filePath contents:[[handoverArr yy_modelToJSONString] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        
        where = [NSString stringWithFormat:@"update syn = 1 where syn is null"];
        [HandoverMaster bg_update:@"HandoverMaster" where:where];
    }
    
    filePath = [NSString stringWithFormat:@"%@/Inventory.json",uploadPath];
    [fileManager removeItemAtPath:filePath error:nil];
    where = [NSString stringWithFormat:@"where syn is null"];
    NSArray* inventoryArr = [Inventory bg_find:@"Inventory" where:where];
    if([inventoryArr count] > 0){

        [fileManager createFileAtPath:filePath contents:[[inventoryArr yy_modelToJSONString] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        
        where = [NSString stringWithFormat:@"update syn = 1 where syn is null"];
        [Inventory bg_update:@"Inventory" where:where];
    }
    
    filePath = [NSString stringWithFormat:@"%@/LogList.json",uploadPath];
    [fileManager removeItemAtPath:filePath error:nil];
    where = [NSString stringWithFormat:@"where syn is null"];
    NSArray* logArr = [LogList bg_find:@"LogList" where:where];
    if([logArr count] > 0){
        
        [fileManager createFileAtPath:filePath contents:[[logArr yy_modelToJSONString] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        
        where = [NSString stringWithFormat:@"update syn = 1 where syn is null"];
        [LogList bg_update:@"LogList" where:where];
    }
    
    filePath = [NSString stringWithFormat:@"%@/ReceiptList.json",uploadPath];
    [fileManager removeItemAtPath:filePath error:nil];
    where = [NSString stringWithFormat:@"where syn is null"];
    NSArray* receiptArr = [ReceiptList bg_find:@"ReceiptList" where:where];
    if([receiptArr count] > 0){
        
        for(ReceiptList* receipt in receiptArr){
            where = [NSString stringWithFormat:@"where DeliveryNo = '%@'",receipt.DeliveryNo];
            NSArray* receiptItemArr = [ReceiptItem bg_find:@"ReceiptItem" where:where];
            [receipt setItems:receiptItemArr];
        }
        
        [fileManager createFileAtPath:filePath contents:[[handoverArr yy_modelToJSONString] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        
        where = [NSString stringWithFormat:@"update syn = 1 where syn is null"];
        [ReceiptList bg_update:@"ReceiptList" where:where];
    }
    
    filePath = [NSString stringWithFormat:@"%@/SalesOrder.json",uploadPath];
    [fileManager removeItemAtPath:filePath error:nil];
    where = [NSString stringWithFormat:@"where syn is null"];
    NSArray* orderArr = [SalesOrder bg_find:@"SalesOrder" where:where];
    if([orderArr count] > 0){
        
        for(SalesOrder* order in orderArr){
            where = [NSString stringWithFormat:@"where OrderNo = '%@'",order.OrderNo];
            NSArray* orderItemArr = [SalesOrderItem bg_find:@"SalesOrderItem" where:where];
            [order setItems:orderItemArr];
        }
        
        [fileManager createFileAtPath:filePath contents:[[handoverArr yy_modelToJSONString] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        
        where = [NSString stringWithFormat:@"update syn = 1 where syn is null"];
        [SalesOrder bg_update:@"SalesOrder" where:where];
    }
    
    [SSZipArchive createZipFileAtPath:uploadZipPath withContentsOfDirectory:uploadPath];
}

@end
