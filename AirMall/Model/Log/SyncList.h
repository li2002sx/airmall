//
//  SyncList.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

@interface SyncList : NSObject

@property(nonatomic)NSString* SyncNo;

@property(nonatomic)NSDate* SyncTime;

@property(nonatomic)NSString* ReceiveTime;

@property(nonatomic)NSInteger* SyncState;

@end
