//
//  MAlertView.h
//  EY
//
//  Created by ldj on 16/7/26.
//  Copyright © 2016年 2YA. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

typedef NS_ENUM(NSInteger, MAlertViewStyle) {
    MAlertViewStyleDefault = 0,    // 底部弹出
    MAlertViewStyleMiddle,         // 中间弹出
    MAlertViewStyleMiddleInputPwd  // 中间输入密码框
};

@interface MAlertView : UIView

/// 底部弹出事件数组
@property (nonatomic, strong) NSArray  *titleArray;

/// 底部弹出图文事件数组
@property (nonatomic, strong) NSArray  *titleImageArray;

/// 背景阴影
@property (nonatomic, strong) UIView   *bgCoverView;

/// 展示View
@property (nonatomic, strong) UIView   *showView;

/// 标题
@property (nonatomic, strong) UILabel  *titleLabel;

/// 信息
@property (nonatomic, strong) UILabel  *messageLabel;

/// 取消按钮
@property (nonatomic, strong) UIButton *cancelButton;

/// 中间弹出框左边事件标题，中间弹出框只有左边一个事件，只能添加一个事件和取消事件
@property (nonatomic, copy  ) NSString *actionTitle;

/// 点击事件Block index 和数组项对应，index 就是数组中对应标题或者图文的点击
@property (nonatomic, copy) void (^onClickBtn)(NSInteger index);

/// 取消事件
@property (nonatomic, copy) void (^onCancelBtn)();

/**
 *  初始化
 *
 *  @param title          标题
 *  @param message        信息
 *  @param cancelTitle    取消标题 
 *  @param cancelImageStr 取消信息
 *  @param mAlertType     类型
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle cancelImage:(NSString *)cancelImageStr withType:(MAlertViewStyle)mAlertType;

/// 展示弹窗
- (void)show;


/**********密码输入框************/

/// 输入完成检查密码
@property (nonatomic, copy) void (^checkPwd)(NSString *pwd);

/// 忘记密码
@property (nonatomic, copy) void (^toForgetView)();
@end