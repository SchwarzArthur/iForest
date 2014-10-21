//
//  StepRouteViewController.m
//  GeoMap
//
//  Created by SchwarzArthur on 4/14/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import "StepRouteViewController.h"
#import "IndividualStepViewController.h"
#import "RouteTableViewCell.h"

@interface StepRouteViewController ()

@end

@implementation StepRouteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = [NSString stringWithFormat:@"Route Steps of %lu", (unsigned long)[_route.steps count]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:24.0/255.0 green:116.0/255.0 blue:255.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.route.steps count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    RouteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Pull out the correct step
    MKRouteStep *step = self.route.steps[indexPath.row];
    
    // Configure the cell...
    cell.labelTitle.text = [NSString stringWithFormat:@"%02ld. Distance: %0.1f km", (long)indexPath.row, step.distance / 1000.0];
    cell.label.text = step.instructions;//step.notice;
    
    return cell;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[IndividualStepViewController class]]) {
        IndividualStepViewController *vc = (IndividualStepViewController *)[segue destinationViewController];
        NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];
        
        // If we have a selected row then set the step appropriately
        if(selectedRow) {
            vc.routeStep = self.route.steps[selectedRow.row];
            vc.stepIndex = selectedRow.row;
        }
    }
}

@end

