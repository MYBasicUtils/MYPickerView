//
//  TYDFTimerPickerTableViewCell.m
//  TuyaInc
//
//  Created by TuyaInc on 2019/5/7.
//  Copyright © 2019 明妍. All rights reserved.
//

#import "MYPickerColumnCell.h"

@implementation MYPickerColumnCell

#define kContentFont 17

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)cellOffsetOnTableView:(UITableView *)tableView {
    CGFloat cellHeight = self.frame.size.height;
    if (!cellHeight) {
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        if (self.frame.origin.y < tableView.contentOffset.y + cellHeight * 0.5) {
            self.label.textColor = self.normalTextColor;
            self.label.font = self.normalFont;
            self.cellSelected = NO;
        } else if (self.frame.origin.y < tableView.contentOffset.y + cellHeight * 1.5) {
            self.label.textColor = self.selectTextColor;
            self.label.font = self.selectFont;
            self.cellSelected = YES;
        } else {
            self.label.textColor = self.normalTextColor;
            self.label.font = self.normalFont;
            self.cellSelected = YES;
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.contentView.bounds;
}

#pragma Getter
- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc]initWithFrame:self.contentView.bounds];
        label.font = [UIFont systemFontOfSize:kContentFont];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _label = label;
    }
    return _label;
}

@end
