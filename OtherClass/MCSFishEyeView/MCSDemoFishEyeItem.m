//
//  MCSDemoFishEyeItem.m
//  FishEyeDemo
//
//  Created by Bartosz Ciechanowski on 8/30/13.
//  Copyright (c) 2013 Macoscope. All rights reserved.
//

#import "MCSDemoFishEyeItem.h"
#import <QuartzCore/QuartzCore.h>

@interface MCSDemoFishEyeItem()
@end

@implementation MCSDemoFishEyeItem

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.layer.cornerRadius = 55.0f;
    
    _label = [[UILabel alloc] initWithFrame:self.bounds];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont fontWithName:@"Avenir Next" size:15];
    _label.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_backgroundView];
    [self addSubview:_label];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  _backgroundView.frame = CGRectInset(self.bounds, 5.0, 5.0);
  _label.frame = CGRectInset(self.bounds, 5.0, 5.0);
  
}

- (UIColor *)selectedColor
{
  return [UIColor colorWithRed:69.0f/255.0f green:69.0f/255.0f blue:69.0f/255.0f alpha:1.0];
}

- (UIColor *)highlightedColor
{
  return [UIColor colorWithRed:97.0f/255.0f green:97.0f/255.0f blue:97.0f/255.0f alpha:1.0];
}

- (UIColor *)defaultColor
{
  return [UIColor colorWithRed:122.0f/255.0f green:122.0f/255.0f blue:122.0f/255.0f alpha: 0.8];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  [UIView animateWithDuration:animated ? 0.2 : 0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    if (selected) {
      self.backgroundView.backgroundColor = [self selectedColor];
      self.label.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    } else {
      self.backgroundView.backgroundColor = [self defaultColor];
      self.label.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    //self.label.textColor = [UIColor colorWithWhite:0.2 alpha:0.7];
    }
  } completion:NULL];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
  [super setHighlighted:highlighted animated:animated];
  
  [UIView animateWithDuration:animated ? 0.2 : 0.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    if (highlighted) {
      self.backgroundView.backgroundColor = [self highlightedColor];
      self.label.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    } else {
      self.backgroundView.backgroundColor = [self defaultColor];
      //self.label.textColor = [UIColor colorWithWhite:0.2 alpha:0.7];
      self.label.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    }
  } completion:NULL];
  
}

@end
