//
//  MAlertView.m
//  EY
//
//  Created by ldj on 16/7/26.
//  Copyright © 2016年 2YA. All rights reserved.
//

#import "MAlertView.h"
#import "UIView+Position.h"
#import "InputPwdView.h"

@interface MAlertView()

@property (nonatomic, assign) MAlertViewStyle mAlertType;

/// 标题和信息的高度
@property (nonatomic, assign) CGFloat customHeight;

/// 输入框
@property (nonatomic, strong) InputPwdView *inputPwdView;

@end

@implementation MAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle cancelImage:(NSString *)cancelImageStr withType:(MAlertViewStyle)mAlertType
{
    self = [super init];
    if (self)
    {
        self.mAlertType = mAlertType;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self addSubview:self.bgCoverView];
        [self setupUI];
        if (title)
        {
            self.titleLabel = [self createLabelWithFrame:CGRectMake(40, 20, self.showView.width - 80, 30) text:title];
            self.titleLabel.font          = [UIFont systemFontOfSize:15];
            self.titleLabel.numberOfLines = 1;
            [self.showView addSubview:self.titleLabel];
            self.customHeight = self.titleLabel.bottom;
        }
        if (message)
        {
            CGFloat height = [self heightWithContext:message
                                            fontSize:[UIFont systemFontOfSize:14]
                                            maxWidth:self.showView.width - 80];
            CGFloat messageHeight = height + 30 > SCREEN_HEIGHT - 100 ? SCREEN_HEIGHT - 100 : height + 30;
        
            CGFloat top = self.titleLabel ? self.titleLabel.bottom : 20;
            self.messageLabel = [self createLabelWithFrame:CGRectMake(40, top, self.showView.width - 80, messageHeight) text:message];
            self.messageLabel.font = [UIFont systemFontOfSize:14];
            [self.showView addSubview:self.messageLabel];
            self.customHeight = self.messageLabel.bottom;
        }
       
        self.showView.height = self.customHeight + 15;
        
        if (cancelTitle || cancelImageStr)
        {
            self.showView.height = self.showView.height + 45;
            
            [self.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
            [self.cancelButton setImage:[UIImage imageNamed:cancelImageStr]
                               forState:UIControlStateNormal];
            
            [self.showView addSubview:self.cancelButton];
        }
        
        self.showView.top = SCREEN_HEIGHT - self.showView.height - 12;

        switch (mAlertType) {
            case MAlertViewStyleMiddle:
            {
                self.showView.center          = self.center;
                self.showView.backgroundColor = [UIColor whiteColor];
                [self.cancelButton setTitleColor:[UIColor blackColor]
                                        forState:UIControlStateNormal];
                
                self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
                
                // 下方分割线
                UILabel *separatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, self.messageLabel.height + 10, self.messageLabel.width, 1)];
                separatorLine.backgroundColor = [UIColor grayColor];
                [self.messageLabel addSubview:separatorLine];
            }
                break;
            
            case MAlertViewStyleMiddleInputPwd:
            {
                CGPoint inputCenter           = CGPointMake(self.center.x, self.center.y - 100);
                self.showView.center          = inputCenter;
                self.showView.backgroundColor = [UIColor whiteColor];
                self.cancelButton.frame       = CGRectMake(self.showView.width - 40, 0, 40, 40);
                self.showView.height          = self.inputPwdView.height;
                [self.showView addSubview:self.inputPwdView];
                [self.showView bringSubviewToFront:self.cancelButton];
            }
                break;
                
            default:
                break;
        }  
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.showView];
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (CGFloat)heightWithContext:(NSString *)context fontSize:(UIFont *)fontSize maxWidth:(CGFloat)maxWidth
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:fontSize,NSFontAttributeName, nil];
    CGRect bounds = [context boundingRectWithSize:CGSizeMake(maxWidth, 100000)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:dict
                                          context:nil];
    return bounds.size.height;
}

#pragma mark - Action Methods

- (void)onCancelButton:(id)sender
{
    if (self.onCancelBtn)
    {
        self.onCancelBtn();
    }
    [self removeFromSuperview];
}

- (void)onclickBtn:(UIButton *)sender
{
    if (self.onClickBtn)
    {
        self.onClickBtn(sender.tag - 100);
        [self removeFromSuperview];
    }
}

- (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text;
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    return label;
}

#pragma mark - Getter

// 背景阴影层
- (UIView *)bgCoverView
{
    if (_bgCoverView == nil)
    {
        _bgCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgCoverView.backgroundColor = [UIColor blackColor];
        _bgCoverView.alpha = 0.5;
        
        // 添加收回手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCancelButton:)];
        [_bgCoverView addGestureRecognizer:tap];
    }
    return _bgCoverView;
}

- (UIView *)showView
{
    if (_showView == nil)
    {
        _showView = [[UIView alloc] initWithFrame:CGRectMake(12, SCREEN_HEIGHT - 182, SCREEN_WIDTH - 24, 170)];
        _showView.backgroundColor = [UIColor whiteColor];
    }
    return _showView;
}

- (UIButton *)cancelButton
{
    if (_cancelButton == nil)
    {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, self.showView.height - 45, self.showView.width, 45);
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(onCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

// 只有中间密码输入框才有这个页面
- (InputPwdView *)inputPwdView
{
    if (_inputPwdView == nil && self.mAlertType == MAlertViewStyleMiddleInputPwd)
    {
        _inputPwdView = [[InputPwdView alloc] initWithFrame:CGRectMake(0, 0, self.showView.width, 165)];
        _inputPwdView.promptLabel.text = @"请输入提现密码";
        
        __weak typeof(self) weakSelf = self;
        
        [_inputPwdView setPasswordBlock:^(NSString *pwdStr) {
            
            if (pwdStr.length == 6)
            {
                if (weakSelf.checkPwd)
                {
                    [weakSelf onCancelButton:nil];
                    weakSelf.checkPwd(pwdStr);
                }
            }
        }];
       // TODO: ????
//        [_inputPwdView setToForgetView:^{
//            [weakSelf onCancelButton:nil];
//            if (weakSelf.toForgetView)
//            {
//                weakSelf.toForgetView();
//            }
//        }];
    }
    return _inputPwdView;
}

- (void)setActionTitle:(NSString *)actionTitle
{
    if (self.mAlertType == MAlertViewStyleMiddle)
    {
        _actionTitle = actionTitle;
        UIButton *clickBtn       = [UIButton buttonWithType:UIButtonTypeCustom];
        clickBtn.frame           = CGRectMake(0, self.cancelButton.top, self.showView.width / 2, 45);
        clickBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        clickBtn.tag             = 100;
        [clickBtn setTitle:_actionTitle forState:UIControlStateNormal];
        [clickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [clickBtn addTarget:self action:@selector(onclickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        // 中间分割线
        UILabel *separatorLine = [[UILabel alloc] initWithFrame:CGRectMake(clickBtn.right - 1, clickBtn.top + 10, 1, 25)];
        separatorLine.backgroundColor = [UIColor blackColor];
        [self.showView addSubview:separatorLine];
        
        self.cancelButton.left  = clickBtn.right;
        self.cancelButton.width = clickBtn.width;
        [self.showView addSubview:clickBtn];
    }
}

- (void)setTitleArray:(NSArray *)titleArray
{
    if (self.mAlertType == MAlertViewStyleDefault)
    {
        _titleArray = titleArray;
        for (int i = 0; i < _titleArray.count; i++)
        {
            UIButton *clickBtn       = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat top              = _messageLabel ? _messageLabel.bottom : 20;
            clickBtn.frame           = CGRectMake(0, top + i*45 , self.showView.width, 45);
            clickBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            clickBtn.tag             = 100 + i;
            [clickBtn setTitle:_titleArray[i] forState:UIControlStateNormal];
            [clickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [clickBtn addTarget:self action:@selector(onclickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.showView addSubview:clickBtn];
            
            // 下方分割线
            UILabel *separatorLine = [[UILabel alloc] initWithFrame:CGRectMake(45, clickBtn.height - 1, clickBtn.width - 90, 1)];
            separatorLine.backgroundColor = [UIColor lightGrayColor];
            if (i != _titleArray.count - 1)
            {
                [clickBtn addSubview:separatorLine];
            }
            
            self.cancelButton.top = clickBtn.bottom + 15;
        }
        self.showView.height = self.cancelButton.bottom;
        self.showView.top = SCREEN_HEIGHT - self.showView.height - 12;
    }
}

- (void)setTitleImageArray:(NSArray *)titleImageArray
{
    if (self.mAlertType == MAlertViewStyleDefault)
    {
        _titleImageArray = titleImageArray;
        
        NSInteger colNum = (self.showView.width - 60) / 97;
        
        if (_titleImageArray.count < colNum)
        {
            CGFloat width = (self.showView.width - 60) / _titleImageArray.count;
            for (int i = 0; i < _titleImageArray.count; i++)
            {
                NSDictionary *dict     = _titleImageArray[i];
                CGFloat top            = self.customHeight ? self.customHeight : 20;
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30 + i*width, top, width, 65)];
                imageView.image        = [UIImage imageNamed:[dict objectForKey:@"image"]];
                imageView.contentMode  = UIViewContentModeScaleAspectFit;
                [self.showView addSubview:imageView];
                
                CGFloat height = [self heightWithContext:[dict objectForKey:@"title"]
                                                fontSize:[UIFont systemFontOfSize:12]
                                                maxWidth:self.showView.width - 80] + 20;
                
                
                UILabel *titleLabel = [self createLabelWithFrame:CGRectMake(imageView.left, imageView.bottom, width, height)
                                                            text:[dict objectForKey:@"title"]];
                [self.showView addSubview:titleLabel];
                
                UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                clickBtn.frame     = CGRectMake(imageView.left, 0, width, titleLabel.bottom);
                clickBtn.tag       = 100 + i;
                [clickBtn addTarget:self action:@selector(onclickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [self.showView addSubview:clickBtn];
                
                self.cancelButton.top = clickBtn.bottom + 15;
            }
        }else
        {
            CGFloat space = (self.showView.width - 60 - 97*colNum) /(colNum - 1);
            for (int i = 0; i < _titleImageArray.count ; i++)
            {
                NSInteger col = i%colNum;
                NSInteger row = i/colNum;
                
                NSDictionary *dict     = _titleImageArray[i];
                CGFloat top            = self.customHeight ? self.customHeight : 20;
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30 + col * (97 + space), top + row * 100, 97, 65)];
                imageView.image        = [UIImage imageNamed:[dict objectForKey:@"image"]];
                imageView.contentMode  = UIViewContentModeScaleAspectFit;
                [self.showView addSubview:imageView];
                
                UILabel *titleLabel = [self createLabelWithFrame:CGRectMake(imageView.left, imageView.bottom, 97, 35)
                                                            text:[dict objectForKey:@"title"]];
                [self.showView addSubview:titleLabel];
                
                UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                clickBtn.frame     = CGRectMake(imageView.left, imageView.top, 97, 100);
                clickBtn.tag       = 100 + i;
                [clickBtn addTarget:self action:@selector(onclickBtn:)
                   forControlEvents:UIControlEventTouchUpInside];
                [self.showView addSubview:clickBtn];
                
                self.cancelButton.top = clickBtn.bottom + 15;
            }
        }
        self.showView.height = self.cancelButton.bottom;
        self.showView.top    = SCREEN_HEIGHT - self.showView.height - 12;
    }
}

@end
