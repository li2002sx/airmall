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
    // Do any additional setup after loading the view.
    bg_setDebug(YES);//打开调试模式,打印输出调试信息.
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    _userInfo = [NSUserDefaults standardUserDefaults];
//    id userObj = [_userInfo objectForKey:_UserKey];
//    if([userObj isEqualToString:@""]){
//        _userDict = [NSMutableDictionary new];
//    }else{
//        _userDict = [NSMutableDictionary dictionaryWithDictionary:userObj];
//    }
    
    bg_setSqliteName(@"AirMall");
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);

    _identifierNumber = [SAMKeychain passwordForService:@_AppService account:@_UUIDAcount];
    if (!_identifierNumber){
        [SAMKeychain setPassword: [NSString stringWithFormat:@"%@", uuidStr] forService:@_AppService account:@_UUIDAcount];
        _identifierNumber = [SAMKeychain passwordForService:@_AppService account:@_UUIDAcount];
    }
    NSLog(@"identifierNumber:%@",_identifierNumber);
}

- (void)viewWillAppear:(BOOL)animated{
    
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
