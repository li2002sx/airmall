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

@property(nonatomic,copy)NSString* EmpNo;

@property(nonatomic,copy)NSString* EmpName;

@property(nonatomic,copy)NSString* EmpPassword;

@property(nonatomic,copy)NSString* EmpPhone;

@property(nonatomic,copy)NSString* EmpType;

@property(nonatomic,copy)NSString* Avatar;

@property(nonatomic,assign)int IsActive;

@property(nonatomic,strong)NSString* CreateTime;

@property(nonatomic,strong)NSString* UpdateTime;

@property(nonatomic,strong)NSString* LastLoginTime;

@end

