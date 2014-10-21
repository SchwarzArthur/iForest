//
//  RecordCell.h
//  DatabaseManager

#import <UIKit/UIKit.h>

@interface RecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelType;
@property (weak, nonatomic) IBOutlet UILabel *labelCoordinate;
@property (weak, nonatomic) IBOutlet UILabel *labelComment;



@end
