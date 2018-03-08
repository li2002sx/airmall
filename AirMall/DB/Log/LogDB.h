//
//  LogDB.h
//  AirMall
//
//  Created by Jankie on 2018/3/8.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import "LogList.h"

@interface LogDB : NSObject

+(void) createLog:(LogList*)log;

@end
