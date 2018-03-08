//
//  CommonUtil.m
//  AirMall
//
//  Created by 李胜喜 on 2018/2/27.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil

+ (void)showOnlyText:(UIView *)view tips:(NSString *)tips{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = tips;
//    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.5f];
    // Move to bottm center.
//    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    [hud hideAnimated:YES afterDelay:2.f];
}

+ (void)showLoading:(NSString *)text andHud:(MBProgressHUD *)hud{
    
    hud.label.text = NSLocalizedString(text, @"");
//    // Change the background view style and color.
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.5f];
}

+ (NSDate *) convertDateFromString:(NSString *)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

+ (NSString *) convertDateToString:(NSDate *)date formatter:(NSString *)formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setDateFormat:formatter];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return  dateString;
}

+ (NSMutableDictionary*) timeDiff:(NSDate *)date1 end:(NSDate *)date2{
    NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
    NSInteger interval1 = [zone1 secondsFromGMTForDate:date1];
    NSDate *localDate1 = [date1 dateByAddingTimeInterval:interval1];
    
    NSTimeZone *zone2 = [NSTimeZone systemTimeZone];
    NSInteger interval2 = [zone2 secondsFromGMTForDate:date2];
    NSDate *localDate2 = [date2 dateByAddingTimeInterval:interval2];
    
    double intervalTime = [localDate2 timeIntervalSinceReferenceDate] - [localDate1 timeIntervalSinceReferenceDate];
    
    NSInteger year = intervalTime/3600/24/365;
    NSInteger month = (intervalTime - year * 3600 * 24 * 365)/3600/24/12;
    NSInteger day = (intervalTime - year * 3600 * 24 * 365 - month * 3600 * 24 * 12)/3600/24;
    NSInteger hour = (intervalTime - year * 3600 * 24 * 365 - month * 3600 * 24 * 12 - day * 3600 * 24) / 3600;
    NSInteger minute = (intervalTime - year * 3600 * 24 * 365 - month * 3600 * 24 * 12 - day * 3600 * 24 - hour * 3600) / 60;
    
    NSInteger second = intervalTime - year * 3600 * 24 * 365 - month * 3600 * 24 * 12 - day * 3600 * 24 - hour * 3600 - minute * 60;
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setValue:[NSString stringWithFormat:@"%ld",year] forKey:@"year"];
    [dict setValue:[NSString stringWithFormat:@"%ld",month] forKey:@"month"];
    [dict setValue:[NSString stringWithFormat:@"%ld",day] forKey:@"day"];
    [dict setValue:[NSString stringWithFormat:@"%ld",hour] forKey:@"hour"];
    [dict setValue:[NSString stringWithFormat:@"%ld",minute] forKey:@"minute"];
    [dict setValue:[NSString stringWithFormat:@"%ld",second] forKey:@"second"];
    
    return dict;
}

@end
