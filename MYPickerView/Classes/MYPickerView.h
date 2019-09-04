//
//  MYPickerView.h
//  MYPickerView
//
//  Created by 温明妍 on 2019/8/29.
//  不带弧度的PickerView 内部使用UITableView实现

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MYPickerView;

@protocol MYPickerViewDataSource<NSObject>
@required
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(MYPickerView *)pickerView;

// returns the # of rows in each component..
- (NSInteger)pickerView:(MYPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
@end

@protocol MYPickerViewDelegate<NSObject>
@optional
// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(MYPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (NSAttributedString *)pickerView:(MYPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component; // attributed title is favored if both methods are implemented
- (UIColor *)pickerView:(MYPickerView *)pickerView viewBackgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component;

- (void)pickerView:(MYPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)pickerView:(MYPickerView *)pickerView title:(NSString *)title didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

- (CGFloat)rowHeightInPickerView:(MYPickerView *)pickerView forComponent:(NSInteger)component;

- (NSString *)pickerView:(MYPickerView *)pickerView middleTextForcomponent:(NSInteger)component;
- (CGFloat)pickerView:(MYPickerView *)pickerView middleTextHorizontalOffsetForcomponent:(NSInteger)component;
- (CGFloat)pickerView:(MYPickerView *)pickerView middleTextVerticalOffsetForcomponent:(NSInteger)component;

- (UIFont *)pickerView:(MYPickerView *)pickerView textFontOfSelectedRowInComponent:(NSInteger)component;
- (UIFont *)pickerView:(MYPickerView *)pickerView textFontOfOtherRowInComponent:(NSInteger)component;

- (UIColor *)pickerView:(MYPickerView *)pickerView textColorOfSelectedRowInComponent:(NSInteger)component;
- (UIColor *)pickerView:(MYPickerView *)pickerView textColorOfOtherRowInComponent:(NSInteger)component;

@end

@interface MYPickerView : UIView

@property(nonatomic,weak) id<MYPickerViewDataSource> dataSource;    // default is nil. weak reference
@property(nonatomic,weak) id<MYPickerViewDelegate>   delegate;      // default is nil. weak reference

@property(nonatomic, strong) UIColor *lineBackgroundColor;          // default is [UIColor grayColor]

@property(nonatomic, strong) UIColor *verticalLineBackgroundColor; // default is [UIColor grayColor] type3 vertical line
@property (nonatomic, assign) CGFloat verticalLineWidth; // default is 0.5

@property (nonatomic, strong)UIColor *textColorOfSelectedRow;     // [UIColor blackColor]
@property(nonatomic, strong) UIFont *textFontOfSelectedRow;

@property (nonatomic, strong)UIColor *textColorOfOtherRow;        // default is [UIColor grayColor]
@property(nonatomic, strong) UIFont *textFontOfOtherRow;

// info that was fetched and cached from the data source and delegate
@property(nonatomic,readonly) NSInteger numberOfComponents;

@property (nonatomic) CGFloat rowHeight;             // default is 44

@property(nonatomic, assign) BOOL isHiddenMiddleText; // default is true  true -> hidden
@property(nonatomic, strong) UIColor *middleTextColor;
@property(nonatomic, strong) UIFont *middleTextFont;

@property(nonatomic, assign) BOOL isCycleScroll; //default is false

- (NSInteger)numberOfRowsInComponent:(NSInteger)component;

// selection. in this case, it means showing the appropriate row in the middle ,default callDelegate
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;// scrolls the specified row to center.
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated callDelegate:(BOOL)callDelegate;
- (NSInteger)selectedRowInComponent:(NSInteger)component;// returns selected row. -1 if nothing selected
// Reloading whole view or single component
- (void)reloadAllComponents;

/**
 refresh columnView;
 if originalrow is beyound columnview'count, then select row 0
 */
- (void)reloadComponent:(NSInteger)component;

/**
 refresh = NO : refresh columnView and select row 0;
 refresh = YES:
 */
- (void)reloadComponent:(NSInteger)component refresh:(BOOL)refresh;

@end


NS_ASSUME_NONNULL_END

