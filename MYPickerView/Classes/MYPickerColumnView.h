//
//  TYTimerPickerColumnView.h
//  lottie-ios
//
//  Created by 温明妍 on 2019/8/29.
//

#import <UIKit/UIKit.h>

@class MYPickerColumnView;

@protocol TYDFTimerPickerColumnViewDelegate <NSObject>

@optional
- (void)pickerColumnView:(MYPickerColumnView *)pickerColumnView didSelectRow:(NSInteger)row;

@end


@interface MYPickerColumnView : UIView

@property(nonatomic, weak) id<TYDFTimerPickerColumnViewDelegate> delegate;

@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIFont *selectFont;
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *selectTextColor;

@property (nonatomic, strong) UIFont *middleTextFont;
@property (nonatomic, strong) UIColor *middleTextColor;
@property (nonatomic, strong) NSString *middleText;
@property (nonatomic, assign) CGFloat horizontalOffset;
@property (nonatomic, assign) CGFloat verticalOffset;

@property (nonatomic, assign) BOOL isScrollCycle;/** < 是否是循环*/

@property (nonatomic, strong) NSArray<NSAttributedString *> *datas; /**< 数据  */

- (void)selectRow:(NSInteger)row animated:(BOOL)animated;

- (void)selectRow:(NSInteger)row animated:(BOOL)animated callDelegate:(BOOL)callDelegate;

- (NSInteger)selectedRow;

- (void)reloadDatas;

@end
