//
//  TYDFTimerPickerTableViewCell.h
//  TuyaInc
//
//  Created by TuyaInc on 2019/5/7.
//  Copyright © 2019 明妍. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYPickerColumnCell : UITableViewCell

@property (nonatomic, weak) UILabel *label;

@property (nonatomic, strong) UIFont *normalFont;// default is 14
@property (nonatomic, strong) UIFont *selectFont;// defalut is 16 medium
@property (nonatomic, strong) UIColor *normalTextColor;// defalut is black
@property (nonatomic, strong) UIColor *selectTextColor;// default is black

@property (nonatomic, assign) BOOL cellSelected;

- (void)cellOffsetOnTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
