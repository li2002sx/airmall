//
//  SynInfoTableViewCell.h
//  AirMall
//
//  Created by 李胜喜 on 2018/3/3.
//  Copyright © 2018年 jankie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SynInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftIconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end
