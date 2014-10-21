//
//  CurlViewController.m
//  GeoMap
//
//  Created by SchwarzArthur on 12/11/2556 BE.
//  Copyright (c) 2556 SchwarzArthur. All rights reserved.
//

#import "CurlViewController.h"
#import "ViewController.h"

const static CGFloat kJVFieldHMargin = 10.0f;

@interface CurlViewController () {
    
    MAP_TYPE map_type;
}

@property (strong, nonatomic) IBOutlet UISegmentedControl *_mapTypeControl;

@property (strong, nonatomic) IBOutlet UISegmentedControl *_mapSourceControl;

@end

@implementation CurlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // [self.view setBackgroundColor:[UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f]];
    
    UILabel *setting = [[UILabel alloc] initWithFrame:CGRectMake(0,180, self.view.frame.size.width, 15)];
    setting.text = @"Setting Map";
    setting.font = [UIFont boldSystemFontOfSize:12];
    setting.backgroundColor = [UIColor clearColor];
    setting.textColor = [UIColor whiteColor];
    //[setting sizeToFit];
    setting.textAlignment = NSTextAlignmentCenter;
    
    
    UIView *div1 = [UIView new];
    div1.frame = CGRectMake(self.view.frame.size.width/2 - 150,setting.frame.origin.y + setting.frame.size.height + 35, 300, 1.0f);
    div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    
    UIView *div2 = [UIView new];
    div2.frame = CGRectMake(div1.frame.origin.x + div1.frame.size.width - 80,setting.frame.origin.y + setting.frame.size.height + 35 + 1.0f, 1.0f, 40);
    div2.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    
    UIView *div3 = [UIView new];
    div3.frame = CGRectMake(self.view.frame.size.width/2 - 150,div1.frame.origin.y + div1.frame.size.height + 40, 300, 1.0f);
    div3.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    
    UILabel *clusterPin = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 150 +15,div1.frame.origin.y + div1.frame.size.height + 10, 0, 0)];
    clusterPin.text = @"Cluster Pin";
    clusterPin.font = [UIFont boldSystemFontOfSize:15];
    clusterPin.backgroundColor = [UIColor clearColor];
    clusterPin.textColor = [UIColor whiteColor];
    [clusterPin sizeToFit];
    
    UILabel *overlay = [[UILabel alloc] initWithFrame:CGRectMake(0,div3.frame.origin.y + div3.frame.size.height + 15, div1.frame.origin.x + div1.frame.size.width - 15, 15)];
    overlay.text = @"Overlay";
    overlay.font = [UIFont boldSystemFontOfSize:12];
    overlay.backgroundColor = [UIColor clearColor];
    overlay.textColor = [UIColor whiteColor];
    overlay.textAlignment = NSTextAlignmentRight;
    
    [self.view addSubview:overlay];
    
     __mapSourceControl.frame = CGRectMake(self.view.frame.size.width/2 - 20,overlay.frame.origin.y + overlay.frame.size.height + 5, 40, 20);
    [__mapSourceControl setTitle:NSLocalizedString(@"<", nil) forSegmentAtIndex:0];
    [__mapSourceControl setTitle:NSLocalizedString(@">", nil) forSegmentAtIndex:1];
    __mapSourceControl.selectedSegmentIndex = _mapSource;
    [self.view addSubview:__mapSourceControl];
    
    self.strandardMap.frame = CGRectMake(self.view.frame.size.width/2 - 150 + 15,div3.frame.origin.y + div3.frame.size.height + 35, 120 - kJVFieldHMargin, 20);
    
    self.googleMap.frame = CGRectMake(div3.frame.origin.x + div3.frame.size.width - 115,div3.frame.origin.y + div3.frame.size.height + 35, 105, 20);
    
    self.strandardMap.text = @"Apple Map";
    self.strandardMap.textAlignment = NSTextAlignmentLeft;
    self.strandardMap.backgroundColor = [UIColor clearColor];
    
    self.googleMap.text = @"Google Map";
    self.googleMap.textAlignment = NSTextAlignmentRight;
    self.googleMap.backgroundColor = [UIColor clearColor];
    
    UIView *div4 = [UIView new];
    div4.frame = CGRectMake(self.view.frame.size.width/2 - 150,__mapSourceControl.frame.origin.y + __mapSourceControl.frame.size.height + 10, 300, 1.0f);
    div4.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    
    __mapTypeControl.frame = CGRectMake(self.view.frame.size.width/2 -100,div4.frame.origin.y + div4.frame.size.height + 10, 200, 25);
    [__mapTypeControl setTitle:NSLocalizedString(@"Standard", nil) forSegmentAtIndex:0];
    [__mapTypeControl setTitle:NSLocalizedString(@"Satellite", nil) forSegmentAtIndex:1];
    [__mapTypeControl setTitle:NSLocalizedString(@"Hybrid", nil) forSegmentAtIndex:2];
    __mapTypeControl.selectedSegmentIndex = _mapType;
    [self.view addSubview:__mapTypeControl];
    
    [_onOffCluster addTarget: self action: @selector(onOffSwitch:) forControlEvents:UIControlEventValueChanged];
    [_onOffCluster setOn:_useClustering animated:NO];
    self.onOffCluster.frame = CGRectMake(div1.frame.origin.x + div1.frame.size.width - 65,div1.frame.origin.y + div1.frame.size.height + 5, 0, 0);
    [self.view addSubview:self.onOffCluster];
    
    if (__mapSourceControl.selectedSegmentIndex == 0) {
        
        self.strandardMap.textColor = [UIColor whiteColor];
        self.strandardMap.font = [UIFont systemFontOfSize:16];
        self.googleMap.textColor = [UIColor lightGrayColor];
        self.googleMap.font = [UIFont systemFontOfSize:14];
    } else {
        self.googleMap.textColor = [UIColor whiteColor];
        self.googleMap.font = [UIFont systemFontOfSize:16];
        self.strandardMap.textColor = [UIColor lightGrayColor];
        self.strandardMap.font = [UIFont systemFontOfSize:14];
    }
    [self.view addSubview:setting];
    [self.view addSubview:clusterPin];
    [self.view addSubview:div1];
    [self.view addSubview:div2];
    [self.view addSubview:div3];
    [self.view addSubview:div4];
    [self.view addSubview:_googleMap];
    [self.view addSubview:_strandardMap];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    
    self._mapSourceControl = nil;
    self._mapTypeControl = nil;
    self.onOffCluster = nil;
    
    [super viewDidUnload];
}

- (IBAction)mapSourceChanged:(id)sender
{
    switch (self._mapSourceControl.selectedSegmentIndex) {
        case 0:
        {
            self.strandardMap.textColor = [UIColor whiteColor];
            self.strandardMap.font = [UIFont systemFontOfSize:16];
            self.googleMap.textColor = [UIColor lightGrayColor];
            self.googleMap.font = [UIFont systemFontOfSize:14];
            
            if ([_delegate respondsToSelector:@selector(curlViewController:mapSourceChanged:)]) {
                [_delegate curlViewController:self mapSourceChanged:__mapSourceControl.selectedSegmentIndex];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 1:
        {
            self.googleMap.textColor = [UIColor whiteColor];
            self.googleMap.font = [UIFont systemFontOfSize:16];
            self.strandardMap.textColor = [UIColor lightGrayColor];
            self.strandardMap.font = [UIFont systemFontOfSize:14];
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                              message:@"If you have layer on map. You have to clear layer before overlay Google Map."//ชั้นข้อมูลอื่นๆที่ปรากฏอยู่ จะถูก Clear ออกก่อนการ Overlay
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Confirm", nil];
            [message show];
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Confirm"])
    {
        if (map_type == MAPSOURCEAPPLE) {
            
            if ([_delegate respondsToSelector:@selector(curlViewController:mapSourceChanged:)]) {
                [_delegate curlViewController:self mapSourceChanged:__mapSourceControl.selectedSegmentIndex];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        } if (map_type == MAPSOURCEGOOGLE) {
            
            if ([_delegate respondsToSelector:@selector(curlViewController:mapTypeChanged:)]) {
                [_delegate curlViewController:self mapTypeChanged:__mapTypeControl.selectedSegmentIndex];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else if([title isEqualToString:@"Cancel"]) {
        
        if (map_type == MAPSOURCEAPPLE) {
            self._mapSourceControl.selectedSegmentIndex = 0;
            
            self.strandardMap.textColor = [UIColor whiteColor];
            self.strandardMap.font = [UIFont systemFontOfSize:16];
            self.googleMap.textColor = [UIColor lightGrayColor];
            self.googleMap.font = [UIFont systemFontOfSize:14];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (IBAction)_mapTypeChang:(id)sender {
    
    if (__mapSourceControl.selectedSegmentIndex == 0) {
        
        if ([_delegate respondsToSelector:@selector(curlViewController:mapTypeChanged:)]) {
            [_delegate curlViewController:self mapTypeChanged:__mapTypeControl.selectedSegmentIndex];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
        map_type = MAPSOURCEAPPLE;
        
    } else if (__mapSourceControl.selectedSegmentIndex == 1) {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                          message:@"If you have layer on map. You have to clear layer before overlay Google Map."//ชั้นข้อมูลอื่นๆที่ปรากฏอยู่ จะถูก Clear ออกก่อนการ Overlay
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Confirm", nil];
        [message show];
        
        map_type = MAPSOURCEGOOGLE;
    }
}

-(void)onOffSwitch:(UISwitch *)sender {
    
    if ([_delegate respondsToSelector:@selector(curlViewControllerWillClusterPin:didCluster:)]) {
        
        [_delegate curlViewControllerWillClusterPin:self didCluster:sender.on];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
