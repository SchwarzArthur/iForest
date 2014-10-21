//
//  UseAreaDetailViewController.m
//  GeoMap
//
//  Created by SchwarzArthur on 9/11/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import "SubUseAreaDetailViewController.h"

@interface SubUseAreaDetailViewController ()

@end

@implementation SubUseAreaDetailViewController

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
    self.navigationItem.title = [NSString stringWithFormat:@"แปลงอนุญาตฯ"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
    return nil;
    } else if (section == 1) {
        return nil;
    } else if (section == 2) {
        return nil;
    } else if (section == 3) {
        return nil;
    } else if (section == 4) {
        return nil;
    } else if (section == 5) {
        return nil;
    } else if (section == 6) {
        return nil;
    } else if (section == 7) {
        return nil;
    } else {
        return nil;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        switch ([indexPath row]) {
                
            case 0:
                [cell.textLabel setText:@"ราย ( ครอบครัว )"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@  ราย",_LAW_A_PEOPLE]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 1:
                [cell.textLabel setText:@"เนื้อที่"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@   ไร่",_LAW_A_AREA]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
        }
    } else if (indexPath.section == 1) {
        
        switch ([indexPath row]) {
                
            case 0:
                [cell.textLabel setText:@"ราย ( ครอบครัว )"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@  ราย",_LAW_B_PEOPLE]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 1:
                [cell.textLabel setText:@"เนื้อที่"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@   ไร่",_LAW_B_AREA]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
        }
    } else if (indexPath.section == 2) {
        
        switch ([indexPath row]) {
                
            case 0:
                [cell.textLabel setText:@"ราย ( ครอบครัว )"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@  ราย",_LAW_C_PEOPLE]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 1:
                [cell.textLabel setText:@"เนื้อที่"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@   ไร่",_LAW_C_AREA]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
        }
    } else if (indexPath.section == 3) {
        
        switch ([indexPath row]) {
                
            case 0:
                [cell.textLabel setText:@"ราย ( ครอบครัว )"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@  ราย",_LAW_D_PEOPLE]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 1:
                [cell.textLabel setText:@"เนื้อที่"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@   ไร่",_LAW_D_AREA]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
        }
    } else if (indexPath.section == 4) {
        
        switch ([indexPath row]) {
                
            case 0:
                [cell.textLabel setText:@"ราย ( ครอบครัว )"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@  ราย",_LAW_E_PEOPLE]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 1:
                [cell.textLabel setText:@"เนื้อที่"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@   ไร่",_LAW_E_AREA]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
        }
    } else if (indexPath.section == 5) {
        
        switch ([indexPath row]) {
                
            case 0:
                [cell.textLabel setText:@"ราย ( ครอบครัว )"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@  ราย",_LAW_F_PEOPLE]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 1:
                [cell.textLabel setText:@"เนื้อที่"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@   ไร่",_LAW_F_AREA]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
        }
    } else if (indexPath.section == 6) {
        
        switch ([indexPath row]) {
                
            case 0:
                [cell.textLabel setText:@"ราย ( ครอบครัว )"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@  ราย",_LAW_G_PEOPLE]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 1:
                [cell.textLabel setText:@"เนื้อที่"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@   ไร่",_LAW_G_AREA]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
        }
    } else if (indexPath.section == 7) {
        
        switch ([indexPath row]) {
                
            case 0:
                [cell.textLabel setText:@"ราย ( ครอบครัว )"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@  ราย",_LAW_H_PEOPLE]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 1:
                [cell.textLabel setText:@"เนื้อที่"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@   ไร่",_LAW_H_AREA]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
        }
    }
    return cell;
}

@end
