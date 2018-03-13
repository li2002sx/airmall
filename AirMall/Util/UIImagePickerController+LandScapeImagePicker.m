//
//  UIImagePickerController+LandScapeImagePicker.m
//  AirMall
//
//  Created by 李胜喜 on 2018/3/13.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import "UIImagePickerController+LandScapeImagePicker.h"

@implementation UIImagePickerController (LandScapeImagePicker)

- (BOOL)shouldAutorotate {
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscape;
}

@end
