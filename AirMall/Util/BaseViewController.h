//
//  BaseViewController.h
//  AirMall
//
//  Created by 李胜喜 on 2018/2/27.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking/AFNetworking.h"
#import "CommonUtil.h"
#import "BGFMDB.h"

@interface BaseViewController : UIViewController{
    NSUserDefaults *_userInfo;
    NSDictionary* _userDict;
}

@end
