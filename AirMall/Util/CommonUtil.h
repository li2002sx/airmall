//
//  CommonUtil.h
//  AirMall
//
//  Created by 李胜喜 on 2018/2/27.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "MBProgressHUD.h"
#import "YYModel.h"

#define _ScreenWidth [UIScreen mainScreen].bounds.size.width
#define _ScreenHeight [UIScreen mainScreen].bounds.size.height

#define _UserKey @"UserKey"
#define _AppService "com.project.airmall"
#define _UUIDAcount "uuid"

#define _BaseUrl "http://180.169.45.158:5678/pages/"

#define _ApiUrl "http://111.13.20.215/"
#define _CustomerNo "CUS0001"
#define _CustomerKey "d939820a079f684b"

@interface CommonUtil : NSObject

+ (NSString *) md5:(NSString *)str;

+ (NSMutableDictionary *) createCommonArgs:(NSMutableDictionary *) params;

+ (void)showOnlyText:(UIView *)view tips:(NSString *)tips;

+ (void)showLoading:(NSString *)text andHud:(MBProgressHUD *)hud;

+ (NSDate *) convertDateFromString:(NSString *)dateString;

+ (NSDate *) convertDateTimeFromString:(NSString *)dateString;

+ (NSString *) convertDateToString:(NSDate *)date formatter:(NSString *)formatter;

+ (NSArray*) timeDiff:(NSDate *)date1 end:(NSDate *)date2;

+ (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

+ (BOOL) imageHasAlpha: (UIImage *) image;

+ (NSString*) image2DataURL: (UIImage *) image;

@end
