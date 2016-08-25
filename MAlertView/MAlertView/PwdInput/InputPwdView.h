//
//  InputPwdView.h
//  EY
//
//  Created by ldj on 16/7/28.
//  Copyright © 2016年 2YA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputPwdView : UIView

/// 返回密码
@property (nonatomic, copy) void(^passwordBlock)(NSString *password);

/// 返回密码
@property (nonatomic, copy) void(^toForgetView)();

/// 提示框，便于修改提示
@property (nonatomic, strong) UILabel *promptLabel;

/// 忘记密码，没有的时候要注意隐藏
@property (nonatomic, strong) UIButton *forgetBtn;

/// 清除输入内容
- (void)clearInputText;

@end
