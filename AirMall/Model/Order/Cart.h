//
//  Cart.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/7.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"
#import "CommonResult.h"

@interface Cart : NSObject

//@property(nonatomic)NSInteger CartID;

@property(nonatomic)NSString* DiningCarNo;

@property(nonatomic)NSInteger ProductID;

@property(nonatomic)NSInteger ProductItemID;

@property(nonatomic)NSString* Sku;

@property(nonatomic)NSString* Barcode;

@property(nonatomic)NSString* ProductName;

@property(nonatomic)NSString* Unit;

@property(nonatomic)float Price;

@property(nonatomic)float Discount;

@property(nonatomic)NSInteger Quantity;

@end

@interface AddCartResult : CommonResult

//@property(nonatomic)NSInteger cartId;

@end

@interface CreateOrderParam : NSObject

@property(nonatomic)NSString* firstName;

@property(nonatomic)NSString* lastName;

@property(nonatomic)NSString* mobile;

@property(nonatomic)NSString* remark;

@end
