//
//  TYDFTimerTableView.m
//  TuyaInc
//
//  Created by TuyaInc on 2019/5/7.
//  Copyright © 2019 明妍. All rights reserved.
//

#import "MYPickerTableView.h"

@implementation MYPickerTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tableFooterView = [UIView new];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.scrollsToTop = false;
    }
    return self;
}

@end
