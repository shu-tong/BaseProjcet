//
//  TitleScrollView.m
//  titleScrollViewTest
//
//  Created by GCF on 16/5/17.
//  Copyright © 2016年 GCF. All rights reserved.
//

#import "TitleScrollView.h"

@interface TitleScrollView ()
@property (nonatomic, strong) UIFont *defaultFont;
@property (nonatomic, strong) UIFont *selectFont;
@end

@implementation TitleScrollView
/**
 *   创建一个标题滚动栏
 *
 *  @param frame           布局
 *  @param titleArray     标题数组
 *  @param selected_index 默认选中按钮的索引
 *  @param scrollEnable   能否滚动
 *  @param isEqualWidth   下面的条子是否按数量等分宽度 YES:等分 NO:按照标题宽度
 *  @param selectColor    选择颜色
 *  @param defaultColor   默认颜色
 *  @param selectBlock    点击标题回调方法
 *
 *  @return return value description
 */
-(instancetype)initWithFrame:(CGRect)frame
                  TitleArray:(NSArray *)titleArray
               selectedIndex:(NSInteger)selected_index
                scrollEnable:(BOOL)scrollEnable
              lineEqualWidth:(BOOL)isEqualWidth
                    Increase:(BOOL)isIncrease
                 selectColor:(UIColor *)selectColor
                defaultColor:(UIColor *)defaultColor
                 SelectBlock:(SelectBlock)selectBlock{
    
    self =[super initWithFrame:frame];
    if (self)
    {
        self.defaultFont = titleFont;
        self.selectFont = [UIFont boldSystemFontOfSize:15];
        
        self.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
        self.showsHorizontalScrollIndicator = NO;
        CGFloat orign_x = 0;
        CGFloat height = self.frame.size.height;
        
        CGFloat space = scrollEnable?20:[TitleScrollHelper caculateSpaceByTitleArray:titleArray rect:frame];
        self.buttonArray = [NSMutableArray new];
        self.block = selectBlock;
        self.isEqualWidth = isEqualWidth;
        self.isSelectItmeIncrease = isIncrease;
        for (int i = 0; i<titleArray.count; i++)
        {
            NSString *title =titleArray[i];
            CGSize size = [TitleScrollHelper titleSize:title height:frame.size.height];
            self.titleButton =[UIButton buttonWithType:UIButtonTypeCustom];
            self.titleButton.frame = CGRectMake(orign_x, 0, size.width+space, height);
            [self.titleButton setTitle:title forState:UIControlStateNormal];
            [self.titleButton setTitleColor:defaultColor forState:UIControlStateNormal];
            [self.titleButton setTitleColor:selectColor forState:UIControlStateSelected];
            [self.titleButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            self.titleButton.titleLabel.font = titleFont;
            self.titleButton.tag = i;
            orign_x = orign_x+space+size.width;
            self.contentSize = CGSizeMake(orign_x, height);
            if (i == selected_index)
            {
                [self.titleButton setSelected:YES];
                self.selectedButt = self.titleButton;
                self.line =[[UILabel alloc]init];
                self.line.backgroundColor = selectColor;
                BSViewsBorder(self.line, 2, 1, [UIColor clearColor])
                [self addSubview:self.line];
            }
            [ self.buttonArray addObject:self.titleButton];
            [self addSubview:self.titleButton];
        }
        [self buttonOffset:self.selectedButt];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
                  TitleArray:(NSArray *)titleArray
               selectedIndex:(NSInteger)selected_index
                scrollEnable:(BOOL)scrollEnable
              lineEqualWidth:(BOOL)isEqualWidth
                    isSelect:(BOOL)isSelect
                 selectColor:(UIColor *)selectColor
                defaultColor:(UIColor *)defaultColor
                 SelectBlock:(SelectBlock)selectBlock{
    
    self =[super initWithFrame:frame];
    if (self)
    {
        self.defaultFont = titleFont;
        self.selectFont = [UIFont boldSystemFontOfSize:15];
        self.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
        self.showsHorizontalScrollIndicator = NO;
        CGFloat orign_x = 0;
        CGFloat height = self.frame.size.height;
        
        CGFloat space = scrollEnable?20:[TitleScrollHelper caculateSpaceByTitleArray:titleArray rect:frame];
        self.buttonArray = [NSMutableArray new];
        self.block = selectBlock;
        self.isEqualWidth = isEqualWidth;
        self.isSelected = isSelect;
        for (int i = 0; i<titleArray.count; i++)
        {
            NSString *title =titleArray[i];
            CGSize size = [TitleScrollHelper titleSize:title height:frame.size.height];
            self.titleButton =[UIButton buttonWithType:UIButtonTypeCustom];
            self.titleButton.frame = CGRectMake(orign_x, (height - 29) / 2, size.width+space, 29);
            [self.titleButton setTitle:title forState:UIControlStateNormal];
            [self.titleButton setTitleColor:defaultColor forState:UIControlStateNormal];
            [self.titleButton setTitleColor:selectColor forState:UIControlStateSelected];
            [self.titleButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            self.titleButton.titleLabel.font = titleFont;
            self.titleButton.tag = i;
            orign_x = orign_x+space+size.width;
            self.contentSize = CGSizeMake(orign_x, height);
            if (i == selected_index)
            {
                [self.titleButton setSelected:YES];
                self.selectedButt = self.titleButton;
                self.line =[[UILabel alloc]init];
                self.line.backgroundColor = selectColor;
                BSViewsBorder(self.line, 2, 1, [UIColor clearColor])
                [self addSubview:self.line];
            }
            [ self.buttonArray addObject:self.titleButton];
            [self addSubview:self.titleButton];
        }
        [self buttonOffset:self.selectedButt];
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame
                  TitleArray:(NSArray *)titleArray
               selectedIndex:(NSInteger)selected_index
                scrollEnable:(BOOL)scrollEnable
              lineEqualWidth:(BOOL)isEqualWidth
                    Increase:(BOOL)isIncrease
                 selectColor:(UIColor *)selectColor
                defaultColor:(UIColor *)defaultColor
            selectTitleColor:(UIColor *)selectTitleColor
                defaultFount:(UIFont *)defaultFount
                 selectFount:(UIFont *)selectFount
                 SelectBlock:(SelectBlock)selectBlock
{
    self =[super initWithFrame:frame];
    if (self)
    {
        self.defaultFont = defaultFount;
        self.selectFont = selectFount;
        
        self.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
        self.showsHorizontalScrollIndicator = NO;
        CGFloat orign_x = 0;
        CGFloat height = self.frame.size.height;
        
        CGFloat space = scrollEnable?20:[TitleScrollHelper caculateSpaceByTitleArray:titleArray rect:frame];
        self.buttonArray = [NSMutableArray new];
        self.block = selectBlock;
        self.isEqualWidth = isEqualWidth;
        self.isSelectItmeIncrease = isIncrease;
        for (int i = 0; i<titleArray.count; i++)
        {
            NSString *title =titleArray[i];
            CGSize size = [TitleScrollHelper titleSize:title height:frame.size.height];
            self.titleButton =[UIButton buttonWithType:UIButtonTypeCustom];
            self.titleButton.frame = CGRectMake(orign_x, 0, size.width+space, height);
            [self.titleButton setTitle:title forState:UIControlStateNormal];
            [self.titleButton setTitleColor:defaultColor forState:UIControlStateNormal];
            [self.titleButton setTitleColor:selectTitleColor forState:UIControlStateSelected];
            [self.titleButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            self.titleButton.titleLabel.font = defaultFount;
            self.titleButton.tag = i;
            orign_x = orign_x+space+size.width;
            self.contentSize = CGSizeMake(orign_x, height);
            if (i == selected_index)
            {
                [self.titleButton setSelected:YES];
                self.selectedButt = self.titleButton;
                self.line =[[UILabel alloc]init];
                self.line.backgroundColor = selectColor;
                BSViewsBorder(self.line, 2, 1, [UIColor clearColor])
                [self addSubview:self.line];
            }
            [ self.buttonArray addObject:self.titleButton];
            [self addSubview:self.titleButton];
        }
        [self buttonOffset:self.selectedButt];
    }
    return self;
}


//按钮点击
-(void)headButtonClick:(UIButton *)butt
{
    [self setSelectedIndex:butt.tag];
    if (self.block) {
        self.block(butt.tag);
    }
    
}

//点击控制滚动视图的偏移量
-(void)buttonOffset:(UIButton *)butt animated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:0.2 animations:^{
//            if (butt.backgroundColor != NavColor) {
//                
//                [butt setBackgroundColor:NavColor];
//            }
            [self buttonOffset:butt];
        }];
    }else{
        [self buttonOffset:butt];
    }
}

-(void)buttonOffset:(UIButton *)butt
{
//    CGSize size = [TitleScrollHelper titleSize:butt.titleLabel.text height:butt.frame.size.height];
//    CGFloat width = self.isEqualWidth?self.width / self.buttonArray.count : size.width;//先不设置
    
    if (self.isSelected) {
        for (UIButton *button in  self.buttonArray)
        {
            button.layer.cornerRadius = 29/2;
            BOOL isSelected = button.tag == butt.tag?YES:NO;
            if (isSelected) {
//                [UIView animateWithDuration:2 animations:^{
                
                    [button setBackgroundColor:[UIColor orangeColor]];
//                }];
            } else {
                [button setBackgroundColor:[UIColor clearColor]];
            }
            [button setSelected:isSelected];
        }
    } else {
        
        //要求两个字的宽度。大概为30px 17-05-16 修改
        if (self.isSelectItmeIncrease) {
            self.line.bounds = CGRectMake(0, 0, 30, 3);
        } else {
            self.line.bounds = CGRectMake(0, 0, 30, 3);
        }
        self.line.center = CGPointMake(butt.center.x, butt.frame.size.height-4);
        for (UIButton *button in  self.buttonArray)
        {
            if (self.isSelectItmeIncrease) {
                if (button.tag == butt.tag) {
                    [button setSelected:YES];
                    button.titleLabel.font = self.selectFont;
                }else{
                    button.titleLabel.font = self.defaultFont;
                    [button setSelected:NO];
                }
            }else{
                BOOL isSelected = button.tag == butt.tag?YES:NO;
                button.titleLabel.font = isSelected ? self.selectFont : self.defaultFont;
                [button setSelected:isSelected];
            }
            
        }
    }
    if (butt.center.x<=self.center.x)
    {
        self.contentOffset = CGPointMake(0, 0);
    }
    else if ((butt.center.x>self.center.x)&&((self.contentSize.width-butt.center.x)>(self.frame.size.width/2.0)))
    {
        self.contentOffset = CGPointMake(butt.center.x-self.center.x, 0);
    }else
    {
        self.contentOffset = CGPointMake(self.contentSize.width-self.frame.size.width, 0);
    }
}

/**
 在当前界面设置选中第几个

 @param selectIndex 选中的下标
 */
-(void)setSelectIndex:(NSInteger)selectIndex{
    [self.titleButton setSelected:YES];
    self.selectedButt = self.buttonArray[selectIndex];
    [self buttonOffset:self.selectedButt];
}

/**
 *  修改选中标题
 *
 *  @param selectedIndex 选中标题的索引
 */
-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    for (UIButton *butt in  self.buttonArray)
    {
        if (butt.tag == selectedIndex)
        {
            [self buttonOffset:butt animated:YES];
            break;
        }
    }
}
- (void)setDefautlTitleColor:(UIColor *)defautlTitleColor
{
    _defautlTitleColor = defautlTitleColor;
    [self.titleButton setTitleColor:defautlTitleColor forState:UIControlStateNormal];
}
- (void)setSelectTitleColor:(UIColor *)selectTitleColor
{
    _selectTitleColor = selectTitleColor;
    [self.titleButton setTitleColor:selectTitleColor forState:UIControlStateSelected];
}
@end
