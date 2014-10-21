//
//  DetailDatabaseViewController.m
//  GeoMap
//
//  Created by SchwarzArthur on 3/28/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import "DetailDatabaseViewController.h"
#import "ViewController.h"
#import "GeodeticUTMConverter.h"
#import "MyDatabaseManager.h"
#import "DBTableViewCell.h"
#import "AHKActionSheet.h"
#import "AGPhotoBrowserView.h"

static NSString *API_KEY = @"YOUR_API_KEY_HERE";
static CGFloat kImageOriginHight = 190.f;

const static CGFloat kJVFieldHeight = 44.0f;
const static CGFloat kJVFieldHMargin = 15.0f;
const static CGFloat kJVFieldFontSize = 15.0f;
const static CGFloat kJVFieldFloatingLabelFontSize = 12.0f;

@interface DetailDatabaseViewController ()<AGPhotoBrowserDelegate, AGPhotoBrowserDataSource>

@property (nonatomic, strong) AGPhotoBrowserView *browserView;

@end

@implementation DetailDatabaseViewController {
    CLGeocoder *geocoder;
    CLPlacemark *placemark;

    UILongPressGestureRecognizer *imageTapRecognizer;
    
    NSArray *activityItems;
    
    UIImage *image;
    NSData *data;
    UIImagePickerController *imagePicker;
}
@synthesize record;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)updateTableViewData {
    NSDate *date = [NSDate date];
  
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          _nameField.text,kName,
                          _pinTypeField.text,kType,
                          _descriptionField.text,kComment,date,KEditDate,data,KPhoto,
                          
                          nil];
    
    [[MyDatabaseManager sharedManager] updateRecord:self.record inRecordTable:dict];
    
    UIBarButtonItem *closeTransparentView = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action)];
    UIBarButtonItem *updateTable = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(updateData)];
    
    NSArray* buttonArrays = [[NSArray alloc] initWithObjects:closeTransparentView,updateTable, nil];
    self.navigationItem.rightBarButtonItems = buttonArrays;
    
    [____tableView reloadData];
    
    _nameField.hidden = YES;
    _pinTypeField.hidden = YES;
    _descriptionField.hidden = YES;
    _addImage.hidden = YES;
    
    [_nameField resignFirstResponder];
    [_pinTypeField resignFirstResponder];
    [_descriptionField resignFirstResponder];
    
    //[self.navigationController popViewControllerAnimated:YES];
    
    //[self dismissViewControllerAnimated:YES completion:nil];--modal
}
-(void)closeTransparentView {
    
    UIBarButtonItem *closeTransparentView = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action)];
    UIBarButtonItem *updateTable = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(updateData)];
    
    NSArray* buttonArrays = [[NSArray alloc] initWithObjects:closeTransparentView,updateTable, nil];
    self.navigationItem.rightBarButtonItems = buttonArrays;
    
    [____tableView reloadData];
    
    _imageView.image = [UIImage imageWithData:record.photo];
    _nameField.hidden = YES;
    _pinTypeField.hidden = YES;
    _descriptionField.hidden = YES;
    _addImage.hidden = YES;
    
    [_nameField resignFirstResponder];
    [_pinTypeField resignFirstResponder];
    [_descriptionField resignFirstResponder];
}
-(void)action {

    NSString *textToShare = [NSString stringWithFormat:@"#iForest My Position : ( Lat: %.4f , Lon: %.4f ).",[record.coordinate_y doubleValue],[record.coordinate_x doubleValue]];
    UIImage *imagetoshare = [UIImage imageWithData:record.photo];
    
    if (record.photo != nil) {
        activityItems = @[textToShare,imagetoshare];
    } else {
        activityItems = @[textToShare];
    }
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
 /*   activity.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                         UIActivityTypeMessage,
                                         UIActivityTypeMail,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToFacebook,
                                         UIActivityTypePostToTwitter,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop];*/
    //activity.excludedActivityTypes = @[UIActivityTypePostToFacebook];
    [self presentViewController:activity animated:TRUE completion:nil];
    
    /*@{
      @"image": [UIImage imageNamed:@"Flower.jpg"],
      @"text": @"Hello world!",
      @"url": [NSURL URLWithString:@"https://github.com/brantyoung/OWActivityViewController"],
      @"coordinate": @{@"latitude": @(37.751586275), @"longitude": @(-122.447721511)}
      };*/

}

-(void)updateData {
    
    _addImage.hidden = NO;
    
    UIBarButtonItem *closeTransparentView = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeTransparentView)];
    UIBarButtonItem *updateTable = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(updateTableViewData)];
    
    NSArray* buttonArrays = [[NSArray alloc] initWithObjects:closeTransparentView,updateTable, nil];
    self.navigationItem.rightBarButtonItems = buttonArrays;
    
   // if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    
        _nameField = [[JVFloatLabeledTextField alloc] initWithFrame:
                    CGRectMake(kJVFieldHMargin, 120, ____tableView.frame.size.width - kJVFieldHMargin, kJVFieldHeight)];
        _pinTypeField = [[JVFloatLabeledTextField alloc] initWithFrame:
                         CGRectMake(kJVFieldHMargin , _nameField.frame.origin.y + _nameField.frame.size.height + 1.0f, ____tableView.frame.size.width - kJVFieldHMargin, kJVFieldHeight)];
        _descriptionField = [[JVFloatLabeledTextView alloc] initWithFrame:CGRectZero];
        _descriptionField.frame = CGRectMake(kJVFieldHMargin - _descriptionField.textContainer.lineFragmentPadding, _pinTypeField.frame.origin.y + _pinTypeField.frame.size.height + 1.0f, self.view.frame.size.width - kJVFieldHMargin + _descriptionField.textContainer.lineFragmentPadding, kJVFieldHeight*3 +27);
  /*  } else {
        _nameField = [[JVFloatLabeledTextField alloc] initWithFrame:
                      CGRectMake(kJVFieldHMargin, 40, ____tableView.frame.size.width - kJVFieldHMargin, kJVFieldHeight)];
        _pinTypeField = [[JVFloatLabeledTextField alloc] initWithFrame:
                         CGRectMake(kJVFieldHMargin , _nameField.frame.origin.y + _nameField.frame.size.height + 1.0f, ____tableView.frame.size.width - kJVFieldHMargin, kJVFieldHeight)];
        _descriptionField = [[JVFloatLabeledTextView alloc] initWithFrame:CGRectZero];
        _descriptionField.frame = CGRectMake(kJVFieldHMargin - _descriptionField.textContainer.lineFragmentPadding, _pinTypeField.frame.origin.y + _pinTypeField.frame.size.height + 1.0f, self.view.frame.size.width - kJVFieldHMargin + _descriptionField.textContainer.lineFragmentPadding, kJVFieldHeight*3 +27);
    }*/
    
     UIColor *floatingLabelColor = [UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f];
    
    _nameField.placeholder = NSLocalizedString(@"Name :", @"");
    _nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Name", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    _nameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _nameField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _nameField.floatingLabelTextColor = floatingLabelColor;
    _nameField.text = record.name;
    _nameField.textColor = [UIColor blackColor];
    _nameField.backgroundColor = [UIColor whiteColor];
    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [____tableView addSubview:_nameField];
    
    _pinTypeField.placeholder = NSLocalizedString(@"Pin type :", @"");
    _pinTypeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Pin type", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    _pinTypeField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _pinTypeField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _pinTypeField.floatingLabelTextColor = floatingLabelColor;
    _pinTypeField.text = record.type;
    _pinTypeField.textColor = [UIColor blackColor];
    _pinTypeField.backgroundColor = [UIColor whiteColor];
    _pinTypeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [____tableView addSubview:_pinTypeField];
    
    _descriptionField.placeholder = NSLocalizedString(@"Description :", @"");
    _descriptionField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _descriptionField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _descriptionField.floatingLabelTextColor = floatingLabelColor;
    _descriptionField.text = record.descriptions;
    _descriptionField.textColor = [UIColor blackColor];
    _descriptionField.backgroundColor = [UIColor whiteColor];
    [____tableView addSubview:_descriptionField];
    
    [_nameField becomeFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"หมุดปัก";//[NSString stringWithFormat:@"%@",self.pin.title];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:24.0/255.0 green:116.0/255.0 blue:255.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *closeTransparentView = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action)];
    UIBarButtonItem *updateTable = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(updateData)];
    
    NSArray* buttonArrays = [[NSArray alloc] initWithObjects:closeTransparentView,updateTable, nil];
    self.navigationItem.rightBarButtonItems = buttonArrays;
    
    [____mapView setShowsUserLocation:TRUE];
    
    //User location tracking
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager startUpdatingLocation];
    
    _userLocation = [_locationManager.location copy];
    NSLog(@"%f %f User location", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude);
    
    geocoder = [[CLGeocoder alloc] init];
    
    // ___tableView.backgroundColor = [UIColor clearColor];
    [self._mapTypeSegmentedControl setTitle:NSLocalizedString(@"Standard", nil) forSegmentAtIndex:0];
    [self._mapTypeSegmentedControl setTitle:NSLocalizedString(@"Satellite", nil) forSegmentAtIndex:1];
    [self._mapTypeSegmentedControl setTitle:NSLocalizedString(@"Hybrid", nil) forSegmentAtIndex:2];
 
    ____tableView.contentInset = UIEdgeInsetsMake(kImageOriginHight, 0, 0, 0);
    [____tableView addSubview:____mapView];
    
    self._mapTypeSegmentedControl.frame = CGRectMake(60, 5, 200, 25);//1213
    [____tableView addSubview:__mapTypeSegmentedControl];
    
    _div = [UIView new];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        _div.frame = CGRectMake(0, self.view.frame.size.height - 40.0f, self.view.frame.size.width,self.view.frame.size.height +20);
    } else {
        _div.frame = CGRectMake(0, 390.0f, self.view.frame.size.width,self.view.frame.size.height +20);
    }
    _div.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    _div.layer.cornerRadius = 6.0f;
    [____mapView addSubview:_div];
    
    UILabel *slice = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 11)];
    slice.text = @"Slice";
    slice.font = [UIFont systemFontOfSize:11];
    slice.backgroundColor = [UIColor clearColor];
    slice.textColor = [UIColor whiteColor];
    slice.textAlignment = NSTextAlignmentCenter;
    // [sliceUp sizeToFit];
    [_div addSubview:slice];
    
    UIImageView *arrowUp = [[UIImageView alloc] initWithFrame:CGRectMake(145, 2.0f, 30, 12)];
    arrowUp.image = [UIImage imageNamed:@"ArrowUp.png"];
    arrowUp.layer.masksToBounds = YES;
    arrowUp.layer.rasterizationScale = [UIScreen mainScreen].scale;
    arrowUp.layer.shouldRasterize = YES;
    arrowUp.clipsToBounds = YES;
    [_div addSubview:arrowUp];
    
    UIImageView *arrowDown = [[UIImageView alloc] initWithFrame:CGRectMake(145, 28.0f, 30, 12)];
    arrowDown.image = [UIImage imageNamed:@"ArrowDown.png"];
    arrowDown.layer.masksToBounds = YES;
    arrowDown.layer.rasterizationScale = [UIScreen mainScreen].scale;
    arrowDown.layer.shouldRasterize = YES;
    arrowDown.clipsToBounds = YES;
    [_div addSubview:arrowDown];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[record.coordinate_y doubleValue] longitude:[record.coordinate_x doubleValue]];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            
            UILabel *subThoroughfare = [[UILabel alloc] initWithFrame:CGRectMake(60, 520, 0, 0)];
            if (placemark.subThoroughfare == nil) {
                subThoroughfare.text = nil;
            } else {
                subThoroughfare.text = [NSString stringWithFormat:@"%@",
                                        placemark.subThoroughfare];
            }
            subThoroughfare.font = [UIFont systemFontOfSize:13];
            subThoroughfare.backgroundColor = [UIColor clearColor];
            subThoroughfare.textColor = [UIColor blackColor];
            [subThoroughfare sizeToFit];
            [____tableView addSubview:subThoroughfare];
            
            UILabel *thoroughfare = [[UILabel alloc] initWithFrame:CGRectMake(60, 540, 0, 0)];
            if (placemark.thoroughfare == nil) {
                thoroughfare.text = nil;
            } else {
                thoroughfare.text = [NSString stringWithFormat:@"%@",
                                     placemark.thoroughfare];
            }
            thoroughfare.font = [UIFont systemFontOfSize:13];
            thoroughfare.backgroundColor = [UIColor clearColor];
            thoroughfare.textColor = [UIColor blackColor];
            [thoroughfare sizeToFit];
            [____tableView addSubview:thoroughfare];
            
            UILabel *locality = [[UILabel alloc] initWithFrame:CGRectMake(60, 560, 0, 0)];
            if (placemark.locality == nil) {
                locality.text = nil;
            } else {
                locality.text = [NSString stringWithFormat:@"%@",
                                 placemark.locality];
            }
            locality.font = [UIFont systemFontOfSize:13];
            locality.backgroundColor = [UIColor clearColor];
            locality.textColor = [UIColor blackColor];
            [locality sizeToFit];
            [____tableView addSubview:locality];
            
            UILabel *administrativeArea = [[UILabel alloc] initWithFrame:CGRectMake(60, 580, 0, 0)];
            if (placemark.administrativeArea == nil) {
                administrativeArea.text = nil;
            } else {
                administrativeArea.text = [NSString stringWithFormat:@"%@",
                                           placemark.administrativeArea];
            }
            administrativeArea.font = [UIFont systemFontOfSize:12];
            administrativeArea.backgroundColor = [UIColor clearColor];
            administrativeArea.textColor = [UIColor blackColor];
            [administrativeArea sizeToFit];
            [____tableView addSubview:administrativeArea];
            
            UILabel *country = [[UILabel alloc] initWithFrame:CGRectMake(60, 600, 0, 0)];
            if (placemark.country == nil && placemark.postalCode == nil) {
                country.text = nil;
            } else if (placemark.country == nil) {
                country.text = [NSString stringWithFormat:@"%@",
                                placemark.postalCode];
            } else if (placemark.postalCode == nil) {
                country.text = [NSString stringWithFormat:@"%@",
                                placemark.country];
            } else {
                country.text = [NSString stringWithFormat:@"%@,  %@",
                                placemark.country,placemark.postalCode];
            }
            country.font = [UIFont systemFontOfSize:13];
            country.backgroundColor = [UIColor clearColor];
            country.textColor = [UIColor blackColor];
            [country sizeToFit];
            [____tableView addSubview:country];
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    ____tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 120.0f)];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake( ____tableView.frame.size.width - 94, 37, 80, 80)];//255
        //imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        if (record.photo == nil) {
            _imageView.image = [UIImage imageNamed:@""];//who96.png
        } else {
            _imageView.image = [UIImage imageWithData:record.photo];
        }
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 40.0;
        _imageView.layer.borderColor = [[UIColor grayColor]colorWithAlphaComponent:0.7].CGColor;
        _imageView.layer.borderWidth = 1.0f;
        _imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _imageView.layer.shouldRasterize = YES;
        _imageView.clipsToBounds = YES;
        _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _imageView.layer.shadowOpacity = 0.2;
        _imageView.layer.shadowOffset = CGSizeMake(0, 1);
        _imageView.layer.shadowRadius = 2.0f;
        
        _coverImage = [UIView new];
        _coverImage = [[UIView alloc] initWithFrame:CGRectMake( ____tableView.frame.size.width - 94, 37, 80, 80)];
        _coverImage.layer.cornerRadius = 40.0;
        _coverImage.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.0f];
        
        _addImage= [[UIButton alloc] initWithFrame:CGRectMake( ____tableView.frame.size.width - 123, 68, 24, 24)];;
        [_addImage setTitle:@"+" forState:UIControlStateNormal];
        [_addImage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addImage.titleLabel.font = [UIFont boldSystemFontOfSize: 20];
        _addImage.backgroundColor = [UIColor redColor];
        _addImage.layer.borderColor = [UIColor redColor].CGColor;
        _addImage.layer.borderWidth = 1.0f;
        _addImage.layer.cornerRadius = 12.0f;
        _addImage.opaque = NO;
        _addImage.alpha = 1.0f;
        _addImage.layer.shadowColor = [UIColor blackColor].CGColor;
        _addImage.layer.shadowOpacity = 0.2;
        _addImage.layer.shadowOffset = CGSizeMake(0, 1);
        _addImage.layer.shadowRadius = 2.0f;
        [_addImage addTarget:self action:@selector(actionSheetAddPhoto) forControlEvents:UIControlEventTouchUpInside];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 68, 0, 0)];
        label.text = @"Attribute";
        label.font = [UIFont systemFontOfSize:20];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        [label sizeToFit];
        
        [view addSubview:label];
        [view addSubview:_addImage];
        [view addSubview:_imageView];
        [view addSubview:_coverImage];
        [_coverImage bringSubviewToFront:_imageView];
        
        view;

    });
    
    _addImage.hidden = YES;
    
    [____mapView setShowsUserLocation:NO];
    
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = [record.coordinate_y doubleValue];
    coordinates.longitude = [record.coordinate_x doubleValue];
    
    MKPointAnnotation *centerPinMap = [[MKPointAnnotation alloc]init];
    centerPinMap.coordinate = coordinates;
    centerPinMap.title = [NSString stringWithFormat:@"%@",record.name];
    [____mapView addAnnotation:centerPinMap];
    
    NSArray *area = [____mapView annotations];
    
    MKMapRect flyTo = MKMapRectNull;
    for (id <MKAnnotation> annotation in area) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(flyTo)) {
            flyTo = pointRect;
        } else {
            flyTo = MKMapRectUnion(flyTo, pointRect);
        }
    }
    ____mapView.visibleMapRect = flyTo;
    
	tableViewContents = [[NSMutableArray alloc]initWithCapacity:15];
    
    for (int i=0; i<15; i++) {
        [tableViewContents addObject:@"Loading"];
    }
    
    weatherManager = [[JFWeatherManager alloc]init];
    
    [self tableViewContents];
    [self addGestureRecogniserToImage];
    
    if (record.photo == nil) {
    } else {
        [self addGestureRecogniserToImageFullFrame];
    }
}

-(void)addGestureRecogniserToImageFullFrame {
    imageTapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageFullFrame:)];
    imageTapRecognizer.minimumPressDuration = 0.2;
    [_coverImage addGestureRecognizer:imageTapRecognizer];
    NSLog(@"addGesture");
}

- (void)imageFullFrame:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
        [self.browserView show];
    NSLog(@"browsershow");
}

- (void)addGestureRecogniserToImage{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(imageFullScreen:)];
    lpgr.minimumPressDuration = 0.5;
    [____mapView addGestureRecognizer:lpgr];
}

- (void)imageFullScreen:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
   // CGSize size = [UIScreen mainScreen].bounds.size;
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
         ____mapView.frame = CGRectMake(0, -kImageOriginHight -63, self.view.frame.size.width, self.view.frame.size.height);
     } else {
         ____mapView.frame = CGRectMake(0, -kImageOriginHight, self.view.frame.size.width, self.view.frame.size.height);
     }
    
    [____tableView bringSubviewToFront:____mapView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    ____mapView.frame = CGRectMake(0, -kImageOriginHight, ____tableView.frame.size.width, kImageOriginHight);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < -kImageOriginHight) {
        CGRect f = ____mapView.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset;
        ____mapView.frame = f;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) {
        return 40;
    } else if (indexPath.row == 6 && indexPath.section == 0) {
        return 115;
    } else if ((indexPath.row == 0 && indexPath.section == 0)||(indexPath.row == 1 && indexPath.section == 0)) {
        return 45;
    } else if ((indexPath.row == 3 && indexPath.section == 0)||(indexPath.row == 4 && indexPath.section == 0)) {
        return 40;
    } else if (indexPath.row == 5 && indexPath.section == 0) {
        return 50;
    } else if (indexPath.row == 2 && indexPath.section == 0) {
        return 170;
    } else {
        return 40;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    /*  if (section == 0)
     return @"Attributes";
     else
     return  @"Weather Attributes";*/
    
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 10;
    else if (section == 1)
        return 15;
    else
        return 2;
}

- (NSString *)formatDate:(NSDate *)theDate
{
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    return [formatter stringFromDate:theDate];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  static NSString *CellIdentifier = @"Cell";
  //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *identifier;
    DBTableViewCell * cell;
    
    if (indexPath.row == 2 && indexPath.section == 0){
        identifier = @"Cellcustom";
    } else {
        identifier = @"Cell";
    }
    cell = [____tableView dequeueReusableCellWithIdentifier:identifier];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[record.coordinate_y doubleValue] longitude:[record.coordinate_x doubleValue]];
    
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = [record.coordinate_y doubleValue];
    coordinates.longitude = [record.coordinate_x doubleValue];
    
    GeodeticUTMConverter *utmConverter = [[GeodeticUTMConverter alloc] init];
    UTMCoordinates utmCoordinates = [utmConverter latitudeAndLongitudeToUTMCoordinates:coordinates];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

 //   [____tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if (indexPath.section == 0) {
        
        switch ([indexPath row]) {
        
            case 0:
                [cell.textLabel setText:@"Name :"];
                [cell.detailTextLabel setText:record.name];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 1:
                [cell.textLabel setText:@"Pin type :"];
                [cell.detailTextLabel setText:record.type];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 2:
                [cell.labelTitle setText:@"Description :"];
                [cell.label setText:record.descriptions];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 3:
            {
                [cell.textLabel setText:@"Create :"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];                
                [cell.detailTextLabel setText:[self formatDate:record.date]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
            }
                
            case 4:
            {
                [cell.textLabel setText:@"Last Update :"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                if (record.editDate == nil) {
                    [cell.detailTextLabel setText:@"-"];
                } else {
                    [cell.detailTextLabel setText:[self formatDate:record.editDate]];
                }
                cell.backgroundColor = [UIColor whiteColor];
                break;
            }
            case 5:
            {
                [cell.textLabel setText:@"ระยะทางจากที่นี่ถึงหมุด :"];
                
                CLLocationDistance distance = [_userLocation distanceFromLocation:location];
                
                if (distance == 0) {
                    
                } else {
                    
                    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.01f Km", distance/1000]];
                    
                }
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //[cell.detailTextLabel setTextColor:[UIColor grayColor]];
                cell.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0f];
            }
                break;
                
            case 6:
                [cell.textLabel setText:@"ที่อยู่ :"];
                [cell.detailTextLabel setText:nil];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
 
            case 7:
                [cell.textLabel setText:@"X (easting) [UTM]"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.1f",utmCoordinates.easting]];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 8:
                [cell.textLabel setText:@"Y (northing) [UTM]"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.1f",utmCoordinates.northing]];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 9:
                [cell.textLabel setText:@"Zone"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%u",utmCoordinates.gridZone]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
        }
    } else if (indexPath.section == 1) {
        switch ([indexPath row]) {
            case 0:
                [cell.textLabel setText:@"Latitude"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:4.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 1:
                [cell.textLabel setText:@"Longitude"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:4.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 2:
                [cell.textLabel setText:@"Conditions"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 3:
                [cell.textLabel setText:@"Temperature (°C)"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 4:
                [cell.textLabel setText:@"Sunrise"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 5:
                [cell.textLabel setText:@"Sunset"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 6:
                [cell.textLabel setText:@"Hours of Day Light"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 7:
                [cell.textLabel setText:@"Humidity"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 8:
                [cell.textLabel setText:@"Pressure (hPA)"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 9:
                [cell.textLabel setText:@"Wind Speed (MPH)"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 10:
                [cell.textLabel setText:@"Wind Direction"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 11:
                [cell.textLabel setText:@"Cloud Coverage"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 12:
                [cell.textLabel setText:@"Rain"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 13:
                [cell.textLabel setText:@"Snow"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 14:
                [cell.textLabel setText:@"Country"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
        }
        [cell.detailTextLabel setText:[tableViewContents objectAtIndex:[indexPath row]]];
    }
    
    return cell;
}
-(void)tableViewContents
{
    [weatherManager fetchWeatherDataForLatitude:[record.coordinate_y doubleValue] andLongitude:[record.coordinate_x doubleValue] withAPIKeyOrNil:API_KEY :^(JFWeatherData *returnedWeatherData) {
        
        NSLog(@"Latitude %.3f",[returnedWeatherData latitudeCoordinateOfRequest]);
        NSLog(@"Longitude %.3f",[returnedWeatherData longitudeCoordinateOfRequest]);
        NSLog(@"Country %@",[returnedWeatherData countryCode]);
        NSLog(@"Conditions are %@",[returnedWeatherData currentConditionsTextualDescription]);
        NSLog(@"Temperature is %f",[returnedWeatherData temperatureInUnitFormat:kTemperatureCelcius]);
        NSLog(@"Sunrise is %@",[returnedWeatherData sunriseTime]);
        NSLog(@"Sunset is %@",[returnedWeatherData sunsetTime]);
        NSLog(@"Hours of Day Light are %@",[returnedWeatherData dayLightHours]);
        NSLog(@"Humidity is %@",[returnedWeatherData humidityPercentage]);
        NSLog(@"Pressure is %0.1f",[returnedWeatherData pressureInUnitFormat:kPressureHectopascal]);
        NSLog(@"Wind Speed is %0.1f",[returnedWeatherData windSpeedInUnitFormat:kWindSpeedMPH]);
        NSLog(@"Wind Direction is %@",[returnedWeatherData windDirectionInGeographicalDirection]);
        NSLog(@"Cloud Coverage %@",[returnedWeatherData cloudCovergePercentage]);
        NSLog(@"Rainfall Over Next 3h is %0.1fmm",[returnedWeatherData rainFallVolumeOver3HoursInMillimeters]);
        NSLog(@"SnowFall Over Next 3h is %0.1fmm",[returnedWeatherData snowFallVolumeOver3HoursInMillimeters]);
        
        [tableViewContents removeAllObjects];
        [tableViewContents addObject:[NSString stringWithFormat:@"%.4f",[returnedWeatherData latitudeCoordinateOfRequest]]];
        [tableViewContents addObject:[NSString stringWithFormat:@"%.4f",[returnedWeatherData longitudeCoordinateOfRequest]]];
        [tableViewContents addObject:[returnedWeatherData currentConditionsTextualDescription]];
        [tableViewContents addObject:[NSString stringWithFormat:@"%.1f°",[returnedWeatherData temperatureInUnitFormat:kTemperatureCelcius]]];
        [tableViewContents addObject:[returnedWeatherData sunriseTime]];
        [tableViewContents addObject:[returnedWeatherData sunsetTime]];
        [tableViewContents addObject:[returnedWeatherData dayLightHours]];
        [tableViewContents addObject:[returnedWeatherData humidityPercentage]];
        [tableViewContents addObject:[NSString stringWithFormat:@"%.1f",[returnedWeatherData pressureInUnitFormat:kPressureHectopascal]]];
        [tableViewContents addObject:[NSString stringWithFormat:@"%.1f",[returnedWeatherData windSpeedInUnitFormat:kWindSpeedMPH]]];
        [tableViewContents addObject:[returnedWeatherData windDirectionInGeographicalDirection]];
        [tableViewContents addObject:[returnedWeatherData cloudCovergePercentage]];
        [tableViewContents addObject:[NSString stringWithFormat:@"%.1fmm",[returnedWeatherData rainFallVolumeOver3HoursInMillimeters]]];
        [tableViewContents addObject:[NSString stringWithFormat:@"%.1fmm",[returnedWeatherData snowFallVolumeOver3HoursInMillimeters]]];
        [tableViewContents addObject:[NSString stringWithFormat:@"%@",[returnedWeatherData countryCode]]];
        
        [____tableView reloadData];
        
    }];
}
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
    _userLocation = newLocation;
    
    [____tableView reloadData];
}
- (IBAction)mapTypeChage:(id)sender {
    
    switch (self._mapTypeSegmentedControl.selectedSegmentIndex) {
        case 0:
            ____mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            ____mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            ____mapView.mapType = MKMapTypeHybrid;
            break;
        default:
            break;
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]]){
        NSString *toAddIdentifier = @"identifier";
        MKPinAnnotationView* annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:toAddIdentifier];

        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:toAddIdentifier];
        annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    return nil;
}

-(void)actionSheetAddPhoto {
    AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:NSLocalizedString(@"Image", nil)];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Take photo", nil)
                              image:nil//[UIImage imageNamed:@"c_polyline"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                [self takePhoto];
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Photo from library", nil)
                              image:nil//[UIImage imageNamed:@"c_polygon"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                [self choosePhotoFromLibrary];
                            }];
    [actionSheet show];
    
    [_nameField resignFirstResponder];
    [_pinTypeField resignFirstResponder];
    [_descriptionField resignFirstResponder];
}

-(void)takePhoto {
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

-(void)choosePhotoFromLibrary {
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    data = UIImagePNGRepresentation(image);
    
    if ([self isViewLoaded]) {
        [self showImage:image];
        [self.___tableView reloadData];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    imagePicker = nil;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"Cancelled image picker controller");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    imagePicker = nil;
}

-(void)showImage:(UIImage *)theImage
{
    self.imageView.image = theImage;
    [self addGestureRecogniserToImageFullFrame];
}

#pragma mark - AGPhotoBrowser datasource

- (NSInteger)numberOfPhotosForPhotoBrowser:(AGPhotoBrowserView *)photoBrowser
{
    return 1;
}

- (UIImage *)photoBrowser:(AGPhotoBrowserView *)photoBrowser imageAtIndex:(NSInteger)index
{
	return [UIImage imageWithData:record.photo];
}

- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser titleForImageAtIndex:(NSInteger)index
{
    return record.name;
}

- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser descriptionForImageAtIndex:(NSInteger)index
{
	return record.descriptions;
}

#pragma mark - AGPhotoBrowser delegate

- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnDoneButton:(UIButton *)doneButton
{
	// -- Dismiss
	NSLog(@"Dismiss the photo browser here");
	[self.browserView hideWithCompletion:^(BOOL finished){
		NSLog(@"Dismissed!");
	}];
}

- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnActionButton:(UIButton *)actionButton atIndex:(NSInteger)index
{
	[self action];
    [self.browserView hideWithCompletion:^(BOOL finished){
		NSLog(@"Dismissed!");
	}];
}

#pragma mark - Getters

- (AGPhotoBrowserView *)browserView
{
	if (!_browserView) {
		_browserView = [[AGPhotoBrowserView alloc] initWithFrame:self.view.bounds];
		_browserView.delegate = self;
		_browserView.dataSource = self;
	}
	
	return _browserView;
}

@end
