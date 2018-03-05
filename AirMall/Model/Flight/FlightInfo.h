//
//  FlightInfo.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/5.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

@interface FlightInfo : NSObject

@property(nonatomic)NSInteger FlightID;

@property(nonatomic)NSDate* FlightDate;

@property(nonatomic)NSString* Carrier;

@property(nonatomic)NSString* FlightNo;

@property(nonatomic)NSString* LineEng;

@property(nonatomic)NSString* LineCHN;

@property(nonatomic)NSString* TailNo;

@property(nonatomic)NSString* ACType;

@property(nonatomic)NSDate* DeptTime;

@property(nonatomic)NSDate* ArrTime;

@property(nonatomic)NSDate* ActualDeptTime;

@property(nonatomic)NSDate* ActualArrTime;

@property(nonatomic)NSString* IntOrDom;

@property(nonatomic)NSString* FlightProp;

@property(nonatomic)NSInteger AirCrewAmoubt;

@property(nonatomic)NSInteger FirstClassAmount;

@property(nonatomic)NSInteger EconomyClassAmount;

@property(nonatomic)NSInteger MileAge;

@end
