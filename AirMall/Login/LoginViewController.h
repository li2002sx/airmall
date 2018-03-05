//
//  LoginViewController.h
//  AirMall
//
//  Created by 李胜喜 on 2018/2/27.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "BaseViewController.h"
#import "MainViewController.h"
#import "StaffDB.h"
#import "PGDatePickManager.h"

@interface LoginViewController : BaseViewController<PGDatePickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *fieldDate;

@property (weak, nonatomic) IBOutlet UITextField *fieldName;

@property (weak, nonatomic) IBOutlet UITextField *fieldPass;

- (IBAction)dateChange:(id)sender;

- (IBAction)loginPressed:(id)sender;

@end
