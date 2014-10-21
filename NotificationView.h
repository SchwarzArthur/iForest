//
//  NotificationView.h
//  NotificationView
//
//  Created by Christian Schwarz on 01.09.13.
//  Copyright (c) 2013 Christian Schwarz. Check LICENSE.md.
//

#import <UIKit/UIKit.h>

static CGFloat const kNotificationViewHeight = 120.0f;
static CGFloat const kNotificationViewSymbolViewSidelength = 44.0f;
static NSTimeInterval const kNotificationViewDefaultShowDuration = 5.0;

typedef enum {
    NotificationViewStyleSuccess,
    NotificationViewStyleError,
} NotificationViewStyle;

@interface NotificationView : UIView

#pragma mark + quick presentation

+ (void)showInViewController:(UIViewController*)viewController
                       style:(NotificationViewStyle)style
                     message:(NSString*)message;

+ (void)showInViewController:(UIViewController*)viewController
                   tintColor:(UIColor*)tintColor
                       image:(UIImage*)image
                     message:(NSString*)message
                    duration:(NSTimeInterval)duration;

#pragma mark + creators

+ (NotificationView*)notificationViewWithParentViewController:(UIViewController*)viewController
                                                      tintColor:(UIColor*)tintColor
                                                          image:(UIImage*)image
                                                        message:(NSString*)message;

#pragma mark - initialization

- (instancetype)initWithParentViewController:(UIViewController*)viewController;

#pragma mark - presentation

- (void)setVisible:(BOOL)showing animated:(BOOL)animated completion:(void (^)())completion;
- (void)dismissWithStyle:(NotificationViewStyle)style message:(NSString*)message duration:(NSTimeInterval)duration animated:(BOOL)animated;
@property (readonly, nonatomic, getter = isShowing) BOOL visible;

#pragma mark - visible properties

/**
 The image property should be used for setting the image displayed in imageView
 Only the alpha value will be used and then be tinted to a 'legible' color
 */
@property (nonatomic, strong) UIImage* image;

@property (nonatomic, strong) UIColor* tintColor;

@property (nonatomic, getter = isShowingActivity) BOOL showingActivity;

@end
