//
//  CommonResult.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/6.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"


@interface CommonResult : NSObject

@property(nonatomic)NSInteger status;

@property(nonatomic,copy)NSString* message;

@end

@interface SelectListResult : CommonResult

@property(nonatomic)NSArray* list;

@end

@interface SelectListForPageResult : CommonResult

@property(nonatomic)NSInteger totalCount;

@property(nonatomic)NSArray* list;

@end

@interface LoginInfoResult : CommonResult

@property(nonatomic)id userInfo;

@end
