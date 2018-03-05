//
//  ProductItem.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

@interface ProductItem : NSObject

@property(nonatomic)NSInteger ItemID;

@property(nonatomic)NSString* Sku;

@property(nonatomic)NSInteger ProductID;

@property(nonatomic)NSString* Barcode;

@property(nonatomic)NSString* Description;

@property(nonatomic)NSString* AttributeName;

@property(nonatomic)NSString* AttributeValue;

@property(nonatomic)float Price;

@property(nonatomic)float Discount;

@property(nonatomic)NSString* Size;

@property(nonatomic)NSString* ImageUrl;

@property(nonatomic)NSString* Remark1;

@property(nonatomic)NSString* Remark2;

@property(nonatomic)NSString* Remark3;

@property(nonatomic)NSString* Remark4;
@end
