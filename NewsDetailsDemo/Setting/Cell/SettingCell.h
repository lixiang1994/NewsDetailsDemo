//
//  SettingCell.h
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/20.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SettingModel.h"

@interface SettingCell : UITableViewCell

@property (nonatomic , strong ) SettingModel *model;

@property (nonatomic , copy ) void (^switchClickBlock)(SettingType, BOOL);

@end
