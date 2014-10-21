//
//  ZoningDetailViewController.m
//  GeoMap
//
//  Created by SchwarzArthur on 9/22/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import "ZoningDetailViewController.h"

@interface ZoningDetailViewController ()

@end

@implementation ZoningDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"Zoning"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        switch ([indexPath row]) {
                
            case 0:
                if ([_ZONEC  isEqual: @""] || [_ZONEC  isEqual: @"(null)"] || [_ZONEC  isEqual: nil]) {
                    _ZONEC = @"-";
                } else {
                
                }
                [cell.textLabel setText:@"อนุรักษ์ (C)"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@  ไร่",_ZONEC]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 1:
                if ([_ZONEE  isEqual: @""] || [_ZONEE  isEqual: @"(null)"] || [_ZONEE  isEqual: nil]) {
                    _ZONEE = @"-";
                } else {
                
                }
                [cell.textLabel setText:@"เศรษฐกิจ (E)"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@  ไร่",_ZONEE]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 2:
                if ([_ZONEA  isEqual: @""] || [_ZONEA  isEqual: @"(null)"] || [_ZONEA  isEqual: nil]) {
                    _ZONEA = @"-";
                } else {
                
                }
                [cell.textLabel setText:@"เกษตรกรรม (A)"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@  ไร่",_ZONEA]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
     
        }
    }
    return cell;
}

@end
