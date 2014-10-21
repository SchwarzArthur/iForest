//
//  AAShareBubbles.m
//  AAShareBubbles
//
//  Created by Almas Adilbek on 26/11/13.
//  Copyright (c) 2013 Almas Adilbek. All rights reserved.
//  https://github.com/mixdesign/AAShareBubbles
//

#import "AAShareBubbles.h"
#import <QuartzCore/QuartzCore.h>

@interface AAShareBubbles()
@end

@implementation AAShareBubbles
{
    NSMutableArray *bubbles;
    NSMutableDictionary *bubbleIndexTypes;
    
    UIView *bgView;
}

@synthesize delegate = _delegate, parentView;

- (id)initWithPoint:(CGPoint)point radius:(int)radiusValue inView:(UIView *)inView
{
    self = [super initWithFrame:CGRectMake(point.x - radiusValue, point.y - radiusValue, 2 * radiusValue, 2 * radiusValue)];
    if (self) {
        self.radius = radiusValue;
        self.bubbleRadius = 30;
        self.parentView = inView;
        
        self.facebookBackgroundColorRGB = 0x3c5a9a;
        self.twitterBackgroundColorRGB = 0x3083be;
        self.mailBackgroundColorRGB = 0xbb54b5;
        self.googlePlusBackgroundColorRGB = 0xd95433;
        self.tumblrBackgroundColorRGB = 0x385877;
        self.vkBackgroundColorRGB = 0x4a74a5;
        self.linkedInBackgroundColorRGB = 0x008dd2;
        self.pinterestBackgroundColorRGB = 0xb61d23;
        self.youtubeBackgroundColorRGB = 0xce3025;
        self.vimeoBackgroundColorRGB = 0x00acf2;
        self.redditBackgroundColorRGB = 0xffffff;
        
        self.addAreaBackgroundColorRGB =  0x1E90FF;//0x87CEFA;//0x40E0D0;//0x00BFFF;
        self.legendBackgroundColorRGB = 0x1E90FF;//0x87CEEB;
        self.searchBackgroundColorRGB = 0x1E90FF;//0xADD8E6;
        self.addPinBackgroundColorRGB = 0x1E90FF;
        self.trackBackgroundColorRGB = 0x1E90FF;//0x00BFFF;
        self.navigationBackgroundColorRGB = 0x1E90FF;//0x40E0D0;
        self.rulerBackgroundColorRGB = 0x1E90FF;//0x4682B4;
        self.editBackgroundColorRGB = 0x1E90FF;//0x5F9EA0;
        self.settingBackgroundColorRGB = 0x1E90FF;//0xB0E0E6;
        self.shareBackgroundColorRGB = 0x48D1CC;
        self.curlBackgroundColorRGB = 0x1E90FF;//0xAFEEEE;

    }
    return self;
}

#pragma mark -
#pragma mark Actions

-(void)buttonWasTapped:(UIButton *)button {
    AAShareBubbleType buttonType = [[bubbleIndexTypes objectForKey:[NSNumber numberWithInteger:button.tag]] intValue];
    [self shareButtonTappedWithType:buttonType];
}

-(void)shareButtonTappedWithType:(AAShareBubbleType)buttonType {
    [self hide];
    if([self.delegate respondsToSelector:@selector(aaShareBubbles:tappedBubbleWithType:)]) {
        [self.delegate aaShareBubbles:self tappedBubbleWithType:buttonType];
    }
}

#pragma mark -
#pragma mark Methods

-(void)show
{
    if(!self.isAnimating)
    {
        self.isAnimating = YES;
        
        [self.parentView addSubview:self];
        
        // Create background
        bgView = [[UIView alloc] initWithFrame:self.parentView.bounds];
        UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareViewBackgroundTapped:)];
        [bgView addGestureRecognizer:tapges];
        [parentView insertSubview:bgView belowSubview:self];
        // --
        
        if(bubbles) {
            bubbles = nil;
        }
        
        bubbles = [[NSMutableArray alloc] init];
        bubbleIndexTypes = [[NSMutableDictionary alloc] init];
        
        if(self.showFacebookBubble)     [self createButtonWithIcon:@"icon-aa-facebook.png" backgroundColor:self.facebookBackgroundColorRGB andType:AAShareBubbleTypeFacebook andText:nil];
        if(self.showTwitterBubble)      [self createButtonWithIcon:@"icon-aa-twitter.png" backgroundColor:self.twitterBackgroundColorRGB andType:AAShareBubbleTypeTwitter andText:nil];
        if(self.showGooglePlusBubble)   [self createButtonWithIcon:@"icon-aa-googleplus.png" backgroundColor:self.googlePlusBackgroundColorRGB andType:AAShareBubbleTypeGooglePlus andText:nil];
        if(self.showTumblrBubble)       [self createButtonWithIcon:@"icon-aa-tumblr.png" backgroundColor:self.tumblrBackgroundColorRGB andType:AAShareBubbleTypeTumblr andText:nil];
        if(self.showMailBubble)         [self createButtonWithIcon:@"icon-aa-at.png" backgroundColor:self.mailBackgroundColorRGB andType:AAShareBubbleTypeMail andText:nil];
        if(self.showVkBubble)           [self createButtonWithIcon:@"icon-aa-vk.png" backgroundColor:self.vkBackgroundColorRGB andType:AAShareBubbleTypeVk andText:nil];
        if(self.showLinkedInBubble)     [self createButtonWithIcon:@"icon-aa-linkedin.png" backgroundColor:self.linkedInBackgroundColorRGB andType:AAShareBubbleTypeLinkedIn andText:nil];
        if(self.showPinterestBubble)    [self createButtonWithIcon:@"icon-aa-pinterest.png" backgroundColor:self.pinterestBackgroundColorRGB andType:AAShareBubbleTypePinterest andText:nil];
        if(self.showYoutubeBubble)      [self createButtonWithIcon:@"icon-aa-youtube.png" backgroundColor:self.youtubeBackgroundColorRGB andType:AAShareBubbleTypeYoutube andText:nil];
        if(self.showVimeoBubble)        [self createButtonWithIcon:@"icon-aa-vimeo.png" backgroundColor:self.vimeoBackgroundColorRGB andType:AAShareBubbleTypeVimeo andText:nil];
        if(self.showRedditBubble)        [self createButtonWithIcon:@"icon-aa-reddit.png" backgroundColor:self.redditBackgroundColorRGB andType:AAShareBubbleTypeReddit andText:nil];
        
        
        if(self.showSettingBubble)     [self createButtonWithIcon:@"Msetting" backgroundColor:self.settingBackgroundColorRGB andType:AAShareBubbleTypeSetting andText:@""];
        if(self.showShareBubble)      [self createButtonWithIcon:nil backgroundColor:self.shareBackgroundColorRGB andType:AAShareBubbleTypeShare andText:@"Share"];
        if(self.showSearchBubble)   [self createButtonWithIcon:@"Msearch" backgroundColor:self.searchBackgroundColorRGB andType:AAShareBubbleTypeSearch andText:@""];
        if(self.showAddAreaBubble)       [self createButtonWithIcon:@"MLayerOverlay" backgroundColor:self.addAreaBackgroundColorRGB andType:AAShareBubbleTypeAddArea andText:@""];
        if(self.showAddPinPlusBubble)         [self createButtonWithIcon:@"Mpin_add_n" backgroundColor:self.addPinBackgroundColorRGB andType:AAShareBubbleTypeAddPin andText:@""];
        if(self.showEditBubble)      [self createButtonWithIcon:@"pMenu_polygon" backgroundColor:self.editBackgroundColorRGB andType:AAShareBubbleTypeEdit andText:@""];
        if(self.showNavigationBubble)     [self createButtonWithIcon:@"MRouteN" backgroundColor:self.navigationBackgroundColorRGB andType:AAShareBubbleTypeNavigation andText:@""];
        if(self.showLegendBubble)    [self createButtonWithIcon:@"Mlegend" backgroundColor:self.legendBackgroundColorRGB andType:AAShareBubbleTypeLegend andText:@""];
        if(self.showCurlBubble)           [self createButtonWithIcon:@"Mreffer" backgroundColor:self.curlBackgroundColorRGB andType:AAShareBubbleTypeCurl andText:@""];
        if(self.showRulerBubble)        [self createButtonWithIcon:nil backgroundColor:self.rulerBackgroundColorRGB andType:AAShareBubbleTypeRuler andText:@"Ruler"];
        if(self.showTrackBubble)        [self createButtonWithIcon:nil backgroundColor:self.trackBackgroundColorRGB andType:AAShareBubbleTypeTrack andText:@"Track"];
        
        if(bubbles.count == 0) return;
        
        float bubbleDistanceFromPivot = self.radius - self.bubbleRadius;
        
        float bubblesBetweenAngel = 360 / bubbles.count;
        float angely = (180 - bubblesBetweenAngel) * 0.5;
        float startAngel = 180 - angely;
        
        NSMutableArray *coordinates = [NSMutableArray array];
        
        for (int i = 0; i < bubbles.count; ++i)
        {
            UIButton *bubble = [bubbles objectAtIndex:i];
            bubble.tag = i;
            
            float angle = startAngel + i * bubblesBetweenAngel;
            float x = cos(angle * M_PI / 180) * bubbleDistanceFromPivot + self.radius;
            float y = sin(angle * M_PI / 180) * bubbleDistanceFromPivot + self.radius;
            
            [coordinates addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:x], @"x", [NSNumber numberWithFloat:y], @"y", nil]];
            
            bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
            bubble.center = CGPointMake(self.radius, self.radius);
        }
        
        int inetratorI = 0;
        for (NSDictionary *coordinate in coordinates)
        {
            UIButton *bubble = [bubbles objectAtIndex:inetratorI];
            float delayTime = inetratorI * 0.1;
            [self performSelector:@selector(showBubbleWithAnimation:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:bubble, @"button", coordinate, @"coordinate", nil] afterDelay:delayTime];
            ++inetratorI;
        }
    }
}
-(void)hide
{
    if(!self.isAnimating)
    {
        self.isAnimating = YES;
        int inetratorI = 0;
        for (UIButton *bubble in bubbles)
        {
            float delayTime = inetratorI * 0.1;
            [self performSelector:@selector(hideBubbleWithAnimation:) withObject:bubble afterDelay:delayTime];
            ++inetratorI;
        }
    }
}

#pragma mark -
#pragma mark Helper functions

-(void)shareViewBackgroundTapped:(UITapGestureRecognizer *)tapGesture {
    [tapGesture.view removeFromSuperview];
    [self hide];
}

-(void)showBubbleWithAnimation:(NSDictionary *)info
{
    UIButton *bubble = (UIButton *)[info objectForKey:@"button"];
    NSDictionary *coordinate = (NSDictionary *)[info objectForKey:@"coordinate"];
    
    [UIView animateWithDuration:0.25 animations:^{
        bubble.center = CGPointMake([[coordinate objectForKey:@"x"] floatValue], [[coordinate objectForKey:@"y"] floatValue]);
        bubble.alpha = 1;
        bubble.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            bubble.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                bubble.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                if(bubble.tag == bubbles.count - 1) self.isAnimating = NO;
                bubble.layer.shadowColor = [UIColor blackColor].CGColor;
                bubble.layer.shadowOpacity = 0.2;
                bubble.layer.shadowOffset = CGSizeMake(0, 1);
                bubble.layer.shadowRadius = 2;
                 if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                     bubble.layer.borderWidth = 1.0f;
                     bubble.layer.borderColor = [UIColor whiteColor].CGColor;
                     bubble.layer.cornerRadius = 28.0f;
                 } else {
                     bubble.layer.borderWidth = 1.0f;
                     bubble.layer.borderColor = [UIColor whiteColor].CGColor;
                     bubble.layer.cornerRadius = 36.0f;
                    // [bubble setTitle:@"map" forState:UIControlStateNormal];
                 }
            }];
        }];
    }];
}
-(void)hideBubbleWithAnimation:(UIButton *)bubble
{
    [UIView animateWithDuration:0.2 animations:^{
        bubble.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            bubble.center = CGPointMake(self.radius, self.radius);
            bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
            bubble.alpha = 0;
        } completion:^(BOOL finished) {
            if(bubble.tag == bubbles.count - 1) {
                self.isAnimating = NO;
                self.hidden = YES;
                [bgView removeFromSuperview];
                bgView = nil;
                
                if([self.delegate respondsToSelector:@selector(aaShareBubblesDidHide)]) {
                    [self.delegate aaShareBubblesDidHide];
                }
                
                [self removeFromSuperview];
            }
            [bubble removeFromSuperview];
        }];
    }];
}

-(void)createButtonWithIcon:(NSString *)iconName backgroundColor:(int)rgb andType:(AAShareBubbleType)type andText:(NSString *)text
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 2 * self.bubbleRadius, 2 * self.bubbleRadius);
    
    // Circle background
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2 * self.bubbleRadius, 2 * self.bubbleRadius)];
    circle.backgroundColor = [self colorFromRGB:rgb];
    circle.layer.cornerRadius = self.bubbleRadius;
    circle.layer.masksToBounds = YES;
    circle.opaque = NO;
    circle.alpha = .90f;
    
    // Circle icon
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", iconName]]];//@"AAShareBubbles.bundle/%@"
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, circle.frame.size.width, circle.frame.size.height)];
    label.text = [NSString stringWithFormat:@"%@", text];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        label.font = [UIFont systemFontOfSize:12];
    } else {
        label.font = [UIFont systemFontOfSize:14];
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    CGRect f = icon.frame;
    f.origin.x = (circle.frame.size.width - f.size.width) * 0.5;
    f.origin.y = (circle.frame.size.height - f.size.height) * 0.5;
    icon.frame = f;
    
    CGRect fr = label.frame;
    fr.origin.x = (circle.frame.size.width - fr.size.width) * 0.5;
    fr.origin.y = (circle.frame.size.height - fr.size.height) * 0.5;
    icon.frame = fr;
    
    [circle addSubview:icon];
    [circle addSubview:label];
    
    [button setBackgroundImage:[self imageWithView:circle] forState:UIControlStateNormal];
    
    [bubbles addObject:button];
    [bubbleIndexTypes setObject:[NSNumber numberWithInteger:type] forKey:[NSNumber numberWithInteger:(bubbles.count - 1)]];
    
    [self addSubview:button];
}

-(UIColor *)colorFromRGB:(int)rgb {
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0];
}

-(UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
