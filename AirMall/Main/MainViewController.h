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
#import "CommonDB.h"
#import "ReceiptDB.h"

@interface MainViewController : BaseViewController<WKNavigationDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *thisFlightNoLabel;

@property (weak, nonatomic) IBOutlet UILabel *lineCHNLabel;

@property (weak, nonatomic) IBOutlet UILabel *preFlightNoLabel;

@property (weak, nonatomic) IBOutlet UILabel *flightDurationLabel;

@property (weak, nonatomic) IBOutlet UILabel *flightTimeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *empPhotoImageView;

@property (weak, nonatomic) IBOutlet UILabel *empNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *empNoLabel;

@property (weak, nonatomic) IBOutlet UILabel *empJobLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastLoginTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *shrinkView;

@property (weak, nonatomic) IBOutlet UITableView *shrinkTableView;

@property (weak, nonatomic) IBOutlet UIView *openView;

@property (weak, nonatomic) IBOutlet UITableView *openTableView;


- (IBAction)btnFrashPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet UIButton *btnBackPressed;

@property (weak, nonatomic) IBOutlet WKWebView *webView;


@end
