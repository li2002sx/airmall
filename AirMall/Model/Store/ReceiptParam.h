//
//  ReceiptParam.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/6.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiptParam : NSObject

@property(nonatomic)NSString* deliveryNo;

@property(nonatomic)NSString* message;

@property(nonatomic)NSArray* deliveryList;

@end

@interface ReceiptSku : NSObject

@property(nonatomic)NSString* sku;

@property(nonatomic)NSString* diningCarNo;

@property(nonatomic)NSInteger confirmCount;

@property(nonatomic)NSInteger damagedCount;

@property(nonatomic)NSString* damagedReason;

@property(nonatomic)NSString* damagedReasonDesc;

@property(nonatomic)NSArray* imageBase64s;

@end

@interface ReplenishParam : NSObject

@property(nonatomic)NSArray* replenishList;

@end

@interface ReplenishSku : NSObject

@property(nonatomic)NSString* sku;

@property(nonatomic)NSString* diningCarNo;

@property(nonatomic)NSInteger needCount;

@end

@interface InventoryParam : NSObject

@property(nonatomic)NSArray* inventoryList;

@end

@interface InventorySku : NSObject

@property(nonatomic)NSString* sku;

@property(nonatomic)NSString* diningCarNo;

@property(nonatomic)NSInteger handoverCount;

@property(nonatomic)NSInteger damagedCount;

@end

@interface TransferParam : NSObject

@property(nonatomic)NSString* handoverNo;

@property(nonatomic)NSArray* transferList;

@end

@interface TransferSku : NSObject

@property(nonatomic)NSString* sku;

@property(nonatomic)NSString* diningCarNo;

@property(nonatomic)NSInteger handoverCount;

@property(nonatomic)NSInteger damagedCount;

@property(nonatomic)NSString* damagedReason;

@property(nonatomic)NSString* damagedReasonDesc;

@property(nonatomic)NSArray* imageBase64s;

@end

