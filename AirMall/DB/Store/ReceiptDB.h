//
//  ReceiptDB.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/6.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import "BGFMDB.h"
#import "CommonResult.h"
#import "ReceiptParam.h"
#import "Inventory.h"
#import "CommonDB.h"
#import "LogDB.h"
#import "ProductDB.h"
#import "ReceiptList.h"
#import "ReceiptItem.h"
#import "Inventory.h"
#import "CommonUtil.h"
#import "HandoverMaster.h"
#import "HandoverItem.h"
#import "DamageList.h"
#import "DamageItem.h"
#import "DamagedProductPicture.h"
#import "HandoverMaster.h"
#import "HandoverItem.h"
#import "LastReturnOrder.h"
#import "LastReturnOrderItem.h"
#import "ReportLog.h"
#import "SalesOrder.h"
#import "SalesOrderItem.h"
#import "SSZipArchive.h"

@interface ReceiptDB : NSObject

+(NSString*) createNo:(NSString*) type flightNo:(NSString*)flightNo flightDate:(NSString*)flightDate;

+(NSString*) receive:(ReceiptParam*) receiptParam userDict:(NSDictionary*) userDict;

+(NSString*) replenish:(ReplenishParam*) replenishParam userDict:(NSDictionary*) userDict;

+(NSString*) inventory:(InventoryParam*) inventoryParam userDict:(NSDictionary*) userDict;

+(NSString*) transfer:(TransferParam*) transferParam userDict:(NSDictionary*) userDict;

+ (void) inventoryChange:(NSString*) newFlightNo oldFlightNo:(NSString*)oldFlightNo flightDate:(NSString*)flightDate;

+ (NSString*) autoInventory:(NSDictionary*) userDict;

+(NSString*) lastReturn:(LastReturnParam*) lastReturnParam userDict:(NSDictionary*) userDict;

+(BOOL) hasNotTrans:(NSString*) flightNo flightDate:(NSString*) flightDate tailNo:(NSString*) tailNo acType:(NSString*)acType;

+(void) createReportLog:(NSString*) flightNo flightDate:(NSString*) flightDate empNo:(NSString*) empNo;

+(BOOL) hasReportOrder:(NSString*) flightNo flightDate:(NSString*) flightDate empNo:(NSString*) empNo;

+(void)createReportFile;

@end
