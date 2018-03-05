//
//  Staff.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/2.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

@interface Staff : NSObject

@property(nonatomic)NSInteger EmpID;

@property(nonatomic,copy)NSString* EmpNo;

@property(nonatomic,copy)NSString* EmpPassword;

@property(nonatomic,copy)NSString* EmpPhone;

@property(nonatomic,copy)NSString* EmpType;

@property(nonatomic,assign)BOOL IsActive;

@property(nonatomic,strong)NSDate* CreateTime;

@property(nonatomic,strong)NSDate* UpdateTime;

@property(nonatomic,strong)NSDate* LastLoginTime;

@end
