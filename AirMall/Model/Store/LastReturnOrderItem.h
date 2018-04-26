//
//  LastReturnOrderItem.h
//  AirMall
//
//  Created by 李胜喜 on 2018/4/20.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

@interface LastReturnOrderItem : NSObject

@property(nonatomic)NSString* ReturnOrderNo;

@property(nonatomic)NSInteger ProductID;

@property(nonatomic)NSInteger ProductItemID;

@property(nonatomic)NSString* Sku;

@property(nonatomic)NSString* DiningCarNo;

@property(nonatomic)NSString* Barcode;

@property(nonatomic)NSString* ProductName;

@property(nonatomic)NSString* Unit;

@property(nonatomic)NSString* Quantity;

@property(nonatomic)NSString* Remark;

@end
