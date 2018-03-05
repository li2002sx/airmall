//
//  CommonUtil.m
//  AirMall
//
//  Created by 李胜喜 on 2018/2/27.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil

+ (void)showOnlyTextDialog:(UIView *)view tips:(NSString *)tips{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.labelText = tips;
    hud.mode = MBProgressHUDModeText;
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
}

+ (void)showHud:(NSString *)text andView:(UIView *)view andHud:(MBProgressHUD *)hud{
    [view addSubview:hud];
    hud.labelText = text;//显示提示
    hud.dimBackground = NO;//使背景成黑灰色，让MBProgressHUD成高亮显示
    hud.square = YES;//设置显示框的高度和宽度一样
    [hud show:YES];
}

@end
