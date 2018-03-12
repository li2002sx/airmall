//
//  DamageItem.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

@interface DamageItem : NSObject

@property(nonatomic)NSString* DamagedNo;

@property(nonatomic)NSInteger ProductID;

@property(nonatomic)NSInteger ProductItemID;

@property(nonatomic)NSString* Sku;

@property(nonatomic)NSString* Barcode;

@property(nonatomic)NSString* ProductName;

@property(nonatomic)NSString* Unit;

@property(nonatomic)NSString* Quantity;

@property(nonatomic)NSString* DamagedReason;

@property(nonatomic)NSString* ImageUrl;

@property(nonatomic)NSString* CreateTime;

@end
