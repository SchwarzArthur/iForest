//
//  DEMOMenuViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "DEMOSecondViewController.h"
#import "ViewController.h"

@interface DEMOMenuViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation DEMOMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] init]; // Frame will be automatically set
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"world96.png"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = @"MENU";
        label.font = [UIFont systemFontOfSize:21];//[UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Other";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 1) {
        //  ViewController *mapViewController = [[ViewController alloc] init];
        //  self.navigationController.viewControllers = @[mapViewController];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
            ViewController *controller = [storyboard           instantiateViewControllerWithIdentifier:@"Map"];
            [self.navigationController pushViewController:controller animated:NO];
            
        } else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];
            ViewController *controller = [storyboard           instantiateViewControllerWithIdentifier:@"Map"];
            [self.navigationController pushViewController:controller animated:NO];
        }
        
    } else if (indexPath.section == 0 && indexPath.row == 0) {
        //  DEMOSecondViewController *secondViewController = [[DEMOSecondViewController alloc] init];
        //  self.navigationController.viewControllers = @[secondViewController];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
            DEMOSecondViewController *controller = [storyboard           instantiateViewControllerWithIdentifier:@"Home"];
            [self.navigationController pushViewController:controller animated:NO];
            
        } else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];
            DEMOSecondViewController *controller = [storyboard           instantiateViewControllerWithIdentifier:@"Home"];
            [self.navigationController pushViewController:controller animated:NO];
        }
    } else if (indexPath.section == 0 && indexPath.row == 2) {
      //  ViewController *mapViewController = [[ViewController alloc] init];
      //  self.navigationController.viewControllers = @[mapViewController];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
            ViewController *controller = [storyboard           instantiateViewControllerWithIdentifier:@"Guide"];
            [self.navigationController pushViewController:controller animated:NO];
            
        } else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];
            ViewController *controller = [storyboard           instantiateViewControllerWithIdentifier:@"Guide"];
            [self.navigationController pushViewController:controller animated:NO];
        }
 
    } else if (indexPath.section == 0 && indexPath.row == 3) {
      //  DEMOSecondViewController *secondViewController = [[DEMOSecondViewController alloc] init];
      //  self.navigationController.viewControllers = @[secondViewController];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
            DEMOSecondViewController *controller = [storyboard           instantiateViewControllerWithIdentifier:@"About"];
            [self.navigationController pushViewController:controller animated:NO];
            
        } else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];
            DEMOSecondViewController *controller = [storyboard           instantiateViewControllerWithIdentifier:@"About"];
            [self.navigationController pushViewController:controller animated:NO];
        }
   
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//2
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"Home", @"Map", @"Guide", @"About"];
        cell.textLabel.text = titles[indexPath.row];
    } else {
        NSArray *titles = NULL;
        cell.textLabel.text = titles[indexPath.row];
    }
    
    return cell;
}

@end
