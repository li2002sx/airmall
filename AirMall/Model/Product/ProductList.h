//
//  ProductList.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"
#import "ProductItem.h"
#import "ProductPicture.h"

@class ProductList;

@interface ProductList : NSObject

@property(nonatomic)NSInteger ProductID;

@property(nonatomic)NSString* ProductName;

@property(nonatomic)NSString* Category1;

@property(nonatomic)NSString* Category2;

@property(nonatomic)NSString* Category3;

@property(nonatomic)NSString* Property;

@property(nonatomic)NSString* Unit;

@property(nonatomic)NSString* ImageUrl;

@property(nonatomic)NSString* ProductType;

@property(nonatomic)NSInteger SupplierID;

@property(nonatomic)NSString* SupplierName;

@property(nonatomic)NSString* ShelfLife;

@property(nonatomic)NSString* ProductionDate;

@property(nonatomic)NSString* ProductOrigin;

@property(nonatomic)NSString* ProductIdentification;

@property(nonatomic)NSString* UpdateTime;

@property(nonatomic)NSString* Remark1;

@property(nonatomic)NSString* Remark2;

@property(nonatomic)NSString* Remark3;

@property(nonatomic)NSString* Remark4;

@property NSArray<ProductItem *>* Items;

@property NSArray<ProductPicture *>* Pictures;

@end
