//
//  LoginViewController.m
//  AirMall
//
//  Created by 李胜喜 on 2018/2/27.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController (){
    
    MBProgressHUD *_hud;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)dateChange:(id)sender {
    
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackgroud = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType1;
    datePicker.isHiddenMiddleText = false;
    datePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:false completion:nil];
//
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//
//    //设置时间格式
//    formatter.dateFormat = @"yyyy.MM.dd";
//    NSString *dateStr = [formatter  stringFromDate:_datePicker.date];
//    _fieldDate.text = dateStr;
}

- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
}

- (IBAction)loginPressed:(id)sender {
    
//    Staff* staff = [Staff new];
//    staff.bg_tableName = tb_staff;
//    staff.EmpNo = @"00001";
//    staff.EmpPassword = @"123456";
//    staff.EmpPhone = @"13800013800";
//    staff.EmpType = @"normal";
//    staff.IsActive = YES;
//    staff.CreateTime =  [NSDate date];
//    staff.UpdateTime =  [NSDate date];
//    staff.LastLoginTime =  [NSDate date];
//    [staff bg_save];
    
    NSString *name = _fieldName.text;
    if ([name length] <= 1) {
        [CommonUtil showOnlyTextDialog:self.view tips:@"用户名不能为空"];
        return;
    }

    NSString *password = _fieldPass.text;
    if ([password length] < 6) {
        [CommonUtil showOnlyTextDialog:self.view tips:@"密码位数必须大于等于6位"];
        return;
    }
    
    Staff* staff = [StaffDB getStaffByNoAndPass:name password:password];
    if(staff == nil){
        
    MainViewController *mainView= [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];

//    [self presentViewController:mainView animated:YES completion:nil];
        
    [self.navigationController pushViewController:mainView animated:YES];
        
      NSLog(@"%@", [staff yy_modelToJSONObject]);
    }else{
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [CommonUtil showOnlyTextDialog:self.view tips:@"没有找到对应的用户"];
    }
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
