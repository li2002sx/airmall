//
//  BaseViewController.m
//  AirMall
//
//  Created by 李胜喜 on 2018/2/27.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifi:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    // Do any additional setup after loading the view.
    bg_setDebug(YES);//打开调试模式,打印输出调试信息.
    self.navigationController.navigationBar.hidden = YES;
    _userInfo = [NSUserDefaults standardUserDefaults];
    _userDict = [NSMutableDictionary dictionaryWithDictionary:[_userInfo objectForKey: user_key]];
    
    bg_setSqliteName(@"AriMall");
}

- (void)notifi:(NSNotification *)notifi{
    NSDictionary *dic = notifi.userInfo;
    //获取网络状态
    NSInteger status = [[dic objectForKey:@"AFNetworkingReachabilityNotificationStatusItem"] integerValue];
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            NSLog(@"无法获取网络状态");
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            NSLog(@"移动蜂窝网络");
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            NSLog(@"wifi上网");
            break;
        case AFNetworkReachabilityStatusNotReachable:
            NSLog(@"无网络连接");
            break;
        default:
            break;
    }
}

- (void)dealloc {
    //注销监听者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
