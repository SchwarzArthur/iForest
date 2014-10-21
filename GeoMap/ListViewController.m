//
//  ListViewController.m
//  GeoMap
//
//  Created by SchwarzArthur on 12/10/2556 BE.
//  Copyright (c) 2556 SchwarzArthur. All rights reserved.
//

#import "ListViewController.h"
#import "Annotation.h"
#import "DetailViewController.h"
#import "WYStoryboardPopoverSegue.h"
#import "ViewController.h"

@interface ListViewController ()<WYPopoverControllerDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    WYPopoverController *detailPopoverController;
    
    ViewController *__viewController;
    
    __weak IBOutlet MKMapView *_mapView;
    __weak IBOutlet UIView *_containerView;
}

@end

#define CELL_HEIGHT 50

@implementation ListViewController
@synthesize _searchBar, _filteredTableData, _isFiltered;

- (void)viewDidLoad
{
    
    _searchBar.placeholder = NSLocalizedString(@"Search for places in tables", nil);

    _tableView.backgroundColor = [UIColor clearColor];

    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setAreas:(NSMutableArray *)areas
{
    _areas = areas;
    [_tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ViewController class]]){
        __viewController = (ViewController *)segue.destinationViewController;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        NSUInteger selectedRow = [_tableView indexPathForSelectedRow].row;
        
        if(_isFiltered){
            
            ((DetailViewController *)segue.destinationViewController).area = _filteredTableData[selectedRow];
        } else {
            ((DetailViewController *)segue.destinationViewController).area = self.areas[selectedRow];
        }
        
    } else {
        
        NSUInteger selectedRow = [_tableView indexPathForSelectedRow].row;
        
        if(_isFiltered){
            
            ((DetailViewController *)segue.destinationViewController).area = _filteredTableData[selectedRow];
        } else {
            ((DetailViewController *)segue.destinationViewController).area = self.areas[selectedRow];
        }
        WYStoryboardPopoverSegue *popoverSegue = (WYStoryboardPopoverSegue *)segue;
        
        detailPopoverController = [popoverSegue popoverControllerWithSender:sender
                                                   permittedArrowDirections:WYPopoverArrowDirectionDown
                                                                   animated:YES
                                                                    options:WYPopoverAnimationOptionFadeWithScale];
        detailPopoverController.delegate = self;
        
    }
    [_searchBar resignFirstResponder];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_isFiltered)
        return @"search from Place";
    else
        return  @"Place";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_isFiltered)
        return _filteredTableData.count;
    else
        return self.areas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"area";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
     
    }
    
    Annotation *ml ;
    {
        if(_isFiltered)
            ml = _filteredTableData[indexPath.row];
        else
            ml = self.areas[indexPath.row];
    }
    
   // Annotation *area = self.areas[indexPath.row];
    
    cell.textLabel.text = ml.title;
    cell.detailTextLabel.text = ml.subtitle;
    
    
    
    return cell;
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        _isFiltered = FALSE;
    }
    else
    {
        _isFiltered = true;
        
        _filteredTableData = [[NSMutableArray alloc] init];
        
        for (Annotation* ml in self.areas )
            
        {
            NSRange titleRange = [ml.title rangeOfString:text options:NSCaseInsensitiveSearch];
            
            NSRange subTitleRange = [ml.subtitle rangeOfString:text options:NSCaseInsensitiveSearch];
            
            
            if(titleRange.location != NSNotFound || subTitleRange.location != NSNotFound )
            {
                [_filteredTableData addObject:ml];
            }
        }
    }
    [_tableView reloadData];
}

/*-(NSString *)tableView:(UITableView *)tableView titleForSwipeAccessoryButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"Go to Point";
}

-(void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Annotation *ml ;
    {
        if(_isFiltered)
            ml = _filteredTableData[indexPath.row];
        else
            ml = self.areas[indexPath.row];
    }

    _setRegionList = ml.coordinate;
    
    [UIView animateWithDuration:0.5 animations:^{
        _mapView.alpha = 1;
        _containerView.alpha = 0;
  
    }];
    
    __viewController.setRegion = _setRegionList;

    NSLog(@"%f,%f",ml.coordinate.latitude,ml.coordinate.longitude);
   // [self dismissViewControllerAnimated:YES completion:nil];
}*/

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        [self performSegueWithIdentifier:@"listToDetails" sender:self];
    } else {
        
        UIView *btn = [UIView new];
        btn.frame = CGRectMake(0, 0, 320, 522);
        
        DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        detailViewController.preferredContentSize = CGSizeMake(320, 522);
        detailViewController.modalInPopover = NO;
        
        UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
        
        detailPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
        detailPopoverController.delegate = self;
        detailPopoverController.passthroughViews = @[];//@[btn];
        detailPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
        detailPopoverController.wantsDefaultContentAppearance = NO;
        
        [detailPopoverController presentPopoverFromRect:CGRectMake(0, 0, 320, 522)
                                                 inView:self.view
                               permittedArrowDirections:WYPopoverArrowDirectionAny
                                               animated:YES
                                                options:WYPopoverAnimationOptionFadeWithScale];
    }
}
- (void)close:(id)sender// don't use^
{
    [detailPopoverController dismissPopoverAnimated:YES completion:^{
        [self popoverControllerDidDismissPopover:detailPopoverController];
    }];
}
#pragma mark - WYPopoverControllerDelegate


- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (BOOL)popoverControllerShouldIgnoreKeyboardBounds:(WYPopoverController *)popoverController
{
    return YES;
}

- (void)popoverController:(WYPopoverController *)popoverController willTranslatePopoverWithYOffset:(float *)value
{
    // keyboard is shown and the popover will be moved up by 163 pixels for example ( *value = 163 )
    *value = 0; // set value to 0 if you want to avoid the popover to be moved
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)aPopoverController
{
    if (aPopoverController == detailPopoverController)
    {
        detailPopoverController.delegate = nil;
        detailPopoverController = nil;
    }
    
}

//This function is where all the magic happens
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    //!!!FIX for issue #1 Cell position wrong------------
    if(cell.layer.position.x != 0){
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    }
    
    //4. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}


//Helper function to get a random float
- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (UIColor*)colorFromIndex:(int)index{
    UIColor *color;
    
    //Purple
    if(index % 3 == 0){
        color = [UIColor colorWithRed:0.93 green:0.01 blue:0.55 alpha:1.0];
        //Blue
    }else if(index % 3 == 1){
        color = [UIColor colorWithRed:0.00 green:0.68 blue:0.94 alpha:1.0];
        //Blk
    }else if(index % 3 == 2){
        color = [UIColor blackColor];
    }
    else if(index % 3 == 3){
        color = [UIColor colorWithRed:0.00 green:1.0 blue:0.00 alpha:1.0];
    }
    
    
    return color;
    
}
@end
