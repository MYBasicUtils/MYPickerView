//
//  MYPickerView.m
//  MYPickerView
//
//  Created by 温明妍 on 2019/8/29.
//

#import "MYPickerView.h"
#import <Masonry/Masonry.h>
#import "MYPickerColumnView.h"

@interface MYPickerView () <TYDFTimerPickerColumnViewDelegate>

@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation MYPickerView

#pragma mark - --------------------dealloc ------------------
#pragma mark - --------------------life cycle--------------------

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    CGFloat rowHeight = self.rowHeight;
    if (!rowHeight) {
        rowHeight = 44;
    }
    [self addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self innerRefreshView];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}

#pragma mark - --------------------UITableViewDelegate--------------
#pragma mark - --------------------TYDFTimerPickerColumnViewDelegate--------------

- (void)pickerColumnView:(MYPickerColumnView *)pickerColumnView didSelectRow:(NSInteger)row {
    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.delegate pickerView:self didSelectRow:row inComponent:pickerColumnView.tag];
    }
}

#pragma mark - --------------------Event Response--------------

- (NSInteger)numberOfRowsInComponent:(NSInteger)component {
    return [self innerNumberOfComponents];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    [self selectRow:row inComponent:component animated:animated callDelegate:YES];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated callDelegate:(BOOL)callDelegate {
    for (MYPickerColumnView *columnView in self.stackView.subviews) {
        if (columnView.tag == component) {
            [columnView selectRow:row animated:animated callDelegate:callDelegate];
            break;
        }
    }
}

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    //当前被选中的row
    NSInteger row = 0;
    MYPickerColumnView *columnView = [self.stackView.subviews objectAtIndex:component];
    row = [columnView selectedRow];
    return row;
}

- (void)reloadAllComponents {
    // 重新刷新一遍
    int i = 0;
    for (MYPickerColumnView *columnView in self.stackView.subviews) {
        if (![columnView isKindOfClass:MYPickerColumnView.class]) {
            continue;
        }
        [self configColumnView:columnView component:i];
        [columnView selectRow:0 animated:NO];
        i++;
    }
}

- (void)reloadComponent:(NSInteger)component {
    [self reloadComponent:component refresh:NO];
}

- (void)reloadComponent:(NSInteger)component refresh:(BOOL)refresh {
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        MYPickerColumnView *columnView = [self.stackView.subviews objectAtIndex:component];
        if (columnView && [columnView isKindOfClass:MYPickerColumnView.class]) {
            NSInteger originalRow = [columnView selectedRow];
            [self configColumnView:columnView component:component];
            if (!refresh) {
                if (columnView.datas.count > originalRow) {
                    [columnView selectRow:originalRow animated:NO];
                } else {
                    [columnView selectRow:0 animated:NO];
                }
            } else {
                [columnView selectRow:0 animated:NO];
            }
            
        }
    });
}


#pragma mark - --------------------private methods--------------

- (void)innerRefreshView {
    [self innerInitColumnsView];
    [self innerRefreshMiddleText];
}

- (void)innerRefreshMiddleText {
    
    if ([self.delegate respondsToSelector:@selector(pickerView:middleTextForcomponent:)]) {
        NSInteger i = 0;
        for (MYPickerColumnView *columnView in self.stackView.subviews) {

            CGFloat horzontalOffset = 0;
            if ([self.delegate respondsToSelector:@selector(pickerView:middleTextHorizontalOffsetForcomponent:)]) {
                horzontalOffset = [self.delegate pickerView:self middleTextHorizontalOffsetForcomponent:i];
            }
            if (horzontalOffset) {
                columnView.horizontalOffset = horzontalOffset;
            }
            
            CGFloat verticalOffset = 0;
            if ([self.delegate respondsToSelector:@selector(pickerView:middleTextVerticalOffsetForcomponent:)]) {
                verticalOffset = [self.delegate pickerView:self middleTextVerticalOffsetForcomponent:i];
            }
            if (verticalOffset) {
                columnView.verticalOffset = verticalOffset;
            }
            columnView.middleText = [self.delegate pickerView:self middleTextForcomponent:i];
            columnView.middleTextColor = self.middleTextColor;
            columnView.middleTextFont = self.middleTextFont;
            i++;
        }
    }
}

- (CGFloat)innerRowHeightInComponent:(NSInteger)component {
    CGFloat rowHeight = self.rowHeight;
    if ([self.delegate respondsToSelector:@selector(rowHeightInPickerView:forComponent:)]) {
        rowHeight = [self.delegate rowHeightInPickerView:self forComponent:component];
    }
    return rowHeight;
}

- (NSArray<NSAttributedString *> *)innerDatasInComponent:(NSInteger)component {
    if ([self.delegate respondsToSelector:@selector(pickerView:attributedTitleForRow:forComponent:)] &&
        [self.dataSource respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]) {
        NSInteger count = [self.dataSource pickerView:self numberOfRowsInComponent:component];
        NSMutableArray<NSAttributedString *> *array = [NSMutableArray<NSAttributedString *> arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            NSAttributedString *text = [self.delegate pickerView:self attributedTitleForRow:i forComponent:component];
            if (!text) {
                text = [[NSAttributedString alloc] initWithString:@""];
            }
            [array addObject:text];
        }
        return array;
    }
    return nil;
}

- (void)configColumnView:(MYPickerColumnView *)columnView component:(NSInteger)i {
    columnView.normalFont = [self innerTextFontInComponent:i];
    columnView.normalTextColor = [self innerTextColorInComponent:i];
    columnView.selectFont = [self innerSelectFontInComponent:i];
    columnView.selectTextColor = [self innerSelectTextColorInComponent:i];
    columnView.datas = [self innerDatasInComponent:i];
}

- (UIFont *)innerTextFontInComponent:(NSInteger)component {
    UIFont *font = self.textFontOfOtherRow;
    if ([self.delegate respondsToSelector:@selector(pickerView:textFontOfOtherRowInComponent:)]) {
        font = [self.delegate pickerView:self textFontOfOtherRowInComponent:component];
    }
    return font;
}

- (UIFont *)innerSelectFontInComponent:(NSInteger)component {
    UIFont *font = self.textFontOfSelectedRow;
    if ([self.delegate respondsToSelector:@selector(pickerView:textFontOfSelectedRowInComponent:)]) {
        font = [self.delegate pickerView:self textFontOfSelectedRowInComponent:component];
    }
    return font;
}

- (UIColor *)innerSelectTextColorInComponent:(NSInteger)component {
    UIColor *color = self.textColorOfSelectedRow;
    if ([self.delegate respondsToSelector:@selector(pickerView:textColorOfSelectedRowInComponent:)]) {
        color = [self.delegate pickerView:self textColorOfSelectedRowInComponent:component];
    }
    return color;
}

- (UIColor *)innerTextColorInComponent:(NSInteger)component {
    UIColor *color = self.textColorOfOtherRow;
    if ([self.delegate respondsToSelector:@selector(pickerView:textColorOfOtherRowInComponent:)]) {
        color = [self.delegate pickerView:self textColorOfOtherRowInComponent:component];
    }
    return color;
}

- (void)innerInitColumnsView {
    NSInteger numberOfComponents = [self innerNumberOfComponents];
    if (!numberOfComponents) {
        return;
    }
    if (numberOfComponents == self.stackView.subviews.count) {
        int i = 0;
        for (MYPickerColumnView *columnView in self.stackView.subviews) {
            if (![columnView isKindOfClass:MYPickerColumnView.class]) {
                continue;
            }
            [self configColumnView:columnView component:i];
            [self.stackView addArrangedSubview:columnView];
            i++;
        }// end of for
        return;
    }
    // 删除
    for (UIView *subView in self.stackView.subviews) {
        [subView removeFromSuperview];
    }
    
    for (int i = 0; i < numberOfComponents; i++) {
        MYPickerColumnView *columnView = [[MYPickerColumnView alloc] init];
        columnView.delegate = self;
        columnView.tag = i;
        [self configColumnView:columnView component:i];
        [self.stackView addArrangedSubview:columnView];
    }
}

- (NSInteger)innerNumberOfComponents {
    NSInteger number = 0;
    if (self.numberOfComponents) {
        number = self.numberOfComponents;
    }
    if ([self.dataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        number = [self.dataSource numberOfComponentsInPickerView:self];
    }
    return number;
}

#pragma mark - --------------------getters & setters & init members ------------------

- (void)setTextFontOfSelectedRow:(UIFont *)textFontOfSelectedRow {
    _textFontOfSelectedRow = textFontOfSelectedRow;
    [self innerRefreshView];
}

- (void)setTextColorOfSelectedRow:(UIColor *)textColorOfSelectedRow {
    _textColorOfSelectedRow = textColorOfSelectedRow;
    [self innerRefreshView];
}

- (void)setTextColorOfOtherRow:(UIColor *)textColorOfOtherRow {
    _textColorOfOtherRow = textColorOfOtherRow;
    [self innerRefreshView];
}

- (void)setTextFontOfOtherRow:(UIFont *)textFontOfOtherRow {
    _textFontOfOtherRow = textFontOfOtherRow;
    [self innerRefreshView];
}

- (void)setIsCycleScroll:(BOOL)isCycleScroll {
    _isCycleScroll = isCycleScroll;
    for (MYPickerColumnView *columnView in self.stackView.subviews) {
        if (![columnView isKindOfClass:MYPickerColumnView.class]) {
            continue;
        }
        columnView.isScrollCycle = isCycleScroll;
    }
}

- (void)setDataSource:(id<MYPickerViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self innerRefreshView];
}

- (void)setDelegate:(id<MYPickerViewDelegate>)delegate {
    _delegate = delegate;
    [self innerRefreshView];
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        //TODO: wmy 5
        _stackView.spacing = 5;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.alignment = UIStackViewAlignmentFill;
    }
    return _stackView;
}

@end
