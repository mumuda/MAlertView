//
//  InputPwdView.m
//  EY
//
//  Created by ldj on 16/7/28.
//  Copyright © 2016年 2YA. All rights reserved.
//

#import "InputPwdView.h"
#import "UIView+Position.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface InputPwdView()<UITextFieldDelegate>
/// 输入框，隐藏
@property (nonatomic, strong) UITextField    *textField;

/// 加密label数组
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation InputPwdView
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.textField];
        [self.textField becomeFirstResponder];
        [self setupUI];
    }
    return self;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *password = [textField.text mutableCopy];
    [password replaceCharactersInRange:range withString:string];
    if (password.length > 6)
    {
        return NO;
    }
    return YES;
}

#pragma mark - Action Methods

- (void)onTap:(id)sender
{
    [self.textField becomeFirstResponder];
}

- (void)onForgetBtn:(id)sender
{
    [_textField resignFirstResponder];
    if (self.toForgetView)
    {
        self.toForgetView();
    }
}

#pragma mark - Private Methods

- (void)clearInputText
{
    for (int i = 0; i < self.dataArray.count; i++)
    {
        UILabel *backLabel= [self.dataArray objectAtIndex:i];
        backLabel.hidden = YES;
        self.textField.text = @"";
    }
}

- (void)textChange:(UITextField *)textField
{
    NSString *password = textField.text;
    if (password.length > 6)
    {
        return;
    }
    
    for (int i = 0; i < self.dataArray.count; i++)
    {
        UILabel *backLabel= [self.dataArray objectAtIndex:i];
        if (i < password.length)
        {
            backLabel.hidden = NO;
        } else {
            backLabel.hidden = YES;
        }
        
    }
    !self.passwordBlock ? : self.passwordBlock(textField.text);
}

- (void)setupUI
{
    [self addSubview:self.promptLabel];
    
    // 下方分割线
    UILabel *separatorLine = [[UILabel alloc] initWithFrame:CGRectMake(33, self.promptLabel.bottom, SCREEN_WIDTH - 66, 1)];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:separatorLine];
    
    // 输入框
    UILabel *inputLabel          = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 40)];
    inputLabel.layer.borderWidth = 1;
    inputLabel.layer.borderColor = [UIColor blackColor].CGColor;
    CGPoint inputCenter          = CGPointMake(self.center.x, self.height / 2 + 5);
    inputLabel.center            = inputCenter;
    inputLabel.userInteractionEnabled = YES;
    [self addSubview:inputLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [inputLabel addGestureRecognizer:tap];
    
    // 输入框显示的密码
    CGFloat space = (inputLabel.width / 6 - 10) / 2 ;
    for (int i = 0; i < 6 ; i++)
    {
        UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(space + i * (space * 2 + 10), 15, 10, 10)];
        backLabel.clipsToBounds      = YES;
        backLabel.layer.cornerRadius = 5;
        backLabel.backgroundColor    = [UIColor blackColor];
        backLabel.tag                = 100 + i;
        backLabel.hidden             = YES;
        [inputLabel addSubview:backLabel];
        [self.dataArray addObject:backLabel];
        
        // 中间分割线
        UILabel *separatorLine = [[UILabel alloc] initWithFrame:CGRectMake(backLabel.right + space - 6, 7.5, 2, 25)];
        separatorLine.backgroundColor = [UIColor lightGrayColor];
        
        if (i != 5)
        {
            [inputLabel addSubview:separatorLine];
        }
    }
    [self addSubview:self.forgetBtn];
}

- (UILabel *)promptLabel
{
    if (_promptLabel == nil)
    {
        _promptLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 24, 30)];
        CGPoint promptCenter       = CGPointMake(self.center.x, self.height / 2 - 45);
        _promptLabel.center        = promptCenter;
        _promptLabel.font          = [UIFont systemFontOfSize:14];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _promptLabel;
}

- (UITextField *)textField
{
    if (_textField == nil)
    {
        _textField              = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.delegate     = self;
        _textField.hidden       = YES;
        [_textField addTarget:self
                       action:@selector(textChange:)
             forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UIButton *)forgetBtn
{
    if (_forgetBtn == nil)
    {
        _forgetBtn       = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetBtn.frame           = CGRectMake(30, self.height / 2 + 30, SCREEN_WIDTH - 60, 20);
        _forgetBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [_forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [_forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_forgetBtn addTarget:self action:@selector(onForgetBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetBtn;
}

@end
