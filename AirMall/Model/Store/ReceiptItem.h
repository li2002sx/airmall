//
//  ReceiptItem.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

@interface ReceiptItem : NSObject

@property(nonatomic)NSString* DeliveryNo;

@property(nonatomic)NSString* DiningCarNo;

@property(nonatomic)NSInteger ProductID;

@property(nonatomic)NSInteger ProductItemID;

@property(nonatomic)NSString* Sku;

@property(nonatomic)NSString* Barcode;

@property(nonatomic)NSString* ProductName;

@property(nonatomic)NSString* Unit;

@property(nonatomic)NSInteger NeedCounts;

@property(nonatomic)NSInteger ConfirmCounts;

@property(nonatomic)NSInteger DamagedCounts;

@property(nonatomic)NSString* DamagedReason;

@property(nonatomic)NSString* Remark;

@end
