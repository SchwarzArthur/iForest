//
//  HomeViewController.m
//  GeoMap
//
//  Created by SchwarzArthur on 4/20/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import "AboutViewController.h"
#import "PWParallaxScrollView.h"

#define kUIColor [UIColor whiteColor];
@interface AboutViewController () <PWParallaxScrollViewDataSource>

@property (nonatomic, strong) PWParallaxScrollView *scrollView;
@property (nonatomic, strong) NSArray *photos;

@end

@implementation AboutViewController

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
    [_scrollView moveToIndex:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"About", nil);
    // self.navigationController.navigationBar.tintColor = [UIColor clearColor];

    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:24.0/255.0 green:116.0/255.0 blue:255.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    [self initControl];
    [self setContent:nil];
    [self reloadData];
    
    [_scrollView nextItem];
    
    ____tableView.tableHeaderView = ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 170.0f)];
        
        UILabel *developer = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, ____tableView.frame.size.width - 28, 50)];
        developer.text = @"Application Name : iForest TH\nVersion : 1.1\nDeveloper : Natthanon SchwarzArthur Chaiyasak";
        developer.font = [UIFont fontWithName:@"Avenir Next" size:9];
        developer.backgroundColor = [UIColor clearColor];
        developer.textColor = [UIColor grayColor];
        developer.lineBreakMode = NSLineBreakByCharWrapping;
        developer.numberOfLines = 3;
        
        [view addSubview:developer];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 70, 0, 0)];
        label.text = @"หมายเหตุ :";
        label.font = [UIFont fontWithName:@"Avenir Next" size:14];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = kUIColor;
        [label sizeToFit];
        
        [view addSubview:label];
        
        UILabel *warning = [[UILabel alloc] initWithFrame:CGRectMake(14, 105, ____tableView.frame.size.width - 28, 50)];
        warning.text = @"◉  แผนที่และข้อมูลใดๆใน Application นี้ ใช้เพื่อการศึกษาเท่านั้น \nไม่สามารถใช้อ้างอิงได้ในทางกฏหมาย";
        warning.font = [UIFont fontWithName:@"Avenir Next" size:9];
        warning.backgroundColor = [UIColor clearColor];
        warning.textColor = kUIColor;
        warning.lineBreakMode = NSLineBreakByCharWrapping;
        warning.numberOfLines = 3;
        //[warning sizeToFit];
        
        [view addSubview:warning];
        view;
        
    });
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
    [label setFont:[UIFont fontWithName:@"Avenir Next" size:18]];
    [label setTextAlignment:NSTextAlignmentCenter];
    //[label setText:[NSString stringWithFormat:@"Title %@", @(index + 1)]];
    [label setText:@"iForest"];
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

- (void)initControl {
    self.scrollView = [[PWParallaxScrollView alloc] initWithFrame:CGRectMake(0, 60, 320, 200)];//self.view.bounds
 
    //    _scrollView.foregroundScreenEdgeInsets = UIEdgeInsetsZero;
    _scrollView.foregroundScreenEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 50);
    [self.view insertSubview:_scrollView atIndex:0];
}

- (void)setContent:(id)content
{
    self.photos = @[@"2", @"1", @"3", @"4"];
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

#pragma UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 4;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"ที่มาชั้นข้อมูล :";
    
    /*if (section == 0)
        return @"พื้นที่ป่า และป่าสงวนแห่งชาติ";
    else if (section == 1)
        return @"พื้นที่อนุรักษ์";
    else if (section == 2)
        return @"ป่าชายเลน";
    else
        return @"ขอบเขตการปกครอง";*/
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   /* if (section == 0)
        return 2;
    else if (section == 1)
        return 4;
    else if (section == 2)
        return 1;
    else
        return 3;*/
    return 10;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:14];
    header.textLabel.textColor = [UIColor blackColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //if (indexPath.section == 0) {
        switch ([indexPath row]) {
            case 0:
                [cell.textLabel setText:@"ป่าสงวนแห่งชาติ"];
                [cell.detailTextLabel setText:@"ที่มา: โครงการเร่งด่วนเพื่อแก้ไขปัญหาการบุกรุกทําลายทรัพยากรป่าไม้ของประเทศ"];
                break;
                
            case 1:
                [cell.textLabel setText:@"พื้นที่คงสภาพป่า ปี 2555 - 2556"];
                [cell.detailTextLabel setText:@"ที่มา: กรมป่าไม้โดยคณะวนศาสตร์ มหาวิทยาลัยเกษตรศาสตร์ทำการแปลภาพถ่ายดาวเทียมไทยโชตและ Landsat 8 ปี 2555-2556"];
                break;
    //    }
    //} else if (indexPath.section == 1) {
    //    switch ([indexPath row]) {
            case 2:
                [cell.textLabel setText:@"อุทยานแห่งชาติ"];
                [cell.detailTextLabel setText:@"ที่มา: โครงการเร่งด่วนเพื่อแก้ไขปัญหาการบุกรุกทําลายทรัพยากรป่าไม้ของประเทศ"];
                break;
                
            case 3:
                [cell.textLabel setText:@"เขตรักษาพันธุ์สัตว์ป่า"];
                [cell.detailTextLabel setText:@"ที่มา: โครงการเร่งด่วนเพื่อแก้ไขปัญหาการบุกรุกทําลายทรัพยากรป่าไม้ของประเทศ"];
                break;
            case 4:
                [cell.textLabel setText:@"เขตห้ามล่าสัตว์ป่า"];
                [cell.detailTextLabel setText:@"ที่มา: โครงการเร่งด่วนเพื่อแก้ไขปัญหาการบุกรุกทําลายทรัพยากรป่าไม้ของประเทศ"];
                break;
                
            case 5:
                [cell.textLabel setText:@"วนอุทยาน"];
                [cell.detailTextLabel setText:@"ที่มา: โครงการเร่งด่วนเพื่อแก้ไขปัญหาการบุกรุกทําลายทรัพยากรป่าไม้ของประเทศ"];
                break;
   //     }
   // } else if (indexPath.section == 2) {
   //     switch ([indexPath row]) {
            case 6:
                [cell.textLabel setText:@"ป่าชายเลน"];
                [cell.detailTextLabel setText:@"ที่มา: กรมทรัพยากรทางทะเลและชายฝั่ง"];
                break;
   //     }
   // } else if (indexPath.section == 3) {
   //     switch ([indexPath row]) {
            case 7:
                [cell.textLabel setText:@"ขอบเขตจังหวัด"];
                [cell.detailTextLabel setText:@"ที่มา: กรมการปกครอง"];
                break;
                
            case 8:
                [cell.textLabel setText:@"ขอบเขตอำเภอ"];
                [cell.detailTextLabel setText:@"ที่มา: กรมการปกครอง"];
                break;
            case 9:
                [cell.textLabel setText:@"สารบัญระวาง 1 : 50,000"];
                [cell.detailTextLabel setText:@"ที่มา: กรมแผนที่ทหาร"];
                break;
    //    }
    }
    
    return cell;
}
@end
