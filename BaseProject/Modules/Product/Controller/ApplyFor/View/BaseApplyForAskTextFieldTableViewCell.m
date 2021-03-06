//
//  BaseApplyForAskTextFieldTableViewCell.m
//  BaseProject
//
//  Created by 舒通 on 2017/9/15.
//  Copyright © 2017年 舒通. All rights reserved.
//

#import "BaseApplyForAskTextFieldTableViewCell.h"

@interface BaseApplyForAskTextFieldTableViewCell ()<UITextViewDelegate>
@property (strong, nonatomic) UILabel *placeHolderLabel;
@end
@implementation BaseApplyForAskTextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupTextView];
    self.textView.delegate = self;
}

#pragma mark  ************** textview delegate **************
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length > 0) {
        if (_textViewText) {
            _textViewText(textView.text);
        }
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        if (_textViewText) {
            _textViewText(textView.text);
        }
    }
}


#pragma mark  ************** setter / getter **************
- (void)setPlaceHoldString:(NSString *)placeHoldString
{
    _placeHoldString = placeHoldString;
    self.placeHolderLabel.text = placeHoldString;
}

#pragma mark  ************** create UI **************
- (void)setupTextView
{
    // _placeholderLabel
    self.placeHolderLabel = [[UILabel alloc] init];
    self.placeHolderLabel.text = @"请输入内容";
    self.placeHolderLabel.numberOfLines = 0;
    self.placeHolderLabel.font = [UIFont systemFontOfSize:14];
    self.placeHolderLabel.textColor = [UIColor lightGrayColor];
    [self.placeHolderLabel sizeToFit];
    [self.textView addSubview:self.placeHolderLabel];
    if (@available(iOS 8.3, *)) {
      [self.textView setValue:self.placeHolderLabel forKey:@"_placeholderLabel"];
    }
    
    self.textView.font =  self.placeHolderLabel.font;
}
@end
