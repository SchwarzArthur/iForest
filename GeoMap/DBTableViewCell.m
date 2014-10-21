//
//  DBTableViewCell.m
//  GeoMap
//
//  Created by SchwarzArthur on 4/8/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import "DBTableViewCell.h"

@implementation DBTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
