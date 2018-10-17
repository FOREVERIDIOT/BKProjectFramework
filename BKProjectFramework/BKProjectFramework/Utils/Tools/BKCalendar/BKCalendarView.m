//
//  BKCalendarView.m
//  MySelfFrame
//
//  Created by BIKE on 17/2/20.
//  Copyright © 2017年 BIKE. All rights reserved.
//

#import "BKCalendarView.h"
#import "BKCalendar.h"

@interface BKCalendarView()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation BKCalendarView

-(NSMutableArray<BKCalendarViewCell *> *)visibleCells
{
    if (!_visibleCells) {
        _visibleCells = [NSMutableArray array];
    }
    return _visibleCells;
}

-(UIView*)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
    }
    return _contentView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height*3);
        self.showsVerticalScrollIndicator = NO;
        self.scrollsToTop = NO;
        
        [self addSubview:self.contentView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGPoint currentOffset = self.contentOffset;
    CGFloat contentHeight = self.contentSize.height;
    CGFloat centerOffsetY = (contentHeight - self.bounds.size.height)/2.0f;
    CGFloat distanceFromCenter = fabs(currentOffset.y - centerOffsetY);
    
    if (distanceFromCenter > (contentHeight/4.0)) {
        self.contentOffset = CGPointMake(currentOffset.x, centerOffsetY);
        
        for (UIView *view in self.visibleCells) {
            CGPoint center = [self.contentView convertPoint:view.center toView:self];
            center.y = center.y + (centerOffsetY - currentOffset.y);
            view.center = [self convertPoint:center toView:self.contentView];
        }
    }
    
    CGRect visibleBounds = [self convertRect:self.bounds toView:self.contentView];
    CGFloat minimumVisibleY = CGRectGetMinY(visibleBounds);
    CGFloat maximumVisibleY = CGRectGetMaxY(visibleBounds);
    
    [self showFromMinY:minimumVisibleY toMax:maximumVisibleY];
}

-(void)showFromMinY:(CGFloat)minY toMax:(CGFloat)maxY
{
    if ([self.visibleCells count] == 0) {
        [self placeNewViewOnBottom:minY];
    }
    
    BKCalendarViewCell *lastCell = [self.visibleCells lastObject];
    CGFloat bottomEdge = CGRectGetMaxY(lastCell.frame);
    while (bottomEdge < maxY) {
        bottomEdge = [self placeNewViewOnBottom:bottomEdge];
    }
    
    BKCalendarViewCell *firstCell = self.visibleCells[0];
    CGFloat topEdge = CGRectGetMinY(firstCell.frame);
    while (topEdge > minY) {
        topEdge = [self placeNewViewOnTop:topEdge];
    }
    
    lastCell = [self.visibleCells lastObject];
    while (lastCell.frame.origin.y > maxY) {
        [lastCell removeFromSuperview];
        [self.visibleCells removeLastObject];
        lastCell = [self.visibleCells lastObject];
    }
    
    firstCell = self.visibleCells[0];
    while (CGRectGetMaxY(firstCell.frame) < minY) {
        [firstCell removeFromSuperview];
        [self.visibleCells removeObjectAtIndex:0];
        firstCell = self.visibleCells[0];
    }
}

/**
 往scrollView最上面加入即将显示的cell
 
 @param topEdge 即将显示cell的最大Y值
 
 @return 即将显示cell最小Y值
 */
- (CGFloat)placeNewViewOnTop:(CGFloat)topEdge
{
    NSInteger mark = [self getMinMarkInVisiableCells];
    
    BKCalendarViewCell *cell = [self insertCell:mark];
    [self.visibleCells insertObject:cell atIndex:0];
    
    CGRect frame = cell.frame;
    frame.size.height = [self getCellHeightWithMark:mark];
    frame.origin.y = topEdge - frame.size.height;
    cell.frame = frame;
    
    [self calendarViewCell:cell assignDataWithMark:mark];
    
    return CGRectGetMinY(frame);
}

/**
 往scrollView最下面加入即将显示的cell

 @param bottomEdge 即将显示cell的最小Y值

 @return 即将显示cell最大Y值
 */
- (CGFloat)placeNewViewOnBottom:(CGFloat)bottomEdge
{
    NSInteger mark = [self getMaxMarkInVisiableCells];
    
    BKCalendarViewCell *cell = [self insertCell:mark];
    [self.visibleCells addObject:cell];
    
    CGRect frame = cell.frame;
    frame.origin.y = bottomEdge;
    frame.size.height = [self getCellHeightWithMark:mark];
    cell.frame = frame;
    
    [self calendarViewCell:cell assignDataWithMark:mark];
    
    return CGRectGetMaxY(frame);
}

/**
 获取目前显示最小mark
 
 @return mark
 */
-(NSInteger)getMinMarkInVisiableCells
{
    if (self.visibleCells.count <= 0) {
        return 0;
    }
    BKCalendarViewCell *cell = (BKCalendarViewCell *)self.visibleCells[0];
    NSInteger mark = cell.mark;
    for (BKCalendarViewCell *cell in self.visibleCells) {
        if (mark > cell.mark) {
            mark = cell.mark;
        }
    }
    return --mark;
}

/**
 获取目前显示最大mark

 @return mark
 */
-(NSInteger)getMaxMarkInVisiableCells
{
    if (self.visibleCells.count <= 0) {
        return 0;
    }
    BKCalendarViewCell *cell = (BKCalendarViewCell *)self.visibleCells[0];
    NSInteger mark = cell.mark;
    for (BKCalendarViewCell *cell in self.visibleCells) {
        if (mark < cell.mark) {
            mark = cell.mark;
        }
    }
    return ++mark;
}

/**
 插入cell

 @param mark 标记

 @return BKCalendarViewCell
 */
-(BKCalendarViewCell*)insertCell:(NSInteger)mark
{
    BKCalendarViewCell * cell = [[BKCalendarViewCell alloc]init];
    cell.mark = mark;
    __weak typeof(self) weakSelf = self;
    cell.returnYearMessage = ^(NSString * message) {
        if ([weakSelf.customDelegate respondsToSelector:@selector(returnYearMessage:)]) {
            [weakSelf.customDelegate returnYearMessage:message];
        }
    };
    cell.monthTap = ^(BKMonthModel * model) {
        if ([weakSelf.customDelegate respondsToSelector:@selector(monthTap:)]) {
            [weakSelf.customDelegate monthTap:model];
        }
    };
    cell.dayTap = ^(BKDayModel * model) {
        if ([weakSelf.customDelegate respondsToSelector:@selector(dayTap:)]) {
            [weakSelf.customDelegate dayTap:model];
        }
    };
    [self.contentView addSubview:cell];
    return cell;
}

/**
 根据mark 算出cell height

 @param mark 标记

 @return cell height
 */
-(CGFloat)getCellHeightWithMark:(NSInteger)mark
{
    NSDate * monthDate = [[NSDate date] getMonthDateAccordingToGapsNumber:mark];
    NSInteger allMonthDayNum = [monthDate getNumberOfDaysPerMonth];
    
    NSDate * monthFirstDate = [monthDate getFirstDayInMonth];
    NSInteger weekNumber = [monthFirstDate calcCurrentDateWeek];
    
    NSInteger row = (allMonthDayNum + weekNumber)/7 + ((allMonthDayNum + weekNumber)%7>0?1:0);
    
    CGFloat one_height = [UIScreen mainScreen].bounds.size.width/7.0f;
    
    //30是月titleLab的高度
    return 30 + one_height*row;
}

/**
 cell数据赋值

 @param cell cell
 @param mark 标记
 */
-(void)calendarViewCell:(BKCalendarViewCell*)cell assignDataWithMark:(NSInteger)mark
{
    NSDate * monthDate = [[NSDate date] getMonthDateAccordingToGapsNumber:mark];
    NSDate * monthFirstDate = [monthDate getFirstDayInMonth];
    [cell assignDataWithFirstDayInMonthDate:monthFirstDate];
}

@end
