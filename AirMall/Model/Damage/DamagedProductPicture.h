//
//  DamagedProductPicture.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/11.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

@interface DamagedProductPicture : NSObject

@property(nonatomic)NSString* DamagedNo;

@property(nonatomic)NSInteger ProductItemID;

@property(nonatomic)NSInteger ProductID;

@property(nonatomic)NSString* Sku;

@property(nonatomic)NSString* PictureUrl;

@end
