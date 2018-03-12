//
//  HandoverMaster.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"
#import "HandoverItem.h"

@interface HandoverMaster : NSObject

@property(nonatomic)NSString* HandoverNo;

@property(nonatomic)NSInteger PreFlightNo;

@property(nonatomic)NSString* FlightNo;

@property(nonatomic)NSString* FlightDate;

@property(nonatomic)NSString* TailNo;

@property(nonatomic)NSString* ACType;

@property(nonatomic)NSString* Type;

@property(nonatomic)NSInteger Status;

@property(nonatomic)NSInteger HandoverCounts;

@property(nonatomic)NSInteger HandoverDamagedCounts;

@property(nonatomic)NSString* HandoverEmpNo;

@property(nonatomic)NSString* HandoverEmpName;

@property(nonatomic)NSString* HandoverDeviceNo;

@property(nonatomic)NSString* HandoverTime;

@property(nonatomic)NSInteger UndertakeCounts;

@property(nonatomic)NSInteger UndertakeDamagedCounts;

@property(nonatomic)NSString* UndertakeEmpNo;

@property(nonatomic)NSString* UndertakeEmpName;

@property(nonatomic)NSString* UndertakeDeviceNo;

@property(nonatomic)NSString* UndertakeTime;

@property(nonatomic)NSString* Remark;

@property NSArray<HandoverItem*>* Items;

@property(nonatomic)NSInteger Syn;

@end
