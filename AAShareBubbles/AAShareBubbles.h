//
//  AAShareBubbles.h
//  AAShareBubbles
//
//  Created by Almas Adilbek on 26/11/13.
//  Copyright (c) 2013 Almas Adilbek. All rights reserved.
//  https://github.com/mixdesign/AAShareBubbles
//

#import <UIKit/UIKit.h>

@protocol AAShareBubblesDelegate;

typedef enum AAShareBubbleType : int {
    AAShareBubbleTypeFacebook = 0,
    AAShareBubbleTypeTwitter = 1,
    AAShareBubbleTypeGooglePlus = 2,
    AAShareBubbleTypeTumblr = 3,
    AAShareBubbleTypeMail = 4,
    AAShareBubbleTypeVk = 5, // Vkontakte (vk.com)
    AAShareBubbleTypeLinkedIn = 6,
    AAShareBubbleTypePinterest = 7,
    AAShareBubbleTypeYoutube = 8,
    AAShareBubbleTypeVimeo = 9,
    AAShareBubbleTypeReddit = 10,
        
    AAShareBubbleTypeAddArea = 11,
    AAShareBubbleTypeLegend = 12,
    AAShareBubbleTypeSearch = 13,
    AAShareBubbleTypeAddPin = 14,
    AAShareBubbleTypeTrack = 15,
    AAShareBubbleTypeNavigation = 16,
    AAShareBubbleTypeRuler = 17,
    AAShareBubbleTypeEdit = 18,
    AAShareBubbleTypeSetting = 19,
    AAShareBubbleTypeShare = 20,
    AAShareBubbleTypeCurl = 21,
    
    
} AAShareBubbleType;

@interface AAShareBubbles : UIView {}

@property (nonatomic, assign) id<AAShareBubblesDelegate> delegate;

@property (nonatomic, assign) BOOL showFacebookBubble;
@property (nonatomic, assign) BOOL showTwitterBubble;
@property (nonatomic, assign) BOOL showMailBubble;
@property (nonatomic, assign) BOOL showGooglePlusBubble;
@property (nonatomic, assign) BOOL showTumblrBubble;
@property (nonatomic, assign) BOOL showVkBubble;
@property (nonatomic, assign) BOOL showLinkedInBubble;
@property (nonatomic, assign) BOOL showPinterestBubble;
@property (nonatomic, assign) BOOL showYoutubeBubble;
@property (nonatomic, assign) BOOL showVimeoBubble;
@property (nonatomic, assign) BOOL showRedditBubble;

@property (nonatomic, assign) BOOL showSettingBubble;
@property (nonatomic, assign) BOOL showAddPinPlusBubble;
@property (nonatomic, assign) BOOL showCurlBubble;
@property (nonatomic, assign) BOOL showNavigationBubble;
@property (nonatomic, assign) BOOL showLegendBubble;
@property (nonatomic, assign) BOOL showEditBubble;
@property (nonatomic, assign) BOOL showRulerBubble;
@property (nonatomic, assign) BOOL showTrackBubble;
@property (nonatomic, assign) BOOL showSearchBubble;
@property (nonatomic, assign) BOOL showAddAreaBubble;
@property (nonatomic, assign) BOOL showShareBubble;

@property (nonatomic, assign) int radius;
@property (nonatomic, assign) int bubbleRadius;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, weak) UIView *parentView;

@property (nonatomic, assign) int facebookBackgroundColorRGB;
@property (nonatomic, assign) int twitterBackgroundColorRGB;
@property (nonatomic, assign) int mailBackgroundColorRGB;
@property (nonatomic, assign) int googlePlusBackgroundColorRGB;
@property (nonatomic, assign) int tumblrBackgroundColorRGB;
@property (nonatomic, assign) int vkBackgroundColorRGB;
@property (nonatomic, assign) int linkedInBackgroundColorRGB;
@property (nonatomic, assign) int pinterestBackgroundColorRGB;
@property (nonatomic, assign) int youtubeBackgroundColorRGB;
@property (nonatomic, assign) int vimeoBackgroundColorRGB;
@property (nonatomic, assign) int redditBackgroundColorRGB;

@property (nonatomic, assign) int settingBackgroundColorRGB;
@property (nonatomic, assign) int addPinBackgroundColorRGB;
@property (nonatomic, assign) int curlBackgroundColorRGB;
@property (nonatomic, assign) int navigationBackgroundColorRGB;
@property (nonatomic, assign) int legendBackgroundColorRGB;
@property (nonatomic, assign) int editBackgroundColorRGB;
@property (nonatomic, assign) int rulerBackgroundColorRGB;
@property (nonatomic, assign) int trackBackgroundColorRGB;
@property (nonatomic, assign) int searchBackgroundColorRGB;
@property (nonatomic, assign) int addAreaBackgroundColorRGB;
@property (nonatomic, assign) int shareBackgroundColorRGB;


-(id)initWithPoint:(CGPoint)point radius:(int)radiusValue inView:(UIView *)inView;

-(void)show;
-(void)hide;


@end

@protocol AAShareBubblesDelegate<NSObject>

@optional

// On buttons pressed
-(void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(AAShareBubbleType)bubbleType ;

// On bubbles hide
-(void)aaShareBubblesDidHide;

@end
