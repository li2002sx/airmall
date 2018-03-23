//
//  CommonUtil.m
//  AirMall
//
//  Created by 李胜喜 on 2018/2/27.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil

+ (NSString *) md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//根据当前参数获取Sign的参数结合，用于加密
+ (NSMutableDictionary *) createCommonArgs:(NSMutableDictionary *) params{

    NSMutableDictionary* args = params;
    
    float timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *timestampStr = [NSString stringWithFormat:@"%0.f",timestamp];
    [params setValue:timestampStr forKey:@"Timestamp"];
    [params setValue:@_CustomerNo forKey:@"CustomerNo"];
    //键排序
    NSArray *sortedArray = [[params allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 lowercaseString] compare:[obj2 lowercaseString] options:NSNumericSearch];
    }];
    
    NSMutableString *mergeArgs = [[NSMutableString alloc] init];
    for (id key in sortedArray) {
        NSString *value = [NSString stringWithFormat:@"%@",params[key]];
        [mergeArgs appendFormat:@"%@=%@",key,value];
    }
    [mergeArgs appendString:@_CustomerKey];
    
    NSString *md5Verify = [[CommonUtil md5:mergeArgs] uppercaseString];
    
    
    [args setValue:timestampStr forKey:@"Timestamp"];
    [args setValue:@_CustomerNo forKey:@"CustomerNo"];
    [args setValue:md5Verify forKey:@"Signature"];
    
    return args;
    
}

+ (void)showOnlyText:(UIView *)view tips:(NSString *)tips{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = tips;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.5f];
    // Move to bottm center.
//    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    [hud hideAnimated:YES afterDelay:2.f];
}

+ (void)showLoading:(NSString *)text andHud:(MBProgressHUD *)hud{
    
    hud.label.text = text;
//    // Change the background view style and color.
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.5f];
}

+ (NSDate *) convertDateFromString:(NSString *)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

+ (NSDate *) convertDateTimeFromString:(NSString *)dateString{
    
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

+ (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (BOOL) imageHasAlpha: (UIImage *) image{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

+ (NSString*) image2DataURL: (UIImage *) image{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
}

@end
