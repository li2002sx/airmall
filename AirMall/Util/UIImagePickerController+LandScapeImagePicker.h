//
//  UIImagePickerController+LandScapeImagePicker.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/13.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (LandScapeImagePicker)

- (BOOL)shouldAutorotate;

- (NSUInteger)supportedInterfaceOrientations;

@end
