//
//  LeveyPopListViewCell.m
//  LeveyPopListViewDemo
//
//  Created by Levey on 2/21/12.
//  Copyright (c) 2012 Levey. All rights reserved.
//

#import "LeveyPopListViewCell.h"

@implementation LeveyPopListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            self.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:14];//[UIFont fontWithName:@"Thonburi" size:15.];//@"Thonburi" size:14.
        } else {
            self.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:17];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectOffset(self.imageView.frame, 0, 1);
    self.textLabel.frame = CGRectOffset(self.textLabel.frame, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
