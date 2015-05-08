//
//  MAActionCell.m
//  MAToolKit
//
//  Created by Mike on 7/30/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import "MAActionCell.h"

@interface MAActionCell ()

@end

@implementation MAActionCell

+ (instancetype)actionCellWithTitle:(NSString *)title subtitle:(NSString *)subtitle accessory:(NSString *)accessory action:(dispatch_block_t)action {
    MAActionCell *actionCell = [[MAActionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    actionCell.textLabel.text = title;
    actionCell.textLabel.font = [UIFont systemFontOfSize:11];
    
    actionCell.detailTextLabel.text = subtitle;
    actionCell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    actionCell.detailTextLabel.numberOfLines = 0;
    
    if([accessory  isEqual: @"button"]) {
        actionCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        actionCell.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else {
        actionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    actionCell.actionBlock = action ?: ^{};
    return actionCell;
}


@end
