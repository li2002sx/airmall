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

@interface ReceiptDB : NSObject

+(CommonResult*) receive:(ReceiptParam*) receiptParam userDict:(NSDictionary*) userDict;

@end
