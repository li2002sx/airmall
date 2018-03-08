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
    datePickManager.cancelButtonText = @"取消";
    datePickManager.confirmButtonText = @"确定";
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType1;
    datePicker.isHiddenMiddleText = false;
    datePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:false completion:nil];
}

- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDate* date = [calendar dateFromComponents:dateComponents];
    NSString* flightDate = [CommonUtil convertDateToString:date formatter:@"yyyy-MM-dd"];
    _fieldDate.text = flightDate;
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
    
//    Cart* cart = [Cart new];
//    [cart bg_save];
    
    NSString *flightNo = _filedFlightNo.text;
    if ([flightNo length] <= 3) {
        [CommonUtil showOnlyText:self.view tips:@"航班号不能为空"];
        return;
    }
    
    NSString *flightDate = _fieldDate.text;
    if ([flightDate length] <= 3) {
        [CommonUtil showOnlyText:self.view tips:@"航班日期不能为空"];
        return;
    }
    
    NSString *empNo = _fieldName.text;
    if ([empNo length] <= 1) {
        [CommonUtil showOnlyText:self.view tips:@"员工号不能为空"];
        return;
    }

    NSString *password = _fieldPass.text;
    if ([password length] < 1) {
        [CommonUtil showOnlyText:self.view tips:@"密码不能为空"];
        return;
    }
    
    id result = [StaffDB staffLogin:flightNo flightDate:flightDate empNo:empNo password:password];
    if(result != nil){
        [StaffDB updateLastLoginTime:empNo];
        [result setObject:[CommonUtil convertDateToString:[NSDate new] formatter:@"yyyy年M月d HH:mm:ss"] forKey:@"LastLoginTime"];
        [_userInfo setValue:result forKey:user_key];
        
    MainViewController *mainView= [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];

//    [self presentViewController:mainView animated:YES completion:nil];
        
    [self.navigationController pushViewController:mainView animated:YES];
        
//      NSLog(@"%@", [staff yy_modelToJSONObject]);
    }else{
        [CommonUtil showOnlyText:self.navigationController.view tips:@"没有找到对应的信息，请检查输入！"];
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
