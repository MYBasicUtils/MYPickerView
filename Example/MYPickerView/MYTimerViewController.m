
//
//  MYTimerViewController.m
//  MYPickerView_Example
//
//  Created by 温明妍 on 2019/9/4.
//  Copyright © 2019 wenmingyan1990@gmail.com. All rights reserved.
//

#import "MYTimerViewController.h"
#import "MYPickerView.h"

@interface MYTimerViewController () <MYPickerViewDataSource ,MYPickerViewDelegate>

@property (nonatomic, strong) MYPickerView *pickerView;

@end

@implementation MYTimerViewController

#pragma mark - --------------------dealloc ------------------
#pragma mark - --------------------life cycle--------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData {
    
}

- (void)initView {
    
}

#pragma mark - --------------------UITableViewDelegate--------------
#pragma mark - --------------------CustomDelegate--------------


- (NSInteger)numberOfComponentsInPickerView:(MYPickerView *)pickerView {
    return self.components;
}

- (NSInteger)hoursCount {
    NSInteger hour = self.model.dialogTimer / 60 / 60 + 1;
    return hour;
}

- (NSInteger)minutesCount {
    NSInteger hour = self.model.dialogTimer / 60 / 60;
    NSUInteger minute = (self.model.dialogTimer - hour * 60 * 60) / 60;
    if (self.hours.integerValue == hour && minute < 60) {
        return minute + 1;
    }
    return 60;
}

- (NSInteger)secondsCount {
    NSInteger hour = self.model.dialogTimer / 60 / 60 + 1;
    NSUInteger minute = (self.model.dialogTimer - (hour - 1) * 60 * 60) / 60;
    NSUInteger seconds = self.model.dialogTimer - (hour - 1) * 60 * 60 - minute * 60;
    if (self.hours.integerValue == hour - 1 && minute == self.minutes.integerValue) {
        return seconds + 1;
    }
    return 60;
}

- (NSInteger)pickerView:(MYPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger hour = self.model.dialogTimer / 60 / 60;
    if (hour) {
        if (component == 0) {
            return [self hoursCount];
        }
        if (component == 1) {
            return [self minutesCount];
        }
        if (component == 2) {
            return [self secondsCount];
        }
    } else {
        if (component == 0) {
            return [self minutesCount];
        }
        if (component == 1) {
            return [self secondsCount];
        }
    }
    return 0;
}

- (NSAttributedString *)pickerView:(MYPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *string = [NSString stringWithFormat:@"%.2ld",(long)row];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:TY_ScreenAdaptionLength(44) weight:UIFontWeightSemibold] range:NSMakeRange(0, 2)];
    [attrString addAttribute:NSForegroundColorAttributeName value:TY_HexColor(0x22242C) range:NSMakeRange(0, 2)];
    return attrString;
}

- (void)pickerView:(MYPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger sumHour = self.model.dialogTimer / 60 / 60;
    if (sumHour) {
        if (component == 0) {
            NSInteger hour = row;
            [pickerView reloadComponent:1];
            if (hour == sumHour) {
                if (self.components == 3) {
                    [pickerView reloadComponent:2];
                }
            }
            self.hours = [NSString stringWithFormat:@"%ld",hour];
            if (self.hours.integerValue == sumHour) {
                self.minutes = @"0";
            }
            if (self.hours.integerValue == sumHour) {
                self.seconds = @"0";
            }
        }
        if (component == 1) {
            NSInteger minute = row;
            self.minutes = [NSString stringWithFormat:@"%ld",minute];
            [pickerView reloadComponent:2];
        }
        if (component == 2) {
            NSInteger second = row;
            self.seconds = [NSString stringWithFormat:@"%ld",second];
        }
    } else {
        if (component == 0) {
            NSInteger minute = row;
            self.minutes = [NSString stringWithFormat:@"%ld",minute];
            [pickerView reloadComponent:1];
        }
        if (component == 1) {
            NSInteger second = row;
            self.seconds = [NSString stringWithFormat:@"%ld",second];
        }
    }
    
    self.timer = [self.hours integerValue] * 60 * 60 + [self.minutes integerValue] * 60 + [self.seconds integerValue];
    TYLogDebug(@"timer = %@,%@,%@",self.hours,self.minutes,self.seconds);
    if (self.centerEventBlock) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"timer"] = @(self.timer);
        self.centerEventBlock(dict);
    }
    if (self.timer == 0) {
        self.bottomBtn.enabled = NO;
    } else {
        self.bottomBtn.enabled = YES;
    }
}


- (CGFloat)rowHeightInPickerView:(MYPickerView *)pickerView forComponent:(NSInteger)component {
    return TY_ScreenAdaptionLength(60);
}

- (CGFloat)pickerView:(MYPickerView *)pickerView middleTextVerticalOffsetForcomponent:(NSInteger)component {
    return TY_ScreenAdaptionLength(-8);
}

- (CGFloat)pickerView:(MYPickerView *)pickerView middleTextHorizontalOffsetForcomponent:(NSInteger)component {
    return TY_ScreenAdaptionLength(40);
}

- (NSString *)pickerView:(MYPickerView *)pickerView middleTextForcomponent:(NSInteger)component {
    if (component == 0) {
        return @"时";
    }
    if (component == 1) {
        return @"分";
    }
    if (component == 2) {
        return @"秒";
    }
    return @"";
}

#pragma mark - --------------------Event Response--------------
#pragma mark - --------------------private methods--------------
#pragma mark - --------------------getters & setters & init members ------------------

- (MYPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[MYPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.lineHeight = 0;
        _pickerView.textFontOfSelectedRow = [UIFont systemFontOfSize:44 weight:UIFontWeightSemibold];
        _pickerView.textColorOfSelectedRow = [UIColor blackColor];
        _pickerView.textFontOfOtherRow =  [UIFont systemFontOfSize:30 weight:UIFontWeightSemibold];
        _pickerView.textColorOfOtherRow = [UIColor lightGrayColor];
        _pickerView.middleTextFont = [UIFont systemFontOfSize:14];
        _pickerView.isCycleScroll = YES;
        _pickerView.isHiddenMiddleText = NO;
    }
    return _pickerView;
}

@end
