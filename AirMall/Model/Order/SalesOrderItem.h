//
//  SalesOrderItem.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

@interface SalesOrderItem : NSObject

@property(nonatomic)NSInteger ID;

@property(nonatomic)NSInteger OrderID;

@property(nonatomic)NSInteger ProductID;

@property(nonatomic)NSString* Sku;

@property(nonatomic)NSString* SkuName;

@property(nonatomic)NSString* Barcode;

@property(nonatomic)float UnitPrice;

@property(nonatomic)float DiscountFee;

@property(nonatomic)NSInteger Quantity;

@property(nonatomic)NSString* Unit;

@property(nonatomic)NSString* Remark;

@end
