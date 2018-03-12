//
//  HandoverItem.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

@interface HandoverItem : NSObject

@property(nonatomic)NSString* HandoverNo;

@property(nonatomic)NSString* DiningCarNo;

@property(nonatomic)NSInteger ProductID;

@property(nonatomic)NSInteger ProductItemID;

@property(nonatomic)NSString* Sku;

@property(nonatomic)NSString* Barcode;

@property(nonatomic)NSString* ProductName;

@property(nonatomic)NSString* Unit;

@property(nonatomic)NSInteger HandoverCounts;

@property(nonatomic)NSInteger HandoverDamagedCounts;

@property(nonatomic)NSInteger UndertakeCounts;

@property(nonatomic)NSInteger UndertakeDamagedCounts;

@property(nonatomic)NSString* Remark;

@end
