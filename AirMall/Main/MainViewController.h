//
//  MainViewController.h
//  AirMall
//
//  Created by 李胜喜 on 2018/2/27.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
#import "WebViewJavascriptBridge.h"
#import "LoginViewController.h"
#import "KLCPopup.h"
#import "ShrinkMenuTableViewCell.h"
#import "OpenMenuTableViewCell.h"

@interface MainViewController : BaseViewController<WKNavigationDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *shrinkView;

@property (weak, nonatomic) IBOutlet UITableView *shrinkTableView;

@property (weak, nonatomic) IBOutlet UIView *openView;

@property (weak, nonatomic) IBOutlet UITableView *openTableView;

@property (weak, nonatomic) IBOutlet UIButton *btnMenu;

- (IBAction)btnMenuPressed:(id)sender;

- (IBAction)btnFrashPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet UIButton *btnBackPressed;

@property (weak, nonatomic) IBOutlet WKWebView *webView;

@property (weak, nonatomic) IBOutlet UIView *menuView;


- (IBAction)logoutPressed:(id)sender;

@end
