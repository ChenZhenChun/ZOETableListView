//
//  ZOETableListView.m
//  xjdoctor
//
//  Created by aiyoyou on 16/1/20.
//  Copyright © 2016年 zoenet. All rights reserved.
//

#import "ZOETableListView.h"

@interface ZOETableListView ()<UITableViewDataSource,UITableViewDelegate>
{
    CGRect      _tablelistFrame;//控件大小
    NSIndexPath *_indexPath;//选中的索引
    BOOL        _seleted;//button选中状态
    NSInteger   _rows;
    CGFloat     cellH;
}
@property (nonatomic,strong) UIButton           *titleViewBtn;
@property (nonatomic,strong) UITableView        *tableView;
@property (nonatomic,strong) UIView             *footerView;
@property (nonatomic,strong) UIColor            *tintColor;
@property (nonatomic,weak)   UIViewController   *delegateController;//代理控制器

@property (nonatomic,assign) BOOL               isHiddentFlag;//控件默认隐藏


@end

@implementation ZOETableListView
@synthesize tintColor = _tintColor;

- (void)setDelegate:(id<TableListViewDelegate>)delegate {
    _delegate = delegate;
    _delegateController = (UIViewController *)delegate;
    [self initTableListView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    _rows = 0;
    if ([self.delegate respondsToSelector:@selector(tableListView:numberOfRowsInSection:)]) {
        _rows = [self.delegate tableListView:tableView numberOfRowsInSection:section];
    }
    if (_rows == 0) {
        _delegateController.navigationItem.titleView = nil;
        self.footerView.frame = CGRectZero;
    }else {
        _delegateController.navigationItem.titleView = self.titleViewBtn;
    }
    return _rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if ([self.delegate respondsToSelector:@selector(tableListView:cellForRowAtIndexPath:)]) {
        cell = [self.delegate tableListView:tableView cellForRowAtIndexPath:indexPath];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //ios7分割线顶头
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    //ios8分割线顶头
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if (!_indexPath) {
        //默认选中的行
        _seletedRow = _seletedRow >(_rows-1)||_seletedRow<0?0:_seletedRow;
        if (indexPath.row == _seletedRow) {
            _seleted = YES;
            [self configCellStyleWithCell:cell];
            NSString *title = cell.textLabel.text;
            [self sizeToFitTitleViewBtn:title];
            [self tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:_seletedRow inSection:0]];
        }
    }else {
        if (_indexPath.row == indexPath.row) {
            [self configCellStyleWithCell:cell];
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    cellH = 44;
    if ([self.delegate respondsToSelector:@selector(heightForRow)]) {
        cellH = [self.delegate heightForRow];
    }
    return cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _seleted = !_seleted;
    self.titleViewBtn.selected = _seleted;
    [self hiddenTableListView];
    //点击按钮文字及图片自适应
    if (_indexPath) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *title = cell.textLabel.text;
        [self sizeToFitTitleViewBtn:title];
    }
    _indexPath = indexPath;
    _seletedRow = indexPath.row;
    if ([self.delegate respondsToSelector:@selector(tableListView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableListView:self didSelectRowAtIndexPath:indexPath];
    }
}


#pragma mark - Action
//titleView点击事件
- (void)clickTableListViewByButton:(UIButton *)send {
    _titleViewBtn = send;
    _seleted = !_seleted;
    _titleViewBtn.selected = _seleted;
    if (_isHiddentFlag) {
        [self showTableListView];
    }else {
        [self hiddenTableListView];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _seleted = !_seleted;
    _titleViewBtn.selected = _seleted;
    [self hiddenTableListView];
}
//隐藏控件
- (void)hiddenTableListView {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.tableView.frame = CGRectMake(0, -_tablelistFrame.size.height, _tablelistFrame.size.width,_tablelistFrame.size.height);
        weakSelf.footerView.frame = CGRectMake(0,
                                               -_tablelistFrame.size.height,
                                               [UIScreen mainScreen].bounds.size.width,
                                               _tablelistFrame.size.height-_rows*cellH);
    } completion:^(BOOL finished) {
        weakSelf.isHiddentFlag = YES;
    }];
    
}

//显示控件
- (void)showTableListView {
    [self.tableView reloadData];
    self.frame = _tablelistFrame;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.tableView.frame = CGRectMake(0, 0, _tablelistFrame.size.width,_tablelistFrame.size.height);
        weakSelf.footerView.frame = CGRectMake(0,
                                               _rows*cellH,
                                               [UIScreen mainScreen].bounds.size.width,
                                               _tablelistFrame.size.height-_rows*cellH);
    } completion:^(BOOL finished) {
        weakSelf.isHiddentFlag = NO;
    }];
    
}

- (void)showOrHidenControl {
    [self clickTableListViewByButton:self.titleViewBtn];
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]init];
        _footerView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenTableListView)];
        [_footerView addGestureRecognizer:tap];
    }
    return _footerView;
}

//cell样式控制
- (void)configCellStyleWithCell:(UITableViewCell *)cell {
    if (_accessoryType != TableListViewCellAccessoryNone ) {
        if (_accessoryType == TableListViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else if(_accessoryType == TableListViewCellAccessoryTextGreenColor) {
            cell.textLabel.textColor = [UIColor colorWithRed:64/255.0 green:202/255.0 blue:117/255.0 alpha:1];
        }else if (_accessoryType == TableListViewCellAccessoryTextTintColor) {
            cell.textLabel.textColor = self.tintColor;
        }
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

//刷新
- (void)reloadData {
    [self.tableView reloadData];
}

//点击按钮根据文字自适应
- (void)sizeToFitTitleViewBtn:(NSString *)title {
    [self.titleViewBtn setTitle:title forState:UIControlStateNormal];
    CGRect frame = _titleViewBtn.frame;
    [_titleViewBtn sizeToFit];
    frame.size.width = _titleViewBtn.frame.size.width+60;
    _titleViewBtn.frame = frame;
    [self.titleViewBtn setImageEdgeInsets:UIEdgeInsetsMake(0,frame.size.width-(50+_titleBtnImageRightEdgeInset), 0,0)];
    [self.titleViewBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,30)];
}


#pragma mark -Properties
//titleView按钮
- (UIButton *)titleViewBtn {
    if (!_titleViewBtn) {
        _titleViewBtn = [[UIButton alloc]init];
        _titleViewBtn.bounds = CGRectMake(0,0,0,44);
        [_titleViewBtn addTarget:self action:@selector(clickTableListViewByButton:) forControlEvents:UIControlEventTouchUpInside];
        [_titleViewBtn setImage:[UIImage imageNamed:@"down_arrow_white"] forState:UIControlStateNormal];
        [_titleViewBtn setImage:[UIImage imageNamed:@"up_arrow_white"] forState:UIControlStateSelected];
    }
    _titleViewBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0,44/2.0);
    return _titleViewBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   -_tablelistFrame.size.height-64,
                                                                   _tablelistFrame.size.width,
                                                                   _tablelistFrame.size.height) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
            
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    _tintColor = tintColor;
}

- (UIColor *)tintColor {
    if (!_tintColor) {
        _tintColor = [UIColor blackColor];
    }
    return _tintColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _tablelistFrame = frame;
    }
    return self;
}

- (void)initTableListView {
    _isHiddentFlag = YES;
    _seleted = NO;
    if (CGRectEqualToRect(_tablelistFrame,CGRectZero)) {
        _tablelistFrame = _delegateController.view.bounds;
    }
    [_delegateController.view addSubview:self];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
    self.backgroundColor = [UIColor colorWithRed:106/255.0 green:106/255.0 blue:106/255.0 alpha:0.3];
    [self addSubview:self.tableView];
    [self addSubview:self.footerView];
}
@end
