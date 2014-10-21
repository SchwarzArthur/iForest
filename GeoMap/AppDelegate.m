//
//  AppDelegate.m
//  GeoMap
//
//  Created by SchwarzArthur on 12/10/2556 BE.
//  Copyright (c) 2556 SchwarzArthur. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "WYPopoverController.h"
#import "WMImageCache.h"
#import "AFNetworking.h"

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
  //  UIViewController *viewController = [[UIViewController alloc] init];
  //  viewController.view.backgroundColor = [UIColor cyanColor];//[UIColor groupTableViewBackgroundColor];
  //  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blurred_background.png"]];
  //  UIWindow *keyWindow = [UIApplication sharedApplication].windows[0];
 //   imageView.frame = keyWindow.bounds;
  //  [keyWindow insertSubview:imageView atIndex:0];
    
    
    //Enabling keyboard manager
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
	//Enabling autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard.
	[[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
	//Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
	[[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    //Giving permission to modify TextView's frame
    [[IQKeyboardManager sharedManager] setCanAdjustTextView:YES];
    
    
    // Override point for customization after application launch.
    
    
    WYPopoverBackgroundView* popoverAppearance = [WYPopoverBackgroundView appearance];
    
    [popoverAppearance setOuterCornerRadius:16];
    [popoverAppearance setOuterShadowBlurRadius:4];
    [popoverAppearance setOuterShadowOffset:CGSizeMake(0, 1)];
    
    [popoverAppearance setGlossShadowColor:[UIColor clearColor]];
    [popoverAppearance setGlossShadowOffset:CGSizeMake(0, 0)];
    
    [popoverAppearance setBorderWidth:0]; // Breaks
    [popoverAppearance setArrowHeight:12];
    [popoverAppearance setArrowBase:20];
    
    [popoverAppearance setInnerCornerRadius:8];
    [popoverAppearance setInnerShadowBlurRadius:0];
    [popoverAppearance setInnerShadowColor:[UIColor clearColor]];
    [popoverAppearance setInnerShadowOffset:CGSizeMake(0, 0)];
    
    UIColor *uniformColor = [UIColor colorWithRed:24.0/255.0 green:116.0/255.0 blue:255.0/255.0 alpha:1];
//[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    [popoverAppearance setFillTopColor:uniformColor];
    [popoverAppearance setFillBottomColor:uniformColor];
    [popoverAppearance setOuterStrokeColor:uniformColor];
    [popoverAppearance setInnerStrokeColor:uniformColor];
    
 /*   UINavigationBar *navBarInPopoverAppearance = [UINavigationBar appearanceWhenContainedIn:[UINavigationController class], [WYPopoverBackgroundView class], nil];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[UIColor clearColor]];
    [shadow setShadowOffset:CGSizeZero];
    
    [navBarInPopoverAppearance setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName : [UIColor purpleColor],
       NSShadowAttributeName: shadow
       }];
    
    //WYPopoverTheme *theme = [WYPopoverTheme themeForIOS6];
    //[WYPopoverController setDefaultTheme:theme];
    
    WYPopoverBackgroundView *popoverAppearance = [WYPopoverBackgroundView appearance];
    [popoverAppearance setArrowHeight:40];
    [popoverAppearance setArrowBase:60];*/
    
    [[WMImageCache sharedInstance] deleteAllCacheFiles];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
     [[WMImageCache sharedInstance] purgeMemoryCache];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[WMImageCache sharedInstance] deleteAllCacheFiles];
}



@end
