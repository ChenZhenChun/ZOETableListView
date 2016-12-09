//
//  ZOETableListView.h
//  xjdoctor
//
//  Created by aiyoyou on 16/1/20.
//  Copyright © 2016年 zoenet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZOETableListView;

typedef enum : NSUInteger {
    TableListViewCellAccessoryNone,//选中行无样式
    TableListViewCellAccessoryCheckmark,//选中行右侧对勾
    TableListViewCellAccessoryTextGreenColor,//选中行文字为绿色
    TableListViewCellAccessoryTextTintColor,//选中行文字颜色与tintColor相同
} TableListViewCellAccessoryType;


@protocol TableListViewDelegate <NSObject>
@required
- (UITableViewCell *)tableListView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableListView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

@optional
//控件cell点击代理
- (void)tableListView:(ZOETableListView *)tableListView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//控件cell高度代理
- (CGFloat)heightForRow;

@end

@interface ZOETableListView : UIView

@property (nonatomic,strong) id<TableListViewDelegate>      delegate;
@property (nonatomic,assign) TableListViewCellAccessoryType accessoryType;
@property (nonatomic,assign) NSInteger                      seletedRow;//Default is 0。默认选中第几行数据。
@property (nonatomic,assign) CGFloat                        titleBtnImageRightEdgeInset;//Default is 0。
@property (nonatomic,readonly) UIButton                     *titleBtn;

- (void)reloadData;
//展开or收起控件（一般不需要调用，在特殊情况下可调用，比如自定义了一个按钮需要达到展开or收起控件的效果）
//- (void)showOrHidenControl;
@end
