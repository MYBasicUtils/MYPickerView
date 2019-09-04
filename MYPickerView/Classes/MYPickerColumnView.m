//
//  TYTimerPickerColumnView.m
//  lottie-ios
//
//  Created by 温明妍 on 2019/8/29.
//

#import "MYPickerColumnView.h"
#import <Masonry/Masonry.h>
#import "MYPickerTableView.h"
#import "MYPickerColumnCell.h"

#define kCycleSection 20

@interface MYPickerColumnView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIStackView *stackView;

@property (nonatomic, assign) BOOL hasScrollToSection;/** < 已滚到到需要的section*/
//TODO: wmy to delete
@property (nonatomic, strong) MYPickerTableView *tableView;

@property (nonatomic, assign) NSInteger selectedRow;

@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, assign) BOOL originalCycleScroll;

@end

@implementation MYPickerColumnView

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
        //TODO: wmy 添加系统的震动
    }
    return self;
}

- (void)initView {
    //TODO: wmy line

    // Text
    self.normalFont = [UIFont systemFontOfSize:14];
    self.selectFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.normalTextColor = [UIColor blackColor];
    self.selectTextColor = [UIColor blackColor];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self addSubview:self.middleLabel];
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(60);
        make.bottom.equalTo(self).multipliedBy(2/3.f);
        make.width.mas_lessThanOrEqualTo(40);
    }];   
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}

#pragma mark - --------------------UITableViewDelegate--------------

- (MYPickerColumnCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYPickerColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MYPickerColumnCell.class) forIndexPath:indexPath];
    if (!cell) {
        cell = [[MYPickerColumnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(MYPickerColumnCell.class)];
    }
    if (indexPath.section == 0 || indexPath.section == [tableView numberOfSections] - 1) {
        cell.label.text = @"";
    } else {
        NSAttributedString *text;
        if (self.datas.count) {
            text = [self.datas objectAtIndex:indexPath.row];
        }
        cell.selectFont = self.selectFont;
        cell.normalFont = self.normalFont;
        cell.selectTextColor = self.selectTextColor;
        cell.normalTextColor = self.normalTextColor;
        
        cell.label.text = text.string;
        cell.label.font = self.normalFont;
        cell.label.textColor = self.normalTextColor;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.height / 3.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == [tableView numberOfSections] - 1) {
        return 1;
    }
    return self.datas.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isScrollCycle) {
        // 头部尾部一个空Cell
        return kCycleSection + 2;
    }
    return 1 + 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(MYPickerColumnCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell cellOffsetOnTableView:tableView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[self.tableView visibleCells] enumerateObjectsUsingBlock:^(__kindof MYPickerColumnCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cellOffsetOnTableView:self.tableView];
    }];
}

- (void)scrollViewDidEndDecelerating:(MYPickerTableView *)tableView {
    [self scrollToCentainCellInTableView:tableView];
}

- (void)scrollViewDidEndDragging:(MYPickerTableView *)tableView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        return;
    }
    [self scrollViewDidEndDecelerating:tableView];
}

- (void)scrollToCentainCellInTableView:(MYPickerTableView *)tableView {
    NSArray *array = [tableView indexPathsForVisibleRows];
    if (!array.count) {
        return;
    }
    NSIndexPath *selectIndexPath;
    for (NSIndexPath *indexPath in array) {
        MYPickerColumnCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.cellSelected) {
            selectIndexPath = [indexPath copy];
            break;
        }
    }
    if (!selectIndexPath) {
        selectIndexPath = [array objectAtIndex:0];
    }
    self.selectedRow = selectIndexPath.row;
    [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    if ([self.delegate respondsToSelector:@selector(pickerColumnView:didSelectRow:)]) {
        [self.delegate pickerColumnView:self didSelectRow:selectIndexPath.row];
        self.selectedRow = selectIndexPath.row;
    }
}

#pragma mark - --------------------CustomDelegate--------------
#pragma mark - --------------------Event Response--------------

- (void)setHorizontalOffset:(CGFloat)horizontalOffset {
    _horizontalOffset = horizontalOffset;
    [self.middleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(60).offset(horizontalOffset);
    }];
}

- (void)setVerticalOffset:(CGFloat)verticalOffset {
    _verticalOffset = verticalOffset;
    [self.middleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).multipliedBy(2/3.f).offset(verticalOffset);
    }];
}

- (void)selectRow:(NSInteger)row animated:(BOOL)animated {
    [self selectRow:row animated:animated callDelegate:YES];
}

- (void)selectRow:(NSInteger)row animated:(BOOL)animated callDelegate:(BOOL)callDelegate {
    NSInteger innerRow = row;
    if (row > self.datas.count - 1 || row < 0) {
        innerRow = 0;
    }
    NSInteger centerSection = 0;
    if (self.isScrollCycle) {
        centerSection = kCycleSection / 2;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:innerRow inSection:centerSection];
    
    if (self.tableView.numberOfSections > centerSection &&
        [self.tableView numberOfRowsInSection:centerSection] > innerRow) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
    }
    
    if (callDelegate && [self.delegate respondsToSelector:@selector(pickerColumnView:didSelectRow:)]) {
        [self.delegate pickerColumnView:self didSelectRow:innerRow];
        self.selectedRow = innerRow;
    }
}

- (NSInteger)selectedRow {
    return _selectedRow;
}

- (void)reloadDatas {
    [self.tableView reloadData];
    if (self.isScrollCycle) {
        NSInteger centerSection = kCycleSection / 2;
        BOOL needScroll = !self.hasScrollToSection &&
        self.tableView.numberOfSections > centerSection &&
        [self.tableView numberOfRowsInSection:centerSection];
        if (needScroll) {
            self.hasScrollToSection = YES;
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.datas.count - 1 inSection:centerSection]
                                     atScrollPosition:UITableViewScrollPositionBottom
                                             animated:NO];
        }
    }
}

#pragma mark - --------------------private methods--------------
#pragma mark - --------------------getters & setters & init members ------------------

- (void)setMiddleText:(NSString *)middleText {
    self.middleLabel.text = middleText;
}

- (void)setMiddleTextFont:(UIFont *)middleTextFont {
    self.middleLabel.font = middleTextFont;
}

- (void)setMiddleTextColor:(UIColor *)middleTextColor {
    self.middleLabel.textColor = middleTextColor;
}

- (UILabel *)middleLabel {
    if (!_middleLabel) {
        _middleLabel = [[UILabel alloc] init];
    }
    return _middleLabel;
}

- (void)setIsScrollCycle:(BOOL)isScrollCycle {
    _isScrollCycle = isScrollCycle;
    self.originalCycleScroll = isScrollCycle;
    [self reloadDatas];
}

- (void)setDatas:(NSArray<NSAttributedString *> *)datas {
    _datas = datas;
    if (datas.count == 1 || datas.count == 2) {
        // 若只有一个 or 两个，则不需要循环
        _isScrollCycle = NO;
    } else {
        self.isScrollCycle = self.originalCycleScroll;
    }
    [self reloadDatas];
}

- (MYPickerTableView *)tableView {
    if (!_tableView) {
        _tableView = [self newTableView];
    }
    return _tableView;
}

- (MYPickerTableView *)newTableView {
    MYPickerTableView *tableView = [[MYPickerTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.decelerationRate = UIScrollViewDecelerationRateFast;
    [tableView registerClass:MYPickerColumnCell.class
      forCellReuseIdentifier:NSStringFromClass(MYPickerColumnCell.class)];
    return tableView;
}

@end
