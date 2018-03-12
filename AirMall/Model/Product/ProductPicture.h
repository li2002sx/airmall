//
//  ProductPicture.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/11.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

@interface ProductPicture : NSObject

@property(nonatomic)NSInteger ProductID;

@property(nonatomic)NSString* PictureType;

@property(nonatomic)NSString* PictureUrl;

@property(nonatomic)NSInteger DisplayOrder;

@end
