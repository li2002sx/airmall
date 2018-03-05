//
//  StaffDB.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/2.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import "Staff.h"

#define tb_staff @"staff"

@interface StaffDB : NSObject

+(Staff*) getStaffByNoAndPass:(NSString*) no password:(NSString*) password;

@end
