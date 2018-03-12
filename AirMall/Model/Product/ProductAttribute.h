//
//  ProductAttribute.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/11.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

@interface ProductAttribute : NSObject

@property(nonatomic)NSInteger ProductItemID;

@property(nonatomic)NSString* AttributeName;

@property(nonatomic)NSString* AttributeValue;

@property(nonatomic)NSInteger DisplayOrder;

@end
