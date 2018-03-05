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

@property(nonatomic)NSInteger ID;

@property(nonatomic)NSInteger DamageID;

@property(nonatomic)NSString* ImageUrl;

@property(nonatomic)NSDate* CreateTime;

@end
