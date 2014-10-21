//
//  AllRecordsViewController.h
//  DatabaseManager

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>



@protocol AllRecordsViewControllerDelegate;


@interface AllRecordsViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>



@property (strong, nonatomic) id<AllRecordsViewControllerDelegate> delegate;

@property (assign, nonatomic) MKMapView* mapRemoveAnnotation;

@end

@protocol AllRecordsViewControllerDelegate <NSObject>

- (void)allRecordsViewController:(AllRecordsViewController *)controller mapRemovedAnnotation:(MKMapView *)mapRemoveAnnotation;

@end
