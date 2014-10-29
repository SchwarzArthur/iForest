//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class QCluster;

@interface ClusterAnnotationView : MKAnnotationView;

+(NSString*)reuseId;


-(instancetype)initWithCluster:(QCluster*)cluster;

@property(nonatomic, strong) QCluster* cluster;

@end