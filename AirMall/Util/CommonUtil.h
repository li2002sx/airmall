//
//  CommonUtil.h
//  AirMall
//
//  Created by 李胜喜 on 2018/2/27.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "YYModel.h"

#define _ScreenWidth [UIScreen mainScreen].bounds.size.width
#define _ScreenHeight [UIScreen mainScreen].bounds.size.height

#define user_key @"USERKEY"


@interface CommonUtil : NSObject

+ (void)showOnlyText:(UIView *)view tips:(NSString *)tips;

+ (void)showLoading:(NSString *)text andHud:(MBProgressHUD *)hud;

+ (NSDate *) convertDateFromString:(NSString *)dateString;

+ (NSString *) convertDateToString:(NSDate *)date formatter:(NSString *)formatter;

+ (NSArray*) timeDiff:(NSDate *)date1 end:(NSDate *)date2;

@end
