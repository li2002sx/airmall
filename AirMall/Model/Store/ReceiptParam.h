//
//  ReceiptParam.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/6.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiptParam : NSObject

@property(nonatomic)NSInteger deliveryID;

@property(nonatomic)NSString* message;

@property(nonatomic)NSArray* deliveryList;

@end

@interface ReceiptSku : NSObject

@property(nonatomic)NSString* sku;

@property(nonatomic)NSInteger confirmCount;

@property(nonatomic)NSInteger damagedCount;

@property(nonatomic)NSString* damagedReason;

@property(nonatomic)NSString* damagedReasonDesc;

@property(nonatomic)NSString* imageBase64;

@end

@interface ReplenishParam : NSObject

@property(nonatomic)NSArray* replenishList;

@end

@interface ReplenishSku : NSObject

@property(nonatomic)NSString* sku;

@property(nonatomic)NSInteger needCount;

@end

