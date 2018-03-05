//
//  HandoverMaster.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

@interface HandoverMaster : NSObject

@property(nonatomic)NSInteger HandoverID;

@property(nonatomic)NSString* HandoverNo;

@property(nonatomic)NSInteger PreFlightID;

@property(nonatomic)NSInteger FlightID;

@property(nonatomic)NSString* Type;

@property(nonatomic)NSInteger Status;

@property(nonatomic)NSInteger HandoverCounts;

@property(nonatomic)NSInteger HandoverDamagedCounts;

@property(nonatomic)NSInteger HandoverEmpId;

@property(nonatomic)NSString* HandoverEmpName;

@property(nonatomic)NSDate* HandoverTime;

@property(nonatomic)NSInteger UndertakeCounts;

@property(nonatomic)NSInteger UndertakeDamagedCounts;

@property(nonatomic)NSString* UndertakeEmpId;

@property(nonatomic)NSString* UndertakeEmpName;

@property(nonatomic)NSDate* UndertakeTime;

@property(nonatomic)NSString* Remark;

@end
