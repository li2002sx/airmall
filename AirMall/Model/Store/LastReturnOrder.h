//
//  LastReturnOrder.h
//  AirMall
//
//  Created by 李胜喜 on 2018/4/20.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LastReturnOrderItem.h"
#import "BGFMDB.h"

@interface LastReturnOrder : NSObject

@property(nonatomic)NSString* ReturnOrderNo;

@property(nonatomic)NSString* FlightNo;

@property(nonatomic)NSString* FlightDate;

@property(nonatomic)NSString* EmpNo;

@property(nonatomic)NSString* DeviceNo;

@property(nonatomic)NSString* CreateTime;

@property NSArray<LastReturnOrderItem*>* Items;

@property(nonatomic)NSInteger Syn;

@end
