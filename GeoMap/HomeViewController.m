//
//  HomeViewController.m
//  GeoMap
//
//  Created by SchwarzArthur on 4/20/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import "HomeViewController.h"
#import "DEMONavigationController.h"
#import "PWParallaxScrollView.h"

@interface HomeViewController () <PWParallaxScrollViewDataSource>

@property (nonatomic, strong) PWParallaxScrollView *scrollView;
@property (nonatomic, strong) NSArray *photos;

@end

@implementation HomeViewController

- (IBAction)prev:(id)sender
{
    [_scrollView prevItem];
}

- (IBAction)next:(id)sender
{
    [_scrollView nextItem];
}

- (IBAction)jumpToItem:(id)sender
{
    [_scrollView moveToIndex:3];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Home", nil);
    // self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(DEMONavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:24.0/255.0 green:116.0/255.0 blue:255.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self initControl];
    [self setContent:nil];
    [self reloadData];
    
    [_scrollView nextItem];
}

#pragma mark - PWParallaxScrollViewSource

- (NSInteger)numberOfItemsInScrollView:(PWParallaxScrollView *)scrollView
{
    return [self.photos count];
}

- (UIView *)backgroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.photos[index]]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}

- (UIView *)foregroundViewAtIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 150, 35)];
    [label setBackgroundColor:[UIColor blackColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:[NSString stringWithFormat:@"Title %@", @(index + 1)]];
    [label setAlpha:0.7f];
    [label setUserInteractionEnabled:YES];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:label.bounds];
    [button setShowsTouchWhenHighlighted:YES];
    [button addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [label addSubview:button];
    
    return label;
}

- (void)test
{
    NSLog(@"hit test");
}

#pragma mark - PWParallaxScrollViewDelegate

- (void)didChangeIndex:(NSInteger)index scrollView:(PWParallaxScrollView *)scrollView {}

#pragma mark - view's life cycle

- (void)initControl
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    
        self.scrollView = [[PWParallaxScrollView alloc] initWithFrame:CGRectMake(0, 60, 320, 170)];//self.view.bounds
    } else {
        self.scrollView = [[PWParallaxScrollView alloc] initWithFrame:CGRectMake(0, 60, 768, 432.5)];
    }
    //    _scrollView.foregroundScreenEdgeInsets = UIEdgeInsetsZero;
    _scrollView.foregroundScreenEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 100);
    [self.view insertSubview:_scrollView atIndex:0];
}

- (void)setContent:(id)content
{
    self.photos = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg"];
}

- (void)reloadData
{
    _scrollView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}
@end
