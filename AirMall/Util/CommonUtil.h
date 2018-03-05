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

@interface CommonUtil : NSObject

+ (void)showOnlyTextDialog:(UIView *)view tips:(NSString *)tips;

+ (void)showHud:(NSString *)text andView:(UIView *)view andHud:(MBProgressHUD *)hud;

@end
