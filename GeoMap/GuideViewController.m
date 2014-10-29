//
//  GuideViewController.m
//  GeoMap
//
//  Created by SchwarzArthur on 4/20/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import "GuideViewController.h"
#import "ItemGuide.h"
#import "MCSFishEyeView.h"
#import "MCSDemoFishEyeItem.h"
#import "GuideWebViewController.h"
#import "ViewController.h"

@interface GuideViewController ()<
 MCSFishEyeViewDataSource, MCSFishEyeViewDelegate> {

     GuideWebViewController *_webViewController;
    
     NSArray *sections;
}
@property (weak, nonatomic) IBOutlet MCSFishEyeView *leftFishEyeView;

@property (strong, nonatomic) IBOutletCollection(MCSFishEyeView) NSArray *fishEyeViews;

@property (strong, nonatomic) NSURL *urlPDF;
@property (strong, nonatomic) NSString *urlLayer;

@end

@implementation GuideViewController

@synthesize searchBar,filteredTableData,isFiltered;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"รายชื่อป่าสงวนฯ 1221 ป่า", nil);
    // self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:24.0/255.0 green:116.0/255.0 blue:255.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tabBarController.tabBar.hidden = YES;
    
    self.leftFishEyeView.itemSize = CGSizeMake(120.0, 120.0);
    self.leftFishEyeView.contentInset = UIEdgeInsetsMake(20.0, 5.0, 20.0, 0.0);
    [self.leftFishEyeView registerItemClass:[MCSDemoFishEyeItem class]];
  
    for (MCSFishEyeView *fishEye in self.fishEyeViews) {
        fishEye.dataSource = self;
        fishEye.delegate = self;
        
        [fishEye reloadData];
    }
    sections = @[@"กระบี่  / 45 ป่า",
                 @"กาญจนบุรี  / 15 ป่า",
                 @"กาฬสินธุ์  / 14 ป่า",
                 @"กำแพงเพชร  / 9 ป่า",
                 @"ขอนแก่น  / 22 ป่า",
                 @"จันทบุรี  / 18 ป่า",
                 @"ฉะเชิงเทรา  / 1 ป่า",
                 @"ชลบุรี  / 9 ป่า",
                 @"ชัยนาท  / 2 ป่า",
                 @"ชัยภูมิ  / 11 ป่า",
                 @"ชุมพร  / 26 ป่า",
                 @"เชียงราย  / 30 ป่า",
                 @"เชียงใหม่  / 25 ป่า",
                 @"ตรัง  / 64 ป่า",
                 @"ตราด  / 14 ป่า",
                 @"ตาก  / 15 ป่า",
                 @"นครพนม  / 12 ป่า",
                 @"นครราชสีมา  / 29 ป่า",
                 @"นครศรีธรรมราช  / 69 ป่า",
                 @"นครสวรรค์  / 6 ป่า",
                 @"นราธิวาส  / 20 ป่า",
                 @"น่าน  / 16 ป่า",
                 @"บุรีรัมย์  / 22 ป่า",
                 @"ประจวบคีรีขันธ์  / 20 ป่า",
                 @"ปราจีนบุรี  / 5 ป่า",
                 @"ปัตตานี  / 15 ป่า",
                 @"พะเยา  / 12 ป่า",
                 @"พังงา  / 73 ป่า",
                 @"พัทลุง  / 31 ป่า",
                 @"พิจิตร  / 3 ป่า",
                 @"พิษณุโลก  / 13 ป่า",
                 @"เพชรบุรี  / 15 ป่า",
                 @"เพชรบูรณ์  / 13 ป่า",
                 @"แพร่  / 27 ป่า",
                 @"ภูเก็ต  / 16 ป่า",
                 @"มหาสารคาม  / 10 ป่า",
                 @"มุกดาหาร  / 13 ป่า",
                 @"แม่ฮ่องสอน  / 9 ป่า",
                 @"ยโสธร  / 27 ป่า",
                 @"ยะลา  / 11 ป่า",
                 @"ร้อยเอ็ด  / 10 ป่า",
                 @"ระนอง  / 13 ป่า",
                 @"ระยอง  / 8 ป่า",
                 @"ราชบุรี  / 7 ป่า",
                 @"ลพบุรี  / 4 ป่า",
                 @"ลำปาง  / 33 ป่า",
                 @"ลำพูน  / 10 ป่า",
                 @"เลย  / 20 ป่า",
                 @"ศรีสะเกษ  / 24 ป่า",
                 @"สกลนคร  / 16 ป่า",
                 @"สงขลา  / 41 ป่า",
                 @"สตูล  / 18 ป่า",
                 @"สมุทรสาคร  / 2 ป่า",
                 @"สระแก้ว  / 8 ป่า",
                 @"สระบุรี  / 8 ป่า",
                 @"สุโขทัย  / 12 ป่า",
                 @"สุพรรณบุรี  / 7 ป่า",
                 @"สุราษฎร์ธานี  / 26 ป่า",
                 @"สุรินทร์  / 29 ป่า",
                 @"หนองคาย  / 8 ป่า",
                 @"หนองบัวลำภู  / 6 ป่า",
                 @"อำนาจเจริญ  / 13 ป่า",
                 @"อุดรธานี  / 21 ป่า",
                 @"อุตรดิตถ์  / 15 ป่า",
                 @"อุทัยธานี  / 9 ป่า",
                 @"อุบลราชธานี  / 45 ป่า"];

    searchBar.delegate = (id)self;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.KrabiProvinces = [[NSMutableArray alloc] init];  ItemGuide *KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะกลาง" provinceE:@"KrabiProvince" code:@"S2.010" par:@"364/2511" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"26 พฤศจิกายน 2511" url:@"S2.010-2511.PDF" date_no:@"ครั้งที่ 1" area:@"37356811.7139" area_rai:@"22181" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะตะละเบ็ง" provinceE:@"KrabiProvince" code:@"S2.026" par:@"892/2523" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"27 มิถุนายน 2523" url:@"S2.026-2523.PDF" date_no:@"ครั้งที่ 1" area:@"1970327.92016" area_rai:@"1150" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะตุหลัง" provinceE:@"KrabiProvince" code:@"S2.030" par:@"1007/2526" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"15 กรกฎาคม 2526" url:@"S2.030-2526.PDF" date_no:@"ครั้งที่ 1" area:@"2581635.14698" area_rai:@"1790" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะนกคอม" provinceE:@"KrabiProvince" code:@"S2.035" par:@"1029/2526" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"31 ธันวาคม 2526" url:@"S2.035-2526.PDF" date_no:@"ครั้งที่ 1" area:@"1859658.77782" area_rai:@"1705" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะปู" provinceE:@"KrabiProvince" code:@"S2.018" par:@"715/2517" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"29 ธันวาคม 2517" url:@"S2.018-2517.PDF" date_no:@"ครั้งที่ 1" area:@"14723315.8781" area_rai:@"9450" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะรอกใน และป่าเกาะรอกนอก" provinceE:@"KrabiProvince" code:@"S2.022" par:@"835/2522" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"14 พฤษภาคม 2522" url:@"S2.022-2522.PDF" date_no:@"ครั้งที่ 1" area:@"3543260.18488" area_rai:@"2561" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะลันตาใหญ่" provinceE:@"KrabiProvince" code:@"S2.040" par:@"1108/2528" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"19 มิถุนายน 2528" url:@"S2.040-2528.PDF" date_no:@"ครั้งที่ 1" area:@"46866398.0377" area_rai:@"29815" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะสีบอยา" provinceE:@"KrabiProvince" code:@"S2.017" par:@"668/2517" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"10 พฤษภาคม 2517" url:@"S2.017-2517.PDF" date_no:@"ครั้งที่ 1" area:@"7332032.00612" area_rai:@"4812" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะฮั่ง" provinceE:@"KrabiProvince" code:@"S2.037" par:@"1061/2527" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"6 กันยายน 2527" url:@"S2.037-2527.PDF" date_no:@"ครั้งที่ 1" area:@"6056739.13121" area_rai:@"3775" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาแก้ว" provinceE:@"KrabiProvince" code:@"S2.012" par:@"573/2516" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"2 ตุลาคม 2516" url:@"S2.012-2516.PDF" date_no:@"ครั้งที่ 1" area:@"12808101.7091" area_rai:@"8406" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาแก้ว และป่าควนยิงวัว" provinceE:@"KrabiProvince" code:@"S2.011" par:@"543/2516" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"17 กรกฎาคม 2516" url:@"S2.011-2516.PDF" date_no:@"ครั้งที่ 1" area:@"59098412.0197" area_rai:@"39426" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาขวาง ป่าโคกยางและป่าช่องบางเหรียง" provinceE:@"KrabiProvince" code:@"S2.038" par:@"1093/2527" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"30 ธันวาคม 2527" url:@"S2.038-2527.PDF" date_no:@"ครั้งที่ 1" area:@"109836022.443" area_rai:@"69063" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาช่องเสียด ป่าเขากลม และป่าเขาช่องบางเหรียง" provinceE:@"KrabiProvince" code:@"S2.032" par:@"1025/2526" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"31 ธันวาคม 2526" url:@"S2.032-2526.PDF" date_no:@"ครั้งที่ 1" area:@"188587353.613" area_rai:@"112737" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาต่อ" provinceE:@"KrabiProvince" code:@"S2.016" par:@"664/2517" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"10 พฤษภาคม 2517" url:@"S2.016-2517.PDF" date_no:@"ครั้งที่ 1" area:@"58185377.2019" area_rai:@"31250" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาทอง ป่าไสไทย และป่าอ่าวนาง" provinceE:@"KrabiProvince" code:@"S2.029" par:@"996/2525" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"26 ธันวาคม 2525" url:@"S2.029-2525.PDF" date_no:@"ครั้งที่ 1" area:@"12691740.5194" area_rai:@"8525" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาประ" provinceE:@"KrabiProvince" code:@"S2.009" par:@"329/2511" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"30 กรกฎาคม 2511" url:@"S2.009-2511.PDF" date_no:@"ครั้งที่ 1" area:@"38678071.9695" area_rai:@"23400" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาพนมเบญจา" provinceE:@"KrabiProvince" code:@"S2.036" par:@"1038/2527" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"31 พฤษภาคม 2527" url:@"S2.036-2527.PDF" date_no:@"ครั้งที่ 1" area:@"111685121.624" area_rai:@"78422" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาหน้าวัว ป่าเขาหน้าแดง ป่าเขาอ่าวป่อง และป่าเขาไม้แก้ว" provinceE:@"KrabiProvince" code:@"S2.023" par:@"868/2522" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"26 ธันวาคม 2522" url:@"S2.023-2522.PDF" date_no:@"ครั้งที่ 1" area:@"10244338.3888" area_rai:@"6550" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาใหญ่" provinceE:@"KrabiProvince" code:@"S2.015" par:@"623/2516" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"21 ธันวาคม 2516" url:@"S2.015-2516.PDF" date_no:@"ครั้งที่ 1" area:@"3860950.26841" area_rai:@"2237" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาอ่าวน้ำเมา และป่าเขาอ่าวนาง" provinceE:@"KrabiProvince" code:@"S2.024" par:@"872/2522" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"26 ธันวาคม 2522" url:@"S2.024-2522.PDF" date_no:@"ครั้งที่ 1" area:@"5878498.43108" area_rai:@"3785" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองกระบี่ใหญ่ และป่าคลองเหนือคลอง" provinceE:@"KrabiProvince" code:@"S2.008" par:@"235/2510" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"7 พฤศจิกายน 2510" url:@"S2.008-2510.PDF" date_no:@"ครั้งที่ 1" area:@"45513885.4355" area_rai:@"28000" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองกาโหรด และป่าคลองหิน" provinceE:@"KrabiProvince" code:@"S2.044" par:@"1168/2529" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"5 มิถุนายน 2529" url:@"S2.044-2529.PDF" date_no:@"ครั้งที่ 1" area:@"48400395.8898" area_rai:@"23463" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองจิหลาด" provinceE:@"KrabiProvince" code:@"S2.007" par:@"234/2510" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"7 พฤศจิกายน 2510" url:@"S2.007-2510.PDF" date_no:@"ครั้งที่ 1" area:@"22687190.3673" area_rai:@"14218" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองพน และป่าบากัน" provinceE:@"KrabiProvince" code:@"S2.034" par:@"1027/2526" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"31 ธันวาคม 2526" url:@"S2.034-2526.PDF" date_no:@"ครั้งที่ 1" area:@"18603128.8238" area_rai:@"13394" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองยาง" provinceE:@"KrabiProvince" code:@"S2.020" par:@"798/2521" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"6 มิถุนายน 2521" url:@"S2.020-2521.PDF" date_no:@"ครั้งที่ 1" area:@"5565315.63094" area_rai:@"3812" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองลัดปันจอ" provinceE:@"KrabiProvince" code:@"S2.019" par:@"784/2520" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"11 ตุลาคม 2520" url:@"S2.019-2520.PDF" date_no:@"ครั้งที่ 1" area:@"62601904.3976" area_rai:@"39716" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองเหนือคลอง และป่าแหลมกรวด" provinceE:@"KrabiProvince" code:@"S2.004" par:@"194/2510" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"25 เมษายน 2510" url:@"S2.004-2510.PDF" date_no:@"ครั้งที่ 1" area:@"49038470.3399" area_rai:@"33437" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองโหนด และป่าลัดบ่อแหน" provinceE:@"KrabiProvince" code:@"S2.014" par:@"601/2516" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"20 พฤศจิกายน 2516" url:@"S2.014-2516.PDF" date_no:@"ครั้งที่ 1" area:@"25116937.1533" area_rai:@"15762" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าช่องศิลา และป่าช่องขี้แรต" provinceE:@"KrabiProvince" code:@"S2.025" par:@"886/2523" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"19 มิถุนายน 2523" url:@"S2.025-2523.PDF" date_no:@"ครั้งที่ 1" area:@"77018330.755" area_rai:@"50853" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าชายเลนคลองบางผึ้ง และป่าคลองพ่อ" provinceE:@"KrabiProvince" code:@"S2.013" par:@"586/2516" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"6 พฤศจิกายน 2516" url:@"S2.013-2516.PDF" date_no:@"ครั้งที่ 1" area:@"64910666.7148" area_rai:@"42500" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าด่านยางคู่ ป่าบางเหรียง และป่าเขาขวาง" provinceE:@"KrabiProvince" code:@"S2.021" par:@"834/2522" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"14 พฤษภาคม 2522" url:@"S2.021-2522.PDF" date_no:@"ครั้งที่ 1" area:@"89746534.4924" area_rai:@"57820" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าที่ดินของรัฐ (แปลงที่ ร.9)" provinceE:@"KrabiProvince" code:@"S2.028" par:@"955/2524" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"27 กันยายน 2524" url:@"S2.028-2524.PDF" date_no:@"ครั้งที่ 1" area:@"144930861.024" area_rai:@"81875" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าในช่องฝั่งตะวันตกถนนสายสาม" provinceE:@"KrabiProvince" code:@"S2.001" par:@"8/2499" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"4 กันยายน 2499" url:@"S2.001-2499.PDF" date_no:@"ครั้งที่ 1" area:@"24552940.8373" area_rai:@"18812" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าในท้องที่ตำบลทับปริก และตำบลเขาคราม" provinceE:@"KrabiProvince" code:@"S2.002" par:@"41/2502" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"21 กรกฎาคม 2502" url:@"S2.002-2502.PDF" date_no:@"ครั้งที่ 1" area:@"7851567.63135" area_rai:@"10625" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าบางคราม" provinceE:@"KrabiProvince" code:@"S2.003" par:@"55/2502" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"1 กันยายน 2502" url:@"S2.003-2502.PDF" date_no:@"ครั้งที่ 1" area:@"102010293.439" area_rai:@"113750" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าปลายคลองพระยา" provinceE:@"KrabiProvince" code:@"S2.033" par:@"1026/2526" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"31 ธันวาคม 2526" url:@"S2.033-2526.PDF" date_no:@"ครั้งที่ 1" area:@"120172856.384" area_rai:@"78950" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าปากลาว และป่าคลองบากัน" provinceE:@"KrabiProvince" code:@"S2.042" par:@"1151/2529" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"16 เมษายน 2529" url:@"S2.042-2529.PDF" date_no:@"ครั้งที่ 1" area:@"109075902.587" area_rai:@"61898" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองพน และป่ากลาเสน้อย" provinceE:@"KrabiProvince" code:@"S2.031" par:@"1021/2526" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"6 ธันวาคม 2526" url:@"S2.031-2526.PDF" date_no:@"ครั้งที่ 1" area:@"73389456.0965" area_rai:@"42283" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองร่าปู แปลงที่หนึ่งและแปลงที่สอง" provinceE:@"KrabiProvince" code:@"S2.039" par:@"1105/2528" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"2 พฤษภาคม 2528" url:@"S2.039-2528.PDF" date_no:@"ครั้งที่ 1" area:@"8018774.68998" area_rai:@"4772" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าสินปุน ร.12" provinceE:@"KrabiProvince" code:@"S2.043" par:@"1167/2529" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"5 มิถุนายน 2529" url:@"S2.043-2529.PDF" date_no:@"ครั้งที่ 1" area:@"169243106.099" area_rai:@"105625" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าไสโป๊ะแปลงที่หนึ่งและแปลงที่สอง" provinceE:@"KrabiProvince" code:@"S2.041" par:@"1109/2528" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"19 มิถุนายน 2528" url:@"S2.041-2528.PDF" date_no:@"ครั้งที่ 1" area:@"12362972.8675" area_rai:@"8016" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าหลังสอด และป่าควนบากันเกาะ" provinceE:@"KrabiProvince" code:@"S2.027" par:@"929/2524" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"8 มีนาคม 2524" url:@"S2.027-2524.PDF" date_no:@"ครั้งที่ 1" area:@"32004409.2564" area_rai:@"20047" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยทังและป่าหนองน้ำแดง (ป่า ร.10)" provinceE:@"KrabiProvince" code:@"S2.045" par:@"1218/2531" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"23 กุมภาพันธ์ 2531" url:@"S2.045-2531.PDF" date_no:@"ครั้งที่ 1" area:@"36477243.8411" area_rai:@"23125" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าแหลมกรวด และป่าคลองบางผึ้ง" provinceE:@"KrabiProvince" code:@"S2.005" par:@"196/2510" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"23 พฤษภาคม 2510" url:@"S2.005-2510.PDF" date_no:@"ครั้งที่ 1" area:@"53415216.4708" area_rai:@"33225" ]; [self.KrabiProvinces addObject:KrabiProvince];
    KrabiProvince = [[ItemGuide alloc] initWithName:@"ป่าอ่าวนาง และป่าหางนาค" provinceE:@"KrabiProvince" code:@"S2.006" par:@"211/2510" type:@"ป่าสงวนแห่งชาติ" province:@"กระบี่" date:@"1 กันยายน 2510" url:@"S2.006-2510.PDF" date_no:@"ครั้งที่ 1" area:@"44723224.3632" area_rai:@"28934" ]; [self.KrabiProvinces addObject:KrabiProvince];
    self.KanchanaburiProvinces = [[NSMutableArray alloc] init];  ItemGuide *KanchanaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาช่องอินทรีด้านตะวันออก" provinceE:@"KrabiProvince" code:@"P2.005" par:@"443/2514" type:@"ป่าสงวนแห่งชาติ" province:@"กาญจนบุรี" date:@"30 ธันวาคม 2514" url:@"P2.005-2514.PDF" date_no:@"ครั้งที่ 1" area:@"59367380.1898" area_rai:@"37500" ]; [self.KanchanaburiProvinces addObject:KanchanaburiProvince];
    KanchanaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาช้างเผือก" provinceE:@"KrabiProvince" code:@"P2.009" par:@"1232/2534" type:@"ป่าสงวนแห่งชาติ" province:@"กาญจนบุรี" date:@"13 สิงหาคม 2534" url:@"P2.009-2534.PDF" date_no:@"ครั้งที่ 2" area:@"1758981952.1" area_rai:@"1085977" ]; [self.KanchanaburiProvinces addObject:KanchanaburiProvince];
    KanchanaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาท่าละเมาะ" provinceE:@"KrabiProvince" code:@"P2.006" par:@"989/2525" type:@"ป่าสงวนแห่งชาติ" province:@"กาญจนบุรี" date:@"5 กันยายน 2515" url:@"P2.006-2515.PDF" date_no:@"ครั้งที่ 2" area:@"10048752.3247" area_rai:@"6781" ]; [self.KanchanaburiProvinces addObject:KanchanaburiProvince];
    KanchanaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาพระฤาษี และป่าเขาบ่อแร่ แปลงที่สอง" provinceE:@"KrabiProvince" code:@"P2.011" par:@"723/2518" type:@"ป่าสงวนแห่งชาติ" province:@"กาญจนบุรี" date:@"18 กุมภาพันธ์ 2518" url:@"P2.011-2518.PDF" date_no:@"ครั้งที่ 1" area:@"1259679129.72" area_rai:@"750000" ]; [self.KanchanaburiProvinces addObject:KanchanaburiProvince];
    KanchanaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาพระฤาษี และป่าเขาบ่อแร่ แปลงที่หนึ่ง" provinceE:@"KrabiProvince" code:@"P2.012" par:@"802/2521" type:@"ป่าสงวนแห่งชาติ" province:@"กาญจนบุรี" date:@"8 กรกฎาคม 2521" url:@"P2.012-2521.PDF" date_no:@"ครั้งที่ 1" area:@"1394170177.63" area_rai:@"542500" ]; [self.KanchanaburiProvinces addObject:KanchanaburiProvince];
    KanchanaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาแสลงพัน" provinceE:@"KrabiProvince" code:@"P2.008" par:@"613/2516" type:@"ป่าสงวนแห่งชาติ" province:@"กาญจนบุรี" date:@"4 ธันวาคม 2516" url:@"P2.008-2516.PDF" date_no:@"ครั้งที่ 1" area:@"2146822.20583" area_rai:@"1040" ]; [self.KanchanaburiProvinces addObject:KanchanaburiProvince];
    KanchanaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าชัฎใหญ่ และป่าเขาสูง" provinceE:@"KrabiProvince" code:@"P2.015" par:@"1074/2527" type:@"ป่าสงวนแห่งชาติ" province:@"กาญจนบุรี" date:@"8 พฤศจิกายน 2527" url:@"P2.015-2527.PDF" date_no:@"ครั้งที่ 1" area:@"21928686.384" area_rai:@"13275" ]; [self.KanchanaburiProvinces addObject:KanchanaburiProvince];
    KanchanaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าดอนแสลบ และป่าเลาขวัญ" provinceE:@"KrabiProvince" code:@"P2.002" par:@"107/2505" type:@"ป่าสงวนแห่งชาติ" province:@"กาญจนบุรี" date:@"28 สิงหาคม 2505" url:@"P2.002-2505.PDF" date_no:@"ครั้งที่ 1" area:@"560594505.687" area_rai:@"337500" ]; [self.KanchanaburiProvinces addObject:KanchanaburiProvince];
    KanchanaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำโจน" provinceE:@"KrabiProvince" code:@"P2.014" par:@"1071/2527" type:@"ป่าสงวนแห่งชาติ" province:@"กาญจนบุรี" date:@"8 พฤศจิกายน 2527" url:@"P2.014-2527.PDF" date_no:@"ครั้งที่ 1" area:@"720197748.161" area_rai:@"472706.25" ]; [self.KanchanaburiProvinces addObject:KanchanaburiProvince];
    KanchanaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าพระแท่นดงรัง" provinceE:@"KrabiProvince" code:@"P2.010" par:@"693/2517" type:@"ป่าสงวนแห่งชาติ" province:@"กาญจนบุรี" date:@"13 สิงหาคม 2517" url:@"P2.010-2517.PDF" date_no:@"ครั้งที่ 1" area:@"2306498.59161" area_rai:@"1344" ]; [self.KanchanaburiProvinces addObject:KanchanaburiProvince];
    KanchanaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าโรงงานกระดาษไทย แปลงที่หก" provinceE:@"KrabiProvince" code:@"P2.013" par:@"913/2523" type:@"ป่าสงวนแห่งชาติ" province:@"กาญจนบุรี" date:@"30 ธันวาคม 2523" url:@"P2.013-2523.PDF" date_no:@"ครั้งที่ 1" area:@"170234802.771" area_rai:@"101562" ]; [self.KanchanaburiProvinces addObject:KanchanaburiProvince];
    KanchanaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าวังใหญ่ และป่าแม่น้ำน้อย" provinceE:@"KrabiProvince" code:@"P2.004" par:@"417/2512" type:@"ป่าสงวนแห่งชาติ" province:@"กาญจนบุรี" date:@"8 เมษายน 2512" url:@"P2.004-2512.PDF" date_no:@"ครั้งที่ 1" area:@"1610837086.97" area_rai:@"996418" ]; [self.KanchanaburiProvinces addObject:KanchanaburiProvince];
    KanchanaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองรี" provinceE:@"KrabiProvince" code:@"P2.003" par:@"1031/2526" type:@"ป่าสงวนแห่งชาติ" province:@"กาญจนบุรี" date:@"31 ธันวาคม 2526" url:@"P2.003-2526.PDF" date_no:@"ครั้งที่ 3" area:@"440012287.506" area_rai:@"272187" ]; [self.KanchanaburiProvinces addObject:KanchanaburiProvince];
    KanchanaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองโรง" provinceE:@"KrabiProvince" code:@"P2.001" par:@"105/2505" type:@"ป่าสงวนแห่งชาติ" province:@"กาญจนบุรี" date:@"24 กรกฎาคม 2505" url:@"P2.001-2505.PDF" date_no:@"ครั้งที่ 1" area:@"27375598.9999" area_rai:@"19375" ]; [self.KanchanaburiProvinces addObject:KanchanaburiProvince];
    KanchanaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยเขยง" provinceE:@"KrabiProvince" code:@"P2.007" par:@"1231/2534" type:@"ป่าสงวนแห่งชาติ" province:@"กาญจนบุรี" date:@"14 พฤศจิกายน 2515" url:@"P2.007-2515.PDF" date_no:@"ครั้งที่ 2" area:@"687302721.391" area_rai:@"376320" ]; [self.KanchanaburiProvinces addObject:KanchanaburiProvince];
    self.KalasinProvinces = [[NSMutableArray alloc] init];  ItemGuide *KalasinProvince = [[ItemGuide alloc] initWithName:@"ป่าแก้งกะอาม" provinceE:@"KrabiProvince" code:@"F4.009" par:@"148/2509" type:@"ป่าสงวนแห่งชาติ" province:@"กาฬสินธุ์" date:@"22 พฤศจิกายน 2509" url:@"F4.009-2509.PDF" date_no:@"ครั้งที่ 1" area:@"131190435.846" area_rai:@"88562" ]; [self.KalasinProvinces addObject:KalasinProvince];
    KalasinProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกกลางหมื่น" provinceE:@"KrabiProvince" code:@"F4.007" par:@"112/2509" type:@"ป่าสงวนแห่งชาติ" province:@"กาฬสินธุ์" date:@"28 มิถุนายน 2509" url:@"F4.007-2509.PDF" date_no:@"ครั้งที่ 1" area:@"26066449.9345" area_rai:@"14918" ]; [self.KalasinProvinces addObject:KalasinProvince];
    KalasinProvince = [[ItemGuide alloc] initWithName:@"ป่าดงด่านแย้" provinceE:@"KrabiProvince" code:@"F4.010" par:@"828/2522" type:@"ป่าสงวนแห่งชาติ" province:@"กาฬสินธุ์" date:@"20 กุมภาพันธ์ 2522" url:@"F4.010-2522.PDF" date_no:@"ครั้งที่ 2" area:@"93420854.013" area_rai:@"76629.33" ]; [self.KalasinProvinces addObject:KalasinProvince];
    KalasinProvince = [[ItemGuide alloc] initWithName:@"ป่าดงนามน" provinceE:@"KrabiProvince" code:@"F4.008" par:@"762/2518" type:@"ป่าสงวนแห่งชาติ" province:@"กาฬสินธุ์" date:@"25 พฤศจิกายน 2518" url:@"F4.008-2518.PDF" date_no:@"ครั้งที่ 2" area:@"19988778.109" area_rai:@"12550" ]; [self.KalasinProvinces addObject:KalasinProvince];
    KalasinProvince = [[ItemGuide alloc] initWithName:@"ป่าดงบังอี่ แปลงที่สอง" provinceE:@"KrabiProvince" code:@"F4.014" par:@"1081/2527" type:@"ป่าสงวนแห่งชาติ" province:@"กาฬสินธุ์" date:@"6 ธันวาคม 2527" url:@"F4.014-2527.PDF" date_no:@"ครั้งที่ 2" area:@"4643600.99397" area_rai:@"2850" ]; [self.KalasinProvinces addObject:KalasinProvince];
    KalasinProvince = [[ItemGuide alloc] initWithName:@"ป่าดงบังอี่ แปลงที่หนึ่ง" provinceE:@"KrabiProvince" code:@"F4.002" par:@"1178/2529" type:@"ป่าสงวนแห่งชาติ" province:@"กาฬสินธุ์" date:@"8 ธันวาคม 2529" url:@"F4.002-2529.PDF" date_no:@"ครั้งที่ 2" area:@"19181435.2203" area_rai:@"12031" ]; [self.KalasinProvinces addObject:KalasinProvince];
    KalasinProvince = [[ItemGuide alloc] initWithName:@"ป่าดงมูล" provinceE:@"KrabiProvince" code:@"F4.015" par:@"741/2518" type:@"ป่าสงวนแห่งชาติ" province:@"กาฬสินธุ์" date:@"6 มิถุนายน 2518" url:@"F4.015-2518.PDF" date_no:@"ครั้งที่ 1" area:@"438155745.33" area_rai:@"258984" ]; [self.KalasinProvinces addObject:KalasinProvince];
    KalasinProvince = [[ItemGuide alloc] initWithName:@"ป่าดงแม่เผด" provinceE:@"KrabiProvince" code:@"F4.003" par:@"74/2504" type:@"ป่าสงวนแห่งชาติ" province:@"กาฬสินธุ์" date:@"6 มิถุนายน 2504" url:@"F4.003-2504.PDF" date_no:@"ครั้งที่ 1" area:@"212903932.885" area_rai:@"119375" ]; [self.KalasinProvinces addObject:KalasinProvince];
    KalasinProvince = [[ItemGuide alloc] initWithName:@"ป่าดงระแนง" provinceE:@"KrabiProvince" code:@"F4.001" par:@"10/2499" type:@"ป่าสงวนแห่งชาติ" province:@"กาฬสินธุ์" date:@"4 กันยายน 2499" url:@"F4.001-2499.PDF" date_no:@"ครั้งที่ 1" area:@"101235531.952" area_rai:@"69375" ]; [self.KalasinProvinces addObject:KalasinProvince];
    KalasinProvince = [[ItemGuide alloc] initWithName:@"ป่าดงหมู" provinceE:@"KrabiProvince" code:@"F4.005" par:@"68/2508" type:@"ป่าสงวนแห่งชาติ" province:@"กาฬสินธุ์" date:@"10 สิงหาคม 2508" url:@"F4.005-2508.PDF" date_no:@"ครั้งที่ 1" area:@"128281854.33" area_rai:@"88075" ]; [self.KalasinProvinces addObject:KalasinProvince];
    KalasinProvince = [[ItemGuide alloc] initWithName:@"ป่าดงห้วยฝา" provinceE:@"KrabiProvince" code:@"F4.006" par:@"819/2521" type:@"ป่าสงวนแห่งชาติ" province:@"กาฬสินธุ์" date:@"26 ธันวาคม 2521" url:@"F4.006-2521.PDF" date_no:@"ครั้งที่ 2" area:@"173432918.72" area_rai:@"110468" ]; [self.KalasinProvinces addObject:KalasinProvince];
    KalasinProvince = [[ItemGuide alloc] initWithName:@"ป่านาจารและป่าดงขวาง" provinceE:@"KrabiProvince" code:@"F4.004" par:@"785/2520" type:@"ป่าสงวนแห่งชาติ" province:@"กาฬสินธุ์" date:@"11 ตุลาคม 2520" url:@"F4.004-2520.PDF" date_no:@"ครั้งที่ 2" area:@"80963751.4253" area_rai:@"37475" ]; [self.KalasinProvinces addObject:KalasinProvince];
    KalasinProvince = [[ItemGuide alloc] initWithName:@"ป่าภูพาน" provinceE:@"KrabiProvince" code:@"F4.012" par:@"302/2511" type:@"ป่าสงวนแห่งชาติ" province:@"กาฬสินธุ์" date:@"28 พฤษภาคม 2511" url:@"F4.012-2511.PDF" date_no:@"ครั้งที่ 1" area:@"255369422.129" area_rai:@"214843" ]; [self.KalasinProvinces addObject:KalasinProvince];
    KalasinProvince = [[ItemGuide alloc] initWithName:@"ป่าภูโหล่ย" provinceE:@"KrabiProvince" code:@"F4.013" par:@"422/2512" type:@"ป่าสงวนแห่งชาติ" province:@"กาฬสินธุ์" date:@"27 พฤษภาคม 2512" url:@"F4.013-2512.PDF" date_no:@"ครั้งที่ 1" area:@"67818662.9001" area_rai:@"38437" ]; [self.KalasinProvinces addObject:KalasinProvince];
    self.KamphaengPhetProvinces = [[NSMutableArray alloc] init];  ItemGuide *KamphaengPhetProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาเขียว ป่าเขาสว่าง และป่าคลองห้วยทราย" provinceE:@"KrabiProvince" code:@"O3.005" par:@"702/2517" type:@"ป่าสงวนแห่งชาติ" province:@"กำแพงเพชร" date:@"20 สิงหาคม 2517" url:@"O3.005-2517.PDF" date_no:@"ครั้งที่ 1" area:@"332080295.817" area_rai:@"195125" ]; [self.KamphaengPhetProvinces addObject:KamphaengPhetProvince];
    KamphaengPhetProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองขลุง และป่าคลองแม่วงก์" provinceE:@"KrabiProvince" code:@"O3.007" par:@"854/2522" type:@"ป่าสงวนแห่งชาติ" province:@"กำแพงเพชร" date:@"3 สิงหาคม 2522" url:@"O3.007-2522.PDF" date_no:@"ครั้งที่ 1" area:@"1186037641.33" area_rai:@"776312" ]; [self.KamphaengPhetProvinces addObject:KamphaengPhetProvince];
    KamphaengPhetProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองวังเจ้าและป่าคลองสวนหมาก" provinceE:@"KrabiProvince" code:@"O3.003" par:@"488/2515" type:@"ป่าสงวนแห่งชาติ" province:@"กำแพงเพชร" date:@"21 พฤศจิกายน 2515" url:@"O3.003-2515.PDF" date_no:@"ครั้งที่ 2" area:@"1186296306.42" area_rai:@"751956" ]; [self.KamphaengPhetProvinces addObject:KamphaengPhetProvince];
    KamphaengPhetProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองสวนหมาก และป่าคลองขลุง" provinceE:@"KrabiProvince" code:@"O3.008" par:@"1017/2526" type:@"ป่าสงวนแห่งชาติ" province:@"กำแพงเพชร" date:@"6 ธันวาคม 2526" url:@"O3.008-2526.PDF" date_no:@"ครั้งที่ 1" area:@"1193937706.32" area_rai:@"717500" ]; [self.KamphaengPhetProvinces addObject:KamphaengPhetProvince];
    KamphaengPhetProvince = [[ItemGuide alloc] initWithName:@"ป่าไตรตรึงษ์" provinceE:@"KrabiProvince" code:@"O3.004" par:@"495/2515" type:@"ป่าสงวนแห่งชาติ" province:@"กำแพงเพชร" date:@"21 พฤศจิกายน 2515" url:@"O3.004-2515.PDF" date_no:@"ครั้งที่ 1" area:@"12829748.5181" area_rai:@"7913" ]; [self.KamphaengPhetProvinces addObject:KamphaengPhetProvince];
    KamphaengPhetProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ระกา" provinceE:@"KrabiProvince" code:@"O3.002" par:@"583/2516" type:@"ป่าสงวนแห่งชาติ" province:@"กำแพงเพชร" date:@"23 ตุลาคม 2516" url:@"O3.002-2516.PDF" date_no:@"ครั้งที่ 2" area:@"322664554.99" area_rai:@"202490" ]; [self.KamphaengPhetProvinces addObject:KamphaengPhetProvince];
    KamphaengPhetProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองคล้า และป่าดงฉัตร" provinceE:@"KrabiProvince" code:@"O3.009" par:@"1070/2527" type:@"ป่าสงวนแห่งชาติ" province:@"กำแพงเพชร" date:@"8 พฤศจิกายน 2527" url:@"O3.009-2527.PDF" date_no:@"ครั้งที่ 1" area:@"806730743.998" area_rai:@"501206" ]; [self.KamphaengPhetProvinces addObject:KamphaengPhetProvince];
    KamphaengPhetProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองเสือโฮก และป่าหนองแขม" provinceE:@"KrabiProvince" code:@"O3.001" par:@"171/2506" type:@"ป่าสงวนแห่งชาติ" province:@"กำแพงเพชร" date:@"13 สิงหาคม 2506" url:@"O3.001-2506.PDF" date_no:@"ครั้งที่ 1" area:@"19946974.3365" area_rai:@"10168.75" ]; [self.KamphaengPhetProvinces addObject:KamphaengPhetProvince];
    KamphaengPhetProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองหลวง" provinceE:@"KrabiProvince" code:@"O3.006" par:@"852/2522" type:@"ป่าสงวนแห่งชาติ" province:@"กำแพงเพชร" date:@"1 กรกฎาคม 2522" url:@"O3.006-2522.PDF" date_no:@"ครั้งที่ 1" area:@"179664979.511" area_rai:@"113300" ]; [self.KamphaengPhetProvinces addObject:KamphaengPhetProvince];
    self.KhonKaenProvinces = [[NSMutableArray alloc] init];  ItemGuide *KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่ากุดน้ำใส" provinceE:@"KrabiProvince" code:@"F1.007" par:@"334/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"30 กรกฎาคม 2511" url:@"F1.007-2511.PDF" date_no:@"ครั้งที่ 1" area:@"9907588.93206" area_rai:@"6093" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาสวนกวาง" provinceE:@"KrabiProvince" code:@"F1.003" par:@"59/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"6 กรกฎาคม 2508" url:@"F1.003-2508.PDF" date_no:@"ครั้งที่ 1" area:@"57982133.079" area_rai:@"38750" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกตลาดใหญ่" provinceE:@"KrabiProvince" code:@"F1.018" par:@"735/2518" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"22 เมษายน 2518" url:@"F1.018-2518.PDF" date_no:@"ครั้งที่ 1" area:@"51324928.8973" area_rai:@"37775" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกหลวง" provinceE:@"KrabiProvince" code:@"F1.001" par:@"8/2507" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"24 พฤศจิกายน 2507" url:@"F1.001-2507.PDF" date_no:@"ครั้งที่ 1" area:@"217236422.002" area_rai:@"129619" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกหลวง แปลงที่สาม" provinceE:@"KrabiProvince" code:@"F1.014" par:@"1229/2533" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"13 กรกฎาคม 2533" url:@"F1.014-2533.PDF" date_no:@"ครั้งที่ 2" area:@"156003170.546" area_rai:@"97656" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าดงซำ" provinceE:@"KrabiProvince" code:@"F1.020" par:@"914/2523" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"30 ธันวาคม 2523" url:@"F1.020-2523.PDF" date_no:@"ครั้งที่ 1" area:@"107364062.855" area_rai:@"69018" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าดงมูล" provinceE:@"KrabiProvince" code:@"F1.005" par:@"284/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"27 กุมภาพันธ์ 2511" url:@"F1.005-2511.PDF" date_no:@"ครั้งที่ 1" area:@"187737218.388" area_rai:@"109375" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าดงลาน" provinceE:@"KrabiProvince" code:@"F1.002" par:@"47/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"11 พฤษภาคม 2508" url:@"F1.002-2508.PDF" date_no:@"ครั้งที่ 1" area:@"581594878.313" area_rai:@"340500" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าโนนน้ำแบ่ง" provinceE:@"KrabiProvince" code:@"F1.017" par:@"859/2522" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"3 สิงหาคม 2522" url:@"F1.017-2522.PDF" date_no:@"ครั้งที่ 2" area:@"243037550.196" area_rai:@"152343" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านนายมและป่าบ้านกุดดุก" provinceE:@"KrabiProvince" code:@"F1.021" par:@"959/2524" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"27 กันยายน 2524" url:@"F1.021-2524.PDF" date_no:@"ครั้งที่ 1" area:@"6896903.83756" area_rai:@"4219" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านอุบลและป่าบ้านหัวลิง" provinceE:@"KrabiProvince" code:@"F1.019" par:@"896/2523" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"1 พฤศจิกายน 2523" url:@"F1.019-2523.PDF" date_no:@"ครั้งที่ 1" area:@"8372762.21193" area_rai:@"5543" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าภูเม็ง" provinceE:@"KrabiProvince" code:@"F1.022" par:@"1052/2527" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"14 มิถุนายน 2527" url:@"F1.022-2527.PDF" date_no:@"ครั้งที่ 1" area:@"22624542.6953" area_rai:@"13875" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าภูระงำ" provinceE:@"KrabiProvince" code:@"F1.009" par:@"403/2512" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"1 เมษายน 2512" url:@"F1.009-2512.PDF" date_no:@"ครั้งที่ 1" area:@"262632338.683" area_rai:@"158050" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าภูเวียง" provinceE:@"KrabiProvince" code:@"F1.004" par:@"64/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"13 กรกฎาคม 2508" url:@"F1.004-2508.PDF" date_no:@"ครั้งที่ 1" area:@"359754578.082" area_rai:@"218162" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าสาวถี" provinceE:@"KrabiProvince" code:@"F1.010" par:@"459/2515" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"5 กันยายน 2515" url:@"F1.010-2515.PDF" date_no:@"ครั้งที่ 1" area:@"64490007.2558" area_rai:@"17656" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าสำราญ" provinceE:@"KrabiProvince" code:@"F1.015" par:@"663/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"10 พฤษภาคม 2517" url:@"F1.015-2517.PDF" date_no:@"ครั้งที่ 1" area:@"50314157.1635" area_rai:@"29275" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าโสกแต้" provinceE:@"KrabiProvince" code:@"F1.013" par:@"602/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"20 พฤศจิกายน 2516" url:@"F1.013-2516.PDF" date_no:@"ครั้งที่ 1" area:@"95928130.2351" area_rai:@"51194" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองนกเขียน" provinceE:@"KrabiProvince" code:@"F1.011" par:@"510/2515" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"30 ธันวาคม 2515" url:@"F1.011-2515.PDF" date_no:@"ครั้งที่ 1" area:@"35130607.6062" area_rai:@"22006" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองเม็กและป่าลุมพุก" provinceE:@"KrabiProvince" code:@"F1.012" par:@"514/2515" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"30 ธันวาคม 2515" url:@"F1.012-2515.PDF" date_no:@"ครั้งที่ 1" area:@"206027140.341" area_rai:@"128250" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองอ่าง" provinceE:@"KrabiProvince" code:@"F1.006" par:@"333/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"30 กรกฎาคม 2511" url:@"F1.006-2511.PDF" date_no:@"ครั้งที่ 1" area:@"18890760.3957" area_rai:@"11718" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยเสียว" provinceE:@"KrabiProvince" code:@"F1.008" par:@"372/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"27 พฤศจิกายน 2511" url:@"F1.008-2511.PDF" date_no:@"ครั้งที่ 1" area:@"62971027.0977" area_rai:@"41600" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    KhonKaenProvince = [[ItemGuide alloc] initWithName:@"ป่าหัวฝาย" provinceE:@"KrabiProvince" code:@"F1.016" par:@"684/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ขอนแก่น" date:@"16 กรกฎาคม 2517" url:@"F1.016-2517.PDF" date_no:@"ครั้งที่ 1" area:@"24157697.4475" area_rai:@"14843" ]; [self.KhonKaenProvinces addObject:KhonKaenProvince];
    self.ChanthaburiProvinces = [[NSMutableArray alloc] init];  ItemGuide *ChanthaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าขุนซ่อง" provinceE:@"KrabiProvince" code:@"B3.014" par:@"219/2510" type:@"ป่าสงวนแห่งชาติ" province:@"จันทบุรี" date:@"5 กันยายน 2510" url:@"B3.014-2510.PDF" date_no:@"ครั้งที่ 1" area:@"1109107816.92" area_rai:@"675000" ]; [self.ChanthaburiProvinces addObject:ChanthaburiProvince];
    ChanthaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาแกลด และป่าเขาสุกริม" provinceE:@"KrabiProvince" code:@"B3.020" par:@"1115/2528" type:@"ป่าสงวนแห่งชาติ" province:@"จันทบุรี" date:@"30 กันยายน 2528" url:@"B3.020-2528.PDF" date_no:@"ครั้งที่ 1" area:@"23315652.3103" area_rai:@"12738" ]; [self.ChanthaburiProvinces addObject:ChanthaburiProvince];
    ChanthaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาลูกช้าง" provinceE:@"KrabiProvince" code:@"B3.016" par:@"1082/2527" type:@"ป่าสงวนแห่งชาติ" province:@"จันทบุรี" date:@"6 ธันวาคม 2527" url:@"B3.016-2527.PDF" date_no:@"ครั้งที่ 2" area:@"10628275.0712" area_rai:@"5513" ]; [self.ChanthaburiProvinces addObject:ChanthaburiProvince];
    ChanthaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาสอยดาว" provinceE:@"KrabiProvince" code:@"B3.013" par:@"97/2508" type:@"ป่าสงวนแห่งชาติ" province:@"จันทบุรี" date:@"31 ธันวาคม 2508" url:@"B3.013-2508.PDF" date_no:@"ครั้งที่ 1" area:@"744544275.88" area_rai:@"465637" ]; [self.ChanthaburiProvinces addObject:ChanthaburiProvince];
    ChanthaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าคุ้งกระเบนและป่าอ่าวแขมหนู" provinceE:@"KrabiProvince" code:@"B3.019" par:@"579/2516" type:@"ป่าสงวนแห่งชาติ" province:@"จันทบุรี" date:@"18 ตุลาคม 2516" url:@"B3.019-2516.PDF" date_no:@"ครั้งที่ 1" area:@"8352427.587" area_rai:@"4625" ]; [self.ChanthaburiProvinces addObject:ChanthaburiProvince];
    ChanthaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าจันตาแป๊ะ และป่าเขาวังแจง" provinceE:@"KrabiProvince" code:@"B3.009" par:@"186/2506" type:@"ป่าสงวนแห่งชาติ" province:@"จันทบุรี" date:@"10 กันยายน 2506" url:@"B3.009-2506.PDF" date_no:@"ครั้งที่ 1" area:@"98409005.2402" area_rai:@"75000" ]; [self.ChanthaburiProvinces addObject:ChanthaburiProvince];
    ChanthaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าดงกะสือ" provinceE:@"KrabiProvince" code:@"B3.011" par:@"21/2507" type:@"ป่าสงวนแห่งชาติ" province:@"จันทบุรี" date:@"31 ธันวาคม 2507" url:@"B3.011-2507.PDF" date_no:@"ครั้งที่ 1" area:@"5997335.39297" area_rai:@"3875" ]; [self.ChanthaburiProvinces addObject:ChanthaburiProvince];
    ChanthaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าตกพรม" provinceE:@"KrabiProvince" code:@"B3.018" par:@"947/2524" type:@"ป่าสงวนแห่งชาติ" province:@"จันทบุรี" date:@"13 สิงหาคม 2524" url:@"B3.018-2524.PDF" date_no:@"ครั้งที่ 2" area:@"175613607.131" area_rai:@"156397" ]; [self.ChanthaburiProvinces addObject:ChanthaburiProvince];
    ChanthaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าท่าม่วง" provinceE:@"KrabiProvince" code:@"B3.006" par:@"111/2505" type:@"ป่าสงวนแห่งชาติ" province:@"จันทบุรี" date:@"28 สิงหาคม 2505" url:@"B3.006-2505.PDF" date_no:@"ครั้งที่ 1" area:@"1602825.84386" area_rai:@"2343.75" ]; [self.ChanthaburiProvinces addObject:ChanthaburiProvince];
    ChanthaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าท่าสอน" provinceE:@"KrabiProvince" code:@"B3.008" par:@"141/2505" type:@"ป่าสงวนแห่งชาติ" province:@"จันทบุรี" date:@"11 ธันวาคม 2505" url:@"B3.008-2505.PDF" date_no:@"ครั้งที่ 1" area:@"3671379.63211" area_rai:@"2193.75" ]; [self.ChanthaburiProvinces addObject:ChanthaburiProvince];
    ChanthaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาทะลาย" provinceE:@"KrabiProvince" code:@"B3.015" par:@"288/2511" type:@"ป่าสงวนแห่งชาติ" province:@"จันทบุรี" date:@"5 มีนาคม 2511" url:@"B3.015-2511.PDF" date_no:@"ครั้งที่ 1" area:@"22247540.6059" area_rai:@"14375" ]; [self.ChanthaburiProvinces addObject:ChanthaburiProvince];
    ChanthaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าปัถวี" provinceE:@"KrabiProvince" code:@"B3.017" par:@"509/2515" type:@"ป่าสงวนแห่งชาติ" province:@"จันทบุรี" date:@"30 ธันวาคม 2515" url:@"B3.017-2515.PDF" date_no:@"ครั้งที่ 1" area:@"47960534.347" area_rai:@"35000" ]; [self.ChanthaburiProvinces addObject:ChanthaburiProvince];
    ChanthaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองบางกะจะ" provinceE:@"KrabiProvince" code:@"B3.001" par:@"40/2502" type:@"ป่าสงวนแห่งชาติ" province:@"จันทบุรี" date:@"14 กรกฎาคม 2502" url:@"B3.001-2502.PDF" date_no:@"ครั้งที่ 1" area:@"1963946.4732" area_rai:@"1406.25" ]; [self.ChanthaburiProvinces addObject:ChanthaburiProvince];
    ChanthaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองพลิ้ว" provinceE:@"KrabiProvince" code:@"B3.004" par:@"57/2502" type:@"ป่าสงวนแห่งชาติ" province:@"จันทบุรี" date:@"8 กันยายน 2502" url:@"B3.004-2502.PDF" date_no:@"ครั้งที่ 1" area:@"4933832.9437" area_rai:@"3250" ]; [self.ChanthaburiProvinces addObject:ChanthaburiProvince];
    ChanthaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนบางกะไชย" provinceE:@"KrabiProvince" code:@"B3.002" par:@"44/2502" type:@"ป่าสงวนแห่งชาติ" province:@"จันทบุรี" date:@"21 กรกฎาคม 2502" url:@"B3.002-2502.PDF" date_no:@"ครั้งที่ 1" area:@"9426532.19632" area_rai:@"9187.5" ]; [self.ChanthaburiProvinces addObject:ChanthaburiProvince];
    ChanthaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนปากน้ำพังราด" provinceE:@"KrabiProvince" code:@"B3.003" par:@"45/2502" type:@"ป่าสงวนแห่งชาติ" province:@"จันทบุรี" date:@"21 กรกฎาคม 2502" url:@"B3.003-2502.PDF" date_no:@"ครั้งที่ 1" area:@"7624983.58869" area_rai:@"5312.5" ]; [self.ChanthaburiProvinces addObject:ChanthaburiProvince];
    ChanthaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนปากน้ำเวฬุ" provinceE:@"KrabiProvince" code:@"B3.007" par:@"123/2505" type:@"ป่าสงวนแห่งชาติ" province:@"จันทบุรี" date:@"30 ตุลาคม 2505" url:@"B3.007-2505.PDF" date_no:@"ครั้งที่ 1" area:@"182599414.143" area_rai:@"119375" ]; [self.ChanthaburiProvinces addObject:ChanthaburiProvince];
    ChanthaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองระหาร" provinceE:@"KrabiProvince" code:@"B3.010" par:@"191/2506" type:@"ป่าสงวนแห่งชาติ" province:@"จันทบุรี" date:@"10 ธันวาคม 2506" url:@"B3.010-2506.PDF" date_no:@"ครั้งที่ 1" area:@"849335.229709" area_rai:@"468.75" ]; [self.ChanthaburiProvinces addObject:ChanthaburiProvince];
    self.ChachoengsaoProvinces = [[NSMutableArray alloc] init];  ItemGuide *ChachoengsaoProvince = [[ItemGuide alloc] initWithName:@"ป่าแควระบม และป่าสียัด" provinceE:@"KrabiProvince" code:@"C2.001" par:@"986/2525" type:@"ป่าสงวนแห่งชาติ" province:@"ฉะเชิงเทรา" date:@"1 พฤศจิกายน 2525" url:@"C2.001-2525.PDF" date_no:@"ครั้งที่ 3" area:@"2423362078.27" area_rai:@"1517106.25" ]; [self.ChachoengsaoProvinces addObject:ChachoengsaoProvince];
    self.ChonburiProvinces = [[NSMutableArray alloc] init];  ItemGuide *ChonburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาเขียว" provinceE:@"KrabiProvince" code:@"B1.002" par:@"56/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ชลบุรี" date:@"25 พฤษภาคม 2508" url:@"B1.002-2508.PDF" date_no:@"ครั้งที่ 1" area:@"84235723.0511" area_rai:@"55625" ]; [self.ChonburiProvinces addObject:ChonburiProvince];
    ChonburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาชมภู่" provinceE:@"KrabiProvince" code:@"B1.006" par:@"595/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ชลบุรี" date:@"13 พฤศจิกายน 2516" url:@"B1.006-2516.PDF" date_no:@"ครั้งที่ 1" area:@"50611604.3728" area_rai:@"28589" ]; [self.ChonburiProvinces addObject:ChonburiProvince];
    ChonburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาพุ" provinceE:@"KrabiProvince" code:@"B1.007" par:@"615/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ชลบุรี" date:@"4 ธันวาคม 2516" url:@"B1.007-2516.PDF" date_no:@"ครั้งที่ 1" area:@"7395236.63336" area_rai:@"5482" ]; [self.ChonburiProvinces addObject:ChonburiProvince];
    ChonburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาเรือแตก" provinceE:@"KrabiProvince" code:@"B1.009" par:@"907/2523" type:@"ป่าสงวนแห่งชาติ" province:@"ชลบุรี" date:@"9 ธันวาคม 2523" url:@"B1.009-2523.PDF" date_no:@"ครั้งที่ 1" area:@"2820683.90295" area_rai:@"1500" ]; [self.ChonburiProvinces addObject:ChonburiProvince];
    ChonburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาหินดาดและป่าเขาไผ่" provinceE:@"KrabiProvince" code:@"B1.008" par:@"818/2521" type:@"ป่าสงวนแห่งชาติ" province:@"ชลบุรี" date:@"14 พฤศจิกายน 2521" url:@"B1.008-2521.PDF" date_no:@"ครั้งที่ 1" area:@"3228010.26633" area_rai:@"2125" ]; [self.ChonburiProvinces addObject:ChonburiProvince];
    ChonburiProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองตะเคียน" provinceE:@"KrabiProvince" code:@"B1.005" par:@"296/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ชลบุรี" date:@"30 เมษายน 2511" url:@"B1.005-2511.PDF" date_no:@"ครั้งที่ 1" area:@"645101608.787" area_rai:@"378750" ]; [self.ChonburiProvinces addObject:ChonburiProvince];
    ChonburiProvince = [[ItemGuide alloc] initWithName:@"ป่าแดง และป่าชุมนุมกลาง" provinceE:@"KrabiProvince" code:@"B1.004" par:@"408/2512" type:@"ป่าสงวนแห่งชาติ" province:@"ชลบุรี" date:@"1 เมษายน 2512" url:@"B1.004-2512.PDF" date_no:@"ครั้งที่ 2" area:@"255164936.762" area_rai:@"160625" ]; [self.ChonburiProvinces addObject:ChonburiProvince];
    ChonburiProvince = [[ItemGuide alloc] initWithName:@"ป่าท่าบุญมี และป่าบ่อทอง" provinceE:@"KrabiProvince" code:@"B1.003" par:@"57/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ชลบุรี" date:@"6 กรกฎาคม 2508" url:@"B1.003-2508.PDF" date_no:@"ครั้งที่ 1" area:@"228217935.06" area_rai:@"170625" ]; [self.ChonburiProvinces addObject:ChonburiProvince];
    ChonburiProvince = [[ItemGuide alloc] initWithName:@"ป่าบางละมุง" provinceE:@"KrabiProvince" code:@"B1.001" par:@"838/2522" type:@"ป่าสงวนแห่งชาติ" province:@"ชลบุรี" date:@"15 พฤษภาคม 2522" url:@"B1.001-2522.PDF" date_no:@"ครั้งที่ 2" area:@"178186137.692" area_rai:@"103075" ]; [self.ChonburiProvinces addObject:ChonburiProvince];
    self.ChainatProvinces = [[NSMutableArray alloc] init];  ItemGuide *ChainatProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาช่องลม และป่าเขาหลัก" provinceE:@"KrabiProvince" code:@"A2.002" par:@"188/2506" type:@"ป่าสงวนแห่งชาติ" province:@"ชัยนาท" date:@"29 ตุลาคม 2506" url:@"A2.002-2506.PDF" date_no:@"ครั้งที่ 1" area:@"59419071.4242" area_rai:@"34368.75" ]; [self.ChainatProvinces addObject:ChainatProvince];
    ChainatProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาราวเทียน" provinceE:@"KrabiProvince" code:@"A2.001" par:@"406/2512" type:@"ป่าสงวนแห่งชาติ" province:@"ชัยนาท" date:@"1 เมษายน 2512" url:@"A2.001-2512.PDF" date_no:@"ครั้งที่ 2" area:@"67061503.6387" area_rai:@"43962" ]; [self.ChainatProvinces addObject:ChainatProvince];
    self.ChaiyaphumProvinces = [[NSMutableArray alloc] init];  ItemGuide *ChaiyaphumProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกหลวง" provinceE:@"KrabiProvince" code:@"D2.009" par:@"899/2523" type:@"ป่าสงวนแห่งชาติ" province:@"ชัยภูมิ" date:@"1 พฤศจิกายน 2523" url:@"D2.009-2523.PDF" date_no:@"ครั้งที่ 1" area:@"26947816.5196" area_rai:@"16531" ]; [self.ChaiyaphumProvinces addObject:ChaiyaphumProvince];
    ChaiyaphumProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกใหญ่" provinceE:@"KrabiProvince" code:@"D2.004" par:@"332/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ชัยภูมิ" date:@"30 กรกฎาคม 2511" url:@"D2.004-2511.PDF" date_no:@"ครั้งที่ 1" area:@"54910025.6525" area_rai:@"35425" ]; [self.ChaiyaphumProvinces addObject:ChaiyaphumProvince];
    ChaiyaphumProvince = [[ItemGuide alloc] initWithName:@"ป่าตาเนิน" provinceE:@"KrabiProvince" code:@"D2.006" par:@"460/2515" type:@"ป่าสงวนแห่งชาติ" province:@"ชัยภูมิ" date:@"5 กันยายน 2515" url:@"D2.006-2515.PDF" date_no:@"ครั้งที่ 1" area:@"88140487.042" area_rai:@"55275" ]; [self.ChaiyaphumProvinces addObject:ChaiyaphumProvince];
    ChaiyaphumProvince = [[ItemGuide alloc] initWithName:@"ป่านายางกลัก" provinceE:@"KrabiProvince" code:@"D2.008" par:@"978/2525" type:@"ป่าสงวนแห่งชาติ" province:@"ชัยภูมิ" date:@"14 กันยายน 2525" url:@"D2.008-2525.PDF" date_no:@"ครั้งที่ 2" area:@"1670445677.4" area_rai:@"1016668" ]; [self.ChaiyaphumProvinces addObject:ChaiyaphumProvince];
    ChaiyaphumProvince = [[ItemGuide alloc] initWithName:@"ป่าภูซำผักหนาม" provinceE:@"KrabiProvince" code:@"D2.007" par:@"538/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ชัยภูมิ" date:@"10 กรกฎาคม 2516" url:@"D2.007-2516.PDF" date_no:@"ครั้งที่ 1" area:@"454008268.536" area_rai:@"290000" ]; [self.ChaiyaphumProvinces addObject:ChaiyaphumProvince];
    ChaiyaphumProvince = [[ItemGuide alloc] initWithName:@"ป่าภูตะเภา" provinceE:@"KrabiProvince" code:@"D2.002" par:@"127/2505" type:@"ป่าสงวนแห่งชาติ" province:@"ชัยภูมิ" date:@"30 ตุลาคม 2505" url:@"D2.002-2505.PDF" date_no:@"ครั้งที่ 1" area:@"25114661.8683" area_rai:@"16756.25" ]; [self.ChaiyaphumProvinces addObject:ChaiyaphumProvince];
    ChaiyaphumProvince = [[ItemGuide alloc] initWithName:@"ป่าภูผาดำและป่าภูผาแดง" provinceE:@"KrabiProvince" code:@"D2.010" par:@"939/2524" type:@"ป่าสงวนแห่งชาติ" province:@"ชัยภูมิ" date:@"1 มิถุนายน 2524" url:@"D2.010-2524.PDF" date_no:@"ครั้งที่ 1" area:@"18807741.262" area_rai:@"11575" ]; [self.ChaiyaphumProvinces addObject:ChaiyaphumProvince];
    ChaiyaphumProvince = [[ItemGuide alloc] initWithName:@"ป่าภูแลนคาด้านทิศใต้" provinceE:@"KrabiProvince" code:@"D2.005" par:@"392/2512" type:@"ป่าสงวนแห่งชาติ" province:@"ชัยภูมิ" date:@"20 กุมภาพันธ์ 2512" url:@"D2.005-2512.PDF" date_no:@"ครั้งที่ 1" area:@"443778094.241" area_rai:@"209765" ]; [self.ChaiyaphumProvinces addObject:ChaiyaphumProvince];
    ChaiyaphumProvince = [[ItemGuide alloc] initWithName:@"ป่าภูแลนคาด้านทิศใต้บางส่วนและป่าหมายเลขสิบแปลงที่สอง" provinceE:@"KrabiProvince" code:@"D2.011" par:@"992/2525" type:@"ป่าสงวนแห่งชาติ" province:@"ชัยภูมิ" date:@"26 ธันวาคม 2525" url:@"D2.011-2525.PDF" date_no:@"ครั้งที่ 1" area:@"146635254.573" area_rai:@"85250" ]; [self.ChaiyaphumProvinces addObject:ChaiyaphumProvince];
    ChaiyaphumProvince = [[ItemGuide alloc] initWithName:@"ป่าภูแลนคาด้านทิศเหนือ" provinceE:@"KrabiProvince" code:@"D2.003" par:@"233/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ชัยภูมิ" date:@"25 ตุลาคม 2510" url:@"D2.003-2510.PDF" date_no:@"ครั้งที่ 1" area:@"446053721.639" area_rai:@"279000" ]; [self.ChaiyaphumProvinces addObject:ChaiyaphumProvince];
    ChaiyaphumProvince = [[ItemGuide alloc] initWithName:@"ป่าภูหยวก" provinceE:@"KrabiProvince" code:@"D2.001" par:@"89/2505" type:@"ป่าสงวนแห่งชาติ" province:@"ชัยภูมิ" date:@"12 มิถุนายน 2505" url:@"D2.001-2505.PDF" date_no:@"ครั้งที่ 1" area:@"76016377.5459" area_rai:@"48593.75" ]; [self.ChaiyaphumProvinces addObject:ChaiyaphumProvince];
    self.ChumphonProvinces = [[NSMutableArray alloc] init];  ItemGuide *ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะเตียบ" provinceE:@"KrabiProvince" code:@"R3.008" par:@"82/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"19 ตุลาคม 2508" url:@"R3.008-2508.PDF" date_no:@"ครั้งที่ 1" area:@"1170417.32694" area_rai:@"687" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาช้างตาย และป่าเขาสีเสียด" provinceE:@"KrabiProvince" code:@"R3.012" par:@"128/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"16 สิงหาคม 2509" url:@"R3.012-2509.PDF" date_no:@"ครั้งที่ 1" area:@"12763462.4342" area_rai:@"7781" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาตังอา และป่าคลองโชน" provinceE:@"KrabiProvince" code:@"R3.021" par:@"248/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"5 ธันวาคม 2510" url:@"R3.021-2510.PDF" date_no:@"ครั้งที่ 1" area:@"102476009.738" area_rai:@"60125" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาใหญ่บางจาก และป่าควนทุ่งมหา" provinceE:@"KrabiProvince" code:@"R3.006" par:@"69/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"10 สิงหาคม 2508" url:@"R3.006-2508.PDF" date_no:@"ครั้งที่ 1" area:@"26167163.0522" area_rai:@"15825" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าชุมโค" provinceE:@"KrabiProvince" code:@"R3.011" par:@"126/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"16 สิงหาคม 2509" url:@"R3.011-2509.PDF" date_no:@"ครั้งที่ 1" area:@"12776971.0768" area_rai:@"7893" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าดอนเทพมูล" provinceE:@"KrabiProvince" code:@"R3.018" par:@"208/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"11 สิงหาคม 2510" url:@"R3.018-2510.PDF" date_no:@"ครั้งที่ 1" area:@"200948.693851" area_rai:@"90" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งระยะและป่านาสัก" provinceE:@"KrabiProvince" code:@"R3.015" par:@"179/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"31 ธันวาคม 2509" url:@"R3.015-2509.PDF" date_no:@"ครั้งที่ 1" area:@"472412966.973" area_rai:@"276412" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่านาพญา" provinceE:@"KrabiProvince" code:@"R3.004" par:@"407/2512" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"1 เมษายน 2512" url:@"R3.004-2512.PDF" date_no:@"ครั้งที่ 2" area:@"22878000.354" area_rai:@"14781" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำตกกะเปาะ" provinceE:@"KrabiProvince" code:@"R3.022" par:@"589/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"6 พฤศจิกายน 2516" url:@"R3.022-2516.PDF" date_no:@"ครั้งที่ 1" area:@"226853056.196" area_rai:@"135200" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าบางน้ำจืด" provinceE:@"KrabiProvince" code:@"R3.024" par:@"716/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"29 ธันวาคม 2517" url:@"R3.024-2517.PDF" date_no:@"ครั้งที่ 1" area:@"2002166.87785" area_rai:@"1300" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าพรุกะชิง" provinceE:@"KrabiProvince" code:@"R3.007" par:@"80/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"19 ตุลาคม 2508" url:@"R3.007-2508.PDF" date_no:@"ครั้งที่ 1" area:@"7200374.97548" area_rai:@"4581" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าพรุดวด" provinceE:@"KrabiProvince" code:@"R3.005" par:@"60/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"6 กรกฎาคม 2508" url:@"R3.005-2508.PDF" date_no:@"ครั้งที่ 1" area:@"3588680.1668" area_rai:@"1375" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าพรุใหญ่" provinceE:@"KrabiProvince" code:@"R3.003" par:@"183/2506" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"10 กันยายน 2506" url:@"R3.003-2506.PDF" date_no:@"ครั้งที่ 1" area:@"4554099.13125" area_rai:@"1962.5" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าพะโต๊ะ ป่าปังหวาน และป่าปากทรง" provinceE:@"KrabiProvince" code:@"R3.027" par:@"968/2525" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"27 เมษายน 2525" url:@"R3.027-2525.PDF" date_no:@"ครั้งที่ 1" area:@"643153586.606" area_rai:@"397344" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่ายางบางจาก" provinceE:@"KrabiProvince" code:@"R3.009" par:@"103/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"31 ธันวาคม 2508" url:@"R3.009-2508.PDF" date_no:@"ครั้งที่ 1" area:@"449282.057647" area_rai:@"362" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่ารับร่อ และป่าสลุย" provinceE:@"KrabiProvince" code:@"R3.025" par:@"871/2522" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"26 ธันวาคม 2522" url:@"R3.025-2522.PDF" date_no:@"ครั้งที่ 2" area:@"987255593.231" area_rai:@"636387" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าละแม" provinceE:@"KrabiProvince" code:@"R3.023" par:@"592/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"13 พฤศจิกายน 2516" url:@"R3.023-2516.PDF" date_no:@"ครั้งที่ 1" area:@"316757186.093" area_rai:@"181000" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองตะโก ป่าเลนคลองท่าทอง และป่าเลนคลองบางมุด" provinceE:@"KrabiProvince" code:@"R3.019" par:@"223/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"5 กันยายน 2510" url:@"R3.019-2510.PDF" date_no:@"ครั้งที่ 1" area:@"13792684.2032" area_rai:@"9710" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองท่าทอง และป่าเลนคลองบางละมุด" provinceE:@"KrabiProvince" code:@"R3.002" par:@"146/2505" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"18 ธันวาคม 2505" url:@"R3.002-2505.PDF" date_no:@"ครั้งที่ 1" area:@"4974234.87887" area_rai:@"2668.75" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองริ่ว" provinceE:@"KrabiProvince" code:@"R3.020" par:@"227/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"26 กันยายน 2510" url:@"R3.020-2510.PDF" date_no:@"ครั้งที่ 1" area:@"698933.165838" area_rai:@"450" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนอ่าวทุ่งคาและป่าอ่าวสวี" provinceE:@"KrabiProvince" code:@"R3.017" par:@"186/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"31 ธันวาคม 2509" url:@"R3.017-2509.PDF" date_no:@"ครั้งที่ 1" area:@"59307964.4828" area_rai:@"37062" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนอ่าวทุ่งมหา" provinceE:@"KrabiProvince" code:@"R3.026" par:@"836/2522" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"15 พฤษภาคม 2522" url:@"R3.026-2522.PDF" date_no:@"ครั้งที่ 1" area:@"8311012.18825" area_rai:@"6256" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนอ่าวพนังตัก" provinceE:@"KrabiProvince" code:@"R3.016" par:@"183/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"31 ธันวาคม 2509" url:@"R3.016-2509.PDF" date_no:@"ครั้งที่ 1" area:@"8940702.09602" area_rai:@"3562" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าเสียบญวน และป่าท่าสาร" provinceE:@"KrabiProvince" code:@"R3.014" par:@"144/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"18 ตุลาคม 2509" url:@"R3.014-2509.PDF" date_no:@"ครั้งที่ 1" area:@"200745868.296" area_rai:@"136600" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองไซ และป่าทุ่งวัวแล่น" provinceE:@"KrabiProvince" code:@"R3.013" par:@"134/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"6 กันยายน 2509" url:@"R3.013-2509.PDF" date_no:@"ครั้งที่ 1" area:@"5630799.91528" area_rai:@"3331" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    ChumphonProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองห้าง และป่าเกาะเรือโกลน" provinceE:@"KrabiProvince" code:@"R3.010" par:@"125/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ชุมพร" date:@"16 สิงหาคม 2509" url:@"R3.010-2509.PDF" date_no:@"ครั้งที่ 1" area:@"2056977.03924" area_rai:@"1350" ]; [self.ChumphonProvinces addObject:ChumphonProvince];
    self.ChiangRaiProvinces = [[NSMutableArray alloc] init];  ItemGuide *ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าขุนห้วยงิ้ว ป่าเชียงเคี่ยน และป่าขุนห้วยโป่ง" provinceE:@"KrabiProvince" code:@"J1.015" par:@"389/2511" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"1 ธันวาคม 2511" url:@"J1.015-2511.PDF" date_no:@"ครั้งที่ 1" area:@"442973755.877" area_rai:@"298828" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าดอยขมิ้นและป่าน้ำแหย่ง" provinceE:@"KrabiProvince" code:@"J1.020" par:@"534/2516" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"10 กรกฎาคม 2516" url:@"J1.020-2516.PDF" date_no:@"ครั้งที่ 1" area:@"15653141.5546" area_rai:@"10000" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าดอยถ้ำผาตอง ป่าดอยสันป่าก๋อย และป่าน้ำแม่งาม" provinceE:@"KrabiProvince" code:@"J1.030" par:@"713/2517" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"29 ธันวาคม 2517" url:@"J1.030-2517.PDF" date_no:@"ครั้งที่ 1" area:@"91331731.3031" area_rai:@"58593" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าดอยทาและป่าดอยบ่อส้ม" provinceE:@"KrabiProvince" code:@"J1.039" par:@"1004/2526" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"15 กรกฎาคม 2526" url:@"J1.039-2526.PDF" date_no:@"ครั้งที่ 1" area:@"33663690.0018" area_rai:@"20000" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าดอยนางนอน" provinceE:@"KrabiProvince" code:@"J1.024" par:@"566/2516" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"25 กันยายน 2516" url:@"J1.024-2516.PDF" date_no:@"ครั้งที่ 1" area:@"65916366.6502" area_rai:@"38475" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าดอยนางแล ป่าดอยยาวและป่าดอยพระบาท" provinceE:@"KrabiProvince" code:@"J1.033" par:@"795/2521" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"6 มิถุนายน 2521" url:@"J1.033-2521.PDF" date_no:@"ครั้งที่ 1" area:@"63812583.6545" area_rai:@"38475" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าดอยบ่อ" provinceE:@"KrabiProvince" code:@"J1.029" par:@"705/2517" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"8 ตุลาคม 2517" url:@"J1.029-2517.PDF" date_no:@"ครั้งที่ 1" area:@"436292976.349" area_rai:@"149185" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าดอยปุย" provinceE:@"KrabiProvince" code:@"J1.022" par:@"1222/2532" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"16 มีนาคม 2532" url:@"J1.022-2532.PDF" date_no:@"ครั้งที่ 2" area:@"95845706.8491" area_rai:@"59912" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าดอยม่อนปู่เมา และป่าดอยม่อนหินขาว" provinceE:@"KrabiProvince" code:@"J1.037" par:@"938/2524" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"1 มิถุนายน 2524" url:@"J1.037-2524.PDF" date_no:@"ครั้งที่ 1" area:@"4403458.77558" area_rai:@"2700" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าดอยหลวง ป่าน้ำยาว และป่าน้ำซ้อ" provinceE:@"KrabiProvince" code:@"J1.018" par:@"517/2515" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"30 ธันวาคม 2515" url:@"J1.018-2515.PDF" date_no:@"ครั้งที่ 1" area:@"225700994.594" area_rai:@"132812" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำมะและป่าสบรวก" provinceE:@"KrabiProvince" code:@"J1.021" par:@"536/2516" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"10 กรกฎาคม 2516" url:@"J1.021-2516.PDF" date_no:@"ครั้งที่ 1" area:@"17885477.1524" area_rai:@"12028" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำม้าและป่าน้ำช้าง" provinceE:@"KrabiProvince" code:@"J1.040" par:@"1068/2527" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"8 พฤศจิกายน 2527" url:@"J1.040-2527.PDF" date_no:@"ครั้งที่ 1" area:@"96027311.9657" area_rai:@"54453" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำแม่คำ ป่าน้ำแม่สลอง และป่าน้ำแม่จันฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"J1.036" par:@"882/2523" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"14 มิถุนายน 2523" url:@"J1.036-2523.PDF" date_no:@"ครั้งที่ 1" area:@"622833568.562" area_rai:@"353750" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำหงาวฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"J1.034" par:@"851/2522" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"1 กรกฎาคม 2522" url:@"J1.034-2522.PDF" date_no:@"ครั้งที่ 1" area:@"171422400.732" area_rai:@"106250" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าโป่งสลี" provinceE:@"KrabiProvince" code:@"J1.001" par:@"9/2499" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"4 กันยายน 2499" url:@"J1.001-2499.PDF" date_no:@"ครั้งที่ 1" area:@"872385.068721" area_rai:@"668.75" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ข้าวต้มและป่าห้วยลึก" provinceE:@"KrabiProvince" code:@"J1.002" par:@"131/2505" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"6 พฤศจิกายน 2505" url:@"J1.002-2505.PDF" date_no:@"ครั้งที่ 1" area:@"40059672.2014" area_rai:@"15362.5" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่โขงฝั่งขวา" provinceE:@"KrabiProvince" code:@"J1.011" par:@"309/2511" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"4 มิถุนายน 2511" url:@"J1.011-2511.PDF" date_no:@"ครั้งที่ 1" area:@"138955723.773" area_rai:@"100750" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ปืม และป่าแม่พุง" provinceE:@"KrabiProvince" code:@"J1.013" par:@"341/2511" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"12 พฤศจิกายน 2511" url:@"J1.013-2511.PDF" date_no:@"ครั้งที่ 1" area:@"274260707.122" area_rai:@"169087" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ปูนน้อย ป่าแม่ปูนหลวง และป่าห้วยโป่งเหม็น" provinceE:@"KrabiProvince" code:@"J1.038" par:@"976/2525" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"14 กันยายน 2525" url:@"J1.038-2525.PDF" date_no:@"ครั้งที่ 1" area:@"767948452.431" area_rai:@"398750" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ลอยไร่ ป่าสักลอและป่าน้ำพุง" provinceE:@"KrabiProvince" code:@"J1.023" par:@"547/2516" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"24 กรกฎาคม 2516" url:@"J1.023-2516.PDF" date_no:@"ครั้งที่ 1" area:@"154540187.275" area_rai:@"93750" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ลาวฝั่งขวา" provinceE:@"KrabiProvince" code:@"J1.016" par:@"478/2515" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"14 พฤศจิกายน 2515" url:@"J1.016-2515.PDF" date_no:@"ครั้งที่ 1" area:@"203508202.988" area_rai:@"124375" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ลาวฝั่งขวา" provinceE:@"KrabiProvince" code:@"J1.026" par:@"638/2516" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"29 ธันวาคม 2516" url:@"J1.026-2516.PDF" date_no:@"ครั้งที่ 1" area:@"274281086.319" area_rai:@"169437" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ลาวฝั่งขวา ป่าแม่ส้าน และป่าแม่ใจ" provinceE:@"KrabiProvince" code:@"J1.010" par:@"228/2510" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"26 กันยายน 2510" url:@"J1.010-2510.PDF" date_no:@"ครั้งที่ 1" area:@"284949143.038" area_rai:@"170625" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ลาวฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"J1.014" par:@"360/2511" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"26 พฤศจิกายน 2511" url:@"J1.014-2511.PDF" date_no:@"ครั้งที่ 1" area:@"1116627812.38" area_rai:@"710937" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ลาวฝั่งซ้าย และป่าแม่กกฝั่งขวา" provinceE:@"KrabiProvince" code:@"J1.025" par:@"581/2516" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"23 ตุลาคม 2516" url:@"J1.025-2516.PDF" date_no:@"ครั้งที่ 1" area:@"334728650.147" area_rai:@"203125" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่อิงฝั่งขวา และป่าแม่งาว" provinceE:@"KrabiProvince" code:@"J1.017" par:@"486/2515" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"14 พฤศจิกายน 2515" url:@"J1.017-2515.PDF" date_no:@"ครั้งที่ 1" area:@"564041882.607" area_rai:@"354563" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าสบกกฝั่งขวา" provinceE:@"KrabiProvince" code:@"J1.027" par:@"649/2517" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"1 เมษายน 2517" url:@"J1.027-2517.PDF" date_no:@"ครั้งที่ 1" area:@"475268481.48" area_rai:@"265725" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยต้นยาง และป่าห้วยแม่แก้ว" provinceE:@"KrabiProvince" code:@"J1.028" par:@"681/2517" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"2 กรกฎาคม 2517" url:@"J1.028-2517.PDF" date_no:@"ครั้งที่ 1" area:@"83357154.248" area_rai:@"50000" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยป่าแดง ป่าห้วยป่าตาล และป่าห้วยไคร้" provinceE:@"KrabiProvince" code:@"J1.035" par:@"878/2523" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"5 มีนาคม 2523" url:@"J1.035-2523.PDF" date_no:@"ครั้งที่ 1" area:@"207902898.446" area_rai:@"132100" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    ChiangRaiProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยสักและป่าแม่กกฝั่งขวา" provinceE:@"KrabiProvince" code:@"J1.012" par:@"1034/2526" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงราย" date:@"31 ธันวาคม 2526" url:@"J1.012-2526.PDF" date_no:@"ครั้งที่ 2" area:@"312040280.754" area_rai:@"191250" ]; [self.ChiangRaiProvinces addObject:ChiangRaiProvince];
    self.ChiangMaiProvinces = [[NSMutableArray alloc] init];  ItemGuide *ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าขุนแม่กวง" provinceE:@"KrabiProvince" code:@"K1.015" par:@"1175/2529" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"3 กรกฎาคม 2529" url:@"K1.015-2529.PDF" date_no:@"ครั้งที่ 2" area:@"480702730.151" area_rai:@"335494" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าขุนแม่ทา" provinceE:@"KrabiProvince" code:@"K1.014" par:@"418/2512" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"29 เมษายน 2512" url:@"K1.014-2512.PDF" date_no:@"ครั้งที่ 1" area:@"237021851.093" area_rai:@"147656" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าขุนแม่ลาย" provinceE:@"KrabiProvince" code:@"K1.018" par:@"494/2515" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"21 พฤศจิกายน 2515" url:@"K1.018-2515.PDF" date_no:@"ครั้งที่ 1" area:@"479880671.726" area_rai:@"293082" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าจอมทอง" provinceE:@"KrabiProvince" code:@"K1.009" par:@"793/2521" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"13 มิถุนายน 2521" url:@"K1.009-2521.PDF" date_no:@"ครั้งที่ 2" area:@"569713986.067" area_rai:@"353500" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าเชียงดาว" provinceE:@"KrabiProvince" code:@"K1.020" par:@"988/2525" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"26 ธันวาคม 2525" url:@"K1.020-2525.PDF" date_no:@"ครั้งที่ 2" area:@"2710665588.26" area_rai:@"1692196.87" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าดอยสุเทพ" provinceE:@"KrabiProvince" code:@"K1.004" par:@"755/2518" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"15 สิงหาคม 2518" url:@"K1.004-2518.PDF" date_no:@"ครั้งที่ 3" area:@"172707376.386" area_rai:@"108011" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าท่าธาร" provinceE:@"KrabiProvince" code:@"K1.019" par:@"524/2516" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"1 พฤษภาคม 2516" url:@"K1.019-2516.PDF" date_no:@"ครั้งที่ 1" area:@"137797000.461" area_rai:@"76132" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ขะจาน" provinceE:@"KrabiProvince" code:@"K1.025" par:@"1146/2528" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"30 ธันวาคม 2528" url:@"K1.025-2528.PDF" date_no:@"ครั้งที่ 1" area:@"2219092.95245" area_rai:@"1350" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ขานและป่าแม่วาง" provinceE:@"KrabiProvince" code:@"K1.013" par:@"368/2511" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"26 พฤศจิกายน 2511" url:@"K1.013-2511.PDF" date_no:@"ครั้งที่ 1" area:@"623159283.902" area_rai:@"392300" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่งัด" provinceE:@"KrabiProvince" code:@"K1.016" par:@"471/2515" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"7 พฤศจิกายน 2515" url:@"K1.016-2515.PDF" date_no:@"ครั้งที่ 1" area:@"980380442.909" area_rai:@"677500" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่แจ่ม" provinceE:@"KrabiProvince" code:@"K1.023" par:@"792/2521" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"13 มิถุนายน 2521" url:@"K1.023-2521.PDF" date_no:@"ครั้งที่ 2" area:@"3273708288.63" area_rai:@"2412009" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่แจ่มและป่าแม่ตื่น" provinceE:@"KrabiProvince" code:@"K1.008" par:@"189/2509" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"31 ธันวาคม 2509" url:@"K1.008-2509.PDF" date_no:@"ครั้งที่ 1" area:@"1903264179.27" area_rai:@"1123437" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ตาลและป่าแม่ยุย" provinceE:@"KrabiProvince" code:@"K1.005" par:@"42/2508" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"9 มีนาคม 2508" url:@"K1.005-2508.PDF" date_no:@"ครั้งที่ 1" area:@"182793343.273" area_rai:@"111250" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่แตง" provinceE:@"KrabiProvince" code:@"K1.017" par:@"924/2523" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"30 ธันวาคม 2523" url:@"K1.017-2523.PDF" date_no:@"ครั้งที่ 2" area:@"1248009646.09" area_rai:@"760824" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ท่าช้างและป่าแม่ขนิน" provinceE:@"KrabiProvince" code:@"K1.012" par:@"243/2510" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"28 พฤศจิกายน 2510" url:@"K1.012-2510.PDF" date_no:@"ครั้งที่ 1" area:@"94700070.3198" area_rai:@"59687" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ริม" provinceE:@"KrabiProvince" code:@"K1.003" par:@"12/2507" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"31 ธันวาคม 2507" url:@"K1.003-2507.PDF" date_no:@"ครั้งที่ 1" area:@"230674627.786" area_rai:@"141562" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่สูน" provinceE:@"KrabiProvince" code:@"K1.026" par:@"1187/2529" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"8 ธันวาคม 2529" url:@"K1.026-2529.PDF" date_no:@"ครั้งที่ 1" area:@"7019656.23387" area_rai:@"3906" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่หลักหมื่น" provinceE:@"KrabiProvince" code:@"K1.022" par:@"682/2517" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"2 กรกฎาคม 2517" url:@"K1.022-2517.PDF" date_no:@"ครั้งที่ 1" area:@"9591996.13323" area_rai:@"8125" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่หาด" provinceE:@"KrabiProvince" code:@"K1.007" par:@"133/2509" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"6 กันยายน 2509" url:@"K1.007-2509.PDF" date_no:@"ครั้งที่ 1" area:@"412067962.95" area_rai:@"249531" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ออน" provinceE:@"KrabiProvince" code:@"K1.006" par:@"51/2508" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"11 พฤษภาคม 2508" url:@"K1.006-2508.PDF" date_no:@"ครั้งที่ 1" area:@"254444344.273" area_rai:@"146250" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าลุ่มน้ำแม่ฝาง" provinceE:@"KrabiProvince" code:@"K1.010" par:@"213/2510" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"1 กันยายน 2510" url:@"K1.010-2510.PDF" date_no:@"ครั้งที่ 1" area:@"1778783415.53" area_rai:@"1000000" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าสะเมิง" provinceE:@"KrabiProvince" code:@"K1.021" par:@"633/2516" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"25 ธันวาคม 2516" url:@"K1.021-2516.PDF" date_no:@"ครั้งที่ 1" area:@"840396097.531" area_rai:@"567500" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าสันทราย" provinceE:@"KrabiProvince" code:@"K1.011" par:@"242/2510" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"28 พฤศจิกายน 2510" url:@"K1.011-2510.PDF" date_no:@"ครั้งที่ 1" area:@"178528908.92" area_rai:@"115968" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าอมก๋อย" provinceE:@"KrabiProvince" code:@"K1.024" par:@"771/2518" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"21 มกราคม 2519" url:@"K1.024-2519.PDF" date_no:@"ครั้งที่ 1" area:@"2302793034.58" area_rai:@"1437500" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    ChiangMaiProvince = [[ItemGuide alloc] initWithName:@"ป่าอินทขิล" provinceE:@"KrabiProvince" code:@"K1.002" par:@"166/2509" type:@"ป่าสงวนแห่งชาติ" province:@"เชียงใหม่" date:@"31 ธันวาคม 2509" url:@"K1.002-2509.PDF" date_no:@"ครั้งที่ 1" area:@"12687085.3833" area_rai:@"7625" ]; [self.ChiangMaiProvinces addObject:ChiangMaiProvince];
    self.TrangProvinces = [[NSMutableArray alloc] init];  ItemGuide *TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะค้อ" provinceE:@"KrabiProvince" code:@"T4.031" par:@"250/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"5 ธันวาคม 2510" url:@"T4.031-2510.PDF" date_no:@"ครั้งที่ 1" area:@"873733.074425" area_rai:@"418" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะเคียน และป่าควนปริง" provinceE:@"KrabiProvince" code:@"T4.021" par:@"177/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"31 ธันวาคม 2509" url:@"T4.021-2509.PDF" date_no:@"ครั้งที่ 1" area:@"15435789.909" area_rai:@"10793" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะปริง" provinceE:@"KrabiProvince" code:@"T4.019" par:@"172/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"31 ธันวาคม 2509" url:@"T4.019-2509.PDF" date_no:@"ครั้งที่ 1" area:@"19164465.7696" area_rai:@"12500" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะมุก" provinceE:@"KrabiProvince" code:@"T4.048" par:@"421/2512" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"27 พฤษภาคม 2512" url:@"T4.048-2512.PDF" date_no:@"ครั้งที่ 1" area:@"6457651.03863" area_rai:@"6375" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะลิบง" provinceE:@"KrabiProvince" code:@"T4.017" par:@"137/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"27 กันยายน 2509" url:@"T4.017-2509.PDF" date_no:@"ครั้งที่ 1" area:@"24339402.6246" area_rai:@"13018" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะแลน" provinceE:@"KrabiProvince" code:@"T4.003" par:@"115/2505" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"18 กันยายน 2505" url:@"T4.003-2505.PDF" date_no:@"ครั้งที่ 1" area:@"5347901.8672" area_rai:@"2450" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะหวายเล็ก และป่าห้วยลูกปลา" provinceE:@"KrabiProvince" code:@"T4.050" par:@"440/2514" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"30 ธันวาคม 2514" url:@"T4.050-2514.PDF" date_no:@"ครั้งที่ 1" area:@"3396073.83973" area_rai:@"3125" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาพลู" provinceE:@"KrabiProvince" code:@"T4.011" par:@"92/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"31 ธันวาคม 2508" url:@"T4.011-2508.PDF" date_no:@"ครั้งที่ 1" area:@"20805730.44" area_rai:@"15000" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเขารังสาด ป่าทะเลสองห้อง และป่าพยอมพอก" provinceE:@"KrabiProvince" code:@"T4.009" par:@"58/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"6 กรกฎาคม 2508" url:@"T4.009-2508.PDF" date_no:@"ครั้งที่ 1" area:@"92602942.3945" area_rai:@"71875" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาหวาง ป่าควนแดง และป่าน้ำราบ" provinceE:@"KrabiProvince" code:@"T4.029" par:@"247/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"5 ธันวาคม 2510" url:@"T4.029-2510.PDF" date_no:@"ครั้งที่ 1" area:@"105061460.544" area_rai:@"86875" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาอ้อย" provinceE:@"KrabiProvince" code:@"T4.047" par:@"420/2512" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"27 พฤษภาคม 2512" url:@"T4.047-2512.PDF" date_no:@"ครั้งที่ 1" area:@"756813.05043" area_rai:@"312" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองกะลาเส และป่าคลองไม้ตาย" provinceE:@"KrabiProvince" code:@"T4.064" par:@"1172/2529" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"3 กรกฎาคม 2529" url:@"T4.064-2529.PDF" date_no:@"ครั้งที่ 1" area:@"75672559.2539" area_rai:@"46843" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองกันตัง และป่าคลองไหโละ" provinceE:@"KrabiProvince" code:@"T4.007" par:@"53/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"11 พฤษภาคม 2508" url:@"T4.007-2508.PDF" date_no:@"ครั้งที่ 1" area:@"84095526.6041" area_rai:@"53750" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองชี และป่าทอนแจ้" provinceE:@"KrabiProvince" code:@"T4.051" par:@"447/2514" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"30 ธันวาคม 2514" url:@"T4.051-2514.PDF" date_no:@"ครั้งที่ 1" area:@"28620693.0241" area_rai:@"31255" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองแตหรำ ป่าปากคลองบางแรต และป่าเขาหนุ่ย" provinceE:@"KrabiProvince" code:@"T4.004" par:@"121/2505" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"2 ตุลาคม 2505" url:@"T4.004-2505.PDF" date_no:@"ครั้งที่ 1" area:@"22976002.2152" area_rai:@"11443.75" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองหยงสตาร์ ป่าคลองหลักขันธ์ และป่าคลองลิพัง" provinceE:@"KrabiProvince" code:@"T4.013" par:@"106/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"31 ธันวาคม 2508" url:@"T4.013-2508.PDF" date_no:@"ครั้งที่ 1" area:@"62610144.1333" area_rai:@"45000" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าควนกันตัง" provinceE:@"KrabiProvince" code:@"T4.054" par:@"476/2515" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"7 พฤศจิกายน 2515" url:@"T4.054-2515.PDF" date_no:@"ครั้งที่ 1" area:@"1143256.38643" area_rai:@"600" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าควนแก้ว ป่าควนเกาะท้อน ป่าควนยิ้ม ป่าควนขวาง และป่าควนกรงนกขุ้ม" provinceE:@"KrabiProvince" code:@"T4.010" par:@"61/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"6 กรกฎาคม 2508" url:@"T4.010-2508.PDF" date_no:@"ครั้งที่ 1" area:@"5724353.70129" area_rai:@"3681" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าควนขวางและป่าเขาโอน" provinceE:@"KrabiProvince" code:@"T4.062" par:@"1136/2528" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"27 พฤศจิกายน 2528" url:@"T4.062-2528.PDF" date_no:@"ครั้งที่ 1" area:@"12499198.3174" area_rai:@"7578" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าควนคุ้งคั้ง" provinceE:@"KrabiProvince" code:@"T4.020" par:@"175/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"31 ธันวาคม 2509" url:@"T4.020-2509.PDF" date_no:@"ครั้งที่ 1" area:@"14090206.7657" area_rai:@"6073" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าควนจุปะ" provinceE:@"KrabiProvince" code:@"T4.052" par:@"451/2514" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"30 ธันวาคม 2514" url:@"T4.052-2514.PDF" date_no:@"ครั้งที่ 1" area:@"6833741.19396" area_rai:@"4687" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าควนตอ" provinceE:@"KrabiProvince" code:@"T4.008" par:@"54/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"25 พฤษภาคม 2508" url:@"T4.008-2508.PDF" date_no:@"ครั้งที่ 1" area:@"685466.695107" area_rai:@"50" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าควนตะเสะ" provinceE:@"KrabiProvince" code:@"T4.042" par:@"306/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"28 พฤษภาคม 2511" url:@"T4.042-2511.PDF" date_no:@"ครั้งที่ 1" area:@"730329.406012" area_rai:@"475" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าควนใต้บ้านเสียมใหม่" provinceE:@"KrabiProvince" code:@"T4.041" par:@"305/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"28 พฤษภาคม 2511" url:@"T4.041-2511.PDF" date_no:@"ครั้งที่ 1" area:@"877977.187405" area_rai:@"625" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าควนบางหมาก" provinceE:@"KrabiProvince" code:@"T4.006" par:@"46/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"11 พฤษภาคม 2508" url:@"T4.006-2508.PDF" date_no:@"ครั้งที่ 1" area:@"3209964.47104" area_rai:@"1875" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าควนบ้าหวี" provinceE:@"KrabiProvince" code:@"T4.049" par:@"437/2514" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"23 พฤศจิกายน 2514" url:@"T4.049-2514.PDF" date_no:@"ครั้งที่ 1" area:@"14671476.5346" area_rai:@"8112" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าควนเร็จ" provinceE:@"KrabiProvince" code:@"T4.015" par:@"121/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"19 กรกฎาคม 2509" url:@"T4.015-2509.PDF" date_no:@"ครั้งที่ 1" area:@"232368.945454" area_rai:@"87" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าควนเรือ" provinceE:@"KrabiProvince" code:@"T4.032" par:@"255/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"26 ธันวาคม 2510" url:@"T4.032-2510.PDF" date_no:@"ครั้งที่ 1" area:@"1243713.3264" area_rai:@"643" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าควนหาดทรายยาว" provinceE:@"KrabiProvince" code:@"T4.037" par:@"281/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"20 กุมภาพันธ์ 2511" url:@"T4.037-2511.PDF" date_no:@"ครั้งที่ 1" area:@"573030.150104" area_rai:@"400" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเคี่ยมซ้อน" provinceE:@"KrabiProvince" code:@"T4.045" par:@"327/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"30 กรกฎาคม 2511" url:@"T4.045-2511.PDF" date_no:@"ครั้งที่ 1" area:@"1650965.14404" area_rai:@"850" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าท่าโต๊ะแซะ" provinceE:@"KrabiProvince" code:@"T4.061" par:@"1000/2526" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"7 พฤษภาคม 2526" url:@"T4.061-2526.PDF" date_no:@"ครั้งที่ 1" area:@"397202.774113" area_rai:@"250" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งค่าย" provinceE:@"KrabiProvince" code:@"T4.033" par:@"257/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"26 ธันวาคม 2510" url:@"T4.033-2510.PDF" date_no:@"ครั้งที่ 1" area:@"4140706.49129" area_rai:@"2600" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งตะเสะ" provinceE:@"KrabiProvince" code:@"T4.063" par:@"1161/2529" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"5 มิถุนายน 2529" url:@"T4.063-2529.PDF" date_no:@"ครั้งที่ 1" area:@"3142602.67843" area_rai:@"1885" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งพานเรือก และป่าใสขี้พร้า" provinceE:@"KrabiProvince" code:@"T4.044" par:@"318/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"4 มิถุนายน 2511" url:@"T4.044-2511.PDF" date_no:@"ครั้งที่ 1" area:@"2455782.65884" area_rai:@"1275" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งใสเจ็ดห้าง และป่าควนไม้ค้ง" provinceE:@"KrabiProvince" code:@"T4.016" par:@"123/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"16 สิงหาคม 2509" url:@"T4.016-2509.PDF" date_no:@"ครั้งที่ 1" area:@"11931318.7407" area_rai:@"8125" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาขาด" provinceE:@"KrabiProvince" code:@"T4.040" par:@"304/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"28 พฤษภาคม 2511" url:@"T4.040-2511.PDF" date_no:@"ครั้งที่ 1" area:@"3472839.84458" area_rai:@"2331" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาน้ำพราย ป่าเขาหน้าแดง ป่าควนยาง และป่าควนเหมียง" provinceE:@"KrabiProvince" code:@"T4.023" par:@"187/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"31 ธันวาคม 2509" url:@"T4.023-2509.PDF" date_no:@"ครั้งที่ 1" area:@"27973278.8369" area_rai:@"13580" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาบรรทัด แปลงที่ 1 ตอนที่ 1" provinceE:@"KrabiProvince" code:@"T4.027" par:@"216/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"1 กันยายน 2510" url:@"T4.027-2510.PDF" date_no:@"ครั้งที่ 1" area:@"117259462.882" area_rai:@"54156" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาบรรทัด แปลงที่ 1 ตอนที่ 2" provinceE:@"KrabiProvince" code:@"T4.030" par:@"249/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"5 ธันวาคม 2510" url:@"T4.030-2510.PDF" date_no:@"ครั้งที่ 1" area:@"138957152.303" area_rai:@"67750" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาบันทัด แปลงที่ 1 ตอนที่ 3" provinceE:@"KrabiProvince" code:@"T4.002" par:@"78/2504" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"10 ตุลาคม 2504" url:@"T4.002-2504.PDF" date_no:@"ครั้งที่ 1" area:@"57876952.6414" area_rai:@"40781.25" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาบันทัด แปลงที่ 2 ตอนที่ 1" provinceE:@"KrabiProvince" code:@"T4.014" par:@"108/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"31 ธันวาคม 2508" url:@"T4.014-2508.PDF" date_no:@"ครั้งที่ 1" area:@"678500715.479" area_rai:@"384775" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกควนท่าโลน" provinceE:@"KrabiProvince" code:@"T4.024" par:@"195/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"23 พฤษภาคม 2510" url:@"T4.024-2510.PDF" date_no:@"ครั้งที่ 1" area:@"3407712.31031" area_rai:@"2059" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าพรุขี้กลา" provinceE:@"KrabiProvince" code:@"T4.057" par:@"687/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"23 กรกฎาคม 2517" url:@"T4.057-2517.PDF" date_no:@"ครั้งที่ 1" area:@"10442949.1032" area_rai:@"6562" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าพรุชีล้อม" provinceE:@"KrabiProvince" code:@"T4.056" par:@"571/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"2 ตุลาคม 2516" url:@"T4.056-2516.PDF" date_no:@"ครั้งที่ 1" area:@"1207121.02752" area_rai:@"825" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าพรุเตียว และป่าคลองยาง" provinceE:@"KrabiProvince" code:@"T4.046" par:@"376/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"28 พฤศจิกายน 2511" url:@"T4.046-2511.PDF" date_no:@"ครั้งที่ 1" area:@"4540028.72109" area_rai:@"2918" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าพรุเสม็ดขาว" provinceE:@"KrabiProvince" code:@"T4.034" par:@"271/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"28 ธันวาคม 2510" url:@"T4.034-2510.PDF" date_no:@"ครั้งที่ 1" area:@"2469809.21945" area_rai:@"1275" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าไม้งาม และป่าทุ่งค้อ" provinceE:@"KrabiProvince" code:@"T4.043" par:@"317/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"4 มิถุนายน 2511" url:@"T4.043-2511.PDF" date_no:@"ครั้งที่ 1" area:@"1087471.01447" area_rai:@"675" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่ายางคลองขุดเหนือ" provinceE:@"KrabiProvince" code:@"T4.059" par:@"889/2523" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"24 มิถุนายน 2523" url:@"T4.059-2523.PDF" date_no:@"ครั้งที่ 1" area:@"80855.0537351" area_rai:@"54" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนเกาะเหลาตำ" provinceE:@"KrabiProvince" code:@"T4.055" par:@"570/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"25 กันยายน 2516" url:@"T4.055-2516.PDF" date_no:@"ครั้งที่ 1" area:@"1207067.14445" area_rai:@"500" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองปรน ป่าเลนคลองควนยาง และป่าเลนคลองหินคอกควาย" provinceE:@"KrabiProvince" code:@"T4.028" par:@"230/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"6 ตุลาคม 2510" url:@"T4.028-2510.PDF" date_no:@"ครั้งที่ 1" area:@"34346401.1399" area_rai:@"23606" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองปะเหลียน และป่าคลองท่าบ้า" provinceE:@"KrabiProvince" code:@"T4.012" par:@"95/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"31 ธันวาคม 2508" url:@"T4.012-2508.PDF" date_no:@"ครั้งที่ 1" area:@"42738822.8282" area_rai:@"25100" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองหวายดน ป่าเลนคลองสุโสะ และป่าเลนคลองกุเหร่า" provinceE:@"KrabiProvince" code:@"T4.058" par:@"806/2521" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"8 กรกฎาคม 2521" url:@"T4.058-2521.PDF" date_no:@"ครั้งที่ 1" area:@"76900826.7098" area_rai:@"13250" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองใหดน ป่าเลนคลองตะเสะ ป่าเลนคลองทุ่งกอ และป่าเลนคลองแพรกออก" provinceE:@"KrabiProvince" code:@"T4.025" par:@"198/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"23 พฤษภาคม 2510" url:@"T4.025-2510.PDF" date_no:@"ครั้งที่ 1" area:@"56859735.9417" area_rai:@"36181" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองไหโละ ป่าเลนคลองปอ และป่าเลนคลองหละ" provinceE:@"KrabiProvince" code:@"T4.053" par:@"464/2515" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"26 กันยายน 2515" url:@"T4.053-2515.PDF" date_no:@"ครั้งที่ 1" area:@"13034591.6924" area_rai:@"8281" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าวังโตน และป่าหนองคล้า" provinceE:@"KrabiProvince" code:@"T4.036" par:@"278/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"6 กุมภาพันธ์ 2511" url:@"T4.036-2511.PDF" date_no:@"ครั้งที่ 1" area:@"2588160.21111" area_rai:@"1750" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าสายเขาหวาง" provinceE:@"KrabiProvince" code:@"T4.001" par:@"24/2501" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"14 ตุลาคม 2501" url:@"T4.001-2501.PDF" date_no:@"ครั้งที่ 1" area:@"39403780.8115" area_rai:@"5000" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าสายคลองร่มเมือง ป่าสายควน และป่าเกาะอ้ายกลิ้ง" provinceE:@"KrabiProvince" code:@"T4.018" par:@"1191/2529" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"31 ธันวาคม 2529" url:@"T4.018-2529.PDF" date_no:@"ครั้งที่ 2" area:@"127570802.901" area_rai:@"101267" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าสายควนหละ และป่าเขาหวาง" provinceE:@"KrabiProvince" code:@"T4.005" par:@"44/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"27 เมษายน 2508" url:@"T4.005-2508.PDF" date_no:@"ครั้งที่ 1" area:@"62866147.8325" area_rai:@"51250" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเสม็ดขาว" provinceE:@"KrabiProvince" code:@"T4.035" par:@"276/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"28 ธันวาคม 2510" url:@"T4.035-2510.PDF" date_no:@"ครั้งที่ 1" area:@"556815.205667" area_rai:@"375" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าใสป่าแก่" provinceE:@"KrabiProvince" code:@"T4.039" par:@"295/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"30 เมษายน 2511" url:@"T4.039-2511.PDF" date_no:@"ครั้งที่ 1" area:@"224123469.172" area_rai:@"154206" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองเนียงแตก ป่าห้วยเคี่ยม และป่าหนองหนักทอง" provinceE:@"KrabiProvince" code:@"T4.026" par:@"200/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"27 มิถุนายน 2510" url:@"T4.026-2510.PDF" date_no:@"ครั้งที่ 1" area:@"16956691.8265" area_rai:@"11331" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยไทรเหนือ" provinceE:@"KrabiProvince" code:@"T4.060" par:@"931/2524" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"1 มิถุนายน 2524" url:@"T4.060-2524.PDF" date_no:@"ครั้งที่ 1" area:@"2437951.53616" area_rai:@"1600" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยนาง" provinceE:@"KrabiProvince" code:@"T4.038" par:@"282/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"20 กุมภาพันธ์ 2511" url:@"T4.038-2511.PDF" date_no:@"ครั้งที่ 1" area:@"2889780.65922" area_rai:@"1812" ]; [self.TrangProvinces addObject:TrangProvince];
    TrangProvince = [[ItemGuide alloc] initWithName:@"ป่าเหรียงห้อง" provinceE:@"KrabiProvince" code:@"T4.022" par:@"178/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ตรัง" date:@"31 ธันวาคม 2509" url:@"T4.022-2509.PDF" date_no:@"ครั้งที่ 1" area:@"2695800.27162" area_rai:@"1643" ]; [self.TrangProvinces addObject:TrangProvince];
    self.TratProvinces = [[NSMutableArray alloc] init];  ItemGuide *TratProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาบรรทัด" provinceE:@"KrabiProvince" code:@"B4.014" par:@"1224/2532" type:@"ป่าสงวนแห่งชาติ" province:@"ตราด" date:@"20 กรกฎาคม 2532" url:@"B4.014-2532.PDF" date_no:@"ครั้งที่ 1" area:@"46001778.7629" area_rai:@"26789" ]; [self.TratProvinces addObject:TratProvince];
    TratProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาสมิง (ป่าคลองใหญ่ และป่าเขาไฟไหม้)" provinceE:@"KrabiProvince" code:@"B4.007" par:@"1032/2526" type:@"ป่าสงวนแห่งชาติ" province:@"ตราด" date:@"31 ธันวาคม 2526" url:@"B4.007-2526.PDF" date_no:@"ครั้งที่ 2" area:@"841339376.978" area_rai:@"513750" ]; [self.TratProvinces addObject:TratProvince];
    TratProvince = [[ItemGuide alloc] initWithName:@"ป่าชุมแสง" provinceE:@"KrabiProvince" code:@"B4.002" par:@"285/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ตราด" date:@"5 มีนาคม 2511" url:@"B4.002-2511.PDF" date_no:@"ครั้งที่ 1" area:@"30833286.5611" area_rai:@"18625" ]; [self.TratProvinces addObject:TratProvince];
    TratProvince = [[ItemGuide alloc] initWithName:@"ป่าดงธรรมชาติ" provinceE:@"KrabiProvince" code:@"B4.012" par:@"727/2518" type:@"ป่าสงวนแห่งชาติ" province:@"ตราด" date:@"18 มีนาคม 2518" url:@"B4.012-2518.PDF" date_no:@"ครั้งที่ 1" area:@"62076607.8187" area_rai:@"39750" ]; [self.TratProvinces addObject:TratProvince];
    TratProvince = [[ItemGuide alloc] initWithName:@"ป่าท้องอ่าว" provinceE:@"KrabiProvince" code:@"B4.003" par:@"311/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ตราด" date:@"4 มิถุนายน 2511" url:@"B4.003-2511.PDF" date_no:@"ครั้งที่ 1" area:@"35583275.5722" area_rai:@"18237" ]; [self.TratProvinces addObject:TratProvince];
    TratProvince = [[ItemGuide alloc] initWithName:@"ป่าท่ากุ่ม และป่าห้วยแร้ง" provinceE:@"KrabiProvince" code:@"B4.013" par:@"916/2523" type:@"ป่าสงวนแห่งชาติ" province:@"ตราด" date:@"30 ธันวาคม 2523" url:@"B4.013-2523.PDF" date_no:@"ครั้งที่ 1" area:@"204578344.899" area_rai:@"115568" ]; [self.TratProvinces addObject:TratProvince];
    TratProvince = [[ItemGuide alloc] initWithName:@"ป่าท่าตะเภา และป่าเลนน้ำเชี่ยว" provinceE:@"KrabiProvince" code:@"B4.008" par:@"672/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ตราด" date:@"28 พฤษภาคม 2517" url:@"B4.008-2517.PDF" date_no:@"ครั้งที่ 1" area:@"30502505.243" area_rai:@"24687" ]; [self.TratProvinces addObject:TratProvince];
    TratProvince = [[ItemGuide alloc] initWithName:@"ป่าท่าโสม" provinceE:@"KrabiProvince" code:@"B4.010" par:@"694/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ตราด" date:@"13 สิงหาคม 2517" url:@"B4.010-2517.PDF" date_no:@"ครั้งที่ 1" area:@"36209090.6426" area_rai:@"21125" ]; [self.TratProvinces addObject:TratProvince];
    TratProvince = [[ItemGuide alloc] initWithName:@"ป่าปากคลองบางพระ ป่าเกาะเจ้า และป่าเกาะลอย" provinceE:@"KrabiProvince" code:@"B4.005" par:@"582/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ตราด" date:@"23 ตุลาคม 2516" url:@"B4.005-2516.PDF" date_no:@"ครั้งที่ 1" area:@"12342099.3375" area_rai:@"7500" ]; [self.TratProvinces addObject:TratProvince];
    TratProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนบางกระดาน" provinceE:@"KrabiProvince" code:@"B4.006" par:@"873/2522" type:@"ป่าสงวนแห่งชาติ" province:@"ตราด" date:@"26 ธันวาคม 2522" url:@"B4.006-2522.PDF" date_no:@"ครั้งที่ 2" area:@"1938221.52452" area_rai:@"1066" ]; [self.TratProvinces addObject:TratProvince];
    TratProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนบ้านธรรมชาติ" provinceE:@"KrabiProvince" code:@"B4.011" par:@"726/2518" type:@"ป่าสงวนแห่งชาติ" province:@"ตราด" date:@"25 กุมภาพันธ์ 2518" url:@"B4.011-2518.PDF" date_no:@"ครั้งที่ 1" area:@"857612.960554" area_rai:@"375" ]; [self.TratProvinces addObject:TratProvince];
    TratProvince = [[ItemGuide alloc] initWithName:@"ป่าเสม็ด" provinceE:@"KrabiProvince" code:@"B4.004" par:@"506/2515" type:@"ป่าสงวนแห่งชาติ" province:@"ตราด" date:@"30 ธันวาคม 2515" url:@"B4.004-2515.PDF" date_no:@"ครั้งที่ 1" area:@"23804070.1965" area_rai:@"8359" ]; [self.TratProvinces addObject:TratProvince];
    TratProvince = [[ItemGuide alloc] initWithName:@"ป่าหินเพิงทึบ ทิวเขาบรรทัด" provinceE:@"KrabiProvince" code:@"B4.001" par:@"781/2519" type:@"ป่าสงวนแห่งชาติ" province:@"ตราด" date:@"29 มิถุนายน 2519" url:@"B4.001-2519.PDF" date_no:@"ครั้งที่ 2" area:@"116533391.387" area_rai:@"55937.5" ]; [self.TratProvinces addObject:TratProvince];
    TratProvince = [[ItemGuide alloc] initWithName:@"ป่าแหลมมะขาม" provinceE:@"KrabiProvince" code:@"B4.009" par:@"680/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ตราด" date:@"2 กรกฎาคม 2517" url:@"B4.009-2517.PDF" date_no:@"ครั้งที่ 1" area:@"2402153.71582" area_rai:@"1796" ]; [self.TratProvinces addObject:TratProvince];
    self.TakProvinces = [[NSMutableArray alloc] init];  ItemGuide *TakProvince = [[ItemGuide alloc] initWithName:@"ป่าช่องแคบ และป่าแม่โกนเกน" provinceE:@"KrabiProvince" code:@"N1.005" par:@"299/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ตาก" date:@"30 เมษายน 2511" url:@"N1.005-2511.PDF" date_no:@"ครั้งที่ 1" area:@"205778634.245" area_rai:@"120625" ]; [self.TakProvinces addObject:TakProvince];
    TakProvince = [[ItemGuide alloc] initWithName:@"ป่าท่าสองยาง" provinceE:@"KrabiProvince" code:@"N1.014" par:@"1019/2526" type:@"ป่าสงวนแห่งชาติ" province:@"ตาก" date:@"6 ธันวาคม 2526" url:@"N1.014-2526.PDF" date_no:@"ครั้งที่ 1" area:@"1882191146.9" area_rai:@"1273375" ]; [self.TakProvinces addObject:TakProvince];
    TakProvince = [[ItemGuide alloc] initWithName:@"ป่าประจำรักษ์" provinceE:@"KrabiProvince" code:@"N1.002" par:@"578/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ตาก" date:@"18 ตุลาคม 2516" url:@"N1.002-2516.PDF" date_no:@"ครั้งที่ 2" area:@"245244280.372" area_rai:@"164875" ]; [self.TakProvinces addObject:TakProvince];
    TakProvince = [[ItemGuide alloc] initWithName:@"ป่าประดาง และป่าวังก์เจ้า" provinceE:@"KrabiProvince" code:@"N1.001" par:@"10/2507" type:@"ป่าสงวนแห่งชาติ" province:@"ตาก" date:@"8 ธันวาคม 2507" url:@"N1.001-2507.PDF" date_no:@"ครั้งที่ 1" area:@"595494891.381" area_rai:@"175000" ]; [self.TakProvinces addObject:TakProvince];
    TakProvince = [[ItemGuide alloc] initWithName:@"ป่าฝั่งซ้ายแม่น้ำปิง" provinceE:@"KrabiProvince" code:@"N1.011" par:@"728/2518" type:@"ป่าสงวนแห่งชาติ" province:@"ตาก" date:@"8 เมษายน 2518" url:@"N1.011-2518.PDF" date_no:@"ครั้งที่ 1" area:@"307180982.008" area_rai:@"187500" ]; [self.TakProvinces addObject:TakProvince];
    TakProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่กลอง และป่าอุ้มผาง" provinceE:@"KrabiProvince" code:@"N1.013" par:@"965/2524" type:@"ป่าสงวนแห่งชาติ" province:@"ตาก" date:@"30 ธันวาคม 2524" url:@"N1.013-2524.PDF" date_no:@"ครั้งที่ 1" area:@"4788099334.65" area_rai:@"2865000" ]; [self.TakProvinces addObject:TakProvince];
    TakProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ตื่น" provinceE:@"KrabiProvince" code:@"N1.004" par:@"170/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ตาก" date:@"31 ธันวาคม 2509" url:@"N1.004-2509.PDF" date_no:@"ครั้งที่ 1" area:@"253762916.927" area_rai:@"166875" ]; [self.TakProvinces addObject:TakProvince];
    TakProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ท้อและป่าห้วยตากฝั่งขวา" provinceE:@"KrabiProvince" code:@"N1.003" par:@"145/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ตาก" date:@"22 พฤศจิกายน 2509" url:@"N1.003-2509.PDF" date_no:@"ครั้งที่ 1" area:@"718540504.061" area_rai:@"370150" ]; [self.TakProvinces addObject:TakProvince];
    TakProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ระมาด" provinceE:@"KrabiProvince" code:@"N1.007" par:@"456/2515" type:@"ป่าสงวนแห่งชาติ" province:@"ตาก" date:@"20 มิถุนายน 2515" url:@"N1.007-2515.PDF" date_no:@"ครั้งที่ 1" area:@"681114935.41" area_rai:@"412487" ]; [self.TakProvinces addObject:TakProvince];
    TakProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ละเมา" provinceE:@"KrabiProvince" code:@"N1.012" par:@"945/2524" type:@"ป่าสงวนแห่งชาติ" province:@"ตาก" date:@"23 กรกฎาคม 2524" url:@"N1.012-2524.PDF" date_no:@"ครั้งที่ 1" area:@"531442321.25" area_rai:@"354687" ]; [self.TakProvinces addObject:TakProvince];
    TakProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่สลิดและป่าโป่งแดง" provinceE:@"KrabiProvince" code:@"N1.009" par:@"605/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ตาก" date:@"27 พฤศจิกายน 2516" url:@"N1.009-2516.PDF" date_no:@"ครั้งที่ 1" area:@"985093810.923" area_rai:@"566377" ]; [self.TakProvinces addObject:TakProvince];
    TakProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่สอด" provinceE:@"KrabiProvince" code:@"N1.010" par:@"639/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ตาก" date:@"29 ธันวาคม 2516" url:@"N1.010-2516.PDF" date_no:@"ครั้งที่ 1" area:@"1366915681.28" area_rai:@"697750" ]; [self.TakProvinces addObject:TakProvince];
    TakProvince = [[ItemGuide alloc] initWithName:@"ป่าลานสาง" provinceE:@"KrabiProvince" code:@"N1.006" par:@"833/2522" type:@"ป่าสงวนแห่งชาติ" province:@"ตาก" date:@"14 พฤษภาคม 2522" url:@"N1.006-2522.PDF" date_no:@"ครั้งที่ 2" area:@"53057634.775" area_rai:@"41831" ]; [self.TakProvinces addObject:TakProvince];
    TakProvince = [[ItemGuide alloc] initWithName:@"ป่าสวนรุกขชาติกิตติขจร" provinceE:@"KrabiProvince" code:@"N1.008" par:@"563/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ตาก" date:@"14 สิงหาคม 2516" url:@"N1.008-2516.PDF" date_no:@"ครั้งที่ 1" area:@"1472031.15446" area_rai:@"768" ]; [self.TakProvinces addObject:TakProvince];
    TakProvince = [[ItemGuide alloc] initWithName:@"ป่าสามหมื่น" provinceE:@"KrabiProvince" code:@"N1.015" par:@"1210/2530" type:@"ป่าสงวนแห่งชาติ" province:@"ตาก" date:@"9 พฤศจิกายน 2530" url:@"N1.015-2530.PDF" date_no:@"ครั้งที่ 1" area:@"283392214.534" area_rai:@"170468" ]; [self.TakProvinces addObject:TakProvince];
    self.NakhonPhanomProvinces = [[NSMutableArray alloc] init];  ItemGuide *NakhonPhanomProvince = [[ItemGuide alloc] initWithName:@"ป่าดงเชียงยืน" provinceE:@"KrabiProvince" code:@"G3.012" par:@"783/2519" type:@"ป่าสงวนแห่งชาติ" province:@"นครพนม" date:@"7 กันยายน 2519" url:@"G3.012-2519.PDF" date_no:@"ครั้งที่ 1" area:@"18854546.7104" area_rai:@"11950" ]; [self.NakhonPhanomProvinces addObject:NakhonPhanomProvince];
    NakhonPhanomProvince = [[ItemGuide alloc] initWithName:@"ป่าดงเซกาแปลงที่สอง" provinceE:@"KrabiProvince" code:@"G3.018" par:@"1238/2538" type:@"ป่าสงวนแห่งชาติ" province:@"นครพนม" date:@"28 พฤศจิกายน 2538" url:@"G3.018-2538.PDF" date_no:@"ครั้งที่ 1" area:@"205776578.999" area_rai:@"126565" ]; [self.NakhonPhanomProvinces addObject:NakhonPhanomProvince];
    NakhonPhanomProvince = [[ItemGuide alloc] initWithName:@"ป่าดงเซกาแปลงที่หนึ่ง" provinceE:@"KrabiProvince" code:@"G3.004" par:@"961/2524" type:@"ป่าสงวนแห่งชาติ" province:@"นครพนม" date:@"5 ธันวาคม 2524" url:@"G3.004-2524.PDF" date_no:@"ครั้งที่ 3" area:@"111809498.726" area_rai:@"67917" ]; [self.NakhonPhanomProvinces addObject:NakhonPhanomProvince];
    NakhonPhanomProvince = [[ItemGuide alloc] initWithName:@"ป่าดงบ้านโพนสว่างและป่าปลาปาก" provinceE:@"KrabiProvince" code:@"G3.014" par:@"910/2523" type:@"ป่าสงวนแห่งชาติ" province:@"นครพนม" date:@"9 ธันวาคม 2523" url:@"G3.014-2523.PDF" date_no:@"ครั้งที่ 1" area:@"100589437.086" area_rai:@"63750" ]; [self.NakhonPhanomProvinces addObject:NakhonPhanomProvince];
    NakhonPhanomProvince = [[ItemGuide alloc] initWithName:@"ป่าดงเมา" provinceE:@"KrabiProvince" code:@"G3.016" par:@"1091/2527" type:@"ป่าสงวนแห่งชาติ" province:@"นครพนม" date:@"30 ธันวาคม 2527" url:@"G3.016-2527.PDF" date_no:@"ครั้งที่ 1" area:@"102756241.072" area_rai:@"65000" ]; [self.NakhonPhanomProvinces addObject:NakhonPhanomProvince];
    NakhonPhanomProvince = [[ItemGuide alloc] initWithName:@"ป่าดงหมู" provinceE:@"KrabiProvince" code:@"G3.017" par:@"1185/2529" type:@"ป่าสงวนแห่งชาติ" province:@"นครพนม" date:@"8 ธันวาคม 2529" url:@"G3.017-2529.PDF" date_no:@"ครั้งที่ 1" area:@"41555896.2119" area_rai:@"24117" ]; [self.NakhonPhanomProvinces addObject:NakhonPhanomProvince];
    NakhonPhanomProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านโพนตูมและป่านางุม" provinceE:@"KrabiProvince" code:@"G3.015" par:@"970/2525" type:@"ป่าสงวนแห่งชาติ" province:@"นครพนม" date:@"27 เมษายน 2525" url:@"G3.015-2525.PDF" date_no:@"ครั้งที่ 1" area:@"219620090.985" area_rai:@"131850" ]; [self.NakhonPhanomProvinces addObject:NakhonPhanomProvince];
    NakhonPhanomProvince = [[ItemGuide alloc] initWithName:@"ป่าภูลังกา" provinceE:@"KrabiProvince" code:@"G3.003" par:@"30/2507" type:@"ป่าสงวนแห่งชาติ" province:@"นครพนม" date:@"31 ธันวาคม 2507" url:@"G3.003-2507.PDF" date_no:@"ครั้งที่ 1" area:@"70796289.3076" area_rai:@"44031" ]; [self.NakhonPhanomProvinces addObject:NakhonPhanomProvince];
    NakhonPhanomProvince = [[ItemGuide alloc] initWithName:@"ป่าสักพุ่มแก" provinceE:@"KrabiProvince" code:@"G3.001" par:@"124/2505" type:@"ป่าสงวนแห่งชาติ" province:@"นครพนม" date:@"30 ตุลาคม 2505" url:@"G3.001-2505.PDF" date_no:@"ครั้งที่ 1" area:@"282791.81204" area_rai:@"162.5" ]; [self.NakhonPhanomProvinces addObject:NakhonPhanomProvince];
    NakhonPhanomProvince = [[ItemGuide alloc] initWithName:@"ป่าสักหนองห้าง" provinceE:@"KrabiProvince" code:@"G3.002" par:@"150/2505" type:@"ป่าสงวนแห่งชาติ" province:@"นครพนม" date:@"25 ธันวาคม 2505" url:@"G3.002-2505.PDF" date_no:@"ครั้งที่ 1" area:@"120479.976668" area_rai:@"100" ]; [self.NakhonPhanomProvinces addObject:NakhonPhanomProvince];
    NakhonPhanomProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองบัวโค้ง" provinceE:@"KrabiProvince" code:@"G3.010" par:@"770/2518" type:@"ป่าสงวนแห่งชาติ" province:@"นครพนม" date:@"13 มกราคม 2519" url:@"G3.011-2519.PDF" date_no:@"ครั้งที่ 1" area:@"16827886.816" area_rai:@"13043" ]; [self.NakhonPhanomProvinces addObject:NakhonPhanomProvince];
    NakhonPhanomProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยศรีคุณ" provinceE:@"KrabiProvince" code:@"G3.005" par:@"337/2511" type:@"ป่าสงวนแห่งชาติ" province:@"นครพนม" date:@"12 พฤศจิกายน 2511" url:@"G3.005-2511.PDF" date_no:@"ครั้งที่ 1" area:@"26888022.5931" area_rai:@"16875" ]; [self.NakhonPhanomProvinces addObject:NakhonPhanomProvince];
    self.NakhonRatchasimaProvinces = [[NSMutableArray alloc] init];  ItemGuide *NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาจอมทอง" provinceE:@"KrabiProvince" code:@"D1.027" par:@"911/2523" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"9 ธันวาคม 2523" url:@"D1.027-2523.PDF" date_no:@"ครั้งที่ 1" area:@"88310293.0543" area_rai:@"56250" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาซับประดู่ และป่าเขามะกอก" provinceE:@"KrabiProvince" code:@"D1.005" par:@"1235/2534" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"1 ตุลาคม 2534" url:@"D1.005-2534.PDF" date_no:@"ครั้งที่ 2" area:@"36494882.3502" area_rai:@"23234" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาเตียน และป่าเขาเขื่อนลั่น" provinceE:@"KrabiProvince" code:@"D1.002" par:@"67/2508" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"20 กรกฎาคม 2508" url:@"D1.002-2508.PDF" date_no:@"ครั้งที่ 1" area:@"31041012.6383" area_rai:@"19375" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาภูหลวง" provinceE:@"KrabiProvince" code:@"D1.016" par:@"1144/2528" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"30 ธันวาคม 2528" url:@"D1.016-2528.PDF" date_no:@"ครั้งที่ 2" area:@"817098390.478" area_rai:@"651440" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาเสียดอ้า ป่าเขานกยูง และป่าเขาอ่างหิน" provinceE:@"KrabiProvince" code:@"D1.004" par:@"147/2509" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"22 พฤศจิกายน 2509" url:@"D1.004-2509.PDF" date_no:@"ครั้งที่ 1" area:@"104143681.579" area_rai:@"63562" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าครบุรี" provinceE:@"KrabiProvince" code:@"D1.006" par:@"176/2509" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"31 ธันวาคม 2509" url:@"D1.006-2509.PDF" date_no:@"ครั้งที่ 1" area:@"1673365315.73" area_rai:@"1051250" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกหลวง" provinceE:@"KrabiProvince" code:@"D1.018" par:@"730/2518" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"8 เมษายน 2518" url:@"D1.018-2518.PDF" date_no:@"ครั้งที่ 1" area:@"743114008.451" area_rai:@"461425" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าโครงการรถไฟเมืองคง และป่าบัวใหญ่" provinceE:@"KrabiProvince" code:@"D1.023" par:@"761/2518" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"25 พฤศจิกายน 2518" url:@"D1.023-2518.PDF" date_no:@"ครั้งที่ 1" area:@"16678438.4697" area_rai:@"10010" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าดงกะสัง และป่าลำพญากลาง" provinceE:@"KrabiProvince" code:@"D1.014" par:@"393/2512" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"20 กุมภาพันธ์ 2512" url:@"D1.014-2512.PDF" date_no:@"ครั้งที่ 1" area:@"691593684.489" area_rai:@"400393" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าดงพญาเย็น" provinceE:@"KrabiProvince" code:@"D1.001" par:@"135/2505" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"11 ธันวาคม 2505" url:@"D1.001-2505.PDF" date_no:@"ครั้งที่ 1" area:@"463579403.302" area_rai:@"97812.5" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าดงอีจานใหญ่" provinceE:@"KrabiProvince" code:@"D1.025" par:@"860/2522" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"3 สิงหาคม 2522" url:@"D1.025-2522.PDF" date_no:@"ครั้งที่ 1" area:@"998512238.911" area_rai:@"605187" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าท่าช้าง และป่าหนองกระทิง" provinceE:@"KrabiProvince" code:@"D1.021" par:@"757/2518" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"19 สิงหาคม 2518" url:@"D1.021-2518.PDF" date_no:@"ครั้งที่ 1" area:@"101989476.443" area_rai:@"60040" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าท่าช้างและป่าหินดาษ" provinceE:@"KrabiProvince" code:@"D1.022" par:@"758/2518" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"19 สิงหาคม 2518" url:@"D1.022-2518.PDF" date_no:@"ครั้งที่ 1" area:@"354682537.572" area_rai:@"219931" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าทำนบเขมร" provinceE:@"KrabiProvince" code:@"D1.017" par:@"691/2517" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"23 กรกฎาคม 2517" url:@"D1.017-2517.PDF" date_no:@"ครั้งที่ 1" area:@"42168619.5944" area_rai:@"24062" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่านครราชสีมา ป่าปักธงชัยและป่าโชคชัย" provinceE:@"KrabiProvince" code:@"D1.011" par:@"268/2510" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"28 ธันวาคม 2510" url:@"D1.011-2510.PDF" date_no:@"ครั้งที่ 1" area:@"127509312.732" area_rai:@"78750" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่านครราชสีมา และป่าปักธงชัย" provinceE:@"KrabiProvince" code:@"D1.019" par:@"737/2518" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"22 เมษายน 2518" url:@"D1.019-2518.PDF" date_no:@"ครั้งที่ 1" area:@"64793677.6855" area_rai:@"39687" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่านครราชสีมาและป่าโชคชัย" provinceE:@"KrabiProvince" code:@"D1.028" par:@"948/2524" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"27 กันยายน 2524" url:@"D1.028-2524.PDF" date_no:@"ครั้งที่ 1" area:@"30456495.5569" area_rai:@"18525" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าปากช่องและป่าหมูสี" provinceE:@"KrabiProvince" code:@"D1.029" par:@"1216/2531" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"18 กุมภาพันธ์ 2531" url:@"D1.029-2531.PDF" date_no:@"ครั้งที่ 2" area:@"146794706.986" area_rai:@"89974" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าพิมาย" provinceE:@"KrabiProvince" code:@"D1.009" par:@"778/2519" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"1 มิถุนายน 2519" url:@"D1.009-2519.PDF" date_no:@"ครั้งที่ 2" area:@"404645542.598" area_rai:@"301369" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าพิมายแปลงที่สอง" provinceE:@"KrabiProvince" code:@"D1.026" par:@"879/2523" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"5 มีนาคม 2523" url:@"D1.026-2523.PDF" date_no:@"ครั้งที่ 1" area:@"105938039.28" area_rai:@"74687" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่ามาบกราด" provinceE:@"KrabiProvince" code:@"D1.020" par:@"740/2518" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"6 มิถุนายน 2518" url:@"D1.020-2518.PDF" date_no:@"ครั้งที่ 1" area:@"24380897.24" area_rai:@"13900" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าวังน้ำเขียว" provinceE:@"KrabiProvince" code:@"D1.015" par:@"1145/2528" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"30 ธันวาคม 2528" url:@"D1.015-2528.PDF" date_no:@"ครั้งที่ 2" area:@"19091970.82" area_rai:@"11721" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าสูงเนิน" provinceE:@"KrabiProvince" code:@"D1.013" par:@"382/2511" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"28 พฤศจิกายน 2511" url:@"D1.013-2511.PDF" date_no:@"ครั้งที่ 1" area:@"280357170.996" area_rai:@"168000" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองเต็ง และป่าจักราช" provinceE:@"KrabiProvince" code:@"D1.012" par:@"294/2511" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"30 เมษายน 2511" url:@"D1.012-2511.PDF" date_no:@"ครั้งที่ 1" area:@"135815237.651" area_rai:@"81875" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองเต็งจักราชแปลงที่สอง" provinceE:@"KrabiProvince" code:@"D1.024" par:@"842/2522" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"1 กรกฎาคม 2522" url:@"D1.024-2522.PDF" date_no:@"ครั้งที่ 1" area:@"16477166.2528" area_rai:@"10206" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองแวงและป่าดงพญาเย็นแปลงที่สอง" provinceE:@"KrabiProvince" code:@"D1.030" par:@"984/2525" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"1 พฤศจิกายน 2525" url:@"D1.030-2525.PDF" date_no:@"ครั้งที่ 1" area:@"191300754.687" area_rai:@"119375" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าหินเหล็กไฟ" provinceE:@"KrabiProvince" code:@"D1.003" par:@"146/2509" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"22 พฤศจิกายน 2509" url:@"D1.003-2509.PDF" date_no:@"ครั้งที่ 1" area:@"95344475.8922" area_rai:@"59706" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าอ่างเก็บน้ำลำฉมวก" provinceE:@"KrabiProvince" code:@"D1.031" par:@"1090/2527" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"30 ธันวาคม 2527" url:@"D1.031-2527.PDF" date_no:@"ครั้งที่ 1" area:@"49426449.9777" area_rai:@"32187" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    NakhonRatchasimaProvince = [[ItemGuide alloc] initWithName:@"ป่าอ่างเก็บน้ำห้วยบ้านยาง" provinceE:@"KrabiProvince" code:@"D1.008" par:@"244/2510" type:@"ป่าสงวนแห่งชาติ" province:@"นครราชสีมา" date:@"28 พฤศจิกายน 2510" url:@"D1.008-2510.PDF" date_no:@"ครั้งที่ 1" area:@"31886095.9303" area_rai:@"20305" ]; [self.NakhonRatchasimaProvinces addObject:NakhonRatchasimaProvince];
    self.NakhonSiThammaratProvinces = [[NSMutableArray alloc] init];  ItemGuide *NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่ากรุงชิง" provinceE:@"KrabiProvince" code:@"S1.064" par:@"1057/2527" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"24 สิงหาคม 2527" url:@"S1.064-2527.PDF" date_no:@"ครั้งที่ 1" area:@"411987270.661" area_rai:@"259750" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าขอนไทรหัก" provinceE:@"KrabiProvince" code:@"S1.006" par:@"169/2509" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"31 ธันวาคม 2509" url:@"S1.006-2509.PDF" date_no:@"ครั้งที่ 1" area:@"24949733.2413" area_rai:@"15206" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเขากะทูน และป่าปลายกะเบียด" provinceE:@"KrabiProvince" code:@"S1.039" par:@"502/2515" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"12 ธันวาคม 2515" url:@"S1.039-2515.PDF" date_no:@"ครั้งที่ 1" area:@"271717211.964" area_rai:@"164375" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาขาว" provinceE:@"KrabiProvince" code:@"S1.068" par:@"1160/2529" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"5 มิถุนายน 2529" url:@"S1.068-2529.PDF" date_no:@"ครั้งที่ 1" area:@"26973651.8472" area_rai:@"16560" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาคอกวาง" provinceE:@"KrabiProvince" code:@"S1.030" par:@"416/2512" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"8 เมษายน 2512" url:@"S1.030-2512.PDF" date_no:@"ครั้งที่ 1" area:@"1055922.52904" area_rai:@"660" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเขานัน" provinceE:@"KrabiProvince" code:@"S1.005" par:@"168/2509" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"31 ธันวาคม 2509" url:@"S1.005-2509.PDF" date_no:@"ครั้งที่ 1" area:@"89792589.951" area_rai:@"59375" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาพระบาท" provinceE:@"KrabiProvince" code:@"S1.061" par:@"1043/2527" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"31 พฤษภาคม 2527" url:@"S1.061-2527.PDF" date_no:@"ครั้งที่ 1" area:@"2932254.91544" area_rai:@"1525" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาศูนย์" provinceE:@"KrabiProvince" code:@"S1.062" par:@"1045/2527" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"31 พฤษภาคม 2527" url:@"S1.062-2527.PDF" date_no:@"ครั้งที่ 1" area:@"6208964.81618" area_rai:@"3788" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาหลวง" provinceE:@"KrabiProvince" code:@"S1.051" par:@"733/5218" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"8 เมษายน 2518" url:@"S1.051-2518.PDF" date_no:@"ครั้งที่ 1" area:@"146650119.038" area_rai:@"91890" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาหัวช้าง" provinceE:@"KrabiProvince" code:@"S1.042" par:@"569/2516" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"25 กันยายน 2516" url:@"S1.042-2516.PDF" date_no:@"ครั้งที่ 1" area:@"8757104.44569" area_rai:@"5500" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาเหมน" provinceE:@"KrabiProvince" code:@"S1.065" par:@"1094/2527" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"30 ธันวาคม 2527" url:@"S1.065-2527.PDF" date_no:@"ครั้งที่ 1" area:@"35351532.1952" area_rai:@"21875" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาออก ป่าเขาท้องโหนด และป่าเขาชัยสน" provinceE:@"KrabiProvince" code:@"S1.054" par:@"875/2522" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"26 ธันวาคม 2522" url:@"S1.054-2522.PDF" date_no:@"ครั้งที่ 1" area:@"12179530.5658" area_rai:@"7500" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองกรุงหยัน" provinceE:@"KrabiProvince" code:@"S1.058" par:@"981/2525" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"16 กันยายน 2525" url:@"S1.058-2525.PDF" date_no:@"ครั้งที่ 1" area:@"141231796.64" area_rai:@"83750" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองค็อง" provinceE:@"KrabiProvince" code:@"S1.046" par:@"646/2517" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"19 มีนาคม 2517" url:@"S1.046-2517.PDF" date_no:@"ครั้งที่ 1" area:@"49350552.7449" area_rai:@"29949" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองเคียน" provinceE:@"KrabiProvince" code:@"S1.057" par:@"972/2525" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"27 เมษายน 2525" url:@"S1.057-2525.PDF" date_no:@"ครั้งที่ 1" area:@"8681563.79503" area_rai:@"5538" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองซ่อน" provinceE:@"KrabiProvince" code:@"S1.032" par:@"431/2514" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"27 กรกฎาคม 2514" url:@"S1.032-2514.PDF" date_no:@"ครั้งที่ 1" area:@"5703659.17557" area_rai:@"4212" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองธง" provinceE:@"KrabiProvince" code:@"S1.045" par:@"630/2516" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"25 ธันวาคม 2516" url:@"S1.045-2516.PDF" date_no:@"ครั้งที่ 1" area:@"93622948.9568" area_rai:@"61800" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองปากแพรก" provinceE:@"KrabiProvince" code:@"S1.036" par:@"453/2514" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"30 ธันวาคม 2514" url:@"S1.036-2514.PDF" date_no:@"ครั้งที่ 1" area:@"6670150.50208" area_rai:@"7300" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองเผียน" provinceE:@"KrabiProvince" code:@"S1.023" par:@"324/2511" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"30 กรกฎาคม 2511" url:@"S1.023-2511.PDF" date_no:@"ครั้งที่ 1" area:@"113858370.185" area_rai:@"69125" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองเพลง" provinceE:@"KrabiProvince" code:@"S1.063" par:@"1048/2527" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"31 พฤษภาคม 2527" url:@"S1.063-2527.PDF" date_no:@"ครั้งที่ 1" area:@"35780105.9849" area_rai:@"26250" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองสาย" provinceE:@"KrabiProvince" code:@"S1.017" par:@"312/2511" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"4 มิถุนายน 2511" url:@"S1.017-2511.PDF" date_no:@"ครั้งที่ 1" area:@"38967534.8542" area_rai:@"19687" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองเหลง" provinceE:@"KrabiProvince" code:@"S1.035" par:@"450/2514" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"30 ธันวาคม 2514" url:@"S1.035-2514.PDF" date_no:@"ครั้งที่ 1" area:@"46646319.147" area_rai:@"34281" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าควนแก้ว ป่าคลองตม และป่าทุ่งลานแซะ" provinceE:@"KrabiProvince" code:@"S1.034" par:@"449/2514" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"30 ธันวาคม 2514" url:@"S1.034-2514.PDF" date_no:@"ครั้งที่ 1" area:@"192099164.386" area_rai:@"116093" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าควนชก" provinceE:@"KrabiProvince" code:@"S1.066" par:@"1098/2528" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"2 พฤษภาคม 2528" url:@"S1.066-2528.PDF" date_no:@"ครั้งที่ 1" area:@"5836072.45436" area_rai:@"3621" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าควนพลอง" provinceE:@"KrabiProvince" code:@"S1.013" par:@"246/2510" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"28 พฤศจิกายน 2510" url:@"S1.013-2510.PDF" date_no:@"ครั้งที่ 1" area:@"4425687.69488" area_rai:@"2781" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าควนลำพู" provinceE:@"KrabiProvince" code:@"S1.059" par:@"1028/2526" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"31 ธันวาคม 2526" url:@"S1.059-2526.PDF" date_no:@"ครั้งที่ 1" area:@"193697.873586" area_rai:@"113" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าควนหนองพุฒ" provinceE:@"KrabiProvince" code:@"S1.004" par:@"74/2508" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"10 สิงหาคม 2508" url:@"S1.004-2508.PDF" date_no:@"ครั้งที่ 1" area:@"105866.490114" area_rai:@"62" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าควนหินราว" provinceE:@"KrabiProvince" code:@"S1.047" par:@"658/2517" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"10 พฤษภาคม 2517" url:@"S1.047-2517.PDF" date_no:@"ครั้งที่ 1" area:@"1855154.28851" area_rai:@"1712" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าควนออกบ้านน้ำตก" provinceE:@"KrabiProvince" code:@"S1.015" par:@"307/2511" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"28 พฤษภาคม 2511" url:@"S1.015-2511.PDF" date_no:@"ครั้งที่ 1" area:@"69735171.2187" area_rai:@"43750" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าช่องกะโสม ป่าวังญวน ป่าควนประ ป่าช่องเขา ป่าไร่ใหญ่ ป่าควนขี้แรด ป่าควนนกจาบ และป่าปากอ่าว" provinceE:@"KrabiProvince" code:@"S1.037" par:@"472/2515" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"7 พฤศจิกายน 2515" url:@"S1.037-2515.PDF" date_no:@"ครั้งที่ 1" area:@"109805271.909" area_rai:@"68437" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าช่องนกฮัง" provinceE:@"KrabiProvince" code:@"S1.010" par:@"188/2509" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"31 ธันวาคม 2509" url:@"S1.010-2509.PDF" date_no:@"ครั้งที่ 1" area:@"15022995.3548" area_rai:@"9478" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเชิงเขานา" provinceE:@"KrabiProvince" code:@"S1.033" par:@"434/2514" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"28 กันยายน 2514" url:@"S1.033-2514.PDF" date_no:@"ครั้งที่ 1" area:@"8025146.05289" area_rai:@"4998" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าดอนทราย และป่ากลอง" provinceE:@"KrabiProvince" code:@"S1.052" par:@"794/2521" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"2 พฤษภาคม 2521" url:@"S1.052-2521.PDF" date_no:@"ครั้งที่ 1" area:@"101337931.566" area_rai:@"52987.5" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าทรายคอเขา" provinceE:@"KrabiProvince" code:@"S1.026" par:@"350/2511" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"19 พฤศจิกายน 2511" url:@"S1.026-2511.PDF" date_no:@"ครั้งที่ 1" area:@"1628714.28911" area_rai:@"937" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าท่าช้างข้าม" provinceE:@"KrabiProvince" code:@"S1.050" par:@"683/2517" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"2 กรกฎาคม 2517" url:@"S1.050-2517.PDF" date_no:@"ครั้งที่ 1" area:@"44415195.1734" area_rai:@"28668" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งทับควาย" provinceE:@"KrabiProvince" code:@"S1.038" par:@"473/2515" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"7 พฤศจิกายน 2515" url:@"S1.038-2515.PDF" date_no:@"ครั้งที่ 1" area:@"7320989.44643" area_rai:@"4925" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งสัง และป่าปากเพรียง" provinceE:@"KrabiProvince" code:@"S1.009" par:@"185/2509" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"31 ธันวาคม 2509" url:@"S1.009-2509.PDF" date_no:@"ครั้งที่ 1" area:@"92857929.0006" area_rai:@"59891" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งหนองควาย" provinceE:@"KrabiProvince" code:@"S1.018" par:@"520/2515" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"30 ธันวาคม 2515" url:@"S1.018-2515.PDF" date_no:@"ครั้งที่ 2" area:@"26342103.0439" area_rai:@"16268" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำตกโยง" provinceE:@"KrabiProvince" code:@"S1.029" par:@"400/2512" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"25 กุมภาพันธ์ 2512" url:@"S1.029-2512.PDF" date_no:@"ครั้งที่ 1" area:@"38230612.9162" area_rai:@"39762" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านกุมแป ป่าบ้านในลุ่ม และป่าพรุควนเคร็ง" provinceE:@"KrabiProvince" code:@"S1.069" par:@"1180/2529" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"8 ธันวาคม 2529" url:@"S1.069-2529.PDF" date_no:@"ครั้งที่ 1" area:@"88001074.0902" area_rai:@"54221" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าปลายคลองวังหีบ" provinceE:@"KrabiProvince" code:@"S1.056" par:@"937/2524" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"1 มิถุนายน 2524" url:@"S1.056-2524.PDF" date_no:@"ครั้งที่ 1" area:@"82090212.4508" area_rai:@"50154" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าปลายคลองโอม" provinceE:@"KrabiProvince" code:@"S1.053" par:@"865/2522" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"1 ตุลาคม 2522" url:@"S1.053-2522.PDF" date_no:@"ครั้งที่ 1" area:@"7113271.30629" area_rai:@"4469" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าปลายรา" provinceE:@"KrabiProvince" code:@"S1.028" par:@"387/2511" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"1 ธันวาคม 2511" url:@"S1.028-2511.PDF" date_no:@"ครั้งที่ 1" area:@"68110949.9015" area_rai:@"37681" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าปลายแหลมตะลุมพุก" provinceE:@"KrabiProvince" code:@"S1.008" par:@"732/2518" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"8 เมษายน 2518" url:@"S1.008-2518.PDF" date_no:@"ครั้งที่ 2" area:@"558776.258554" area_rai:@"344" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าพรุพี" provinceE:@"KrabiProvince" code:@"S1.024" par:@"348/2511" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"19 พฤศจิกายน 2511" url:@"S1.024-2511.PDF" date_no:@"ครั้งที่ 1" area:@"50079099.4502" area_rai:@"25812" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าภูเขาหลวง" provinceE:@"KrabiProvince" code:@"S1.041" par:@"535/2516" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"10 กรกฎาคม 2516" url:@"S1.041-2516.PDF" date_no:@"ครั้งที่ 1" area:@"31735608.348" area_rai:@"20247" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่ายางงาม" provinceE:@"KrabiProvince" code:@"S1.021" par:@"316/2511" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"4 มิถุนายน 2511" url:@"S1.021-2511.PDF" date_no:@"ครั้งที่ 1" area:@"1814362.00363" area_rai:@"1143" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่ายางโพรง และป่าเขาใหญ่" provinceE:@"KrabiProvince" code:@"S1.040" par:@"533/2516" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"19 มิถุนายน 2516" url:@"S1.040-2516.PDF" date_no:@"ครั้งที่ 1" area:@"88047845.051" area_rai:@"60625" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนเขาแหลมทาบ" provinceE:@"KrabiProvince" code:@"S1.019" par:@"314/2511" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"4 มิถุนายน 2511" url:@"S1.019-2511.PDF" date_no:@"ครั้งที่ 1" area:@"1770424.59115" area_rai:@"1125" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองขนอม" provinceE:@"KrabiProvince" code:@"S1.025" par:@"349/2511" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"19 พฤศจิกายน 2511" url:@"S1.025-2511.PDF" date_no:@"ครั้งที่ 1" area:@"18223681.3099" area_rai:@"11275" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนปากน้ำ" provinceE:@"KrabiProvince" code:@"S1.016" par:@"308/2511" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"28 พฤษภาคม 2511" url:@"S1.016-2511.PDF" date_no:@"ครั้งที่ 1" area:@"7962451.0714" area_rai:@"3975" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนปากน้ำท่าหมาก" provinceE:@"KrabiProvince" code:@"S1.031" par:@"419/2512" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"27 พฤษภาคม 2512" url:@"S1.031-2512.PDF" date_no:@"ครั้งที่ 1" area:@"598421.48615" area_rai:@"268" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนปากน้ำสิชล" provinceE:@"KrabiProvince" code:@"S1.011" par:@"232/2510" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"24 ตุลาคม 2510" url:@"S1.011-2510.PDF" date_no:@"ครั้งที่ 1" area:@"1368026.8701" area_rai:@"962" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนปากพนังฝั่งตะวันตก" provinceE:@"KrabiProvince" code:@"S1.007" par:@"171/2509" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"31 ธันวาคม 2509" url:@"S1.007-2509.PDF" date_no:@"ครั้งที่ 1" area:@"13363050.2804" area_rai:@"8162" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนปากพนังฝั่งตะวันออก และป่าเลนเกาะไชย" provinceE:@"KrabiProvince" code:@"S1.003" par:@"63/2508" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"13 กรกฎาคม 2508" url:@"S1.003-2508.PDF" date_no:@"ครั้งที่ 1" area:@"50818982.6641" area_rai:@"35156" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนปากพยา-ปากนคร" provinceE:@"KrabiProvince" code:@"S1.001" par:@"0/2495" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"23 ธันวาคม 2495" url:@"S1.001-2495.PDF" date_no:@"ครั้งที่ 1" area:@"42762887.7121" area_rai:@"23575" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าวังใหญ่" provinceE:@"KrabiProvince" code:@"S1.049" par:@"674/2517" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"4 มิถุนายน 2517" url:@"S1.049-2517.PDF" date_no:@"ครั้งที่ 1" area:@"475167.736582" area_rai:@"387" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าวังอีคุย" provinceE:@"KrabiProvince" code:@"S1.002" par:@"204/2507" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"10 มีนาคม 2507" url:@"S1.002-2507.PDF" date_no:@"ครั้งที่ 1" area:@"671274.648993" area_rai:@"243.75" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าใสโตน และป่าในตาก" provinceE:@"KrabiProvince" code:@"S1.014" par:@"263/2510" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"26 ธันวาคม 2510" url:@"S1.014-2510.PDF" date_no:@"ครั้งที่ 1" area:@"5640809.06343" area_rai:@"2712" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าไสเกาะธง" provinceE:@"KrabiProvince" code:@"S1.020" par:@"315/2511" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"4 มิถุนายน 2511" url:@"S1.020-2511.PDF" date_no:@"ครั้งที่ 1" area:@"789076.744124" area_rai:@"493" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าไสค่าย" provinceE:@"KrabiProvince" code:@"S1.060" par:@"1042/2527" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"31 พฤษภาคม 2527" url:@"S1.060-2527.PDF" date_no:@"ครั้งที่ 1" area:@"4897920.21103" area_rai:@"3800" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองคล้า" provinceE:@"KrabiProvince" code:@"S1.048" par:@"667/2517" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"10 พฤษภาคม 2517" url:@"S1.048-2517.PDF" date_no:@"ครั้งที่ 1" area:@"2638727.92153" area_rai:@"1762" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองหงส์ และป่าควนกรด" provinceE:@"KrabiProvince" code:@"S1.043" par:@"585/2516" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"6 พฤศจิกายน 2516" url:@"S1.043-2516.PDF" date_no:@"ครั้งที่ 1" area:@"3826398.12352" area_rai:@"2556" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองหว้า" provinceE:@"KrabiProvince" code:@"S1.055" par:@"880/2523" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"5 มีนาคม 2523" url:@"S1.055-2523.PDF" date_no:@"ครั้งที่ 1" area:@"2603657.33696" area_rai:@"1438" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าหน้าไซ ป่าควนขาวเครา และป่าควนประ" provinceE:@"KrabiProvince" code:@"S1.044" par:@"590/2516" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"6 พฤศจิกายน 2516" url:@"S1.044-2516.PDF" date_no:@"ครั้งที่ 1" area:@"110238069.279" area_rai:@"67187" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าหน้าไซ และป่านาปู" provinceE:@"KrabiProvince" code:@"S1.067" par:@"1099/2528" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"2 พฤษภาคม 2528" url:@"S1.067-2528.PDF" date_no:@"ครั้งที่ 1" area:@"45570186.0119" area_rai:@"25572" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยกองเสา" provinceE:@"KrabiProvince" code:@"S1.027" par:@"365/2511" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"26 พฤศจิกายน 2511" url:@"S1.027-2511.PDF" date_no:@"ครั้งที่ 1" area:@"12526194.5605" area_rai:@"8212" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยเหรียง" provinceE:@"KrabiProvince" code:@"S1.012" par:@"245/2510" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"28 พฤศจิกายน 2510" url:@"S1.012-2510.PDF" date_no:@"ครั้งที่ 1" area:@"4028197.94908" area_rai:@"3156" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    NakhonSiThammaratProvince = [[ItemGuide alloc] initWithName:@"ป่าอ่าวกราย" provinceE:@"KrabiProvince" code:@"S1.022" par:@"323/2511" type:@"ป่าสงวนแห่งชาติ" province:@"นครศรีธรรมราช" date:@"30 กรกฎาคม 2511" url:@"S1.022-2511.PDF" date_no:@"ครั้งที่ 1" area:@"37005372.1544" area_rai:@"23562" ]; [self.NakhonSiThammaratProvinces addObject:NakhonSiThammaratProvince];
    self.NakhonSawanProvinces = [[NSMutableArray alloc] init];  ItemGuide *NakhonSawanProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาคอก ป่าเขาโลมนาง และป่าเขาสอยดาว" provinceE:@"KrabiProvince" code:@"O1.008" par:@"1013/2526" type:@"ป่าสงวนแห่งชาติ" province:@"นครสวรรค์" date:@"30 กันยายน 2526" url:@"O1.008-2526.PDF" date_no:@"ครั้งที่ 1" area:@"173669743.401" area_rai:@"105600" ]; [self.NakhonSawanProvinces addObject:NakhonSawanProvince];
    NakhonSawanProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาสนามชัย" provinceE:@"KrabiProvince" code:@"O1.005" par:@"159/2506" type:@"ป่าสงวนแห่งชาติ" province:@"นครสวรรค์" date:@"26 กุมภาพันธ์ 2506" url:@"O1.005-2506.PDF" date_no:@"ครั้งที่ 1" area:@"17691929.683" area_rai:@"10856.25" ]; [self.NakhonSawanProvinces addObject:NakhonSawanProvince];
    NakhonSawanProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาสูงและป่าเขาพระ" provinceE:@"KrabiProvince" code:@"O1.007" par:@"1239/2538" type:@"ป่าสงวนแห่งชาติ" province:@"นครสวรรค์" date:@"28 พฤศจิกายน 2538" url:@"O1.007-2538.PDF" date_no:@"ครั้งที่ 3" area:@"106454008.659" area_rai:@"65800" ]; [self.NakhonSawanProvinces addObject:NakhonSawanProvince];
    NakhonSawanProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาหลวง" provinceE:@"KrabiProvince" code:@"O1.006" par:@"703/2517" type:@"ป่าสงวนแห่งชาติ" province:@"นครสวรรค์" date:@"27 สิงหาคม 2517" url:@"O1.006-2517.PDF" date_no:@"ครั้งที่ 1" area:@"61646591.7828" area_rai:@"55312" ]; [self.NakhonSawanProvinces addObject:NakhonSawanProvince];
    NakhonSawanProvince = [[ItemGuide alloc] initWithName:@"ป่าดงยางห้วยพลับ" provinceE:@"KrabiProvince" code:@"O1.002" par:@"19/2501" type:@"ป่าสงวนแห่งชาติ" province:@"นครสวรรค์" date:@"29 เมษายน 2501" url:@"O1.002-2501.PDF" date_no:@"ครั้งที่ 1" area:@"1442766.71895" area_rai:@"1000" ]; [self.NakhonSawanProvinces addObject:NakhonSawanProvince];
    NakhonSawanProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่วงก์ - แม่เปิน" provinceE:@"KrabiProvince" code:@"O1.001" par:@"12/2501" type:@"ป่าสงวนแห่งชาติ" province:@"นครสวรรค์" date:@"29 เมษายน 2501" url:@"O1.001-2501.PDF" date_no:@"ครั้งที่ 1" area:@"1576319406.68" area_rai:@"1080725" ]; [self.NakhonSawanProvinces addObject:NakhonSawanProvince];
    self.NarathiwatProvinces = [[NSMutableArray alloc] init];  ItemGuide *NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่ากะลุบี" provinceE:@"KrabiProvince" code:@"U3.003" par:@"101/2505" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"24 กรกฎาคม 2505" url:@"U3.003-2505.PDF" date_no:@"ครั้งที่ 1" area:@"4400408.73052" area_rai:@"2043.75" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาตันหยง" provinceE:@"KrabiProvince" code:@"U3.017" par:@"673/2517" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"4 มิถุนายน 2517" url:@"U3.017-2517.PDF" date_no:@"ครั้งที่ 1" area:@"3874822.1027" area_rai:@"2687" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาสำนัก" provinceE:@"KrabiProvince" code:@"U3.014" par:@"810/2521" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"3 ตุลาคม 2521" url:@"U3.014-2521.PDF" date_no:@"ครั้งที่ 2" area:@"2519086.73558" area_rai:@"1250" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกจะโก" provinceE:@"KrabiProvince" code:@"U3.016" par:@"1022/2526" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"6 ธันวาคม 2526" url:@"U3.016-2526.PDF" date_no:@"ครั้งที่ 2" area:@"9724992.62272" area_rai:@"6415" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกไม้เรือ" provinceE:@"KrabiProvince" code:@"U3.015" par:@"438/2514" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"23 พฤศจิกายน 2514" url:@"U3.015-2514.PDF" date_no:@"ครั้งที่ 1" area:@"20170727.2326" area_rai:@"16481" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขากรือซอ" provinceE:@"KrabiProvince" code:@"U3.018" par:@"801/2521" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"8 กรกฎาคม 2521" url:@"U3.018-2521.PDF" date_no:@"ครั้งที่ 1" area:@"11231367.3608" area_rai:@"8750" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาบาลา" provinceE:@"KrabiProvince" code:@"U3.005" par:@"26/2507" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"31 ธันวาคม 2507" url:@"U3.005-2507.PDF" date_no:@"ครั้งที่ 1" area:@"174125797.5" area_rai:@"105625" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขารือเสาะ ป่ายี่งอ และป่าบาเจาะ" provinceE:@"KrabiProvince" code:@"U3.009" par:@"38/2508" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"9 มีนาคม 2508" url:@"U3.009-2508.PDF" date_no:@"ครั้งที่ 1" area:@"117733221.943" area_rai:@"85312" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าบองอ" provinceE:@"KrabiProvince" code:@"U3.013" par:@"377/2511" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"28 พฤศจิกายน 2511" url:@"U3.013-2511.PDF" date_no:@"ครั้งที่ 1" area:@"71881135.1168" area_rai:@"58750" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าบูเก๊ะตามง" provinceE:@"KrabiProvince" code:@"U3.007" par:@"29/2507" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"31 ธันวาคม 2507" url:@"U3.007-2507.PDF" date_no:@"ครั้งที่ 1" area:@"11753401.8216" area_rai:@"8681" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าบูเก๊ะตาเว แปลงที่ 1" provinceE:@"KrabiProvince" code:@"U3.011" par:@"159/2509" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"27 ธันวาคม 2509" url:@"U3.011-2509.PDF" date_no:@"ครั้งที่ 1" area:@"50710879.5479" area_rai:@"31631" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าบูเก๊ะตาเว แปลงที่ 2" provinceE:@"KrabiProvince" code:@"U3.010" par:@"89//2508" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"16 พฤศจิกายน 2508" url:@"U3.010-2508.PDF" date_no:@"ครั้งที่ 1" area:@"27127137.4244" area_rai:@"19618" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าบูงอ" provinceE:@"KrabiProvince" code:@"U3.020" par:@"1164/2529" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"5 มิถุนายน 2529" url:@"U3.020-2529.PDF" date_no:@"ครั้งที่ 1" area:@"953018.7016" area_rai:@"603" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าปรินยอฝั่งซ้ายแม่น้ำสายบุรีแปลงที่1" provinceE:@"KrabiProvince" code:@"U3.002" par:@"67/2502" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"26 เมษายน 2503" url:@"U3.002-2503.PDF" date_no:@"ครั้งที่ 1" area:@"225399052.258" area_rai:@"125000" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าฝั่งขวาแม่น้ำสายบุรี" provinceE:@"KrabiProvince" code:@"U3.021" par:@"1226/2532" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"15 มกราคม 2533" url:@"U3.021-2533.PDF" date_no:@"ครั้งที่ 1" area:@"13382638.5447" area_rai:@"8125" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าลุ่มน้ำบางนรา แปลงที่ 1" provinceE:@"KrabiProvince" code:@"U3.006" par:@"20/2507" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"31 ธันวาคม 2507" url:@"U3.006-2507.PDF" date_no:@"ครั้งที่ 1" area:@"51365913.9675" area_rai:@"19100" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าลุ่มน้ำบางนรา แปลงที่ 2" provinceE:@"KrabiProvince" code:@"U3.008" par:@"34/2507" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"31 ธันวาคม 2507" url:@"U3.008-2507.PDF" date_no:@"ครั้งที่ 1" area:@"233325847.769" area_rai:@"178850" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าลูโบ๊ะลาเซาะ" provinceE:@"KrabiProvince" code:@"U3.019" par:@"917/2523" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"30 ธันวาคม 2523" url:@"U3.019-2523.PDF" date_no:@"ครั้งที่ 1" area:@"21308918.6309" area_rai:@"13125" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าอุแตแค" provinceE:@"KrabiProvince" code:@"U3.012" par:@"173/2509" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"31 ธันวาคม 2509" url:@"U3.012-2509.PDF" date_no:@"ครั้งที่ 1" area:@"4689394.49461" area_rai:@"3015" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    NarathiwatProvince = [[ItemGuide alloc] initWithName:@"ป่าไอยสะเตียร์" provinceE:@"KrabiProvince" code:@"U3.001" par:@"0/2494" type:@"ป่าสงวนแห่งชาติ" province:@"นราธิวาส" date:@"20 พฤศจิกายน 2494" url:@"U3.001-2494.PDF" date_no:@"ครั้งที่ 1" area:@"1070047.90397" area_rai:@"585" ]; [self.NarathiwatProvinces addObject:NarathiwatProvince];
    self.NanProvinces = [[NSMutableArray alloc] init];  ItemGuide *NanProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาน้อย" provinceE:@"KrabiProvince" code:@"H2.001" par:@"59/2502" type:@"ป่าสงวนแห่งชาติ" province:@"น่าน" date:@"8 ธันวาคม 2502" url:@"H2.001-2502.PDF" date_no:@"ครั้งที่ 1" area:@"1762902.6733" area_rai:@"1125" ]; [self.NanProvinces addObject:NanProvince];
    NanProvince = [[ItemGuide alloc] initWithName:@"ป่าดอยภูคาและป่าผาแดง" provinceE:@"KrabiProvince" code:@"H2.016" par:@"1217/2531" type:@"ป่าสงวนแห่งชาติ" province:@"น่าน" date:@"23 กุมภาพันธ์ 2531" url:@"H2.016-2531.PDF" date_no:@"ครั้งที่ 1" area:@"2522274916.45" area_rai:@"1565312" ]; [self.NanProvinces addObject:NanProvince];
    NanProvince = [[ItemGuide alloc] initWithName:@"ป่าถ้ำผาตูบ" provinceE:@"KrabiProvince" code:@"H2.003" par:@"212/2507" type:@"ป่าสงวนแห่งชาติ" province:@"น่าน" date:@"23 เมษายน 2507" url:@"H2.003-2507.PDF" date_no:@"ครั้งที่ 1" area:@"22552215.1113" area_rai:@"11875" ]; [self.NanProvinces addObject:NanProvince];
    NanProvince = [[ItemGuide alloc] initWithName:@"ป่านาซาว" provinceE:@"KrabiProvince" code:@"H2.005" par:@"343/2511" type:@"ป่าสงวนแห่งชาติ" province:@"น่าน" date:@"12 พฤศจิกายน 2511" url:@"H2.005-2511.PDF" date_no:@"ครั้งที่ 1" area:@"62775417.9335" area_rai:@"38593" ]; [self.NanProvinces addObject:NanProvince];
    NanProvince = [[ItemGuide alloc] initWithName:@"ป่านาซาวฝั่งซ้าย ถนนสายแพร่-น่าน" provinceE:@"KrabiProvince" code:@"H2.004" par:@"13/2507" type:@"ป่าสงวนแห่งชาติ" province:@"น่าน" date:@"31 ธันวาคม 2507" url:@"H2.004-2507.PDF" date_no:@"ครั้งที่ 1" area:@"107667406.678" area_rai:@"70625" ]; [self.NanProvinces addObject:NanProvince];
    NanProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำยาว และป่าน้ำสวด" provinceE:@"KrabiProvince" code:@"H2.015" par:@"1220/2531" type:@"ป่าสงวนแห่งชาติ" province:@"น่าน" date:@"9 มีนาคม 2531" url:@"H2.015-2531.PDF" date_no:@"ครั้งที่ 1" area:@"2447076954.13" area_rai:@"1477500" ]; [self.NanProvinces addObject:NanProvince];
    NanProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำว้าและป่าแม่จริม" provinceE:@"KrabiProvince" code:@"H2.009" par:@"1133/2528" type:@"ป่าสงวนแห่งชาติ" province:@"น่าน" date:@"27 พฤศจิกายน 2528" url:@"H2.009-2528.PDF" date_no:@"ครั้งที่ 1" area:@"750039571.383" area_rai:@"465375" ]; [self.NanProvinces addObject:NanProvince];
    NanProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำว้าและป่าห้วยสาลี่" provinceE:@"KrabiProvince" code:@"H2.010" par:@"1134/2528" type:@"ป่าสงวนแห่งชาติ" province:@"น่าน" date:@"27 พฤศจิกายน 2528" url:@"H2.010-2528.PDF" date_no:@"ครั้งที่ 1" area:@"701326808.965" area_rai:@"429688" ]; [self.NanProvinces addObject:NanProvince];
    NanProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำสา และป่าแม่สาครฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"H2.006" par:@"541/2516" type:@"ป่าสงวนแห่งชาติ" province:@"น่าน" date:@"17 กรกฎาคม 2516" url:@"H2.006-2516.PDF" date_no:@"ครั้งที่ 1" area:@"199277559.463" area_rai:@"120000" ]; [self.NanProvinces addObject:NanProvince];
    NanProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำสาฝั่งขวาตอนขุน" provinceE:@"KrabiProvince" code:@"H2.012" par:@"1188/2529" type:@"ป่าสงวนแห่งชาติ" province:@"น่าน" date:@"8 ธันวาคม 2529" url:@"H2.012-2529.PDF" date_no:@"ครั้งที่ 1" area:@"215811226.958" area_rai:@"123308" ]; [self.NanProvinces addObject:NanProvince];
    NanProvince = [[ItemGuide alloc] initWithName:@"ป่าฝั่งขวาแม่น้ำน่านตอนใต้" provinceE:@"KrabiProvince" code:@"H2.013" par:@"1212/2530" type:@"ป่าสงวนแห่งชาติ" province:@"น่าน" date:@"2 ธันวาคม 2530" url:@"H2.013-Plus.PDF" date_no:@"ครั้งที่ 1" area:@"1645798607.24" area_rai:@"1009609" ]; [self.NanProvinces addObject:NanProvince];
    NanProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่น้ำน่านฝั่งตะวันออกตอนใต้" provinceE:@"KrabiProvince" code:@"H2.014" par:@"1214/2530" type:@"ป่าสงวนแห่งชาติ" province:@"น่าน" date:@"16 ธันวาคม 2530" url:@"H2.014-2530.PDF" date_no:@"ครั้งที่ 1" area:@"928997942.602" area_rai:@"582688" ]; [self.NanProvinces addObject:NanProvince];
    NanProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่สาครฝั่งขวา" provinceE:@"KrabiProvince" code:@"H2.007" par:@"999/2526" type:@"ป่าสงวนแห่งชาติ" province:@"น่าน" date:@"24 มีนาคม 2526" url:@"H2.007-2526.PDF" date_no:@"ครั้งที่ 1" area:@"78836158.229" area_rai:@"49015.62" ]; [self.NanProvinces addObject:NanProvince];
    NanProvince = [[ItemGuide alloc] initWithName:@"ป่าสาลีก" provinceE:@"KrabiProvince" code:@"H2.002" par:@"1100/2528" type:@"ป่าสงวนแห่งชาติ" province:@"น่าน" date:@"2 พฤษภาคม 2528" url:@"H2.002-2528.PDF" date_no:@"ครั้งที่ 2" area:@"117242806.476" area_rai:@"63285" ]; [self.NanProvinces addObject:NanProvince];
    NanProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยงวงและป่าห้วยสาลี่" provinceE:@"KrabiProvince" code:@"H2.011" par:@"1147/2528" type:@"ป่าสงวนแห่งชาติ" province:@"น่าน" date:@"30 ธันวาคม 2528" url:@"H2.011-2528.PDF" date_no:@"ครั้งที่ 1" area:@"454650986.265" area_rai:@"360625" ]; [self.NanProvinces addObject:NanProvince];
    NanProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยแม่ขะนิง" provinceE:@"KrabiProvince" code:@"H2.008" par:@"1003/2526" type:@"ป่าสงวนแห่งชาติ" province:@"น่าน" date:@"15 กรกฎาคม 2526" url:@"H2.008-2526.PDF" date_no:@"ครั้งที่ 1" area:@"347581750.449" area_rai:@"128608" ]; [self.NanProvinces addObject:NanProvince];
    self.BuriramProvinces = [[NSMutableArray alloc] init];  ItemGuide *BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาคอก" provinceE:@"KrabiProvince" code:@"D3.004" par:@"149/2505" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"25 ธันวาคม 2505" url:@"D3.004-2505.PDF" date_no:@"ครั้งที่ 1" area:@"94627031.4192" area_rai:@"57750" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาพนมรุ้ง" provinceE:@"KrabiProvince" code:@"D3.009" par:@"210/2510" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"1 กันยายน 2510" url:@"D3.009-2510.PDF" date_no:@"ครั้งที่ 1" area:@"15660477.1777" area_rai:@"10256" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาอังคาร" provinceE:@"KrabiProvince" code:@"D3.012" par:@"383/2511" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"1 ธันวาคม 2511" url:@"D3.012-2511.PDF" date_no:@"ครั้งที่ 1" area:@"43009130.0039" area_rai:@"27681" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกงอย ป่าหนองตะคร้อ และป่าหนองย่างหมู" provinceE:@"KrabiProvince" code:@"D3.018" par:@"850/2522" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"1 กรกฎาคม 2522" url:@"D3.018-2522.PDF" date_no:@"ครั้งที่ 1" area:@"44933324.0193" area_rai:@"27831" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกโจด" provinceE:@"KrabiProvince" code:@"D3.003" par:@"145/2505" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"18 ธันวาคม 2505" url:@"D3.003-2505.PDF" date_no:@"ครั้งที่ 1" area:@"28834580.4905" area_rai:@"15606.25" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกโจด แปลงที่สอง" provinceE:@"KrabiProvince" code:@"D3.020" par:@"960/2524" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"1 พฤศจิกายน 2524" url:@"D3.020-2524.PDF" date_no:@"ครั้งที่ 1" area:@"17498025.5224" area_rai:@"10156" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกซาดและป่าหนองแสง" provinceE:@"KrabiProvince" code:@"D3.011" par:@"370/2511" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"27 พฤศจิกายน 2511" url:@"D3.011-2511.PDF" date_no:@"ครั้งที่ 1" area:@"9973621.63176" area_rai:@"6275" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกใหญ่ ป่าหนองพระสรวล และป่าหนองหมี" provinceE:@"KrabiProvince" code:@"D3.008" par:@"192/2510" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"25 เมษายน 2510" url:@"D3.008-2510.PDF" date_no:@"ครั้งที่ 1" area:@"73373909.5767" area_rai:@"45850" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าดงเค็ง" provinceE:@"KrabiProvince" code:@"D3.021" par:@"1192/2529" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"31 ธันวาคม 2529" url:@"D3.021-2529.PDF" date_no:@"ครั้งที่ 1" area:@"34418194.9147" area_rai:@"21094" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าดงพลอง" provinceE:@"KrabiProvince" code:@"D3.002" par:@"81/2504" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"12 ธันวาคม 2504" url:@"D3.002-2504.PDF" date_no:@"ครั้งที่ 1" area:@"66740974.7904" area_rai:@"38668.75" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าดงใหญ่" provinceE:@"KrabiProvince" code:@"D3.001" par:@"58/2502" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"8 ธันวาคม 2502" url:@"D3.001-2502.PDF" date_no:@"ครั้งที่ 1" area:@"909722587.537" area_rai:@"631250" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าโนนแดง และป่าโคกกระเดื่อง" provinceE:@"KrabiProvince" code:@"D3.019" par:@"941/2524" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"23 กรกฎาคม 2524" url:@"D3.019-2524.PDF" date_no:@"ครั้งที่ 1" area:@"33089071.9421" area_rai:@"20228" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านกรวด แปลงที่ห้า" provinceE:@"KrabiProvince" code:@"D3.016" par:@"661/2517" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"10 พฤษภาคม 2517" url:@"D3.016-2517.PDF" date_no:@"ครั้งที่ 1" area:@"276710285.363" area_rai:@"167993" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านบัวถนน" provinceE:@"KrabiProvince" code:@"D3.015" par:@"651/2517" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"10 พฤษภาคม 2517" url:@"D3.015-2517.PDF" date_no:@"ครั้งที่ 1" area:@"16942924.6721" area_rai:@"18476" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าปรีธม" provinceE:@"KrabiProvince" code:@"D3.013" par:@"513/2515" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"30 ธันวาคม 2515" url:@"D3.013-2515.PDF" date_no:@"ครั้งที่ 1" area:@"58993817.4942" area_rai:@"31906" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าเมืองไผ่" provinceE:@"KrabiProvince" code:@"D3.010" par:@"369/2511" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"27 พฤศจิกายน 2511" url:@"D3.010-2511.PDF" date_no:@"ครั้งที่ 1" area:@"624126885.558" area_rai:@"410156" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่ารอบอ่างเก็บน้ำห้วยจระเข้มาก" provinceE:@"KrabiProvince" code:@"D3.022" par:@"1207/2530" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"24 สิงหาคม 2530" url:@"D3.022-2530.PDF" date_no:@"ครั้งที่ 1" area:@"35626511.0469" area_rai:@"21780" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าริมฝั่งชี" provinceE:@"KrabiProvince" code:@"D3.014" par:@"642/2517" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"12 มีนาคม 2517" url:@"D3.014-2517.PDF" date_no:@"ครั้งที่ 1" area:@"61154225.4197" area_rai:@"36550" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าละเวี้ย และป่าหนองน้ำขุ่น" provinceE:@"KrabiProvince" code:@"D3.017" par:@"804/2521" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"8 กรกฎาคม 2521" url:@"D3.017-2521.PDF" date_no:@"ครั้งที่ 1" area:@"84544088.7255" area_rai:@"58750" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าละหานทราย" provinceE:@"KrabiProvince" code:@"D3.007" par:@"116/2509" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"28 มิถุนายน 2509" url:@"D3.007-2509.PDF" date_no:@"ครั้งที่ 1" area:@"88287762.8156" area_rai:@"54375" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองก้านงา ป่าโคกหนองเต็งและป่าโคกหิน" provinceE:@"KrabiProvince" code:@"D3.006" par:@"81/2508" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"19 ตุลาคม 2508" url:@"D3.006-2508.PDF" date_no:@"ครั้งที่ 1" area:@"55852381.9469" area_rai:@"35000" ]; [self.BuriramProvinces addObject:BuriramProvince];
    BuriramProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองข่า" provinceE:@"KrabiProvince" code:@"D3.005" par:@"170/2506" type:@"ป่าสงวนแห่งชาติ" province:@"บุรีรัมย์" date:@"13 สิงหาคม 2506" url:@"D3.005-2506.PDF" date_no:@"ครั้งที่ 1" area:@"3810211.62731" area_rai:@"2437.5" ]; [self.BuriramProvinces addObject:BuriramProvince];
    self.PrachuapKhiriKhanProvinces = [[NSMutableArray alloc] init];  ItemGuide *PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่ากลางอ่าว" provinceE:@"KrabiProvince" code:@"Q2.001" par:@"0/2492" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"16 สิงหาคม 2492" url:@"Q2.001-2492.PDF" date_no:@"ครั้งที่ 1" area:@"2144576.12944" area_rai:@"1200" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่ากุยบุรี" provinceE:@"KrabiProvince" code:@"Q2.012" par:@"325/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"30 กรกฎาคม 2511" url:@"Q2.012-2511.PDF" date_no:@"ครั้งที่ 1" area:@"1492894053.8" area_rai:@"915625" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่าเขากลอย" provinceE:@"KrabiProvince" code:@"Q2.002" par:@"15/2501" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"29 เมษายน 2501" url:@"Q2.002-2501.PDF" date_no:@"ครั้งที่ 1" area:@"8053755.66738" area_rai:@"5050" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาเขียว" provinceE:@"KrabiProvince" code:@"Q2.017" par:@"1084/2527" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"6 ธันวาคม 2527" url:@"Q2.017-2527.PDF" date_no:@"ครั้งที่ 1" area:@"7504690.15112" area_rai:@"3663" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาไชยราช และป่าคลองกรูด" provinceE:@"KrabiProvince" code:@"Q2.008" par:@"28/2507" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"31 ธันวาคม 2507" url:@"Q2.008-2507.PDF" date_no:@"ครั้งที่ 1" area:@"865822864.198" area_rai:@"539500" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาตาม่องล่าย" provinceE:@"KrabiProvince" code:@"Q2.014" par:@"670/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"28 พฤษภาคม 2517" url:@"Q2.014-2517.PDF" date_no:@"ครั้งที่ 1" area:@"1321022.83606" area_rai:@"862" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาถ้ำพยอม" provinceE:@"KrabiProvince" code:@"Q2.016" par:@"1076/2527" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"8 พฤศจิกายน 2527" url:@"Q2.016-2527.PDF" date_no:@"ครั้งที่ 1" area:@"3672007.38721" area_rai:@"2056" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาทุ่งมะเม่า" provinceE:@"KrabiProvince" code:@"Q2.015" par:@"923/2523" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"30 ธันวาคม 2523" url:@"Q2.015-2523.PDF" date_no:@"ครั้งที่ 1" area:@"4008571.78706" area_rai:@"2525" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาน้อย" provinceE:@"KrabiProvince" code:@"Q2.019" par:@"1113/2528" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"19 มิถุนายน 2528" url:@"Q2.019-2528.PDF" date_no:@"ครั้งที่ 1" area:@"2065975.92389" area_rai:@"1183" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาน้อยห้วยตามา" provinceE:@"KrabiProvince" code:@"Q2.020" par:@"1125/2528" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"27 พฤศจิกายน 2528" url:@"Q2.020-2528.PDF" date_no:@"ครั้งที่ 1" area:@"2376377.64412" area_rai:@"1455" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาสีเสียด" provinceE:@"KrabiProvince" code:@"Q2.013" par:@"648/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"1 เมษายน 2517" url:@"Q2.013-2517.PDF" date_no:@"ครั้งที่ 1" area:@"635695.562566" area_rai:@"237" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองเก่า และป่าคลองคอย" provinceE:@"KrabiProvince" code:@"Q2.010" par:@"222/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"5 กันยายน 2510" url:@"Q2.010-2510.PDF" date_no:@"ครั้งที่ 1" area:@"2998090.92911" area_rai:@"1984" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองแม่รำพึง" provinceE:@"KrabiProvince" code:@"Q2.009" par:@"165/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"31 ธันวาคม 2509" url:@"Q2.009-2509.PDF" date_no:@"ครั้งที่ 1" area:@"7036252.95607" area_rai:@"4550" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองวาฬ" provinceE:@"KrabiProvince" code:@"Q2.011" par:@"300/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"28 พฤษภาคม 2511" url:@"Q2.011-2511.PDF" date_no:@"ครั้งที่ 1" area:@"1225232.40618" area_rai:@"787" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่าดอนเต็งรัง" provinceE:@"KrabiProvince" code:@"Q2.006" par:@"11/2507" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"31 ธันวาคม 2507" url:@"Q2.006-2507.PDF" date_no:@"ครั้งที่ 1" area:@"1333152.53173" area_rai:@"818" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่าทับสะแก" provinceE:@"KrabiProvince" code:@"Q2.007" par:@"19/2507" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"31 ธันวาคม 2507" url:@"Q2.007-2507.PDF" date_no:@"ครั้งที่ 1" area:@"320327180.079" area_rai:@"200750" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งกระต่ายขัง" provinceE:@"KrabiProvince" code:@"Q2.021" par:@"1141/2528" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"27 พฤศจิกายน 2528" url:@"Q2.021-2528.PDF" date_no:@"ครั้งที่ 1" area:@"1767337.46942" area_rai:@"1110" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่าพุน้ำเค็ม" provinceE:@"KrabiProvince" code:@"Q2.005" par:@"181/2506" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"10 กันยายน 2506" url:@"Q2.005-2506.PDF" date_no:@"ครั้งที่ 1" area:@"106358298.196" area_rai:@"61162.5" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนบางปู" provinceE:@"KrabiProvince" code:@"Q2.018" par:@"1112/2528" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"19 มิถุนายน 2528" url:@"Q2.018-2528.PDF" date_no:@"ครั้งที่ 1" area:@"940380.864274" area_rai:@"550" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    PrachuapKhiriKhanProvince = [[ItemGuide alloc] initWithName:@"ป่าวังด้วน และป่าห้วยยาง" provinceE:@"KrabiProvince" code:@"Q2.004" par:@"769/2518" type:@"ป่าสงวนแห่งชาติ" province:@"ประจวบคีรีขันธ์" date:@"9 ธันวาคม 2518" url:@"Q2.004-2518.PDF" date_no:@"ครั้งที่ 2" area:@"23113927.6791" area_rai:@"13490" ]; [self.PrachuapKhiriKhanProvinces addObject:PrachuapKhiriKhanProvince];
    self.PrachinburiProvinces = [[NSMutableArray alloc] init];  ItemGuide *PrachinburiProvince = [[ItemGuide alloc] initWithName:@"ป่าแก่งดินสอ ป่าแก่งใหญ่ และป่าเขาสะโตน" provinceE:@"KrabiProvince" code:@"C1.004" par:@"895/2523" type:@"ป่าสงวนแห่งชาติ" province:@"ปราจีนบุรี" date:@"1 พฤศจิกายน 2523" url:@"C1.004-2523.PDF" date_no:@"ครั้งที่ 3" area:@"1070765659.11" area_rai:@"705109" ]; [self.PrachinburiProvinces addObject:PrachinburiProvince];
    PrachinburiProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งโพธิ์" provinceE:@"KrabiProvince" code:@"C1.009" par:@"912/2523" type:@"ป่าสงวนแห่งชาติ" province:@"ปราจีนบุรี" date:@"30 ธันวาคม 2523" url:@"C1.009-2523.PDF" date_no:@"ครั้งที่ 1" area:@"27199413.996" area_rai:@"19350" ]; [self.PrachinburiProvinces addObject:PrachinburiProvince];
    PrachinburiProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำตกเขาอีโต้" provinceE:@"KrabiProvince" code:@"C1.010" par:@"1002/2526" type:@"ป่าสงวนแห่งชาติ" province:@"ปราจีนบุรี" date:@"15 กรกฎาคม 2526" url:@"C1.010-2526.PDF" date_no:@"ครั้งที่ 1" area:@"18370076.0163" area_rai:@"13593" ]; [self.PrachinburiProvinces addObject:PrachinburiProvince];
    PrachinburiProvince = [[ItemGuide alloc] initWithName:@"ป่าประดู่-วังตะเคียน" provinceE:@"KrabiProvince" code:@"C1.001" par:@"0/2496" type:@"ป่าสงวนแห่งชาติ" province:@"ปราจีนบุรี" date:@"29 กันยายน 2496" url:@"C1.001-2496.PDF" date_no:@"ครั้งที่ 1" area:@"1786330.93645" area_rai:@"987" ]; [self.PrachinburiProvinces addObject:PrachinburiProvince];
    PrachinburiProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยไคร้" provinceE:@"KrabiProvince" code:@"C1.007" par:@"373/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ปราจีนบุรี" date:@"27 พฤศจิกายน 2511" url:@"C1.007-2511.PDF" date_no:@"ครั้งที่ 1" area:@"526388286.166" area_rai:@"466300" ]; [self.PrachinburiProvinces addObject:PrachinburiProvince];
    self.PattaniProvinces = [[NSMutableArray alloc] init];  ItemGuide *PattaniProvince = [[ItemGuide alloc] initWithName:@"ป่ากะรุบี" provinceE:@"KrabiProvince" code:@"U1.012" par:@"883/2523" type:@"ป่าสงวนแห่งชาติ" province:@"ปัตตานี" date:@"19 มิถุนายน 2523" url:@"U1.012-2523.PDF" date_no:@"ครั้งที่ 1" area:@"14489957.3068" area_rai:@"2500" ]; [self.PattaniProvinces addObject:PattaniProvince];
    PattaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาตูม" provinceE:@"KrabiProvince" code:@"U1.006" par:@"1190/2529" type:@"ป่าสงวนแห่งชาติ" province:@"ปัตตานี" date:@"31 ธันวาคม 2529" url:@"U1.006-2529.PDF" date_no:@"ครั้งที่ 2" area:@"3033618.93148" area_rai:@"1850" ]; [self.PattaniProvinces addObject:PattaniProvince];
    PattaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเขายีโด๊ะ" provinceE:@"KrabiProvince" code:@"U1.009" par:@"626/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ปัตตานี" date:@"21 ธันวาคม 2516" url:@"U1.009-2516.PDF" date_no:@"ครั้งที่ 1" area:@"46980088.3803" area_rai:@"22500" ]; [self.PattaniProvinces addObject:PattaniProvince];
    PattaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาใหญ่" provinceE:@"KrabiProvince" code:@"U1.002" par:@"151/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ปัตตานี" date:@"20 ธันวาคม 2509" url:@"U1.002-2509.PDF" date_no:@"ครั้งที่ 1" area:@"38655583.6047" area_rai:@"24375" ]; [self.PattaniProvinces addObject:PattaniProvince];
    PattaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดอนนา" provinceE:@"KrabiProvince" code:@"U1.014" par:@"1208/2530" type:@"ป่าสงวนแห่งชาติ" province:@"ปัตตานี" date:@"9 พฤศจิกายน 2530" url:@"U1.014-2530.PDF" date_no:@"ครั้งที่ 1" area:@"7755210.86313" area_rai:@"4844" ]; [self.PattaniProvinces addObject:PattaniProvince];
    PattaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาเปาะยานิ" provinceE:@"KrabiProvince" code:@"U1.010" par:@"631/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ปัตตานี" date:@"25 ธันวาคม 2516" url:@"U1.010-2516.PDF" date_no:@"ครั้งที่ 1" area:@"16550556.8859" area_rai:@"10008" ]; [self.PattaniProvinces addObject:PattaniProvince];
    PattaniProvince = [[ItemGuide alloc] initWithName:@"ป่าบาโงจะลาฆี" provinceE:@"KrabiProvince" code:@"U1.008" par:@"596/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ปัตตานี" date:@"20 พฤศจิกายน 2516" url:@"U1.008-2516.PDF" date_no:@"ครั้งที่ 1" area:@"1688479.72133" area_rai:@"625" ]; [self.PattaniProvinces addObject:PattaniProvince];
    PattaniProvince = [[ItemGuide alloc] initWithName:@"ป่าบูเก๊ะกุ้ง" provinceE:@"KrabiProvince" code:@"U1.011" par:@"644/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ปัตตานี" date:@"12 มีนาคม 2517" url:@"U1.011-2517.PDF" date_no:@"ครั้งที่ 1" area:@"2083626.62201" area_rai:@"933" ]; [self.PattaniProvinces addObject:PattaniProvince];
    PattaniProvince = [[ItemGuide alloc] initWithName:@"ป่าบูเก๊ะตางอ" provinceE:@"KrabiProvince" code:@"U1.007" par:@"580/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ปัตตานี" date:@"18 ตุลาคม 2516" url:@"U1.007-2516.PDF" date_no:@"ครั้งที่ 1" area:@"1881641.08723" area_rai:@"1219" ]; [self.PattaniProvinces addObject:PattaniProvince];
    PattaniProvince = [[ItemGuide alloc] initWithName:@"ป่าไม้แก่น" provinceE:@"KrabiProvince" code:@"U1.004" par:@"1204/2530" type:@"ป่าสงวนแห่งชาติ" province:@"ปัตตานี" date:@"13 สิงหาคม 2530" url:@"U1.004-2530.PDF" date_no:@"ครั้งที่ 2" area:@"6227670.24586" area_rai:@"4020" ]; [self.PattaniProvinces addObject:PattaniProvince];
    PattaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนยะหริ่ง" provinceE:@"KrabiProvince" code:@"U1.001" par:@"131/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ปัตตานี" date:@"16 สิงหาคม 2509" url:@"U1.001-2509.PDF" date_no:@"ครั้งที่ 1" area:@"10077227.3316" area_rai:@"6212" ]; [self.PattaniProvinces addObject:PattaniProvince];
    PattaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนยะหริ่ง แปลงที่สอง" provinceE:@"KrabiProvince" code:@"U1.013" par:@"1058/2527" type:@"ป่าสงวนแห่งชาติ" province:@"ปัตตานี" date:@"6 กันยายน 2527" url:@"U1.013-2527.PDF" date_no:@"ครั้งที่ 1" area:@"1391262.18732" area_rai:@"1250" ]; [self.PattaniProvinces addObject:PattaniProvince];
    PattaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนยะหริ่ง แปลงที่สาม" provinceE:@"KrabiProvince" code:@"U1.015" par:@"1237/2536" type:@"ป่าสงวนแห่งชาติ" province:@"ปัตตานี" date:@"12 มีนาคม 2536" url:@"U1.015-2536.PDF" date_no:@"ครั้งที่ 1" area:@"725541.632924" area_rai:@"375" ]; [self.PattaniProvinces addObject:PattaniProvince];
    PattaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนหนองจิก" provinceE:@"KrabiProvince" code:@"U1.003" par:@"256/2510" type:@"ป่าสงวนแห่งชาติ" province:@"ปัตตานี" date:@"26 ธันวาคม 2510" url:@"U1.003-2510.PDF" date_no:@"ครั้งที่ 1" area:@"20039007.6378" area_rai:@"12187" ]; [self.PattaniProvinces addObject:PattaniProvince];
    PattaniProvince = [[ItemGuide alloc] initWithName:@"ป่าสายโฮ่" provinceE:@"KrabiProvince" code:@"U1.005" par:@"500/2515" type:@"ป่าสงวนแห่งชาติ" province:@"ปัตตานี" date:@"12 ธันวาคม 2515" url:@"U1.005-2515.PDF" date_no:@"ครั้งที่ 1" area:@"9445195.60306" area_rai:@"6750" ]; [self.PattaniProvinces addObject:PattaniProvince];
    self.PhayaoProvinces = [[NSMutableArray alloc] init];  ItemGuide *PhayaoProvince = [[ItemGuide alloc] initWithName:@"ป่าดอยบ่อส้ม และป่าดอยโป่งนก" provinceE:@"KrabiProvince" code:@"J2.002" par:@"1005/2526" type:@"ป่าสงวนแห่งชาติ" province:@"พะเยา" date:@"15 กรกฎาคม 2526" url:@"J2.002-2526.PDF" date_no:@"ครั้งที่ 1" area:@"46080243.7084" area_rai:@"28125" ]; [self.PhayaoProvinces addObject:PhayaoProvince];
    PhayaoProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำเปื๋อย ป่าน้ำหย่วน และป่าน้ำลาว" provinceE:@"KrabiProvince" code:@"J2.001" par:@"966/2524" type:@"ป่าสงวนแห่งชาติ" province:@"พะเยา" date:@"30 ธันวาคม 2524" url:@"J2.001-2524.PDF" date_no:@"ครั้งที่ 1" area:@"474954608.958" area_rai:@"323181" ]; [self.PhayaoProvinces addObject:PhayaoProvince];
    PhayaoProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำแม่ปืม และป่าดงประดู่" provinceE:@"KrabiProvince" code:@"J1.019" par:@"527/2516" type:@"ป่าสงวนแห่งชาติ" province:@"พะเยา" date:@"1 พฤษภาคม 2516" url:@"J1.019-2516.PDF" date_no:@"ครั้งที่ 1" area:@"37556811.9969" area_rai:@"31000" ]; [self.PhayaoProvinces addObject:PhayaoProvince];
    PhayaoProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำแวนและป่าห้วยไคร้" provinceE:@"KrabiProvince" code:@"J1.032" par:@"779/2519" type:@"ป่าสงวนแห่งชาติ" province:@"พะเยา" date:@"1 มิถุนายน 2519" url:@"J1.032-2519.PDF" date_no:@"ครั้งที่ 1" area:@"143360948.279" area_rai:@"86250" ]; [self.PhayaoProvinces addObject:PhayaoProvince];
    PhayaoProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่จุน" provinceE:@"KrabiProvince" code:@"J1.006" par:@"208/2507" type:@"ป่าสงวนแห่งชาติ" province:@"พะเยา" date:@"10 มีนาคม 2507" url:@"J1.006-2507.PDF" date_no:@"ครั้งที่ 1" area:@"173059100.493" area_rai:@"104062.5" ]; [self.PhayaoProvinces addObject:PhayaoProvince];
    PhayaoProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ต๋ำ" provinceE:@"KrabiProvince" code:@"J1.003" par:@"152/2505" type:@"ป่าสงวนแห่งชาติ" province:@"พะเยา" date:@"31 ธันวาคม 2505" url:@"J1.003-2505.PDF" date_no:@"ครั้งที่ 1" area:@"226259817.803" area_rai:@"163625" ]; [self.PhayaoProvinces addObject:PhayaoProvince];
    PhayaoProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ต้ำ และป่าแม่นาเรือ" provinceE:@"KrabiProvince" code:@"J1.009" par:@"184/2509" type:@"ป่าสงวนแห่งชาติ" province:@"พะเยา" date:@"31 ธันวาคม 2509" url:@"J1.009-2509.PDF" date_no:@"ครั้งที่ 1" area:@"253754829.357" area_rai:@"148407" ]; [self.PhayaoProvinces addObject:PhayaoProvince];
    PhayaoProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ยม" provinceE:@"KrabiProvince" code:@"J1.031" par:@"774/2518" type:@"ป่าสงวนแห่งชาติ" province:@"พะเยา" date:@"24 กุมภาพันธ์ 2519" url:@"J1.031-2519.PDF" date_no:@"ครั้งที่ 1" area:@"2175757846.7" area_rai:@"1290200" ]; [self.PhayaoProvinces addObject:PhayaoProvince];
    PhayaoProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ร่องขุย" provinceE:@"KrabiProvince" code:@"J1.005" par:@"177/2506" type:@"ป่าสงวนแห่งชาติ" province:@"พะเยา" date:@"20 สิงหาคม 2506" url:@"J1.005-2506.PDF" date_no:@"ครั้งที่ 1" area:@"122547101.094" area_rai:@"77687.5" ]; [self.PhayaoProvinces addObject:PhayaoProvince];
    PhayaoProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ฮ่องป๋อ ป่าห้วยแก้ว และป่าแม่อิงฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"J2.003" par:@"1050/2527" type:@"ป่าสงวนแห่งชาติ" province:@"พะเยา" date:@"14 มิถุนายน 2527" url:@"J2.003-2527.PDF" date_no:@"ครั้งที่ 2" area:@"126815783.117" area_rai:@"75450" ]; [self.PhayaoProvinces addObject:PhayaoProvince];
    PhayaoProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยดอกเข็ม และป่าแม่อิงฝั่งขวา" provinceE:@"KrabiProvince" code:@"J1.004" par:@"175/2506" type:@"ป่าสงวนแห่งชาติ" province:@"พะเยา" date:@"20 สิงหาคม 2506" url:@"J1.004-2506.PDF" date_no:@"ครั้งที่ 1" area:@"195294997.389" area_rai:@"98750" ]; [self.PhayaoProvinces addObject:PhayaoProvince];
    PhayaoProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยบงและป่าห้วยเคียน" provinceE:@"KrabiProvince" code:@"J1.008" par:@"149/2509" type:@"ป่าสงวนแห่งชาติ" province:@"พะเยา" date:@"22 พฤศจิกายน 2509" url:@"J1.008-2509.PDF" date_no:@"ครั้งที่ 1" area:@"47856496.6949" area_rai:@"34737" ]; [self.PhayaoProvinces addObject:PhayaoProvince];
    self.PhangNgaProvinces = [[NSMutableArray alloc] init];  ItemGuide *PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะเกาะ" provinceE:@"KrabiProvince" code:@"S3.051" par:@"903/2523" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"9 ธันวาคม 2523" url:@"S3.051-2523.PDF" date_no:@"ครั้งที่ 1" area:@"32798851.1941" area_rai:@"17062" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะเคี่ยม" provinceE:@"KrabiProvince" code:@"S3.003" par:@"9/2507" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"24 พฤศจิกายน 2507" url:@"S3.003-2507.PDF" date_no:@"ครั้งที่ 1" area:@"874427.800549" area_rai:@"600" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะโบยใต้" provinceE:@"KrabiProvince" code:@"S3.046" par:@"840/2522" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"15 พฤษภาคม 2522" url:@"S3.046-2522.PDF" date_no:@"ครั้งที่ 1" area:@"2183610.89021" area_rai:@"1375" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะยาวน้อย" provinceE:@"KrabiProvince" code:@"S3.049" par:@"874/2522" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"26 ธันวาคม 2522" url:@"S3.049-2522.PDF" date_no:@"ครั้งที่ 1" area:@"8547419.75794" area_rai:@"5575" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะยาวใหญ่ แปลงที่สอง" provinceE:@"KrabiProvince" code:@"S3.039" par:@"718/2517" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"29 ธันวาคม 2517" url:@"S3.039-2517.PDF" date_no:@"ครั้งที่ 1" area:@"4138679.31368" area_rai:@"2489" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะยาวใหญ่ แปลงที่หนึ่ง" provinceE:@"KrabiProvince" code:@"S3.069" par:@"1046/2527" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"31 พฤษภาคม 2527" url:@"S3.069-2527.PDF" date_no:@"ครั้งที่ 1" area:@"8694030.93732" area_rai:@"5494" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะระ" provinceE:@"KrabiProvince" code:@"S3.027" par:@"597/2516" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"20 พฤศจิกายน 2516" url:@"S3.027-2516.PDF" date_no:@"ครั้งที่ 1" area:@"19352256.8634" area_rai:@"12187" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขากล้วย" provinceE:@"KrabiProvince" code:@"S3.055" par:@"920/2523" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"30 ธันวาคม 2523" url:@"S3.055-2523.PDF" date_no:@"ครั้งที่ 1" area:@"314571.242574" area_rai:@"312" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาเต่า" provinceE:@"KrabiProvince" code:@"S3.056" par:@"921/2523" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"30 ธันวาคม 2523" url:@"S3.056-2523.PDF" date_no:@"ครั้งที่ 1" area:@"564221.143126" area_rai:@"422" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาทอย และป่านางหงษ์" provinceE:@"KrabiProvince" code:@"S3.059" par:@"932/2524" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"1 มิถุนายน 2524" url:@"S3.059-2524.PDF" date_no:@"ครั้งที่ 1" area:@"62693793.314" area_rai:@"37607" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาบ่อไทร" provinceE:@"KrabiProvince" code:@"S3.023" par:@"501/2515" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"12 ธันวาคม 2515" url:@"S3.023-2515.PDF" date_no:@"ครั้งที่ 1" area:@"41417239.6894" area_rai:@"18918" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาบางแก้ว ป่าเขาบางเคียน และป่าควนหินดาน" provinceE:@"KrabiProvince" code:@"S3.008" par:@"237/2510" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"7 พฤศจิกายน 2510" url:@"S3.008-2510.PDF" date_no:@"ครั้งที่ 1" area:@"16643352.829" area_rai:@"11787" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาปลายโต๊ะ และป่าเขาศก" provinceE:@"KrabiProvince" code:@"S3.057" par:@"922/2523" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"30 ธันวาคม 2523" url:@"S3.057-2523.PDF" date_no:@"ครั้งที่ 1" area:@"235492611.824" area_rai:@"146094" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาพระพิชัย" provinceE:@"KrabiProvince" code:@"S3.032" par:@"640/2516" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"29 ธันวาคม 2516" url:@"S3.032-2516.PDF" date_no:@"ครั้งที่ 1" area:@"12550304.5065" area_rai:@"7835" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขามามังและป่าเขาบางเต่า" provinceE:@"KrabiProvince" code:@"S3.001" par:@"34/2501" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"21 ตุลาคม 2501" url:@"S3.001-2501.PDF" date_no:@"ครั้งที่ 1" area:@"7186718.84226" area_rai:@"4250" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาลำปี" provinceE:@"KrabiProvince" code:@"S3.066" par:@"1023/2526" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"9 ธันวาคม 2526" url:@"S3.066-2526.PDF" date_no:@"ครั้งที่ 1" area:@"73272878.2342" area_rai:@"47780" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาหน่วยอึ้ง ป่าเขาเหมาะน้อย และป่าเขาพ่อตา" provinceE:@"KrabiProvince" code:@"S3.009" par:@"241/2510" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"28 พฤศจิกายน 2510" url:@"S3.009-2510.PDF" date_no:@"ครั้งที่ 1" area:@"41863930.6332" area_rai:@"25875" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาหลักลำแก่น" provinceE:@"KrabiProvince" code:@"S3.002" par:@"95/2505" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"10 กรกฎาคม 2505" url:@"S3.002-2505.PDF" date_no:@"ครั้งที่ 1" area:@"19212212.0715" area_rai:@"10262.5" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาหลักและป่าลำรู" provinceE:@"KrabiProvince" code:@"S3.054" par:@"915/2523" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"30 ธันวาคม 2523" url:@"S3.054-2523.PDF" date_no:@"ครั้งที่ 1" area:@"50123823.0432" area_rai:@"30900" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองกาหมาย" provinceE:@"KrabiProvince" code:@"S3.017" par:@"356/2511" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"22 พฤศจิกายน 2511" url:@"S3.017-2511.PDF" date_no:@"ครั้งที่ 1" area:@"1317795.96775" area_rai:@"700" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองติเต๊ะ" provinceE:@"KrabiProvince" code:@"S3.033" par:@"645/2517" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"19 มีนาคม 2517" url:@"S3.033-2517.PDF" date_no:@"ครั้งที่ 1" area:@"8558091.86917" area_rai:@"4887" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองทองหลาง" provinceE:@"KrabiProvince" code:@"S3.021" par:@"386/2511" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"1 ธันวาคม 2511" url:@"S3.021-2511.PDF" date_no:@"ครั้งที่ 1" area:@"5364081.66383" area_rai:@"3203" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองทุ่งมะพร้าว" provinceE:@"KrabiProvince" code:@"S3.073" par:@"1152/2529" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"16 เมษายน 2529" url:@"S3.073-2529.PDF" date_no:@"ครั้งที่ 1" area:@"56899393.9207" area_rai:@"34339" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองพรุแจด" provinceE:@"KrabiProvince" code:@"S3.011" par:@"344/2511" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"12 พฤศจิกายน 2511" url:@"S3.011-2511.PDF" date_no:@"ครั้งที่ 1" area:@"1739333.08142" area_rai:@"1093" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองย่าหมี" provinceE:@"KrabiProvince" code:@"S3.012" par:@"345/2511" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"19 พฤศจิกายน 2511" url:@"S3.012-2511.PDF" date_no:@"ครั้งที่ 1" area:@"3397181.74983" area_rai:@"2150" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองโละปาไล้" provinceE:@"KrabiProvince" code:@"S3.020" par:@"385/2511" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"1 ธันวาคม 2511" url:@"S3.020-2511.PDF" date_no:@"ครั้งที่ 1" area:@"2779057.37171" area_rai:@"1595" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองสามช่อง และป่าคลองกระโสม" provinceE:@"KrabiProvince" code:@"S3.042" par:@"752/2518" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"22 กรกฎาคม 2518" url:@"S3.042-2518.PDF" date_no:@"ครั้งที่ 1" area:@"28404874.3867" area_rai:@"19912" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองหยง" provinceE:@"KrabiProvince" code:@"S3.019" par:@"375/2511" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"28 พฤศจิกายน 2511" url:@"S3.019-2511.PDF" date_no:@"ครั้งที่ 1" area:@"7863232.04168" area_rai:@"4687" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองหาดทรายเปลือกหอย และป่าคลองท่าอยู่" provinceE:@"KrabiProvince" code:@"S3.025" par:@"587/2516" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"6 พฤศจิกายน 2516" url:@"S3.025-2516.PDF" date_no:@"ครั้งที่ 1" area:@"10380717.6817" area_rai:@"4887" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองเหีย" provinceE:@"KrabiProvince" code:@"S3.016" par:@"355/2511" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"22 พฤศจิกายน 2511" url:@"S3.016-2511.PDF" date_no:@"ครั้งที่ 1" area:@"2833442.39131" area_rai:@"1818" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองอ่าวเลน" provinceE:@"KrabiProvince" code:@"S3.018" par:@"374/2511" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"27 พฤศจิกายน 2511" url:@"S3.018-2511.PDF" date_no:@"ครั้งที่ 1" area:@"998155.334472" area_rai:@"600" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนเขาเปาะ" provinceE:@"KrabiProvince" code:@"S3.029" par:@"627/2516" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"21 ธันวาคม 2516" url:@"S3.029-2516.PDF" date_no:@"ครั้งที่ 1" area:@"5872048.9297" area_rai:@"4057" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนจุก" provinceE:@"KrabiProvince" code:@"S3.014" par:@"347/2511" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"19 พฤศจิกายน 2511" url:@"S3.014-2511.PDF" date_no:@"ครั้งที่ 1" area:@"9575233.33465" area_rai:@"6600" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนช้างเขาทองหลาง" provinceE:@"KrabiProvince" code:@"S3.043" par:@"788/2520" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"25 ตุลาคม 2520" url:@"S3.043-2520.PDF" date_no:@"ครั้งที่ 1" area:@"8495556.75489" area_rai:@"5002" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนโต๊ะหลา และป่าแหลมซำ" provinceE:@"KrabiProvince" code:@"S3.071" par:@"1059/2527" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"6 กันยายน 2527" url:@"S3.071-2527.PDF" date_no:@"ครั้งที่ 1" area:@"19286741.6268" area_rai:@"11820" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนถ้ำ และป่าบางกรัก" provinceE:@"KrabiProvince" code:@"S3.060" par:@"934/2524" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"1 มิถุนายน 2524" url:@"S3.060-2524.PDF" date_no:@"ครั้งที่ 1" area:@"2381490.58414" area_rai:@"1519" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนนาบอน" provinceE:@"KrabiProvince" code:@"S3.053" par:@"908/2523" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"9 ธันวาคม 2523" url:@"S3.053-2523.PDF" date_no:@"ครั้งที่ 1" area:@"1871348.51626" area_rai:@"1045" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนมะรุ่ย" provinceE:@"KrabiProvince" code:@"S3.063" par:@"964/2524" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"30 ธันวาคม 2524" url:@"S3.063-2524.PDF" date_no:@"ครั้งที่ 1" area:@"28733915.55" area_rai:@"17457" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนหัวโตน และป่าเขาพัง" provinceE:@"KrabiProvince" code:@"S3.044" par:@"803/2521" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"8 กรกฎาคม 2521" url:@"S3.044-2521.PDF" date_no:@"ครั้งที่ 1" area:@"29930324.7986" area_rai:@"18865" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกขรบ" provinceE:@"KrabiProvince" code:@"S3.010" par:@"265/2510" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"28 ธันวาคม 2510" url:@"S3.010-2510.PDF" date_no:@"ครั้งที่ 1" area:@"1809425.6999" area_rai:@"1125" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าช่องหลาด" provinceE:@"KrabiProvince" code:@"S3.013" par:@"346/2511" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"19 พฤศจิกายน 2511" url:@"S3.013-2511.PDF" date_no:@"ครั้งที่ 1" area:@"8783754.18116" area_rai:@"5718" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าชายทะเลเขาหลัก" provinceE:@"KrabiProvince" code:@"S3.034" par:@"666/2517" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"10 พฤษภาคม 2517" url:@"S3.034-2517.PDF" date_no:@"ครั้งที่ 1" area:@"602563.946469" area_rai:@"412" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งทุ" provinceE:@"KrabiProvince" code:@"S3.028" par:@"598/2516" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"20 พฤศจิกายน 2516" url:@"S3.028-2516.PDF" date_no:@"ครั้งที่ 1" area:@"9814513.75264" area_rai:@"5950" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งนาดำ และป่าควนปากเตรียม" provinceE:@"KrabiProvince" code:@"S3.031" par:@"637/2516" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"29 ธันวาคม 2516" url:@"S3.031-2516.PDF" date_no:@"ครั้งที่ 1" area:@"4450931.25608" area_rai:@"2225" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขากะได" provinceE:@"KrabiProvince" code:@"S3.007" par:@"231/2510" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"6 ตุลาคม 2510" url:@"S3.007-2510.PDF" date_no:@"ครั้งที่ 1" area:@"59370085.9738" area_rai:@"40000" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขากะทะคว่ำ" provinceE:@"KrabiProvince" code:@"S3.045" par:@"813/2521" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"3 ตุลาคม 2521" url:@"S3.045-2521.PDF" date_no:@"ครั้งที่ 1" area:@"79548478.5106" area_rai:@"47700" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาโตนดิน" provinceE:@"KrabiProvince" code:@"S3.030" par:@"629/2516" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"25 ธันวาคม 2516" url:@"S3.030-2516.PDF" date_no:@"ครั้งที่ 1" area:@"44873818.3518" area_rai:@"28875" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาทุ่งคาโงก" provinceE:@"KrabiProvince" code:@"S3.041" par:@"720/2516" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"7 มกราคม 2518" url:@"S3.041-2518.PDF" date_no:@"ครั้งที่ 1" area:@"45943327.6031" area_rai:@"27935" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขานมสาว" provinceE:@"KrabiProvince" code:@"S3.040" par:@"719/2517" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"7 มกราคม 2518" url:@"S3.040-2518.PDF" date_no:@"ครั้งที่ 1" area:@"334990433.595" area_rai:@"205401" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขานมสาว แปลงที่สอง" provinceE:@"KrabiProvince" code:@"S3.061" par:@"936/2524" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"1 มิถุนายน 2524" url:@"S3.061-2524.PDF" date_no:@"ครั้งที่ 1" area:@"6567876.5733" area_rai:@"3913" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาบางปริก และป่าบางอี" provinceE:@"KrabiProvince" code:@"S3.026" par:@"591/2516" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"6 พฤศจิกายน 2516" url:@"S3.026-2516.PDF" date_no:@"ครั้งที่ 1" area:@"33305649.9417" area_rai:@"24275" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาแม่นางขาว" provinceE:@"KrabiProvince" code:@"S3.064" par:@"971/2525" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"27 เมษายน 2525" url:@"S3.064-2525.PDF" date_no:@"ครั้งที่ 1" area:@"42977971.404" area_rai:@"26442" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาศรีราชา ป่าเขาบางกรัก และป่าเขาบางใหญ่" provinceE:@"KrabiProvince" code:@"S3.065" par:@"998/2526" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"15 มีนาคม 2526" url:@"S3.065-2526.PDF" date_no:@"ครั้งที่ 1" area:@"63434580.6132" area_rai:@"37718" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาสูง" provinceE:@"KrabiProvince" code:@"S3.067" par:@"1024/2526" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"9 ธันวาคม 2526" url:@"S3.067-2526.PDF" date_no:@"ครั้งที่ 1" area:@"70216950.3894" area_rai:@"43516" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาหราสูง" provinceE:@"KrabiProvince" code:@"S3.072" par:@"1060/2527" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"6 กันยายน 2527" url:@"S3.072-2527.PDF" date_no:@"ครั้งที่ 1" area:@"75455506.8583" area_rai:@"45000" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาหลัก และป่าเขาโตน" provinceE:@"KrabiProvince" code:@"S3.035" par:@"675/2517" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"4 มิถุนายน 2517" url:@"S3.035-2517.PDF" date_no:@"ครั้งที่ 1" area:@"144927747.806" area_rai:@"89590" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่านากก" provinceE:@"KrabiProvince" code:@"S3.006" par:@"229/2510" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"26 กันยายน 2510" url:@"S3.006-2510.PDF" date_no:@"ครั้งที่ 1" area:@"4281567.50782" area_rai:@"2812" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าบางหยวก ป่าบางหอย และป่าบางยาง" provinceE:@"KrabiProvince" code:@"S3.048" par:@"861/2522" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"3 สิงหาคม 2522" url:@"S3.048-2522.PDF" date_no:@"ครั้งที่ 1" area:@"20568567.4063" area_rai:@"13662" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านบางหลาม" provinceE:@"KrabiProvince" code:@"S3.052" par:@"904/2523" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"9 ธันวาคม 2523" url:@"S3.052-2523.PDF" date_no:@"ครั้งที่ 1" area:@"7863444.4328" area_rai:@"4840" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าฝ่ายท่า" provinceE:@"KrabiProvince" code:@"S3.004" par:@"62/2508" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"13 กรกฎาคม 2508" url:@"S3.004-2508.PDF" date_no:@"ครั้งที่ 1" area:@"12115571.5906" area_rai:@"7500" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าพรุใน" provinceE:@"KrabiProvince" code:@"S3.015" par:@"354/2511" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"22 พฤศจิกายน 2511" url:@"S3.015-2511.PDF" date_no:@"ครั้งที่ 1" area:@"13495473.0018" area_rai:@"8000" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าพานพอ" provinceE:@"KrabiProvince" code:@"S3.047" par:@"843/2522" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"1 กรกฎาคม 2522" url:@"S3.047-2522.PDF" date_no:@"ครั้งที่ 1" area:@"76190058.7999" area_rai:@"43750" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองบางปอ" provinceE:@"KrabiProvince" code:@"S3.070" par:@"1051/2527" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"14 มิถุนายน 2527" url:@"S3.070-2527.PDF" date_no:@"ครั้งที่ 1" area:@"2674944.07709" area_rai:@"1443" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองสามช่อง แปลงที่สอง" provinceE:@"KrabiProvince" code:@"S3.068" par:@"1033/2526" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"31 ธันวาคม 2526" url:@"S3.068-2526.PDF" date_no:@"ครั้งที่ 1" area:@"5108400.15823" area_rai:@"5000" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนโครงการกิ่งอำเภอคุระบุรี แปลงที่สาม" provinceE:@"KrabiProvince" code:@"S3.038" par:@"714/2517" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"29 ธันวาคม 2517" url:@"S3.038-2517.PDF" date_no:@"ครั้งที่ 1" area:@"118707037.976" area_rai:@"74137" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนโครงการทับปุด" provinceE:@"KrabiProvince" code:@"S3.037" par:@"686/2517" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"23 กรกฎาคม 2517" url:@"S3.037-2517.PDF" date_no:@"ครั้งที่ 1" area:@"31904766.691" area_rai:@"20371" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนโครงการอำเภอคุระบุรี" provinceE:@"KrabiProvince" code:@"S3.058" par:@"930/2524" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"8 มีนาคม 2524" url:@"S3.058-2524.PDF" date_no:@"ครั้งที่ 1" area:@"6629198.01332" area_rai:@"4725" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนโครงการอำเภอคุระบุรี แปลงที่หนึ่ง" provinceE:@"KrabiProvince" code:@"S3.062" par:@"951/2524" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"27 กันยายน 2524" url:@"S3.062-2524.PDF" date_no:@"ครั้งที่ 1" area:@"76584855.7715" area_rai:@"63750" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนโครงการอำเภอตะกั่วป่า และป่าเขาบางนายสี" provinceE:@"KrabiProvince" code:@"S3.050" par:@"900/2523" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"1 พฤศจิกายน 2523" url:@"S3.050-2523.PDF" date_no:@"ครั้งที่ 1" area:@"98292546.5987" area_rai:@"60250" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าวังทัง" provinceE:@"KrabiProvince" code:@"S3.005" par:@"226/2510" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"26 กันยายน 2510" url:@"S3.005-2510.PDF" date_no:@"ครั้งที่ 1" area:@"5790553.98545" area_rai:@"3800" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าสนชายทะเล" provinceE:@"KrabiProvince" code:@"S3.024" par:@"572/2516" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"2 ตุลาคม 2516" url:@"S3.024-2516.PDF" date_no:@"ครั้งที่ 1" area:@"1668846.48299" area_rai:@"937.5" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าหมู่เกาะสุรินทร์" provinceE:@"KrabiProvince" code:@"S3.022" par:@"441/2514" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"30 ธันวาคม 2514" url:@"S3.022-2514.PDF" date_no:@"ครั้งที่ 1" area:@"24156984.8156" area_rai:@"20594" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    PhangNgaProvince = [[ItemGuide alloc] initWithName:@"ป่าหัวเขา" provinceE:@"KrabiProvince" code:@"S3.036" par:@"685/2517" type:@"ป่าสงวนแห่งชาติ" province:@"พังงา" date:@"16 กรกฎาคม 2517" url:@"S3.036-2517.PDF" date_no:@"ครั้งที่ 1" area:@"1865263.51556" area_rai:@"1000" ]; [self.PhangNgaProvinces addObject:PhangNgaProvince];
    self.PhatthalungProvinces = [[NSMutableArray alloc] init];  ItemGuide *PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะเต่า คลองเรียน" provinceE:@"KrabiProvince" code:@"T3.007" par:@"71/2503" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"20 ธันวาคม 2503" url:@"T3.007-2503.PDF" date_no:@"ครั้งที่ 1" area:@"36675439.1215" area_rai:@"23687.5" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะหมาก" provinceE:@"KrabiProvince" code:@"T3.040" par:@"1153/2529" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"16 เมษายน 2529" url:@"T3.040-2529.PDF" date_no:@"ครั้งที่ 1" area:@"8303844.06855" area_rai:@"5009" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาจันทร์" provinceE:@"KrabiProvince" code:@"T3.036" par:@"820/2521" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"26 ธันวาคม 2521" url:@"T3.036-2521.PDF" date_no:@"ครั้งที่ 1" area:@"17993354.0953" area_rai:@"10000" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาศพนางพันธุรัตน์ ป่าควนแก้ว และป่าควนอ้ายหลุด" provinceE:@"KrabiProvince" code:@"T3.014" par:@"17/2507" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"31 ธันวาคม 2507" url:@"T3.014-2507.PDF" date_no:@"ครั้งที่ 1" area:@"7910442.69508" area_rai:@"7456" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาหวัง ป่าเขาคับ ป่าเขาเขียว และป่าเขายาโง้ง" provinceE:@"KrabiProvince" code:@"T3.033" par:@"600/2516" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"20 พฤศจิกายน 2516" url:@"T3.033-2516.PDF" date_no:@"ครั้งที่ 1" area:@"11675693.3993" area_rai:@"8125" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาหัวช้าง ป่าเขาตีนป่า ป่าเขาหลักไก่ และป่าเขาพระ" provinceE:@"KrabiProvince" code:@"T3.010" par:@"167/2506" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"13 สิงหาคม 2506" url:@"T3.010-2506.PDF" date_no:@"ครั้งที่ 1" area:@"18423179.3967" area_rai:@"11937.5" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าเขียว" provinceE:@"KrabiProvince" code:@"T3.037" par:@"952/2524" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"27 กันยายน 2524" url:@"T3.037-2524.PDF" date_no:@"ครั้งที่ 1" area:@"9036034.7837" area_rai:@"5531" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองยวน" provinceE:@"KrabiProvince" code:@"T3.013" par:@"4/2507" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"24 พฤศจิกายน 2507" url:@"T3.013-2507.PDF" date_no:@"ครั้งที่ 1" area:@"9986787.83036" area_rai:@"6175" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าควน ป่ายาง และป่าควนดินสอ" provinceE:@"KrabiProvince" code:@"T3.008" par:@"147/2505" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"18 ธันวาคม 2505" url:@"T3.008-2505.PDF" date_no:@"ครั้งที่ 1" area:@"644254.444813" area_rai:@"443.75" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าควนคำทอง" provinceE:@"KrabiProvince" code:@"T3.011" par:@"174/2506" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"20 สิงหาคม 2506" url:@"T3.011-2506.PDF" date_no:@"ครั้งที่ 1" area:@"8524856.69605" area_rai:@"5275" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าควนโคกยา ป่าควนโต๊ะดน และป่าควนนุ้ย" provinceE:@"KrabiProvince" code:@"T3.018" par:@"584/2516" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"6 พฤศจิกายน 2516" url:@"T3.018-2516.PDF" date_no:@"ครั้งที่ 2" area:@"14448205.5608" area_rai:@"9775" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าควนตอ ป่าควนฤทธิ์ ป่าควนเลียบและป่าควนหินขาว" provinceE:@"KrabiProvince" code:@"T3.039" par:@"1137/2528" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"27 พฤศจิกายน 2528" url:@"T3.039-2528.PDF" date_no:@"ครั้งที่ 1" area:@"8528631.81433" area_rai:@"5185" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าควนเปล้า ป่าควนกฤษณา และป่าสระราชา" provinceE:@"KrabiProvince" code:@"T3.019" par:@"138/2509" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"27 กันยายน 2509" url:@"T3.019-2509.PDF" date_no:@"ครั้งที่ 1" area:@"25761248.0264" area_rai:@"14525" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าควนเสาธง ป่าควนนายสุก และป่าควนนายหวัด" provinceE:@"KrabiProvince" code:@"T3.034" par:@"721/2518" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"18 กุมภาพันธ์ 2518" url:@"T3.034-2518.PDF" date_no:@"ครั้งที่ 1" area:@"27590291.1939" area_rai:@"14000" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าควนหวาน ป่าควนนอโม และป่าห้วยหาร" provinceE:@"KrabiProvince" code:@"T3.009" par:@"158/2506" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"26 กุมภาพันธ์ 2506" url:@"T3.009-2506.PDF" date_no:@"ครั้งที่ 1" area:@"1889521.28672" area_rai:@"1125" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าควนหินกอง ป่าควนโพธิ์เล ป่าควนขี้หมิ้น และป่าควนน้ำทรัพย์" provinceE:@"KrabiProvince" code:@"T3.030" par:@"475/2515" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"7 พฤศจิกายน 2515" url:@"T3.030-2515.PDF" date_no:@"ครั้งที่ 1" area:@"36681574.1387" area_rai:@"25500" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าควนหินแท่น ป่าควนไม้ไผ่ ป่าเขาวงทับใคร และป่าเลเหมียง" provinceE:@"KrabiProvince" code:@"T3.012" par:@"182/2506" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"10 กันยายน 2506" url:@"T3.012-2506.PDF" date_no:@"ครั้งที่ 1" area:@"43403140.3955" area_rai:@"26843.75" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าค่ายไพ" provinceE:@"KrabiProvince" code:@"T3.016" par:@"83/2508" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"19 ตุลาคม 2508" url:@"T3.016-2508.PDF" date_no:@"ครั้งที่ 1" area:@"2558049.72938" area_rai:@"1662" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าท่าเตียน" provinceE:@"KrabiProvince" code:@"T3.038" par:@"1001/2526" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"16 พฤษภาคม 2526" url:@"T3.038-2526.PDF" date_no:@"ครั้งที่ 1" area:@"1052081.54551" area_rai:@"563" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาบรรทัด แปลงที่ 1 ตอนที่ 2" provinceE:@"KrabiProvince" code:@"T3.002" par:@"20/2501" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"29 เมษายน 2501" url:@"T3.002-2501.PDF" date_no:@"ครั้งที่ 1" area:@"65640792.9538" area_rai:@"60000" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาบรรทัด แปลงที่ 1 ตอนที่ 3" provinceE:@"KrabiProvince" code:@"T3.006" par:@"65/2502" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"26 เมษายน 2503" url:@"T3.006-2503.PDF" date_no:@"ครั้งที่ 1" area:@"339432440.679" area_rai:@"160625" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาบรรทัด แปลงที่ 2 ตอนที่ 2" provinceE:@"KrabiProvince" code:@"T3.003" par:@"31/2501" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"21 ตุลาคม 2501" url:@"T3.003-2501.PDF" date_no:@"ครั้งที่ 1" area:@"122585399.357" area_rai:@"93750" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาบรรทัด แปลงที่ 2 ตอนที่ 3" provinceE:@"KrabiProvince" code:@"T3.001" par:@"14/2501" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"29 เมษายน 2501" url:@"T3.001-2501.PDF" date_no:@"ครั้งที่ 1" area:@"159370912.885" area_rai:@"151968.75" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าในวัง" provinceE:@"KrabiProvince" code:@"T3.015" par:@"211/2507" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"23 เมษายน 2507" url:@"T3.015-2507.PDF" date_no:@"ครั้งที่ 1" area:@"20608557.4537" area_rai:@"6725" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าพรุเสม็ด และป่าบางเต็ง" provinceE:@"KrabiProvince" code:@"T3.035" par:@"814/2521" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"3 ตุลาคม 2521" url:@"T3.035-2521.PDF" date_no:@"ครั้งที่ 1" area:@"724572.101071" area_rai:@"450" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าภูเขาบรรทัด แปลงที่ 1 ตอนที่ 1" provinceE:@"KrabiProvince" code:@"T3.005" par:@"43/2502" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"21 กรกฎาคม 2502" url:@"T3.005-2502.PDF" date_no:@"ครั้งที่ 1" area:@"64214673.4409" area_rai:@"38375" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าภูเขาบรรทัด แปลงที่ 2 ตอนที่ 1" provinceE:@"KrabiProvince" code:@"T3.004" par:@"42/2502" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"21 กรกฎาคม 2502" url:@"T3.004-2502.PDF" date_no:@"ครั้งที่ 1" area:@"34270335.0903" area_rai:@"30750" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยเรือ และป่าควนเพ็ง" provinceE:@"KrabiProvince" code:@"T3.032" par:@"554/2516" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"7 สิงหาคม 2516" url:@"T3.032-2516.PDF" date_no:@"ครั้งที่ 1" area:@"12130385.9269" area_rai:@"6875" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยส้ม และป่าลำนาวา" provinceE:@"KrabiProvince" code:@"T3.041" par:@"1181/2529" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"8 ธันวาคม 2529" url:@"T3.041-2529.PDF" date_no:@"ครั้งที่ 1" area:@"11142927" area_rai:@"6976" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าเหนือคลอง" provinceE:@"KrabiProvince" code:@"T3.028" par:@"384/2511" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"1 ธันวาคม 2511" url:@"T3.028-2511.PDF" date_no:@"ครั้งที่ 1" area:@"24549197.4781" area_rai:@"14375" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    PhatthalungProvince = [[ItemGuide alloc] initWithName:@"ป่าเหมืองกั่ว และป่าบางเตง" provinceE:@"KrabiProvince" code:@"T3.017" par:@"87/2508" type:@"ป่าสงวนแห่งชาติ" province:@"พัทลุง" date:@"16 พฤศจิกายน 2508" url:@"T3.017-2508.PDF" date_no:@"ครั้งที่ 1" area:@"3406235.88701" area_rai:@"2781" ]; [self.PhatthalungProvinces addObject:PhatthalungProvince];
    self.PhichitProvinces = [[NSMutableArray alloc] init];  ItemGuide *PhichitProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาเจ็ดลูก ป่าเขาตะพานนาค และป่าเขาชะอม" provinceE:@"KrabiProvince" code:@"M3.002" par:@"1092/2527" type:@"ป่าสงวนแห่งชาติ" province:@"พิจิตร" date:@"30 ธันวาคม 2527" url:@"M3.002-2527.PDF" date_no:@"ครั้งที่ 2" area:@"1935699.8015" area_rai:@"1150" ]; [self.PhichitProvinces addObject:PhichitProvince];
    PhichitProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาทราย และป่าเขาพระ" provinceE:@"KrabiProvince" code:@"M3.003" par:@"1067/2527" type:@"ป่าสงวนแห่งชาติ" province:@"พิจิตร" date:@"8 พฤศจิกายน 2527" url:@"M3.003-2527.PDF" date_no:@"ครั้งที่ 1" area:@"2633918.18411" area_rai:@"1875" ]; [self.PhichitProvinces addObject:PhichitProvince];
    PhichitProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองดง" provinceE:@"KrabiProvince" code:@"M3.001" par:@"155/2509" type:@"ป่าสงวนแห่งชาติ" province:@"พิจิตร" date:@"27 ธันวาคม 2509" url:@"M3.001-2509.PDF" date_no:@"ครั้งที่ 1" area:@"1694283.12497" area_rai:@"885" ]; [self.PhichitProvinces addObject:PhichitProvince];
    self.PhitsanulokProvinces = [[NSMutableArray alloc] init];  ItemGuide *PhitsanulokProvince = [[ItemGuide alloc] initWithName:@"ป่าเขากระยาง" provinceE:@"KrabiProvince" code:@"M1.007" par:@"977/2525" type:@"ป่าสงวนแห่งชาติ" province:@"พิษณุโลก" date:@"14 กันยายน 2525" url:@"M1.007-2525.PDF" date_no:@"ครั้งที่ 1" area:@"578541835.054" area_rai:@"332000" ]; [self.PhitsanulokProvinces addObject:PhitsanulokProvince];
    PhitsanulokProvince = [[ItemGuide alloc] initWithName:@"ป่าดงตีนตก" provinceE:@"KrabiProvince" code:@"M1.005" par:@"759/2518" type:@"ป่าสงวนแห่งชาติ" province:@"พิษณุโลก" date:@"25 พฤศจิกายน 2518" url:@"M1.005-2518.PDF" date_no:@"ครั้งที่ 1" area:@"256496993.222" area_rai:@"173267" ]; [self.PhitsanulokProvinces addObject:PhitsanulokProvince];
    PhitsanulokProvince = [[ItemGuide alloc] initWithName:@"ป่าแดงและป่าชาติตระการ" provinceE:@"KrabiProvince" code:@"M1.009" par:@"993/2525" type:@"ป่าสงวนแห่งชาติ" province:@"พิษณุโลก" date:@"26 ธันวาคม 2525" url:@"M1.009-2525.PDF" date_no:@"ครั้งที่ 1" area:@"448845827.017" area_rai:@"220750" ]; [self.PhitsanulokProvinces addObject:PhitsanulokProvince];
    PhitsanulokProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำภาค และป่าลำแควน้อยฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"M1.006" par:@"876/2523" type:@"ป่าสงวนแห่งชาติ" province:@"พิษณุโลก" date:@"5 มีนาคม 2523" url:@"M1.006-2523.PDF" date_no:@"ครั้งที่ 1" area:@"518843261.929" area_rai:@"308362" ]; [self.PhitsanulokProvinces addObject:PhitsanulokProvince];
    PhitsanulokProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำภาคน้อย" provinceE:@"KrabiProvince" code:@"M1.013" par:@"1179/2529" type:@"ป่าสงวนแห่งชาติ" province:@"พิษณุโลก" date:@"8 ธันวาคม 2529" url:@"M1.013-2529.PDF" date_no:@"ครั้งที่ 1" area:@"79087972.5217" area_rai:@"49219" ]; [self.PhitsanulokProvinces addObject:PhitsanulokProvince];
    PhitsanulokProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำภาคฝั่งขวา" provinceE:@"KrabiProvince" code:@"M1.008" par:@"991/2525" type:@"ป่าสงวนแห่งชาติ" province:@"พิษณุโลก" date:@"26 ธันวาคม 2525" url:@"M1.008-2525.PDF" date_no:@"ครั้งที่ 1" area:@"482569659.255" area_rai:@"279375" ]; [self.PhitsanulokProvinces addObject:PhitsanulokProvince];
    PhitsanulokProvince = [[ItemGuide alloc] initWithName:@"ป่าเนินเพิ่ม" provinceE:@"KrabiProvince" code:@"M1.003" par:@"467/2515" type:@"ป่าสงวนแห่งชาติ" province:@"พิษณุโลก" date:@"31 ตุลาคม 2515" url:@"M1.003-2515.PDF" date_no:@"ครั้งที่ 1" area:@"838695444.184" area_rai:@"468750" ]; [self.PhitsanulokProvinces addObject:PhitsanulokProvince];
    PhitsanulokProvince = [[ItemGuide alloc] initWithName:@"ป่าโป่งแค" provinceE:@"KrabiProvince" code:@"M1.011" par:@"1154/2529" type:@"ป่าสงวนแห่งชาติ" province:@"พิษณุโลก" date:@"16 เมษายน 2529" url:@"M1.011-2529.PDF" date_no:@"ครั้งที่ 1" area:@"48924017.8121" area_rai:@"30125" ]; [self.PhitsanulokProvinces addObject:PhitsanulokProvince];
    PhitsanulokProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่น้ำเข็ก" provinceE:@"KrabiProvince" code:@"M1.010" par:@"1036/2527" type:@"ป่าสงวนแห่งชาติ" province:@"พิษณุโลก" date:@"31 พฤษภาคม 2527" url:@"M1.010-2527.PDF" date_no:@"ครั้งที่ 1" area:@"30648881.1675" area_rai:@"17450" ]; [self.PhitsanulokProvinces addObject:PhitsanulokProvince];
    PhitsanulokProvince = [[ItemGuide alloc] initWithName:@"ป่าลุ่มน้ำวังทองฝั่งขวา" provinceE:@"KrabiProvince" code:@"M1.001" par:@"84/2508" type:@"ป่าสงวนแห่งชาติ" province:@"พิษณุโลก" date:@"19 ตุลาคม 2508" url:@"M1.001-2508.PDF" date_no:@"ครั้งที่ 1" area:@"369097776.949" area_rai:@"343000" ]; [self.PhitsanulokProvinces addObject:PhitsanulokProvince];
    PhitsanulokProvince = [[ItemGuide alloc] initWithName:@"ป่าลุ่มน้ำวังทองฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"M1.002" par:@"167/2509" type:@"ป่าสงวนแห่งชาติ" province:@"พิษณุโลก" date:@"31 ธันวาคม 2509" url:@"M1.002-2509.PDF" date_no:@"ครั้งที่ 1" area:@"744058907.79" area_rai:@"479375" ]; [self.PhitsanulokProvinces addObject:PhitsanulokProvince];
    PhitsanulokProvince = [[ItemGuide alloc] initWithName:@"ป่าสวนเมี่ยง" provinceE:@"KrabiProvince" code:@"M1.012" par:@"1158/2529" type:@"ป่าสงวนแห่งชาติ" province:@"พิษณุโลก" date:@"5 มิถุนายน 2529" url:@"M1.012-2529.PDF" date_no:@"ครั้งที่ 1" area:@"247890167.443" area_rai:@"151250" ]; [self.PhitsanulokProvinces addObject:PhitsanulokProvince];
    PhitsanulokProvince = [[ItemGuide alloc] initWithName:@"ป่าสองฝั่งลำน้ำแควน้อย" provinceE:@"KrabiProvince" code:@"M1.004" par:@"704/2517" type:@"ป่าสงวนแห่งชาติ" province:@"พิษณุโลก" date:@"27 สิงหาคม 2517" url:@"M1.004-2517.PDF" date_no:@"ครั้งที่ 1" area:@"605108798.612" area_rai:@"324378" ]; [self.PhitsanulokProvinces addObject:PhitsanulokProvince];
    self.PhetchaburiProvinces = [[NSMutableArray alloc] init];  ItemGuide *PhetchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาถ้ำรงค์ และป่าหนองช้างตาย" provinceE:@"KrabiProvince" code:@"Q1.004" par:@"76/2508" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบุรี" date:@"5 ตุลาคม 2508" url:@"Q1.004-2508.PDF" date_no:@"ครั้งที่ 1" area:@"1030275.30785" area_rai:@"750" ]; [self.PhetchaburiProvinces addObject:PhetchaburiProvince];
    PhetchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาถ้ำเสือและป่าเขาโป่งแย้" provinceE:@"KrabiProvince" code:@"Q1.014" par:@"1085/2527" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบุรี" date:@"6 ธันวาคม 2527" url:@"Q1.014-2527.PDF" date_no:@"ครั้งที่ 1" area:@"21910791.3472" area_rai:@"13426" ]; [self.PhetchaburiProvinces addObject:PhetchaburiProvince];
    PhetchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าชะอำและป่าบ้านโรง" provinceE:@"KrabiProvince" code:@"Q1.012" par:@"990/2525" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบุรี" date:@"26 ธันวาคม 2525" url:@"Q1.012-2525.PDF" date_no:@"ครั้งที่ 1" area:@"117610636.632" area_rai:@"81211" ]; [self.PhetchaburiProvinces addObject:PhetchaburiProvince];
    PhetchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าดอนมะทราง" provinceE:@"KrabiProvince" code:@"Q1.003" par:@"31/2507" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบุรี" date:@"31 ธันวาคม 2507" url:@"Q1.003-2507.PDF" date_no:@"ครั้งที่ 1" area:@"783270.809014" area_rai:@"456" ]; [self.PhetchaburiProvinces addObject:PhetchaburiProvince];
    PhetchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าบอมตะโก" provinceE:@"KrabiProvince" code:@"Q1.008" par:@"269/2510" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบุรี" date:@"28 ธันวาคม 2510" url:@"Q1.008-2510.PDF" date_no:@"ครั้งที่ 1" area:@"101457.194781" area_rai:@"51" ]; [self.PhetchaburiProvinces addObject:PhetchaburiProvince];
    PhetchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านแหลม" provinceE:@"KrabiProvince" code:@"Q1.006" par:@"115/2509" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบุรี" date:@"28 มิถุนายน 2509" url:@"Q1.006-2509.PDF" date_no:@"ครั้งที่ 1" area:@"1410101.40094" area_rai:@"625" ]; [self.PhetchaburiProvinces addObject:PhetchaburiProvince];
    PhetchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าปากทะเล" provinceE:@"KrabiProvince" code:@"Q1.002" par:@"93/2505" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบุรี" date:@"19 มิถุนายน 2505" url:@"Q1.002-2505.PDF" date_no:@"ครั้งที่ 1" area:@"1599071.07611" area_rai:@"1000" ]; [self.PhetchaburiProvinces addObject:PhetchaburiProvince];
    PhetchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่ายาง" provinceE:@"KrabiProvince" code:@"Q1.007" par:@"252/2510" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบุรี" date:@"26 ธันวาคม 2510" url:@"Q1.007-2510.PDF" date_no:@"ครั้งที่ 1" area:@"6481490.94193" area_rai:@"3777" ]; [self.PhetchaburiProvinces addObject:PhetchaburiProvince];
    PhetchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่ายางน้ำกลัดเหนือและป่ายางน้ำกลัดใต้" provinceE:@"KrabiProvince" code:@"Q1.005" par:@"101/2508" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบุรี" date:@"31 ธันวาคม 2508" url:@"Q1.005-2508.PDF" date_no:@"ครั้งที่ 1" area:@"3479105513.27" area_rai:@"2099112" ]; [self.PhetchaburiProvinces addObject:PhetchaburiProvince];
    PhetchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่ายางลำห้วยแม่ประจันต์" provinceE:@"KrabiProvince" code:@"Q1.001" par:@"881/2523" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบุรี" date:@"19 มิถุนายน 2523" url:@"Q1.001-2523.PDF" date_no:@"ครั้งที่ 2" area:@"1730065.28927" area_rai:@"1125" ]; [self.PhetchaburiProvinces addObject:PhetchaburiProvince];
    PhetchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่ายางหัก-เขาปุ้ม" provinceE:@"KrabiProvince" code:@"Q1.009" par:@"458/2515" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบุรี" date:@"5 กันยายน 2515" url:@"Q1.009-2515.PDF" date_no:@"ครั้งที่ 1" area:@"127523450.358" area_rai:@"81815" ]; [self.PhetchaburiProvinces addObject:PhetchaburiProvince];
    PhetchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองกระทุ่ม" provinceE:@"KrabiProvince" code:@"Q1.013" par:@"1077/2527" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบุรี" date:@"8 พฤศจิกายน 2527" url:@"Q1.013-2527.PDF" date_no:@"ครั้งที่ 1" area:@"833191.510192" area_rai:@"500" ]; [self.PhetchaburiProvinces addObject:PhetchaburiProvince];
    PhetchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองหญ้าปล้อง" provinceE:@"KrabiProvince" code:@"Q1.010" par:@"616/2516" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบุรี" date:@"4 ธันวาคม 2516" url:@"Q1.010-2516.PDF" date_no:@"ครั้งที่ 1" area:@"185133173.847" area_rai:@"106837" ]; [self.PhetchaburiProvinces addObject:PhetchaburiProvince];
    PhetchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าหมายเลขแปดสิบเจ็ด" provinceE:@"KrabiProvince" code:@"Q1.011" par:@"926/2524" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบุรี" date:@"8 มีนาคม 2524" url:@"Q1.011-2524.PDF" date_no:@"ครั้งที่ 1" area:@"9141599.24392" area_rai:@"5550" ]; [self.PhetchaburiProvinces addObject:PhetchaburiProvince];
    PhetchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยโป่งงาม" provinceE:@"KrabiProvince" code:@"Q1.015" par:@"1086/2527" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบุรี" date:@"27 ธันวาคม 2527" url:@"Q1.015-2527.PDF" date_no:@"ครั้งที่ 1" area:@"2729201.42629" area_rai:@"1365" ]; [self.PhetchaburiProvinces addObject:PhetchaburiProvince];
    self.PhetchabunProvinces = [[NSMutableArray alloc] init];  ItemGuide *PhetchabunProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาปางก่อและป่าวังชมภู" provinceE:@"KrabiProvince" code:@"M4.012" par:@"1184/2529" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบูรณ์" date:@"8 ธันวาคม 2529" url:@"M4.012-2529.PDF" date_no:@"ครั้งที่ 1" area:@"735220270.349" area_rai:@"438469" ]; [self.PhetchabunProvinces addObject:PhetchabunProvince];
    PhetchabunProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาโปลกหล่น" provinceE:@"KrabiProvince" code:@"M4.013" par:@"1197/2530" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบูรณ์" date:@"27 มีนาคม 2530" url:@"M4.013-2530.PDF" date_no:@"ครั้งที่ 1" area:@"188795071.978" area_rai:@"116881" ]; [self.PhetchabunProvinces addObject:PhetchabunProvince];
    PhetchabunProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกซำซาง" provinceE:@"KrabiProvince" code:@"M4.011" par:@"1162/2529" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบูรณ์" date:@"5 มิถุนายน 2529" url:@"M4.011-2529.PDF" date_no:@"ครั้งที่ 1" area:@"82758906.2831" area_rai:@"52275" ]; [self.PhetchabunProvinces addObject:PhetchabunProvince];
    PhetchabunProvince = [[ItemGuide alloc] initWithName:@"ป่าตะเบาะและป่าห้วยใหญ่" provinceE:@"KrabiProvince" code:@"M4.003" par:@"619/2516" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบูรณ์" date:@"21 ธันวาคม 2516" url:@"M4.003-2516.PDF" date_no:@"ครั้งที่ 1" area:@"521636405.448" area_rai:@"313125" ]; [self.PhetchabunProvinces addObject:PhetchabunProvince];
    PhetchabunProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำหนาว" provinceE:@"KrabiProvince" code:@"M4.001" par:@"91/2508" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบูรณ์" date:@"31 ธันวาคม 2508" url:@"M4.001-2508.PDF" date_no:@"ครั้งที่ 1" area:@"823831140.539" area_rai:@"533125" ]; [self.PhetchabunProvinces addObject:PhetchabunProvince];
    PhetchabunProvince = [[ItemGuide alloc] initWithName:@"ป่าฝั่งซ้ายแม่น้ำป่าสัก" provinceE:@"KrabiProvince" code:@"M4.010" par:@"1155/2529" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบูรณ์" date:@"16 เมษายน 2529" url:@"M4.010-2529.PDF" date_no:@"ครั้งที่ 1" area:@"891835974.174" area_rai:@"538200" ]; [self.PhetchabunProvinces addObject:PhetchabunProvince];
    PhetchabunProvince = [[ItemGuide alloc] initWithName:@"ป่าลำกงและป่าคลองตะโก" provinceE:@"KrabiProvince" code:@"M4.009" par:@"987/2525" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบูรณ์" date:@"1 พฤศจิกายน 2525" url:@"M4.009-2525.PDF" date_no:@"ครั้งที่ 1" area:@"179567775.582" area_rai:@"112950" ]; [self.PhetchabunProvinces addObject:PhetchabunProvince];
    PhetchabunProvince = [[ItemGuide alloc] initWithName:@"ป่าลุ่มน้ำป่าสัก" provinceE:@"KrabiProvince" code:@"M4.006" par:@"925/2524" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบูรณ์" date:@"8 มีนาคม 2524" url:@"M4.006-2524.PDF" date_no:@"ครั้งที่ 1" area:@"238230654.627" area_rai:@"148487" ]; [self.PhetchabunProvinces addObject:PhetchabunProvince];
    PhetchabunProvince = [[ItemGuide alloc] initWithName:@"ป่าลุ่มน้ำป่าสักฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"M4.008" par:@"957/2524" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบูรณ์" date:@"27 กันยายน 2524" url:@"M4.008-2524.PDF" date_no:@"ครั้งที่ 1" area:@"390996549.378" area_rai:@"236750" ]; [self.PhetchabunProvinces addObject:PhetchabunProvince];
    PhetchabunProvince = [[ItemGuide alloc] initWithName:@"ป่าวังโป่ง ป่าชนแดน และป่าวังกำแพง" provinceE:@"KrabiProvince" code:@"M4.002" par:@"997/2525" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบูรณ์" date:@"29 ธันวาคม 2525" url:@"M4.002-2525.PDF" date_no:@"ครั้งที่ 2" area:@"939372433.685" area_rai:@"590000" ]; [self.PhetchabunProvinces addObject:PhetchabunProvince];
    PhetchabunProvince = [[ItemGuide alloc] initWithName:@"ป่าสองข้างทางสายชัยวิบูลย์" provinceE:@"KrabiProvince" code:@"M4.005" par:@"894/2523" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบูรณ์" date:@"1 พฤศจิกายน 2523" url:@"M4.005-2523.PDF" date_no:@"ครั้งที่ 1" area:@"1344997372.8" area_rai:@"513050" ]; [self.PhetchabunProvinces addObject:PhetchabunProvince];
    PhetchabunProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยทินและป่าคลองตีบ" provinceE:@"KrabiProvince" code:@"M4.004" par:@"827/2521" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบูรณ์" date:@"29 ธันวาคม 2521" url:@"M4.004-2521.PDF" date_no:@"ครั้งที่ 1" area:@"473582553.573" area_rai:@"315593" ]; [self.PhetchabunProvinces addObject:PhetchabunProvince];
    PhetchabunProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยน้ำโจนและป่าวังสาร" provinceE:@"KrabiProvince" code:@"M4.007" par:@"949/2524" type:@"ป่าสงวนแห่งชาติ" province:@"เพชรบูรณ์" date:@"27 กันยายน 2524" url:@"M4.007-2524.PDF" date_no:@"ครั้งที่ 1" area:@"80952535.7588" area_rai:@"44550" ]; [self.PhetchabunProvinces addObject:PhetchabunProvince];
    self.PhraeProvinces = [[NSMutableArray alloc] init];  ItemGuide *PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าบ่อแก้ว ป่าแม่สูง และป่าแม่สิน" provinceE:@"KrabiProvince" code:@"H1.014" par:@"361/2511" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"26 พฤศจิกายน 2511" url:@"H1.014-2511.PDF" date_no:@"ครั้งที่ 1" area:@"242991373.152" area_rai:@"137500" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ก๋อนและป่าแม่สาย" provinceE:@"KrabiProvince" code:@"H1.003" par:@"78/2508" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"19 ตุลาคม 2508" url:@"H1.003-2508.PDF" date_no:@"ครั้งที่ 1" area:@"324789585.762" area_rai:@"181250" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่เกิ๋ง" provinceE:@"KrabiProvince" code:@"H1.019" par:@"551/2516" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"31 กรกฎาคม 2516" url:@"H1.019-2516.PDF" date_no:@"ครั้งที่ 1" area:@"171993981.571" area_rai:@"102275" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่เข็ก" provinceE:@"KrabiProvince" code:@"H1.026" par:@"1079/2527" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"6 ธันวาคม 2527" url:@"H1.026-2527.PDF" date_no:@"ครั้งที่ 1" area:@"44988353.0953" area_rai:@"35000" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่คำมี" provinceE:@"KrabiProvince" code:@"H1.012" par:@"277/2510" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"28 ธันวาคม 2510" url:@"H1.012-2510.PDF" date_no:@"ครั้งที่ 1" area:@"345585688.533" area_rai:@"210000" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่แคม" provinceE:@"KrabiProvince" code:@"H1.017" par:@"445/2514" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"30 ธันวาคม 2514" url:@"H1.017-2514.PDF" date_no:@"ครั้งที่ 1" area:@"80397586.1256" area_rai:@"73750" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่จั๊วะฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"H1.027" par:@"1089/2527" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"27 ธันวาคม 2527" url:@"H1.027-2527.PDF" date_no:@"ครั้งที่ 1" area:@"28738179.9864" area_rai:@"16875" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่จั๊วะและป่าแม่มาน" provinceE:@"KrabiProvince" code:@"H1.001" par:@"207/2507" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"10 มีนาคม 2507" url:@"H1.001-2507.PDF" date_no:@"ครั้งที่ 1" area:@"66430018.3256" area_rai:@"40625" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ต้าตอนขุน" provinceE:@"KrabiProvince" code:@"H1.008" par:@"152/2529" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"20 ธันวาคม 2509" url:@"H1.008-2509.PDF" date_no:@"ครั้งที่ 1" area:@"243736011.693" area_rai:@"152775" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ต้าฝั่งขวาตอนใต้" provinceE:@"KrabiProvince" code:@"H1.023" par:@"574/2516" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"2 ตุลาคม 2516" url:@"H1.023-2516.PDF" date_no:@"ครั้งที่ 1" area:@"101062942.41" area_rai:@"62500" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ต้าฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"H1.013" par:@"335/2511" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"30 กรกฎาคม 2511" url:@"H1.013-2511.PDF" date_no:@"ครั้งที่ 1" area:@"166332892.748" area_rai:@"104968" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่เติ๊ก ป่าแม่ถาง และป่าแม่กำปอง" provinceE:@"KrabiProvince" code:@"H1.009" par:@"220/2510" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"5 กันยายน 2510" url:@"H1.009-2510.PDF" date_no:@"ครั้งที่ 1" area:@"275572063.541" area_rai:@"162500" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ปงและป่าแม่ลอง" provinceE:@"KrabiProvince" code:@"H1.021" par:@"825/2521" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"29 ธันวาคม 2521" url:@"H1.021-2521.PDF" date_no:@"ครั้งที่ 2" area:@"100992525.591" area_rai:@"50275" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ปาน" provinceE:@"KrabiProvince" code:@"H1.015" par:@"395/2512" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"20 กุมภาพันธ์ 2512" url:@"H1.015-2512.PDF" date_no:@"ครั้งที่ 1" area:@"64854172.1893" area_rai:@"38125" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ปุงและป่าแม่เป้า" provinceE:@"KrabiProvince" code:@"H1.024" par:@"604/2516" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"27 พฤศจิกายน 2516" url:@"H1.024-2516.PDF" date_no:@"ครั้งที่ 1" area:@"229715438.183" area_rai:@"137500" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่พวก" provinceE:@"KrabiProvince" code:@"H1.002" par:@"77/2508" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"19 ตุลาคม 2508" url:@"H1.002-2508.PDF" date_no:@"ครั้งที่ 1" area:@"222635769.827" area_rai:@"108062" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ยมตะวันตก" provinceE:@"KrabiProvince" code:@"H1.025" par:@"635/2516" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"25 ธันวาคม 2516" url:@"H1.025-2516.PDF" date_no:@"ครั้งที่ 1" area:@"317707734.89" area_rai:@"245625" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ยมฝั่งตะวันออก" provinceE:@"KrabiProvince" code:@"H1.011" par:@"273/2510" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"28 ธันวาคม 2510" url:@"H1.011-2510.PDF" date_no:@"ครั้งที่ 1" area:@"273304751.241" area_rai:@"178489" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ยาง" provinceE:@"KrabiProvince" code:@"H1.016" par:@"396/2512" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"25 กุมภาพันธ์ 2512" url:@"H1.016-2512.PDF" date_no:@"ครั้งที่ 1" area:@"91081478.7165" area_rai:@"59737" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่แย้ และป่าแม่สาง" provinceE:@"KrabiProvince" code:@"H1.004" par:@"86/2508" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"16 พฤศจิกายน 2508" url:@"H1.004-2508.PDF" date_no:@"ครั้งที่ 1" area:@"125614180.813" area_rai:@"79687" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ลานและป่าแม่กาง" provinceE:@"KrabiProvince" code:@"H1.005" par:@"102/2508" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"31 ธันวาคม 2508" url:@"H1.005-2508.PDF" date_no:@"ครั้งที่ 1" area:@"186926167.785" area_rai:@"116250" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ลู่และป่าแม่แป๋น" provinceE:@"KrabiProvince" code:@"H1.007" par:@"124/2509" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"16 สิงหาคม 2509" url:@"H1.007-2509.PDF" date_no:@"ครั้งที่ 1" area:@"159034125.304" area_rai:@"84375" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่สรอย" provinceE:@"KrabiProvince" code:@"H1.018" par:@"531/2516" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"19 มิถุนายน 2516" url:@"H1.018-2516.PDF" date_no:@"ครั้งที่ 1" area:@"209873120.821" area_rai:@"160625" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่สอง" provinceE:@"KrabiProvince" code:@"H1.022" par:@"565/2516" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"25 กันยายน 2516" url:@"H1.022-2516.PDF" date_no:@"ครั้งที่ 1" area:@"760916245.423" area_rai:@"359593" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่แฮด" provinceE:@"KrabiProvince" code:@"H1.020" par:@"562/2516" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"14 สิงหาคม 2516" url:@"H1.020-2516.PDF" date_no:@"ครั้งที่ 1" area:@"24948644.5821" area_rai:@"11990" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยเบี้ยและป่าห้วยบ่อทอง" provinceE:@"KrabiProvince" code:@"H1.010" par:@"267/2510" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"28 ธันวาคม 2510" url:@"H1.010-2510.PDF" date_no:@"ครั้งที่ 1" area:@"76259661.8194" area_rai:@"49500" ]; [self.PhraeProvinces addObject:PhraeProvince];
    PhraeProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยป้อม" provinceE:@"KrabiProvince" code:@"H1.006" par:@"107/2508" type:@"ป่าสงวนแห่งชาติ" province:@"แพร่" date:@"31 ธันวาคม 2508" url:@"H1.006-2508.PDF" date_no:@"ครั้งที่ 1" area:@"32966854.9897" area_rai:@"17037" ]; [self.PhraeProvinces addObject:PhraeProvince];
    self.PhuketProvinces = [[NSMutableArray alloc] init];  ItemGuide *PhuketProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะโหลน" provinceE:@"KrabiProvince" code:@"S4.011" par:@"357/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ภูเก็ต" date:@"22 พฤศจิกายน 2511" url:@"S4.011-2511.PDF" date_no:@"ครั้งที่ 1" area:@"2872744.7663" area_rai:@"1537" ]; [self.PhuketProvinces addObject:PhuketProvince];
    PhuketProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาโต๊ะแซะ" provinceE:@"KrabiProvince" code:@"S4.013" par:@"608/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ภูเก็ต" date:@"4 ธันวาคม 2516" url:@"S4.013-2516.PDF" date_no:@"ครั้งที่ 1" area:@"905148.14672" area_rai:@"550" ]; [self.PhuketProvinces addObject:PhuketProvince];
    PhuketProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาไม้พอก และป่าไม้แก้ว" provinceE:@"KrabiProvince" code:@"S4.016" par:@"1097/2528" type:@"ป่าสงวนแห่งชาติ" province:@"ภูเก็ต" date:@"2 พฤษภาคม 2528" url:@"S4.016-2528.PDF" date_no:@"ครั้งที่ 1" area:@"7245431.75911" area_rai:@"4444" ]; [self.PhuketProvinces addObject:PhuketProvince];
    PhuketProvince = [[ItemGuide alloc] initWithName:@"ป่าเขารวก และป่าเขาเมือง" provinceE:@"KrabiProvince" code:@"S4.006" par:@"3/2507" type:@"ป่าสงวนแห่งชาติ" province:@"ภูเก็ต" date:@"24 พฤศจิกายน 2507" url:@"S4.006-2507.PDF" date_no:@"ครั้งที่ 1" area:@"10840865.623" area_rai:@"7175" ]; [self.PhuketProvinces addObject:PhuketProvince];
    PhuketProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาสามเหลี่ยม" provinceE:@"KrabiProvince" code:@"S4.015" par:@"849/2522" type:@"ป่าสงวนแห่งชาติ" province:@"ภูเก็ต" date:@"1 กรกฎาคม 2522" url:@"S4.015-2522.PDF" date_no:@"ครั้งที่ 1" area:@"2330689.33567" area_rai:@"1254" ]; [self.PhuketProvinces addObject:PhuketProvince];
    PhuketProvince = [[ItemGuide alloc] initWithName:@"ป่าควนเขาพระแทว" provinceE:@"KrabiProvince" code:@"S4.007" par:@"201/2507" type:@"ป่าสงวนแห่งชาติ" province:@"ภูเก็ต" date:@"3 มีนาคม 2507" url:@"S4.007-2507.PDF" date_no:@"ครั้งที่ 1" area:@"20354435.4891" area_rai:@"13925" ]; [self.PhuketProvinces addObject:PhuketProvince];
    PhuketProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขากมลา" provinceE:@"KrabiProvince" code:@"S4.012" par:@"401/2512" type:@"ป่าสงวนแห่งชาติ" province:@"ภูเก็ต" date:@"25 กุมภาพันธ์ 2512" url:@"S4.012-2512.PDF" date_no:@"ครั้งที่ 1" area:@"48229968.2801" area_rai:@"29600" ]; [self.PhuketProvinces addObject:PhuketProvince];
    PhuketProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขานาคเกิด" provinceE:@"KrabiProvince" code:@"S4.014" par:@"621/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ภูเก็ต" date:@"21 ธันวาคม 2516" url:@"S4.014-2516.PDF" date_no:@"ครั้งที่ 1" area:@"40339835.112" area_rai:@"24750" ]; [self.PhuketProvinces addObject:PhuketProvince];
    PhuketProvince = [[ItemGuide alloc] initWithName:@"ป่าบางขนุน" provinceE:@"KrabiProvince" code:@"S4.009" par:@"217/2507" type:@"ป่าสงวนแห่งชาติ" province:@"ภูเก็ต" date:@"23 เมษายน 2507" url:@"S4.009-2507.PDF" date_no:@"ครั้งที่ 1" area:@"9303458.30808" area_rai:@"5000" ]; [self.PhuketProvinces addObject:PhuketProvince];
    PhuketProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองเกาะผี" provinceE:@"KrabiProvince" code:@"S4.002" par:@"140/2505" type:@"ป่าสงวนแห่งชาติ" province:@"ภูเก็ต" date:@"11 ธันวาคม 2505" url:@"S4.002-2505.PDF" date_no:@"ครั้งที่ 1" area:@"4219536.44086" area_rai:@"2687.5" ]; [self.PhuketProvinces addObject:PhuketProvince];
    PhuketProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองท่ามะพร้าว" provinceE:@"KrabiProvince" code:@"S4.004" par:@"185/2506" type:@"ป่าสงวนแห่งชาติ" province:@"ภูเก็ต" date:@"10 กันยายน 2506" url:@"S4.004-2506.PDF" date_no:@"ครั้งที่ 1" area:@"4652258.37021" area_rai:@"1750" ]; [self.PhuketProvinces addObject:PhuketProvince];
    PhuketProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองท่าเรือ" provinceE:@"KrabiProvince" code:@"S4.005" par:@"1/2507" type:@"ป่าสงวนแห่งชาติ" province:@"ภูเก็ต" date:@"24 พฤศจิกายน 2507" url:@"S4.005-2507.PDF" date_no:@"ครั้งที่ 1" area:@"5647834.02121" area_rai:@"3181" ]; [self.PhuketProvinces addObject:PhuketProvince];
    PhuketProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองบางชีเหล้า-คลองท่าจีน" provinceE:@"KrabiProvince" code:@"S4.001" par:@"16/2501" type:@"ป่าสงวนแห่งชาติ" province:@"ภูเก็ต" date:@"29 เมษายน 2501" url:@"S4.001-2501.PDF" date_no:@"ครั้งที่ 1" area:@"6451258.33442" area_rai:@"2168.75" ]; [self.PhuketProvinces addObject:PhuketProvince];
    PhuketProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองบางโรง" provinceE:@"KrabiProvince" code:@"S4.010" par:@"328/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ภูเก็ต" date:@"30 กรกฎาคม 2511" url:@"S4.010-2511.PDF" date_no:@"ครั้งที่ 1" area:@"6017293.83226" area_rai:@"3887" ]; [self.PhuketProvinces addObject:PhuketProvince];
    PhuketProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองพารา" provinceE:@"KrabiProvince" code:@"S4.003" par:@"184/2506" type:@"ป่าสงวนแห่งชาติ" province:@"ภูเก็ต" date:@"10 กันยายน 2506" url:@"S4.003-2506.PDF" date_no:@"ครั้งที่ 1" area:@"4252833.4658" area_rai:@"2343.75" ]; [self.PhuketProvinces addObject:PhuketProvince];
    PhuketProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองอู่ตะเภา" provinceE:@"KrabiProvince" code:@"S4.008" par:@"206/2507" type:@"ป่าสงวนแห่งชาติ" province:@"ภูเก็ต" date:@"10 มีนาคม 2507" url:@"S4.008-2507.PDF" date_no:@"ครั้งที่ 1" area:@"2502012.15074" area_rai:@"1556.25" ]; [self.PhuketProvinces addObject:PhuketProvince];
    self.MahaSarakhamProvinces = [[NSMutableArray alloc] init];  ItemGuide *MahaSarakhamProvince = [[ItemGuide alloc] initWithName:@"ป่ากุดรัง" provinceE:@"KrabiProvince" code:@"F2.008" par:@"1065/2527" type:@"ป่าสงวนแห่งชาติ" province:@"มหาสารคาม" date:@"6 กันยายน 2527" url:@"F2.008-2527.PDF" date_no:@"ครั้งที่ 2" area:@"145106736.731" area_rai:@"89757" ]; [self.MahaSarakhamProvinces addObject:MahaSarakhamProvince];
    MahaSarakhamProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกขามป้อม" provinceE:@"KrabiProvince" code:@"F2.004" par:@"283/2511" type:@"ป่าสงวนแห่งชาติ" province:@"มหาสารคาม" date:@"20 กุมภาพันธ์ 2511" url:@"F2.004-2511.PDF" date_no:@"ครั้งที่ 1" area:@"16433950.8148" area_rai:@"10625" ]; [self.MahaSarakhamProvinces addObject:MahaSarakhamProvince];
    MahaSarakhamProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกข่าว" provinceE:@"KrabiProvince" code:@"F2.001" par:@"173/2506" type:@"ป่าสงวนแห่งชาติ" province:@"มหาสารคาม" date:@"20 สิงหาคม 2506" url:@"F2.001-2506.PDF" date_no:@"ครั้งที่ 1" area:@"12097405.0143" area_rai:@"7406.25" ]; [self.MahaSarakhamProvinces addObject:MahaSarakhamProvince];
    MahaSarakhamProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกผักกูดและป่าโป่งแดง" provinceE:@"KrabiProvince" code:@"F2.005" par:@"331/2511" type:@"ป่าสงวนแห่งชาติ" province:@"มหาสารคาม" date:@"30 กรกฎาคม 2511" url:@"F2.005-2511.PDF" date_no:@"ครั้งที่ 1" area:@"34633215.3156" area_rai:@"18787" ]; [self.MahaSarakhamProvinces addObject:MahaSarakhamProvince];
    MahaSarakhamProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกไร่" provinceE:@"KrabiProvince" code:@"F2.010" par:@"885/2523" type:@"ป่าสงวนแห่งชาติ" province:@"มหาสารคาม" date:@"19 มิถุนายน 2523" url:@"F2.010-2523.PDF" date_no:@"ครั้งที่ 1" area:@"10769215.0622" area_rai:@"6562" ]; [self.MahaSarakhamProvinces addObject:MahaSarakhamProvince];
    MahaSarakhamProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกสำโรงและป่าปอพาน" provinceE:@"KrabiProvince" code:@"F2.009" par:@"858/2522" type:@"ป่าสงวนแห่งชาติ" province:@"มหาสารคาม" date:@"3 สิงหาคม 2522" url:@"F2.009-2522.PDF" date_no:@"ครั้งที่ 1" area:@"1474652.13532" area_rai:@"863" ]; [self.MahaSarakhamProvinces addObject:MahaSarakhamProvince];
    MahaSarakhamProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกหินลาด" provinceE:@"KrabiProvince" code:@"F2.003" par:@"50/2508" type:@"ป่าสงวนแห่งชาติ" province:@"มหาสารคาม" date:@"11 พฤษภาคม 2508" url:@"F2.003-2508.PDF" date_no:@"ครั้งที่ 1" area:@"6879179.05211" area_rai:@"3750" ]; [self.MahaSarakhamProvinces addObject:MahaSarakhamProvince];
    MahaSarakhamProvince = [[ItemGuide alloc] initWithName:@"ป่าดงเค็งและป่าหนองหญ้าปล้อง" provinceE:@"KrabiProvince" code:@"F2.007" par:@"454/2514" type:@"ป่าสงวนแห่งชาติ" province:@"มหาสารคาม" date:@"11 มกราคม 2515" url:@"F2.007-2515.PDF" date_no:@"ครั้งที่ 1" area:@"18608268.6877" area_rai:@"10937" ]; [self.MahaSarakhamProvinces addObject:MahaSarakhamProvince];
    MahaSarakhamProvince = [[ItemGuide alloc] initWithName:@"ป่าดินแดงและป่าวังกุง" provinceE:@"KrabiProvince" code:@"F2.002" par:@"43/2508" type:@"ป่าสงวนแห่งชาติ" province:@"มหาสารคาม" date:@"27 เมษายน 2508" url:@"F2.002-2508.PDF" date_no:@"ครั้งที่ 1" area:@"122763650.708" area_rai:@"76250" ]; [self.MahaSarakhamProvinces addObject:MahaSarakhamProvince];
    MahaSarakhamProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองคูและป่านาดูน" provinceE:@"KrabiProvince" code:@"F2.006" par:@"339/2511" type:@"ป่าสงวนแห่งชาติ" province:@"มหาสารคาม" date:@"12 พฤศจิกายน 2511" url:@"F2.006-2511.PDF" date_no:@"ครั้งที่ 1" area:@"49169973.588" area_rai:@"29375" ]; [self.MahaSarakhamProvinces addObject:MahaSarakhamProvince];
    self.MukdahanProvinces = [[NSMutableArray alloc] init];  ItemGuide *MukdahanProvince = [[ItemGuide alloc] initWithName:@"ป่าดงบังอี่ แปลงที่เจ็ด" provinceE:@"KrabiProvince" code:@"G6.006" par:@"1163/2529" type:@"ป่าสงวนแห่งชาติ" province:@"มุกดาหาร" date:@"5 มิถุนายน 2529" url:@"G6.006-2529.PDF" date_no:@"ครั้งที่ 1" area:@"10681722.6434" area_rai:@"6766" ]; [self.MukdahanProvinces addObject:MukdahanProvince];
    MukdahanProvince = [[ItemGuide alloc] initWithName:@"ป่าดงบังอี่ แปลงที่สอง" provinceE:@"KrabiProvince" code:@"G3.007" par:@"503/2515" type:@"ป่าสงวนแห่งชาติ" province:@"มุกดาหาร" date:@"12 ธันวาคม 2515" url:@"G3.007-2515.PDF" date_no:@"ครั้งที่ 1" area:@"234471228.87" area_rai:@"135937" ]; [self.MukdahanProvinces addObject:MukdahanProvince];
    MukdahanProvince = [[ItemGuide alloc] initWithName:@"ป่าดงบังอี่ แปลงที่สาม" provinceE:@"KrabiProvince" code:@"G3.006" par:@"491/2515" type:@"ป่าสงวนแห่งชาติ" province:@"มุกดาหาร" date:@"21 พฤศจิกายน 2515" url:@"G3.006-2515.PDF" date_no:@"ครั้งที่ 1" area:@"338823741.916" area_rai:@"453822" ]; [self.MukdahanProvinces addObject:MukdahanProvince];
    MukdahanProvince = [[ItemGuide alloc] initWithName:@"ป่าดงบังอี่ แปลงที่สี่" provinceE:@"KrabiProvince" code:@"G3.008" par:@"542/2516" type:@"ป่าสงวนแห่งชาติ" province:@"มุกดาหาร" date:@"17 กรกฎาคม 2516" url:@"G3.008-2516.PDF" date_no:@"ครั้งที่ 1" area:@"29969989.9231" area_rai:@"17875" ]; [self.MukdahanProvinces addObject:MukdahanProvince];
    MukdahanProvince = [[ItemGuide alloc] initWithName:@"ป่าดงบังอี่ แปลงที่หก" provinceE:@"KrabiProvince" code:@"G6.008" par:@"1230/2533" type:@"ป่าสงวนแห่งชาติ" province:@"มุกดาหาร" date:@"28 ธันวาคม 2533" url:@"G6.008-2533.PDF" date_no:@"ครั้งที่ 1" area:@"31430558.745" area_rai:@"19063" ]; [self.MukdahanProvinces addObject:MukdahanProvince];
    MukdahanProvince = [[ItemGuide alloc] initWithName:@"ป่าดงบังอี่ แปลงที่หนึ่ง" provinceE:@"KrabiProvince" code:@"G3.009" par:@"559/2516" type:@"ป่าสงวนแห่งชาติ" province:@"มุกดาหาร" date:@"14 สิงหาคม 2516" url:@"G3.009-2516.PDF" date_no:@"ครั้งที่ 1" area:@"338934739.607" area_rai:@"253887" ]; [self.MukdahanProvinces addObject:MukdahanProvince];
    MukdahanProvince = [[ItemGuide alloc] initWithName:@"ป่าดงบังอี่ แปลงที่ห้า" provinceE:@"KrabiProvince" code:@"G6.001" par:@"1015/2526" type:@"ป่าสงวนแห่งชาติ" province:@"มุกดาหาร" date:@"6 ธันวาคม 2526" url:@"G6.001-2526.PDF" date_no:@"ครั้งที่ 2" area:@"34692764.8541" area_rai:@"19787" ]; [self.MukdahanProvinces addObject:MukdahanProvince];
    MukdahanProvince = [[ItemGuide alloc] initWithName:@"ป่าดงภูพาน" provinceE:@"KrabiProvince" code:@"G6.005" par:@"1127/2528" type:@"ป่าสงวนแห่งชาติ" province:@"มุกดาหาร" date:@"27 พฤศจิกายน 2528" url:@"G6.005-2528.PDF" date_no:@"ครั้งที่ 1" area:@"616329524.699" area_rai:@"377438" ]; [self.MukdahanProvinces addObject:MukdahanProvince];
    MukdahanProvince = [[ItemGuide alloc] initWithName:@"ป่าดงภูสีฐาน" provinceE:@"KrabiProvince" code:@"G3.013" par:@"857/2522" type:@"ป่าสงวนแห่งชาติ" province:@"มุกดาหาร" date:@"3 สิงหาคม 2522" url:@"G3.013-2522.PDF" date_no:@"ครั้งที่ 1" area:@"559404869.056" area_rai:@"407518" ]; [self.MukdahanProvinces addObject:MukdahanProvince];
    MukdahanProvince = [[ItemGuide alloc] initWithName:@"ป่าดงหมู" provinceE:@"KrabiProvince" code:@"G6.002" par:@"1035/2527" type:@"ป่าสงวนแห่งชาติ" province:@"มุกดาหาร" date:@"31 พฤษภาคม 2527" url:@"G6.002-2527.PDF" date_no:@"ครั้งที่ 1" area:@"212589168.931" area_rai:@"136406" ]; [self.MukdahanProvinces addObject:MukdahanProvince];
    MukdahanProvince = [[ItemGuide alloc] initWithName:@"ป่าดงหมู แปลงที่สอง" provinceE:@"KrabiProvince" code:@"G6.007" par:@"1186/2529" type:@"ป่าสงวนแห่งชาติ" province:@"มุกดาหาร" date:@"8 ธันวาคม 2529" url:@"G6.007-2529.PDF" date_no:@"ครั้งที่ 1" area:@"66245610.7589" area_rai:@"40594" ]; [self.MukdahanProvinces addObject:MukdahanProvince];
    MukdahanProvince = [[ItemGuide alloc] initWithName:@"ป่าดงหมู แปลงที่สาม" provinceE:@"KrabiProvince" code:@"G6.003" par:@"1102/2528" type:@"ป่าสงวนแห่งชาติ" province:@"มุกดาหาร" date:@"2 พฤษภาคม 2528" url:@"G6.003-2528.PDF" date_no:@"ครั้งที่ 1" area:@"85540910.4623" area_rai:@"62891" ]; [self.MukdahanProvinces addObject:MukdahanProvince];
    MukdahanProvince = [[ItemGuide alloc] initWithName:@"ป่าดงหมู แปลงที่หนึ่ง" provinceE:@"KrabiProvince" code:@"G6.004" par:@"1120/2528" type:@"ป่าสงวนแห่งชาติ" province:@"มุกดาหาร" date:@"30 กันยายน 2528" url:@"G6.004-2528.PDF" date_no:@"ครั้งที่ 1" area:@"10235775.49" area_rai:@"7500" ]; [self.MukdahanProvinces addObject:MukdahanProvince];
    self.MaeHongSonProvinces = [[NSMutableArray alloc] init];  ItemGuide *MaeHongSonProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่เงา และป่าแม่สำเพ็ง" provinceE:@"KrabiProvince" code:@"L1.009" par:@"844/2522" type:@"ป่าสงวนแห่งชาติ" province:@"แม่ฮ่องสอน" date:@"1 กรกฎาคม 2522" url:@"L1.009-2522.PDF" date_no:@"ครั้งที่ 1" area:@"774320457.25" area_rai:@"562500" ]; [self.MaeHongSonProvinces addObject:MaeHongSonProvince];
    MaeHongSonProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ปายฝั่งขวา" provinceE:@"KrabiProvince" code:@"L1.007" par:@"1233/2534" type:@"ป่าสงวนแห่งชาติ" province:@"แม่ฮ่องสอน" date:@"13 สิงหาคม 2534" url:@"L1.007-2534.PDF" date_no:@"ครั้งที่ 2" area:@"1295529270.51" area_rai:@"801747" ]; [self.MaeHongSonProvinces addObject:MaeHongSonProvince];
    MaeHongSonProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ปายฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"L1.005" par:@"1234/2534" type:@"ป่าสงวนแห่งชาติ" province:@"แม่ฮ่องสอน" date:@"13 สิงหาคม 2534" url:@"L1.005-2534.PDF" date_no:@"ครั้งที่ 2" area:@"992346856.484" area_rai:@"605313" ]; [self.MaeHongSonProvinces addObject:MaeHongSonProvince];
    MaeHongSonProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ปายฝั่งซ้ายตอนบน" provinceE:@"KrabiProvince" code:@"L1.008" par:@"650/2517" type:@"ป่าสงวนแห่งชาติ" province:@"แม่ฮ่องสอน" date:@"1 เมษายน 2517" url:@"L1.008-2517.PDF" date_no:@"ครั้งที่ 1" area:@"1335934364.15" area_rai:@"662812" ]; [self.MaeHongSonProvinces addObject:MaeHongSonProvince];
    MaeHongSonProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ยวมฝั่งขวา" provinceE:@"KrabiProvince" code:@"L1.003" par:@"822/2521" type:@"ป่าสงวนแห่งชาติ" province:@"แม่ฮ่องสอน" date:@"29 ธันวาคม 2521" url:@"L1.003-2521.PDF" date_no:@"ครั้งที่ 2" area:@"841518893.899" area_rai:@"655125" ]; [self.MaeHongSonProvinces addObject:MaeHongSonProvince];
    MaeHongSonProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ยวมฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"L1.004" par:@"178/2506" type:@"ป่าสงวนแห่งชาติ" province:@"แม่ฮ่องสอน" date:@"20 สิงหาคม 2506" url:@"L1.004-2506.PDF" date_no:@"ครั้งที่ 1" area:@"1994645065.73" area_rai:@"1659375" ]; [self.MaeHongSonProvinces addObject:MaeHongSonProvince];
    MaeHongSonProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ยวมฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"L1.006" par:@"6/2507" type:@"ป่าสงวนแห่งชาติ" province:@"แม่ฮ่องสอน" date:@"25 พฤศจิกายน 2507" url:@"L1.006-2507.PDF" date_no:@"ครั้งที่ 1" area:@"933576255.254" area_rai:@"725156" ]; [self.MaeHongSonProvinces addObject:MaeHongSonProvince];
    MaeHongSonProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่สุรินทร์" provinceE:@"KrabiProvince" code:@"L1.002" par:@"172/2506" type:@"ป่าสงวนแห่งชาติ" province:@"แม่ฮ่องสอน" date:@"13 สิงหาคม 2506" url:@"L1.002-2506.PDF" date_no:@"ครั้งที่ 1" area:@"494924181.519" area_rai:@"177500" ]; [self.MaeHongSonProvinces addObject:MaeHongSonProvince];
    MaeHongSonProvince = [[ItemGuide alloc] initWithName:@"ป่าสาละวิน" provinceE:@"KrabiProvince" code:@"L1.001" par:@"469/2515" type:@"ป่าสงวนแห่งชาติ" province:@"แม่ฮ่องสอน" date:@"7 พฤศจิกายน 2515" url:@"L1.001-2515.PDF" date_no:@"ครั้งที่ 2" area:@"1862670128.19" area_rai:@"1139000" ]; [self.MaeHongSonProvinces addObject:MaeHongSonProvince];
    self.YasothonProvinces = [[NSMutableArray alloc] init];  ItemGuide *YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่ากำแมด" provinceE:@"KrabiProvince" code:@"E4.009" par:@"593/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"13 พฤศจิกายน 2516" url:@"E4.009-2516.PDF" date_no:@"ครั้งที่ 1" area:@"13731080.5093" area_rai:@"8700" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่ากุดชุม" provinceE:@"KrabiProvince" code:@"E4.022" par:@"979/2525" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"14 กันยายน 2525" url:@"E4.022-2525.PDF" date_no:@"ครั้งที่ 1" area:@"31613277.6045" area_rai:@"19080" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกนาโก" provinceE:@"KrabiProvince" code:@"E4.008" par:@"567/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"25 กันยายน 2516" url:@"E4.008-2516.PDF" date_no:@"ครั้งที่ 1" area:@"53636708.0828" area_rai:@"30700" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกหนองบัวและป่านาทม" provinceE:@"KrabiProvince" code:@"E4.006" par:@"553/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"7 สิงหาคม 2516" url:@"E4.006-2516.PDF" date_no:@"ครั้งที่ 1" area:@"52893096.0141" area_rai:@"30937" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าดงบังอี่" provinceE:@"KrabiProvince" code:@"E4.010" par:@"617/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"4 ธันวาคม 2516" url:@"E4.010-2516.PDF" date_no:@"ครั้งที่ 1" area:@"149089710.598" area_rai:@"87031" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าดงบ้านมะพริก" provinceE:@"KrabiProvince" code:@"E4.027" par:@"1132/2528" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"27 พฤศจิกายน 2528" url:@"E4.027-2528.PDF" date_no:@"ครั้งที่ 1" area:@"25378636.9421" area_rai:@"7856" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าดงปอและป่าดงบังอี่" provinceE:@"KrabiProvince" code:@"E4.001" par:@"16/2507" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"31 ธันวาคม 2507" url:@"E4.001-2507.PDF" date_no:@"ครั้งที่ 1" area:@"290773052.13" area_rai:@"187100" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าดงพันชาด" provinceE:@"KrabiProvince" code:@"E4.014" par:@"699/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"13 สิงหาคม 2517" url:@"E4.014-2517.PDF" date_no:@"ครั้งที่ 1" area:@"910430.804718" area_rai:@"468" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าดงมะไฟ" provinceE:@"KrabiProvince" code:@"E4.002" par:@"39/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"9 มีนาคม 2508" url:@"E4.002-2508.PDF" date_no:@"ครั้งที่ 1" area:@"54656087.3174" area_rai:@"62731" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าดงใหญ่" provinceE:@"KrabiProvince" code:@"E4.021" par:@"969/2525" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"27 เมษายน 2525" url:@"E4.021-2525.PDF" date_no:@"ครั้งที่ 1" area:@"2225762.39811" area_rai:@"1445" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าดอนตาแต้ม" provinceE:@"KrabiProvince" code:@"E4.004" par:@"415/2512" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"8 เมษายน 2512" url:@"E4.004-2512.PDF" date_no:@"ครั้งที่ 1" area:@"94383468.2624" area_rai:@"60500" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าดอนหัวนา" provinceE:@"KrabiProvince" code:@"E4.018" par:@"909/2523" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"9 ธันวาคม 2523" url:@"E4.018-2523.PDF" date_no:@"ครั้งที่ 1" area:@"3978985.13674" area_rai:@"2687" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าตำบลเดิด" provinceE:@"KrabiProvince" code:@"E4.007" par:@"557/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"14 สิงหาคม 2516" url:@"E4.007-2516.PDF" date_no:@"ครั้งที่ 1" area:@"19741048.4388" area_rai:@"12800" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าทรายมูลและป่าทุ่งแต้" provinceE:@"KrabiProvince" code:@"E4.011" par:@"622/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"21 ธันวาคม 2516" url:@"E4.011-2516.PDF" date_no:@"ครั้งที่ 1" area:@"21776679.0573" area_rai:@"13750" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านขั้นไดใหญ่และป่าบ้านเชียงหวาง" provinceE:@"KrabiProvince" code:@"E4.005" par:@"529/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"19 มิถุนายน 2516" url:@"E4.005-2516.PDF" date_no:@"ครั้งที่ 1" area:@"19609626.7726" area_rai:@"12737" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านแจนแลน" provinceE:@"KrabiProvince" code:@"E4.016" par:@"764/2518" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"25 พฤศจิกายน 2518" url:@"E4.016-2518.PDF" date_no:@"ครั้งที่ 1" area:@"2365677.68634" area_rai:@"1425" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านนาดี" provinceE:@"KrabiProvince" code:@"E4.023" par:@"1103/2528" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"2 พฤษภาคม 2528" url:@"E4.023-2528.PDF" date_no:@"ครั้งที่ 1" area:@"36754735.8697" area_rai:@"22516" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านพะเสา" provinceE:@"KrabiProvince" code:@"E4.012" par:@"657/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"10 พฤษภาคม 2517" url:@"E4.012-2517.PDF" date_no:@"ครั้งที่ 1" area:@"3415181.24758" area_rai:@"2175" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านหนองตุและป่าคูสองชั้น" provinceE:@"KrabiProvince" code:@"E4.017" par:@"846/2522" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"1 กรกฎาคม 2522" url:@"E4.017-2522.PDF" date_no:@"ครั้งที่ 1" area:@"2197530.26778" area_rai:@"1275" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าผือฮี" provinceE:@"KrabiProvince" code:@"E4.020" par:@"962/2524" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"5 ธันวาคม 2524" url:@"E4.020-2524.PDF" date_no:@"ครั้งที่ 1" area:@"12923402.9995" area_rai:@"8400" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าโพธิ์ไทร" provinceE:@"KrabiProvince" code:@"E4.019" par:@"943/2524" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"23 กรกฎาคม 2524" url:@"E4.019-2524.PDF" date_no:@"ครั้งที่ 1" area:@"7166567.20226" area_rai:@"4633" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าโพนงามและป่าดงปอ" provinceE:@"KrabiProvince" code:@"E4.003" par:@"114/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"28 มิถุนายน 2509" url:@"E4.003-2509.PDF" date_no:@"ครั้งที่ 1" area:@"121930343.464" area_rai:@"69862" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าฟ้าห่วน" provinceE:@"KrabiProvince" code:@"E4.013" par:@"659/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"10 พฤษภาคม 2517" url:@"E4.013-2517.PDF" date_no:@"ครั้งที่ 1" area:@"5544790.7113" area_rai:@"3393" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองแดง" provinceE:@"KrabiProvince" code:@"E4.026" par:@"1129/2528" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"27 พฤศจิกายน 2528" url:@"E4.026-2528.PDF" date_no:@"ครั้งที่ 1" area:@"12000590.1031" area_rai:@"3190" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองหว้า" provinceE:@"KrabiProvince" code:@"E4.025" par:@"1128/2528" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"27 พฤศจิกายน 2528" url:@"E4.025-2528.PDF" date_no:@"ครั้งที่ 1" area:@"26764105.597" area_rai:@"15705" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยปอ" provinceE:@"KrabiProvince" code:@"E4.024" par:@"1116/2528" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"30 กันยายน 2528" url:@"E4.024-2528.PDF" date_no:@"ครั้งที่ 1" area:@"25314020.8336" area_rai:@"15164" ]; [self.YasothonProvinces addObject:YasothonProvince];
    YasothonProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยแสนลึกและป่าหนองหิน" provinceE:@"KrabiProvince" code:@"E4.015" par:@"710/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ยโสธร" date:@"8 ตุลาคม 2517" url:@"E4.015-2517.PDF" date_no:@"ครั้งที่ 1" area:@"42182892.9276" area_rai:@"26562" ]; [self.YasothonProvinces addObject:YasothonProvince];
    self.YalaProvinces = [[NSMutableArray alloc] init];  ItemGuide *YalaProvince = [[ItemGuide alloc] initWithName:@"ป่ากาบัง" provinceE:@"KrabiProvince" code:@"U2.001" par:@"46/2502" type:@"ป่าสงวนแห่งชาติ" province:@"ยะลา" date:@"1 กันยายน 2502" url:@"U2.001-2502.PDF" date_no:@"ครั้งที่ 1" area:@"235780556.207" area_rai:@"168750" ]; [self.YalaProvinces addObject:YalaProvince];
    YalaProvince = [[ItemGuide alloc] initWithName:@"ป่ากาโสด" provinceE:@"KrabiProvince" code:@"U2.003" par:@"68/2502" type:@"ป่าสงวนแห่งชาติ" province:@"ยะลา" date:@"26 เมษายน 2503" url:@"U2.003-2503.PDF" date_no:@"ครั้งที่ 1" area:@"6392542.49926" area_rai:@"6281.25" ]; [self.YalaProvinces addObject:YalaProvince];
    YalaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาใหญ่" provinceE:@"KrabiProvince" code:@"U2.005" par:@"162/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ยะลา" date:@"27 ธันวาคม 2509" url:@"U2.005-2509.PDF" date_no:@"ครั้งที่ 1" area:@"34138999.3391" area_rai:@"23750" ]; [self.YalaProvinces addObject:YalaProvince];
    YalaProvince = [[ItemGuide alloc] initWithName:@"ป่าจะกว๊ะ" provinceE:@"KrabiProvince" code:@"U2.011" par:@"1166/2529" type:@"ป่าสงวนแห่งชาติ" province:@"ยะลา" date:@"5 มิถุนายน 2529" url:@"U2.011-2529.PDF" date_no:@"ครั้งที่ 1" area:@"28306440.2994" area_rai:@"17451" ]; [self.YalaProvinces addObject:YalaProvince];
    YalaProvince = [[ItemGuide alloc] initWithName:@"ป่าตันหยงกาลอ" provinceE:@"KrabiProvince" code:@"U2.002" par:@"64/2507" type:@"ป่าสงวนแห่งชาติ" province:@"ยะลา" date:@"26 เมษายน 2503" url:@"U2.002-2503.PDF" date_no:@"ครั้งที่ 1" area:@"11460722.665" area_rai:@"7187.5" ]; [self.YalaProvinces addObject:YalaProvince];
    YalaProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขากาลอ" provinceE:@"KrabiProvince" code:@"U2.010" par:@"1150/2529" type:@"ป่าสงวนแห่งชาติ" province:@"ยะลา" date:@"16 เมษายน 2529" url:@"U2.010-2529.PDF" date_no:@"ครั้งที่ 1" area:@"67804994.8578" area_rai:@"41719" ]; [self.YalaProvinces addObject:YalaProvince];
    YalaProvince = [[ItemGuide alloc] initWithName:@"ป่าบูกิ๊ตตำมะซู และป่าบูกิ๊ตกือแล" provinceE:@"KrabiProvince" code:@"U2.006" par:@"182/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ยะลา" date:@"31 ธันวาคม 2509" url:@"U2.006-2509.PDF" date_no:@"ครั้งที่ 1" area:@"437044.666594" area_rai:@"275" ]; [self.YalaProvinces addObject:YalaProvince];
    YalaProvince = [[ItemGuide alloc] initWithName:@"ป่าเบตง" provinceE:@"KrabiProvince" code:@"U2.004" par:@"65/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ยะลา" date:@"13 กรกฎาคม 2508" url:@"U2.004-2508.PDF" date_no:@"ครั้งที่ 1" area:@"279352415.885" area_rai:@"175000" ]; [self.YalaProvinces addObject:YalaProvince];
    YalaProvince = [[ItemGuide alloc] initWithName:@"ป่าลาก๊ะ" provinceE:@"KrabiProvince" code:@"U2.009" par:@"1142/2528" type:@"ป่าสงวนแห่งชาติ" province:@"ยะลา" date:@"11 ธันวาคม 2528" url:@"U2.009-2528.PDF" date_no:@"ครั้งที่ 1" area:@"19237434.3609" area_rai:@"11039" ]; [self.YalaProvinces addObject:YalaProvince];
    YalaProvince = [[ItemGuide alloc] initWithName:@"ป่าลาบู และป่าถ้ำทะลุ" provinceE:@"KrabiProvince" code:@"U2.007" par:@"191/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ยะลา" date:@"31 ธันวาคม 2509" url:@"U2.007-2509.PDF" date_no:@"ครั้งที่ 1" area:@"330560969.364" area_rai:@"208850" ]; [self.YalaProvinces addObject:YalaProvince];
    YalaProvince = [[ItemGuide alloc] initWithName:@"ป่าสกายอกุวิง" provinceE:@"KrabiProvince" code:@"U2.008" par:@"768/2518" type:@"ป่าสงวนแห่งชาติ" province:@"ยะลา" date:@"9 ธันวาคม 2518" url:@"U2.008-2518.PDF" date_no:@"ครั้งที่ 1" area:@"13985377.0863" area_rai:@"8125" ]; [self.YalaProvinces addObject:YalaProvince];
    self.RoiEtProvinces = [[NSMutableArray alloc] init];  ItemGuide *RoiEtProvince = [[ItemGuide alloc] initWithName:@"ป่าคำใหญ่และป่าคำขวาง" provinceE:@"KrabiProvince" code:@"F3.008" par:@"444/2514" type:@"ป่าสงวนแห่งชาติ" province:@"ร้อยเอ็ด" date:@"30 ธันวาคม 2514" url:@"F3.008-2514.PDF" date_no:@"ครั้งที่ 1" area:@"27587812.1782" area_rai:@"17431" ]; [self.RoiEtProvinces addObject:RoiEtProvince];
    RoiEtProvince = [[ItemGuide alloc] initWithName:@"ป่าดงขี้เหล็ก" provinceE:@"KrabiProvince" code:@"F3.004" par:@"130/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ร้อยเอ็ด" date:@"16 สิงหาคม 2509" url:@"F3.004-2509.PDF" date_no:@"ครั้งที่ 1" area:@"7988505.50865" area_rai:@"5506" ]; [self.RoiEtProvinces addObject:RoiEtProvince];
    RoiEtProvince = [[ItemGuide alloc] initWithName:@"ป่าดงภูเงินและป่าดงหนองฟ้า" provinceE:@"KrabiProvince" code:@"F3.007" par:@"427/2512" type:@"ป่าสงวนแห่งชาติ" province:@"ร้อยเอ็ด" date:@"3 มิถุนายน 2512" url:@"F3.007-2512.PDF" date_no:@"ครั้งที่ 1" area:@"25432267.3455" area_rai:@"16787" ]; [self.RoiEtProvinces addObject:RoiEtProvince];
    RoiEtProvince = [[ItemGuide alloc] initWithName:@"ป่าดงมะอี่" provinceE:@"KrabiProvince" code:@"F3.009" par:@"815/2521" type:@"ป่าสงวนแห่งชาติ" province:@"ร้อยเอ็ด" date:@"14 พฤศจิกายน 2521" url:@"F3.009-2521.PDF" date_no:@"ครั้งที่ 1" area:@"534408973.014" area_rai:@"329491" ]; [self.RoiEtProvinces addObject:RoiEtProvince];
    RoiEtProvince = [[ItemGuide alloc] initWithName:@"ป่าดงแม่เผด" provinceE:@"KrabiProvince" code:@"F3.002" par:@"119/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ร้อยเอ็ด" date:@"28 มิถุนายน 2509" url:@"F3.002-2509.PDF" date_no:@"ครั้งที่ 1" area:@"74348724.7921" area_rai:@"49375" ]; [self.RoiEtProvinces addObject:RoiEtProvince];
    RoiEtProvince = [[ItemGuide alloc] initWithName:@"ป่าดงหนองกล้า" provinceE:@"KrabiProvince" code:@"F3.003" par:@"122/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ร้อยเอ็ด" date:@"16 สิงหาคม 2509" url:@"F3.003-2509.PDF" date_no:@"ครั้งที่ 1" area:@"10198767.4146" area_rai:@"6562" ]; [self.RoiEtProvinces addObject:RoiEtProvince];
    RoiEtProvince = [[ItemGuide alloc] initWithName:@"ป่าดงหันและป่าโคกสูง" provinceE:@"KrabiProvince" code:@"F3.005" par:@"539/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ร้อยเอ็ด" date:@"10 กรกฎาคม 2516" url:@"F3.005-2516.PDF" date_no:@"ครั้งที่ 2" area:@"15765416.4677" area_rai:@"9287" ]; [self.RoiEtProvinces addObject:RoiEtProvince];
    RoiEtProvince = [[ItemGuide alloc] initWithName:@"ป่าเป็ดก่า" provinceE:@"KrabiProvince" code:@"F3.001" par:@"96/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ร้อยเอ็ด" date:@"31 ธันวาคม 2508" url:@"F3.001-2508.PDF" date_no:@"ครั้งที่ 1" area:@"23436536.563" area_rai:@"14456" ]; [self.RoiEtProvinces addObject:RoiEtProvince];
    RoiEtProvince = [[ItemGuide alloc] initWithName:@"ป่าไม้ล้มและป่าโคกหนองบั่ว" provinceE:@"KrabiProvince" code:@"F3.010" par:@"821/2521" type:@"ป่าสงวนแห่งชาติ" province:@"ร้อยเอ็ด" date:@"26 ธันวาคม 2521" url:@"F3.010-2521.PDF" date_no:@"ครั้งที่ 1" area:@"23531751.6741" area_rai:@"21350" ]; [self.RoiEtProvinces addObject:RoiEtProvince];
    RoiEtProvince = [[ItemGuide alloc] initWithName:@"ป่าอุโมงและป่าหนองแวง" provinceE:@"KrabiProvince" code:@"F3.006" par:@"797/2521" type:@"ป่าสงวนแห่งชาติ" province:@"ร้อยเอ็ด" date:@"6 มิถุนายน 2521" url:@"F3.006-2521.PDF" date_no:@"ครั้งที่ 2" area:@"15228792.9112" area_rai:@"9062" ]; [self.RoiEtProvinces addObject:RoiEtProvince];
    self.RanongProvinces = [[NSMutableArray alloc] init];  ItemGuide *RanongProvince = [[ItemGuide alloc] initWithName:@"ป่ากะเปอร์" provinceE:@"KrabiProvince" code:@"R2.011" par:@"1169/2529" type:@"ป่าสงวนแห่งชาติ" province:@"ระนอง" date:@"5 มิถุนายน 2529" url:@"R2.011-2529.PDF" date_no:@"ครั้งที่ 1" area:@"430802432.854" area_rai:@"256000" ]; [self.RanongProvinces addObject:RanongProvince];
    RanongProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะช้าง" provinceE:@"KrabiProvince" code:@"R2.006" par:@"624/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ระนอง" date:@"21 ธันวาคม 2516" url:@"R2.006-2516.PDF" date_no:@"ครั้งที่ 1" area:@"19995147.3339" area_rai:@"12434" ]; [self.RanongProvinces addObject:RanongProvince];
    RanongProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะพะยาม" provinceE:@"KrabiProvince" code:@"R2.007" par:@"625/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ระนอง" date:@"21 ธันวาคม 2516" url:@"R2.007-2516.PDF" date_no:@"ครั้งที่ 1" area:@"16327428.3309" area_rai:@"10875" ]; [self.RanongProvinces addObject:RanongProvince];
    RanongProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาน้ำตกหงาว" provinceE:@"KrabiProvince" code:@"R2.002" par:@"13/2501" type:@"ป่าสงวนแห่งชาติ" province:@"ระนอง" date:@"29 เมษายน 2501" url:@"R2.002-2501.PDF" date_no:@"ครั้งที่ 1" area:@"3285128.65145" area_rai:@"1831.25" ]; [self.RanongProvinces addObject:RanongProvince];
    RanongProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองลำเลียง-ละอุ่น" provinceE:@"KrabiProvince" code:@"R2.001" par:@"71/27/2497" type:@"ป่าสงวนแห่งชาติ" province:@"ระนอง" date:@"27 เมษายน 2497" url:@"R2.001-2497.PDF" date_no:@"ครั้งที่ 1" area:@"45350227.3142" area_rai:@"27643" ]; [self.RanongProvinces addObject:RanongProvince];
    RanongProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองเส็ตกวด ป่าเขาหินช้าง และป่าเขาสามแหลม" provinceE:@"KrabiProvince" code:@"R2.004" par:@"14/2507" type:@"ป่าสงวนแห่งชาติ" province:@"ระนอง" date:@"31 ธันวาคม 2507" url:@"R2.004-2507.PDF" date_no:@"ครั้งที่ 1" area:@"30022582.7161" area_rai:@"19412" ]; [self.RanongProvinces addObject:RanongProvince];
    RanongProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองหัวเขียว และป่าคลองเกาะสุย" provinceE:@"KrabiProvince" code:@"R2.005" par:@"164/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ระนอง" date:@"27 ธันวาคม 2509" url:@"R2.005-2509.PDF" date_no:@"ครั้งที่ 1" area:@"125108666.155" area_rai:@"77031" ]; [self.RanongProvinces addObject:RanongProvince];
    RanongProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองหินกอง และป่าคลองม่วงกลวง" provinceE:@"KrabiProvince" code:@"R2.008" par:@"1056/2527" type:@"ป่าสงวนแห่งชาติ" province:@"ระนอง" date:@"24 สิงหาคม 2527" url:@"R2.008-2527.PDF" date_no:@"ครั้งที่ 1" area:@"117680783.425" area_rai:@"72712.25" ]; [self.RanongProvinces addObject:RanongProvince];
    RanongProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำขาว" provinceE:@"KrabiProvince" code:@"R2.010" par:@"1165/2529" type:@"ป่าสงวนแห่งชาติ" province:@"ระนอง" date:@"5 มิถุนายน 2529" url:@"R2.010-2529.PDF" date_no:@"ครั้งที่ 1" area:@"274679139.123" area_rai:@"164521" ]; [self.RanongProvinces addObject:RanongProvince];
    RanongProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำจืด ป่ามะมุ และป่าปากจั่น" provinceE:@"KrabiProvince" code:@"R2.009" par:@"1159/2529" type:@"ป่าสงวนแห่งชาติ" province:@"ระนอง" date:@"5 มิถุนายน 2529" url:@"R2.009-2529.PDF" date_no:@"ครั้งที่ 1" area:@"125237264.711" area_rai:@"76513" ]; [self.RanongProvinces addObject:RanongProvince];
    RanongProvince = [[ItemGuide alloc] initWithName:@"ป่าละอุ่น และป่าราชกรูด" provinceE:@"KrabiProvince" code:@"R2.013" par:@"1200/2530" type:@"ป่าสงวนแห่งชาติ" province:@"ระนอง" date:@"27 มีนาคม 2530" url:@"R2.013-2530.PDF" date_no:@"ครั้งที่ 1" area:@"702525404.738" area_rai:@"429922" ]; [self.RanongProvinces addObject:RanongProvince];
    RanongProvince = [[ItemGuide alloc] initWithName:@"ป่าลำเลียง" provinceE:@"KrabiProvince" code:@"R2.012" par:@"1173/2529" type:@"ป่าสงวนแห่งชาติ" province:@"ระนอง" date:@"3 กรกฎาคม 2529" url:@"R2.012-2529.PDF" date_no:@"ครั้งที่ 1" area:@"238573670.568" area_rai:@"143406" ]; [self.RanongProvinces addObject:RanongProvince];
    RanongProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนคลองม่วงกลวงและป่าแหลมหน้าทุ่ง" provinceE:@"KrabiProvince" code:@"R2.003" par:@"1064/2527" type:@"ป่าสงวนแห่งชาติ" province:@"ระนอง" date:@"6 กันยายน 2527" url:@"R2.003-2527.PDF" date_no:@"ครั้งที่ 2" area:@"168181557.095" area_rai:@"100000" ]; [self.RanongProvinces addObject:RanongProvince];
    self.RayongProvinces = [[NSMutableArray alloc] init];  ItemGuide *RayongProvince = [[ItemGuide alloc] initWithName:@"ป่ากะเฉด ป่าเพ และป่าแกลง" provinceE:@"KrabiProvince" code:@"B2.007" par:@"36/2507" type:@"ป่าสงวนแห่งชาติ" province:@"ระยอง" date:@"31 ธันวาคม 2507" url:@"B2.007-2507.PDF" date_no:@"ครั้งที่ 1" area:@"52256258.5828" area_rai:@"28937" ]; [self.RayongProvinces addObject:RayongProvince];
    RayongProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาห้วยมะหาด ป่าเขานั่งยอง และป่าเขาครอก" provinceE:@"KrabiProvince" code:@"B2.011" par:@"1018/2526" type:@"ป่าสงวนแห่งชาติ" province:@"ระยอง" date:@"6 ธันวาคม 2526" url:@"B2.011-2526.PDF" date_no:@"ครั้งที่ 1" area:@"29803744.7014" area_rai:@"17811" ]; [self.RayongProvinces addObject:RayongProvince];
    RayongProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองระเวิง และป่าเขาสมเส็ด" provinceE:@"KrabiProvince" code:@"B2.003" par:@"1156/2529" type:@"ป่าสงวนแห่งชาติ" province:@"ระยอง" date:@"16 เมษายน 2529" url:@"B2.003-2529.PDF" date_no:@"ครั้งที่ 2" area:@"231172592.282" area_rai:@"137500" ]; [self.RayongProvinces addObject:RayongProvince];
    RayongProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านนา และป่าทุ่งควายกิน" provinceE:@"KrabiProvince" code:@"B2.006" par:@"18/2507" type:@"ป่าสงวนแห่งชาติ" province:@"ระยอง" date:@"31 ธันวาคม 2507" url:@"B2.006-2507.PDF" date_no:@"ครั้งที่ 1" area:@"529018517.168" area_rai:@"313500" ]; [self.RayongProvinces addObject:RayongProvince];
    RayongProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านเพ" provinceE:@"KrabiProvince" code:@"B2.002" par:@"39/2502" type:@"ป่าสงวนแห่งชาติ" province:@"ระยอง" date:@"14 กรกฎาคม 2502" url:@"B2.002-2502.PDF" date_no:@"ครั้งที่ 1" area:@"974131.745074" area_rai:@"625" ]; [self.RayongProvinces addObject:RayongProvince];
    RayongProvince = [[ItemGuide alloc] initWithName:@"ป่าภูเขาหินตั้ง" provinceE:@"KrabiProvince" code:@"B2.009" par:@"831/2522" type:@"ป่าสงวนแห่งชาติ" province:@"ระยอง" date:@"27 มีนาคม 2522" url:@"B2.009-2522.PDF" date_no:@"ครั้งที่ 1" area:@"8838005.28809" area_rai:@"5700" ]; [self.RayongProvinces addObject:RayongProvince];
    RayongProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนประแส และป่าพังราด" provinceE:@"KrabiProvince" code:@"B2.001" par:@"36/2501" type:@"ป่าสงวนแห่งชาติ" province:@"ระยอง" date:@"21 ตุลาคม 2501" url:@"B2.001-2501.PDF" date_no:@"ครั้งที่ 1" area:@"15445434.5561" area_rai:@"9090" ]; [self.RayongProvinces addObject:RayongProvince];
    RayongProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองสนม" provinceE:@"KrabiProvince" code:@"B2.005" par:@"143/2505" type:@"ป่าสงวนแห่งชาติ" province:@"ระยอง" date:@"11 ธันวาคม 2505" url:@"B2.005-2505.PDF" date_no:@"ครั้งที่ 1" area:@"1007246.07186" area_rai:@"580" ]; [self.RayongProvinces addObject:RayongProvince];
    self.RatchaburiProvinces = [[NSMutableArray alloc] init];  ItemGuide *RatchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขากรวด และป่าเขาพลอง" provinceE:@"KrabiProvince" code:@"P1.001" par:@"7/2499" type:@"ป่าสงวนแห่งชาติ" province:@"ราชบุรี" date:@"4 กันยายน 2499" url:@"P1.001-2499.PDF" date_no:@"ครั้งที่ 1" area:@"7363571.33728" area_rai:@"4787.5" ]; [self.RatchaburiProvinces addObject:RatchaburiProvince];
    RatchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาบิน" provinceE:@"KrabiProvince" code:@"P1.003" par:@"79/2504" type:@"ป่าสงวนแห่งชาติ" province:@"ราชบุรี" date:@"31 ตุลาคม 2504" url:@"P1.003-2504.PDF" date_no:@"ครั้งที่ 1" area:@"32796497.6318" area_rai:@"21250" ]; [self.RatchaburiProvinces addObject:RatchaburiProvince];
    RatchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าซำสาม" provinceE:@"KrabiProvince" code:@"P1.005" par:@"180/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ราชบุรี" date:@"31 ธันวาคม 2509" url:@"P1.005-2509.PDF" date_no:@"ครั้งที่ 1" area:@"4663188.99707" area_rai:@"2625" ]; [self.RatchaburiProvinces addObject:RatchaburiProvince];
    RatchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าฝั่งซ้ายแม่น้ำภาชี" provinceE:@"KrabiProvince" code:@"P1.007" par:@"1069/2527" type:@"ป่าสงวนแห่งชาติ" province:@"ราชบุรี" date:@"8 พฤศจิกายน 2527" url:@"P1.007-2527.PDF" date_no:@"ครั้งที่ 1" area:@"1647796700.59" area_rai:@"977250" ]; [self.RatchaburiProvinces addObject:RatchaburiProvince];
    RatchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าพุยาง และป่าพุสามซ้อน" provinceE:@"KrabiProvince" code:@"P1.004" par:@"125/2505" type:@"ป่าสงวนแห่งชาติ" province:@"ราชบุรี" date:@"30 ตุลาคม 2505" url:@"P1.004-2505.PDF" date_no:@"ครั้งที่ 1" area:@"135633024.753" area_rai:@"87656.25" ]; [self.RatchaburiProvinces addObject:RatchaburiProvince];
    RatchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่ายางด่านทับตะโก" provinceE:@"KrabiProvince" code:@"P1.002" par:@"62/2502" type:@"ป่าสงวนแห่งชาติ" province:@"ราชบุรี" date:@"26 เมษายน 2503" url:@"P1.002-2503.PDF" date_no:@"ครั้งที่ 1" area:@"53638558.2616" area_rai:@"71875" ]; [self.RatchaburiProvinces addObject:RatchaburiProvince];
    RatchaburiProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองกลางเนิน" provinceE:@"KrabiProvince" code:@"P1.006" par:@"181/2509" type:@"ป่าสงวนแห่งชาติ" province:@"ราชบุรี" date:@"31 ธันวาคม 2509" url:@"P1.006-2509.PDF" date_no:@"ครั้งที่ 1" area:@"199978.931126" area_rai:@"150" ]; [self.RatchaburiProvinces addObject:RatchaburiProvince];
    self.LopburiProvinces = [[NSMutableArray alloc] init];  ItemGuide *LopburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาเพนียด" provinceE:@"KrabiProvince" code:@"A3.004" par:@"1193/2529" type:@"ป่าสงวนแห่งชาติ" province:@"ลพบุรี" date:@"31 ธันวาคม 2529" url:@"A3.004-2529.PDF" date_no:@"ครั้งที่ 1" area:@"31110689.5903" area_rai:@"17477" ]; [self.LopburiProvinces addObject:LopburiProvince];
    LopburiProvince = [[ItemGuide alloc] initWithName:@"ป่าชัยบาดาล" provinceE:@"KrabiProvince" code:@"A3.001" par:@"1083/2527" type:@"ป่าสงวนแห่งชาติ" province:@"ลพบุรี" date:@"6 ธันวาคม 2527" url:@"A3.001-2527.PDF" date_no:@"ครั้งที่ 3" area:@"624888983.906" area_rai:@"396562" ]; [self.LopburiProvinces addObject:LopburiProvince];
    LopburiProvince = [[ItemGuide alloc] initWithName:@"ป่าซับลังกา" provinceE:@"KrabiProvince" code:@"A3.002" par:@"66/2502" type:@"ป่าสงวนแห่งชาติ" province:@"ลพบุรี" date:@"26 เมษายน 2502" url:@"A3.002-2502.PDF" date_no:@"ครั้งที่ 1" area:@"459704420.976" area_rai:@"248987.5" ]; [self.LopburiProvinces addObject:LopburiProvince];
    LopburiProvince = [[ItemGuide alloc] initWithName:@"ป่าวังเพลิง ป่าม่วงค่อมและป่าลำนารายณ์" provinceE:@"KrabiProvince" code:@"A3.003" par:@"397/2512" type:@"ป่าสงวนแห่งชาติ" province:@"ลพบุรี" date:@"25 กุมภาพันธ์ 2512" url:@"A3.003-2512.PDF" date_no:@"ครั้งที่ 1" area:@"742040713.885" area_rai:@"447082" ]; [self.LopburiProvinces addObject:LopburiProvince];
    self.LampangProvinces = [[NSMutableArray alloc] init];  ItemGuide *LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าขุนวัง แปลงที่สอง" provinceE:@"KrabiProvince" code:@"I1.029" par:@"1078/2527" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"6 ธันวาคม 2527" url:@"I1.029-2527.PDF" date_no:@"ครั้งที่ 1" area:@"305407890.89" area_rai:@"191538" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าขุนวัง แปลงที่สาม" provinceE:@"KrabiProvince" code:@"I1.032" par:@"1110/2528" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"19 มิถุนายน 2528" url:@"I1.032-2528.PDF" date_no:@"ครั้งที่ 1" area:@"290669258.997" area_rai:@"179395" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าขุนวัง แปลงที่หนึ่ง" provinceE:@"KrabiProvince" code:@"I1.024" par:@"935/2524" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"1 มิถุนายน 2524" url:@"I1.024-2524.PDF" date_no:@"ครั้งที่ 1" area:@"280362264.095" area_rai:@"164234" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าดอยขุนตาล" provinceE:@"KrabiProvince" code:@"I1.008" par:@"496/2515" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"5 ธันวาคม 2515" url:@"I1.008-2515.PDF" date_no:@"ครั้งที่ 2" area:@"195337849.713" area_rai:@"120350" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่งาวฝั่งขวา" provinceE:@"KrabiProvince" code:@"I1.017" par:@"722/2518" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"18 กุมภาพันธ์ 2518" url:@"I1.017-2518.PDF" date_no:@"ครั้งที่ 1" area:@"693900700" area_rai:@"104187" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่งาวฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"I1.011" par:@"518/2515" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"30 ธันวาคม 2515" url:@"I1.011-2515.PDF" date_no:@"ครั้งที่ 1" area:@"425761798.585" area_rai:@"294000" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่จาง" provinceE:@"KrabiProvince" code:@"I1.003" par:@"102/2505" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"24 กรกฎาคม 2505" url:@"I1.003-2505.PDF" date_no:@"ครั้งที่ 1" area:@"167226721.888" area_rai:@"106968.75" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่จาง (ตอนขุน)" provinceE:@"KrabiProvince" code:@"I1.010" par:@"499/2515" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"12 ธันวาคม 2515" url:@"I1.010-2515.PDF" date_no:@"ครั้งที่ 1" area:@"270499503.069" area_rai:@"215000" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่จางใต้ฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"I1.014" par:@"610/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"4 ธันวาคม 2516" url:@"I1.014-2516.PDF" date_no:@"ครั้งที่ 1" area:@"214936589.802" area_rai:@"122400" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่จางฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"I1.019" par:@"747/2518" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"8 กรกฎาคม 2518" url:@"I1.019-2518.PDF" date_no:@"ครั้งที่ 1" area:@"283413066.193" area_rai:@"67312" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่แจ้ฟ้า" provinceE:@"KrabiProvince" code:@"I1.012" par:@"552/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"31 กรกฎาคม 2516" url:@"I1.012-2516.PDF" date_no:@"ครั้งที่ 1" area:@"293607421.181" area_rai:@"168521" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ตั๋ง" provinceE:@"KrabiProvince" code:@"I1.002" par:@"94/2505" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"19 มิถุนายน 2505" url:@"I1.002-2505.PDF" date_no:@"ครั้งที่ 1" area:@"77611.5128417" area_rai:@"56.25" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ต๋าและป่าแม่มาย" provinceE:@"KrabiProvince" code:@"I1.020" par:@"767/2518" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"9 ธันวาคม 2518" url:@"I1.020-2518.PDF" date_no:@"ครั้งที่ 1" area:@"467111028.93" area_rai:@"242000" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ตุ๋ยฝั่งขวา" provinceE:@"KrabiProvince" code:@"I1.025" par:@"954/2524" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"27 กันยายน 2524" url:@"I1.025-2524.PDF" date_no:@"ครั้งที่ 1" area:@"348206568.257" area_rai:@"76000" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ตุ๋ยฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"I1.033" par:@"1189/2529" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"8 ธันวาคม 2529" url:@"I1.033-2529.PDF" date_no:@"ครั้งที่ 1" area:@"117559338.728" area_rai:@"75560" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ทรายคำ" provinceE:@"KrabiProvince" code:@"I1.006" par:@"79/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"19 ตุลาคม 2508" url:@"I1.006-2508.PDF" date_no:@"ครั้งที่ 1" area:@"209109515.447" area_rai:@"140625" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ทาน" provinceE:@"KrabiProvince" code:@"I1.030" par:@"1080/2527" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"6 ธันวาคม 2527" url:@"I1.030-2527.PDF" date_no:@"ครั้งที่ 1" area:@"178238650.461" area_rai:@"108125" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ปราบ" provinceE:@"KrabiProvince" code:@"I1.027" par:@"1053/2527" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"24 สิงหาคม 2527" url:@"I1.027-2527.PDF" date_no:@"ครั้งที่ 1" area:@"140420253.149" area_rai:@"84843" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ป้าย" provinceE:@"KrabiProvince" code:@"I1.001" par:@"738/2518" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"20 พฤษภาคม 2518" url:@"I1.001-2518.PDF" date_no:@"ครั้งที่ 2" area:@"22883018.1516" area_rai:@"26860" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่โป่ง" provinceE:@"KrabiProvince" code:@"I1.023" par:@"866/2522" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"1 ตุลาคม 2522" url:@"I1.023-2522.PDF" date_no:@"ครั้งที่ 1" area:@"429320052.242" area_rai:@"250306" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่พริก" provinceE:@"KrabiProvince" code:@"I1.009" par:@"466/2515" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"31 ตุลาคม 2515" url:@"I1.009-2515.PDF" date_no:@"ครั้งที่ 1" area:@"459289433.014" area_rai:@"203130" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่มอก" provinceE:@"KrabiProvince" code:@"I1.031" par:@"1104/2528" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"2 พฤษภาคม 2528" url:@"I1.031-2528.PDF" date_no:@"ครั้งที่ 1" area:@"779336602.052" area_rai:@"486094" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่เมาะ" provinceE:@"KrabiProvince" code:@"I1.007" par:@"950/2524" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"12 พฤศจิกายน 2550" url:@"I1.007-2550.PDF" date_no:@"ครั้งที่ 3" area:@"287415131.476" area_rai:@"181913" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ยางและป่าแม่อาง" provinceE:@"KrabiProvince" code:@"I1.016" par:@"692/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"13 สิงหาคม 2517" url:@"I1.016-2517.PDF" date_no:@"ครั้งที่ 1" area:@"290903270.294" area_rai:@"262500" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ยาว" provinceE:@"KrabiProvince" code:@"I1.026" par:@"973/2525" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"1 สิงหาคม 2525" url:@"I1.026-2525.PDF" date_no:@"ครั้งที่ 1" area:@"338154182.278" area_rai:@"84812" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่เรียง" provinceE:@"KrabiProvince" code:@"I1.018" par:@"739/2518" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"6 มิถุนายน 2518" url:@"I1.018-2518.PDF" date_no:@"ครั้งที่ 1" area:@"361056601.314" area_rai:@"235494" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่เลิมและป่าแม่ปะ" provinceE:@"KrabiProvince" code:@"I1.005" par:@"209/2507" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"10 มีนาคม 2507" url:@"I1.005-2507.PDF" date_no:@"ครั้งที่ 1" area:@"243922027.53" area_rai:@"142625" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่วะ" provinceE:@"KrabiProvince" code:@"I1.022" par:@"799/2521" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"6 มิถุนายน 2521" url:@"I1.022-2521.PDF" date_no:@"ครั้งที่ 1" area:@"238089511.221" area_rai:@"96875" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่สะเลียม" provinceE:@"KrabiProvince" code:@"I1.004" par:@"104/2505" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"24 กรกฎาคม 2505" url:@"I1.004-2505.PDF" date_no:@"ครั้งที่ 1" area:@"62165080.0885" area_rai:@"40625" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่สุกและป่าแม่สอย" provinceE:@"KrabiProvince" code:@"I1.013" par:@"560/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"14 สิงหาคม 2516" url:@"I1.013-2516.PDF" date_no:@"ครั้งที่ 1" area:@"659366656.573" area_rai:@"395000" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่เสริม" provinceE:@"KrabiProvince" code:@"I1.021" par:@"772/2518" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"5 กุมภาพันธ์ 2519" url:@"I1.021-2519.PDF" date_no:@"ครั้งที่ 1" area:@"335051271.219" area_rai:@"213250" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่อาบ" provinceE:@"KrabiProvince" code:@"I1.028" par:@"1066/2527" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"8 พฤศจิกายน 2527" url:@"I1.028-2527.PDF" date_no:@"ครั้งที่ 1" area:@"278032583.944" area_rai:@"168750" ]; [self.LampangProvinces addObject:LampangProvince];
    LampangProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ไฮ" provinceE:@"KrabiProvince" code:@"I1.015" par:@"620/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ลำปาง" date:@"21 ธันวาคม 2516" url:@"I1.015-2516.PDF" date_no:@"ครั้งที่ 1" area:@"82244673.7509" area_rai:@"53125" ]; [self.LampangProvinces addObject:LampangProvince];
    self.LamphunProvinces = [[NSMutableArray alloc] init];  ItemGuide *LamphunProvince = [[ItemGuide alloc] initWithName:@"ป่าขุนแม่ลี้" provinceE:@"KrabiProvince" code:@"K2.007" par:@"457/2515" type:@"ป่าสงวนแห่งชาติ" province:@"ลำพูน" date:@"20 มิถุนายน 2515" url:@"K2.007-2515.PDF" date_no:@"ครั้งที่ 1" area:@"372560751.857" area_rai:@"273750" ]; [self.LamphunProvinces addObject:LamphunProvince];
    LamphunProvince = [[ItemGuide alloc] initWithName:@"ป่าดอยขุนตาล" provinceE:@"KrabiProvince" code:@"K2.003" par:@"166/2506" type:@"ป่าสงวนแห่งชาติ" province:@"ลำพูน" date:@"13 สิงหาคม 2506" url:@"K2.003-2506.PDF" date_no:@"ครั้งที่ 1" area:@"63888303.6335" area_rai:@"39206.25" ]; [self.LamphunProvinces addObject:LamphunProvince];
    LamphunProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านโฮ่ง" provinceE:@"KrabiProvince" code:@"K2.004" par:@"202/2507" type:@"ป่าสงวนแห่งชาติ" province:@"ลำพูน" date:@"3 มีนาคม 2507" url:@"K2.004-2507.PDF" date_no:@"ครั้งที่ 1" area:@"352978023.697" area_rai:@"202812.5" ]; [self.LamphunProvinces addObject:LamphunProvince];
    LamphunProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ตืน และป่าแม่แนต" provinceE:@"KrabiProvince" code:@"K2.006" par:@"773/2518" type:@"ป่าสงวนแห่งชาติ" province:@"ลำพูน" date:@"24 กุมภาพันธ์ 2519" url:@"K2.006-2519.PDF" date_no:@"ครั้งที่ 2" area:@"440255945.285" area_rai:@"294350" ]; [self.LamphunProvinces addObject:LamphunProvince];
    LamphunProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ทา" provinceE:@"KrabiProvince" code:@"K2.005" par:@"55/2508" type:@"ป่าสงวนแห่งชาติ" province:@"ลำพูน" date:@"25 พฤษภาคม 2508" url:@"K2.005-2508.PDF" date_no:@"ครั้งที่ 1" area:@"602880949.365" area_rai:@"392250" ]; [self.LamphunProvinces addObject:LamphunProvince];
    LamphunProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ธิ แม่ตีบ แม่สาร" provinceE:@"KrabiProvince" code:@"K2.001" par:@"83/2505" type:@"ป่าสงวนแห่งชาติ" province:@"ลำพูน" date:@"27 มีนาคม 2505" url:@"K2.001-2505.PDF" date_no:@"ครั้งที่ 1" area:@"207168577.286" area_rai:@"119375" ]; [self.LamphunProvinces addObject:LamphunProvince];
    LamphunProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ลี้" provinceE:@"KrabiProvince" code:@"K2.008" par:@"796/2521" type:@"ป่าสงวนแห่งชาติ" province:@"ลำพูน" date:@"6 มิถุนายน 2521" url:@"K2.008-2521.PDF" date_no:@"ครั้งที่ 2" area:@"320713680.492" area_rai:@"167032" ]; [self.LamphunProvinces addObject:LamphunProvince];
    LamphunProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่หาด และป่าแม่ก้อ" provinceE:@"KrabiProvince" code:@"K2.009" par:@"748/2518" type:@"ป่าสงวนแห่งชาติ" province:@"ลำพูน" date:@"8 กรกฎาคม 2518" url:@"K2.009-2518.PDF" date_no:@"ครั้งที่ 1" area:@"713143324.808" area_rai:@"275000" ]; [self.LamphunProvinces addObject:LamphunProvince];
    LamphunProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่อาว" provinceE:@"KrabiProvince" code:@"K2.002" par:@"160/2506" type:@"ป่าสงวนแห่งชาติ" province:@"ลำพูน" date:@"15 มีนาคม 2506" url:@"K2.002-2506.PDF" date_no:@"ครั้งที่ 1" area:@"93925814.5195" area_rai:@"53606.25" ]; [self.LamphunProvinces addObject:LamphunProvince];
    LamphunProvince = [[ItemGuide alloc] initWithName:@"ป่าเหมืองจี้ และป่าสันป่าสัก" provinceE:@"KrabiProvince" code:@"K2.010" par:@"830/2522" type:@"ป่าสงวนแห่งชาติ" province:@"ลำพูน" date:@"27 มีนาคม 2522" url:@"K2.010-2522.PDF" date_no:@"ครั้งที่ 1" area:@"20428003.4952" area_rai:@"12656" ]; [self.LamphunProvinces addObject:LamphunProvince];
    self.LoeiProvinces = [[NSMutableArray alloc] init];  ItemGuide *LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกผาดำ ป่าโคกหนองข่า และป่าภูบอบิด" provinceE:@"KrabiProvince" code:@"G5.007" par:@"561/2516" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"14 สิงหาคม 2516" url:@"G5.007-2516.PDF" date_no:@"ครั้งที่ 2" area:@"670263709.704" area_rai:@"402688" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกภูเหล็ก" provinceE:@"KrabiProvince" code:@"G5.013" par:@"749/2518" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"18 กรกฎาคม 2518" url:@"G5.013-2518.PDF" date_no:@"ครั้งที่ 1" area:@"712466651.705" area_rai:@"478125" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกหินนกยูง" provinceE:@"KrabiProvince" code:@"G5.001" par:@"111/2509" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"28 มิถุนายน 2509" url:@"G5.001-2509.PDF" date_no:@"ครั้งที่ 1" area:@"29950513.2705" area_rai:@"19968" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกใหญ่" provinceE:@"KrabiProvince" code:@"G5.003" par:@"129/2509" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"16 สิงหาคม 2509" url:@"G5.003-2509.PDF" date_no:@"ครั้งที่ 1" area:@"66556312.3613" area_rai:@"41600" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าดงขุนแคม ป่าโคกใหญ่ ป่าภูผาแง่ม และป่าลาดค่าง" provinceE:@"KrabiProvince" code:@"G5.018" par:@"928/2524" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"8 มีนาคม 2524" url:@"G5.018-2524.PDF" date_no:@"ครั้งที่ 1" area:@"567392629.028" area_rai:@"340019" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าดงซำทอง ป่าดงหนองไผ่ และป่าดงผาสามยอด" provinceE:@"KrabiProvince" code:@"G5.004" par:@"139/2509" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"18 ตุลาคม 2509" url:@"G5.004-2509.PDF" date_no:@"ครั้งที่ 1" area:@"369016517.092" area_rai:@"223100" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าดงซำผักคาด" provinceE:@"KrabiProvince" code:@"G5.020" par:@"1062/2527" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"6 กันยายน 2527" url:@"G5.020-2527.PDF" date_no:@"ครั้งที่ 1" area:@"8721605.11643" area_rai:@"5391" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าดงซำแม่นาง" provinceE:@"KrabiProvince" code:@"G5.009" par:@"521/2515" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"30 ธันวาคม 2515" url:@"G5.009-2515.PDF" date_no:@"ครั้งที่ 2" area:@"34757790.9208" area_rai:@"22000" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าภูเขาแก้วและป่าดงปากชม" provinceE:@"KrabiProvince" code:@"G5.014" par:@"750/2518" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"18 กรกฎาคม 2518" url:@"G5.014-2518.PDF" date_no:@"ครั้งที่ 1" area:@"1128341224.38" area_rai:@"853500" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าภูค้อและป่าภูกระแต" provinceE:@"KrabiProvince" code:@"G5.017" par:@"897/2523" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"1 พฤศจิกายน 2523" url:@"G5.017-2523.PDF" date_no:@"ครั้งที่ 1" area:@"360383463.62" area_rai:@"231250" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าภูช้างและป่าภูนกกก" provinceE:@"KrabiProvince" code:@"G5.005" par:@"150/2509" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"22 พฤศจิกายน 2509" url:@"G5.005-2509.PDF" date_no:@"ครั้งที่ 1" area:@"82396548.9278" area_rai:@"50812" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าภูเปือย" provinceE:@"KrabiProvince" code:@"G5.006" par:@"214/2510" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"1 กันยายน 2510" url:@"G5.006-2510.PDF" date_no:@"ครั้งที่ 1" area:@"71434330.4729" area_rai:@"45000" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าภูเปือย ป่าภูขี้เถ้า และป่าภูเรือ" provinceE:@"KrabiProvince" code:@"G5.019" par:@"1041/2527" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"31 พฤษภาคม 2527" url:@"G5.019-2527.PDF" date_no:@"ครั้งที่ 1" area:@"1517422718.26" area_rai:@"947000" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าภูผาขาว และป่าภูผายา" provinceE:@"KrabiProvince" code:@"G5.021" par:@"1101/2528" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"2 พฤษภาคม 2528" url:@"G5.021-2528.PDF" date_no:@"ครั้งที่ 1" area:@"205953485.073" area_rai:@"127500" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าภูหงส์" provinceE:@"KrabiProvince" code:@"G5.002" par:@"519/2515" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"30 ธันวาคม 2515" url:@"G5.002-2515.PDF" date_no:@"ครั้งที่ 2" area:@"34209835.07" area_rai:@"21193" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าภูหลวงและป่าภูหอ" provinceE:@"KrabiProvince" code:@"G5.011" par:@"643/2517" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"12 มีนาคม 2517" url:@"G5.011-2517.PDF" date_no:@"ครั้งที่ 1" area:@"370271618.043" area_rai:@"235937" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าภูห้วยปูน และป่าภูแผงม้า" provinceE:@"KrabiProvince" code:@"G5.012" par:@"697/2517" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"13 สิงหาคม 2517" url:@"G5.012-2517.PDF" date_no:@"ครั้งที่ 1" area:@"13328329.7358" area_rai:@"8002" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าภูห้วยหมาก ป่าภูทอก และป่าภูบ่อบิด" provinceE:@"KrabiProvince" code:@"G5.016" par:@"870/2522" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"26 ธันวาคม 2522" url:@"G5.016-2522.PDF" date_no:@"ครั้งที่ 1" area:@"150682077.995" area_rai:@"91662" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยส้มและป่าภูผาแดง" provinceE:@"KrabiProvince" code:@"G5.022" par:@"1206/2530" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"24 สิงหาคม 2530" url:@"G5.022-2530.PDF" date_no:@"ครั้งที่ 1" area:@"330585989.725" area_rai:@"204188" ]; [self.LoeiProvinces addObject:LoeiProvince];
    LoeiProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยอีเลิศ" provinceE:@"KrabiProvince" code:@"G5.008" par:@"412/2512" type:@"ป่าสงวนแห่งชาติ" province:@"เลย" date:@"8 เมษายน 2512" url:@"G5.008-2512.PDF" date_no:@"ครั้งที่ 1" area:@"12279853.7487" area_rai:@"3168" ]; [self.LoeiProvinces addObject:LoeiProvince];
    self.SisaketProvinces = [[NSMutableArray alloc] init];  ItemGuide *SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยทาและป่าห้วยขยุง" provinceE:@"KrabiProvince" code:@"E3.021" par:@"863/2522" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีษะเกษ" date:@"3 สิงหาคม 2522" url:@"E3.021-2522.PDF" date_no:@"ครั้งที่ 1" area:@"86415371.8197" area_rai:@"56606" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาพระวิหาร" provinceE:@"KrabiProvince" code:@"E3.017" par:@"1228/2533" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"13 กรกฎาคม 2533" url:@"E3.017-2533.PDF" date_no:@"ครั้งที่ 3" area:@"781897625.976" area_rai:@"482500" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าดงแดง" provinceE:@"KrabiProvince" code:@"E3.008" par:@"653/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"10 พฤษภาคม 2517" url:@"E3.008-2517.PDF" date_no:@"ครั้งที่ 1" area:@"12612754.7786" area_rai:@"7600" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าดงภู" provinceE:@"KrabiProvince" code:@"E3.009" par:@"656/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"10 พฤษภาคม 2517" url:@"E3.009-2517.PDF" date_no:@"ครั้งที่ 1" area:@"9673576.043" area_rai:@"5100" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าดงใหญ่" provinceE:@"KrabiProvince" code:@"E3.013" par:@"706/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"4 มิถุนายน 2517" url:@"E3.013-2517.PDF" date_no:@"ครั้งที่ 1" area:@"2102926.80178" area_rai:@"1287" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าดงใหญ่" provinceE:@"KrabiProvince" code:@"E3.015" par:@"677/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"20 สิงหาคม 2517" url:@"E3.015-2517.PDF" date_no:@"ครั้งที่ 1" area:@"5217426.85195" area_rai:@"2768" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าดงใหญ่" provinceE:@"KrabiProvince" code:@"E3.016" par:@"700/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"8 ตุลาคม 2517" url:@"E3.016-2517.PDF" date_no:@"ครั้งที่ 1" area:@"9735144.85924" area_rai:@"6500" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าแตงแซง" provinceE:@"KrabiProvince" code:@"E3.025" par:@"1047/2527" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"31 พฤษภาคม 2527" url:@"E3.025-2527.PDF" date_no:@"ครั้งที่ 1" area:@"15283615.6827" area_rai:@"9098" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าโนนจาน" provinceE:@"KrabiProvince" code:@"E3.011" par:@"665/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"10 พฤษภาคม 2517" url:@"E3.011-2517.PDF" date_no:@"ครั้งที่ 1" area:@"5635424.28948" area_rai:@"3550" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าโนนซาด" provinceE:@"KrabiProvince" code:@"E3.010" par:@"662/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"10 พฤษภาคม 2517" url:@"E3.010-2517.PDF" date_no:@"ครั้งที่ 1" area:@"5150147.90469" area_rai:@"3081" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าโนนทราย" provinceE:@"KrabiProvince" code:@"E3.020" par:@"841/2522" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"15 พฤษภาคม 2522" url:@"E3.020-2522.PDF" date_no:@"ครั้งที่ 1" area:@"5781393.29901" area_rai:@"4018" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าโนนลาน" provinceE:@"KrabiProvince" code:@"E3.005" par:@"436/2514" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"23 พฤศจิกายน 2514" url:@"E3.005-2514.PDF" date_no:@"ครั้งที่ 1" area:@"24865207.1813" area_rai:@"16050" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าโนนหัวภู" provinceE:@"KrabiProvince" code:@"E3.023" par:@"995/2525" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"26 ธันวาคม 2525" url:@"E3.023-2525.PDF" date_no:@"ครั้งที่ 1" area:@"8399693.16407" area_rai:@"5012" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านพอก" provinceE:@"KrabiProvince" code:@"E3.022" par:@"864/2522" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"1 ตุลาคม 2522" url:@"E3.022-2522.PDF" date_no:@"ครั้งที่ 1" area:@"6331323.9215" area_rai:@"3175" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านหนองม่วง" provinceE:@"KrabiProvince" code:@"E3.006" par:@"479/2515" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"14 พฤศจิกายน 2515" url:@"E3.006-2515.PDF" date_no:@"ครั้งที่ 1" area:@"75034006.8751" area_rai:@"45390" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าฝั่งขวาห้วยขยุง" provinceE:@"KrabiProvince" code:@"E3.012" par:@"669/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"10 พฤษภาคม 2517" url:@"E3.012-2517.PDF" date_no:@"ครั้งที่ 1" area:@"30796693.0224" area_rai:@"21960" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าฝั่งขวาห้วยทับทัน" provinceE:@"KrabiProvince" code:@"E3.002" par:@"303/2511" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"28 พฤษภาคม 2511" url:@"E3.002-2511.PDF" date_no:@"ครั้งที่ 1" area:@"73637857.8726" area_rai:@"44375" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าฝั่งขวาห้วยศาลา" provinceE:@"KrabiProvince" code:@"E3.007" par:@"607/2516" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"27 พฤศจิกายน 2516" url:@"E3.007-2516.PDF" date_no:@"ครั้งที่ 1" area:@"537858200.829" area_rai:@"317187" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่ายางชุมน้อยและป่าทุ่งมั่ง" provinceE:@"KrabiProvince" code:@"E3.024" par:@"1009/2526" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"15 กรกฎาคม 2526" url:@"E3.024-2526.PDF" date_no:@"ครั้งที่ 1" area:@"26133912.4524" area_rai:@"17772" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าสนบุสูง" provinceE:@"KrabiProvince" code:@"E3.001" par:@"405/2512" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"1 เมษายน 2512" url:@"E3.001-2512.PDF" date_no:@"ครั้งที่ 2" area:@"32680566.1629" area_rai:@"17406" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าสนละเอาะ" provinceE:@"KrabiProvince" code:@"E3.004" par:@"423/2512" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"27 พฤษภาคม 2512" url:@"E3.004-2512.PDF" date_no:@"ครั้งที่ 1" area:@"208027983.994" area_rai:@"117250" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองดง" provinceE:@"KrabiProvince" code:@"E3.026" par:@"1195/2530" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"27 มีนาคม 2530" url:@"E3.026-2530.PDF" date_no:@"ครั้งที่ 1" area:@"19266601.711" area_rai:@"11172" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยขยุง" provinceE:@"KrabiProvince" code:@"E3.014" par:@"690/2517" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"23 กรกฎาคม 2517" url:@"E3.014-2517.PDF" date_no:@"ครั้งที่ 1" area:@"84744939.1559" area_rai:@"53750" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยสำราญ แปลงที่สาม" provinceE:@"KrabiProvince" code:@"E3.018" par:@"763/2518" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"25 พฤศจิกายน 2518" url:@"E3.018-2518.PDF" date_no:@"ครั้งที่ 1" area:@"13772390.2826" area_rai:@"7180" ]; [self.SisaketProvinces addObject:SisaketProvince];
    SisaketProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยสำราญ แปลงที่สี่" provinceE:@"KrabiProvince" code:@"E3.019" par:@"766/2518" type:@"ป่าสงวนแห่งชาติ" province:@"ศรีสะเกษ" date:@"9 ธันวาคม 2518" url:@"E3.019-2518.PDF" date_no:@"ครั้งที่ 1" area:@"24156687.4107" area_rai:@"14525" ]; [self.SisaketProvinces addObject:SisaketProvince];
    self.SakonNakhonProvinces = [[NSMutableArray alloc] init];  ItemGuide *SakonNakhonProvince = [[ItemGuide alloc] initWithName:@"ป่ากุดไห ป่านาใน และป่าโนนอุดม" provinceE:@"KrabiProvince" code:@"G4.012" par:@"1138/2528" type:@"ป่าสงวนแห่งชาติ" province:@"สกลนคร" date:@"27 พฤศจิกายน 2528" url:@"G4.012-2528.PDF" date_no:@"ครั้งที่ 1" area:@"286377164.154" area_rai:@"170188" ]; [self.SakonNakhonProvinces addObject:SakonNakhonProvince];
    SakonNakhonProvince = [[ItemGuide alloc] initWithName:@"ป่ากุสุมาลย์ แปลงที่สอง" provinceE:@"KrabiProvince" code:@"G4.008" par:@"756/2518" type:@"ป่าสงวนแห่งชาติ" province:@"สกลนคร" date:@"19 สิงหาคม 2518" url:@"G4.008-2518.PDF" date_no:@"ครั้งที่ 1" area:@"12130439.44" area_rai:@"6250" ]; [self.SakonNakhonProvinces addObject:SakonNakhonProvince];
    SakonNakhonProvince = [[ItemGuide alloc] initWithName:@"ป่ากุสุมาลย์ แปลงที่หนึ่ง" provinceE:@"KrabiProvince" code:@"G4.005" par:@"689/2517" type:@"ป่าสงวนแห่งชาติ" province:@"สกลนคร" date:@"23 กรกฎาคม 2517" url:@"G4.005-2517.PDF" date_no:@"ครั้งที่ 1" area:@"20259200.5689" area_rai:@"11875" ]; [self.SakonNakhonProvinces addObject:SakonNakhonProvince];
    SakonNakhonProvince = [[ItemGuide alloc] initWithName:@"ป่าแก่งแคน" provinceE:@"KrabiProvince" code:@"G4.011" par:@"1117/2528" type:@"ป่าสงวนแห่งชาติ" province:@"สกลนคร" date:@"30 กันยายน 2528" url:@"G4.011-2528.PDF" date_no:@"ครั้งที่ 1" area:@"81754224.1233" area_rai:@"48906" ]; [self.SakonNakhonProvinces addObject:SakonNakhonProvince];
    SakonNakhonProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกภู และป่านาม่อง" provinceE:@"KrabiProvince" code:@"G4.015" par:@"1198/2530" type:@"ป่าสงวนแห่งชาติ" province:@"สกลนคร" date:@"27 มีนาคม 2530" url:@"G4.015-2530.PDF" date_no:@"ครั้งที่ 1" area:@"146390726.772" area_rai:@"89688" ]; [self.SakonNakhonProvinces addObject:SakonNakhonProvince];
    SakonNakhonProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกศาลา" provinceE:@"KrabiProvince" code:@"G4.013" par:@"1170/2529" type:@"ป่าสงวนแห่งชาติ" province:@"สกลนคร" date:@"5 มิถุนายน 2529" url:@"G4.013-2529.PDF" date_no:@"ครั้งที่ 1" area:@"10953827.473" area_rai:@"6469" ]; [self.SakonNakhonProvinces addObject:SakonNakhonProvince];
    SakonNakhonProvince = [[ItemGuide alloc] initWithName:@"ป่าดงจีนและป่าดงเชียงโม" provinceE:@"KrabiProvince" code:@"G4.001" par:@"32/2507" type:@"ป่าสงวนแห่งชาติ" province:@"สกลนคร" date:@"31 ธันวาคม 2507" url:@"G4.001-2507.PDF" date_no:@"ครั้งที่ 1" area:@"47889649.2252" area_rai:@"30625" ]; [self.SakonNakhonProvinces addObject:SakonNakhonProvince];
    SakonNakhonProvince = [[ItemGuide alloc] initWithName:@"ป่าดงชมภูพาน และป่าดงกะเฌอ" provinceE:@"KrabiProvince" code:@"G4.016" par:@"1213/2530" type:@"ป่าสงวนแห่งชาติ" province:@"สกลนคร" date:@"16 ธันวาคม 2530" url:@"G4.016-2530.PDF" date_no:@"ครั้งที่ 1" area:@"325867073.141" area_rai:@"202063" ]; [self.SakonNakhonProvinces addObject:SakonNakhonProvince];
    SakonNakhonProvince = [[ItemGuide alloc] initWithName:@"ป่าดงผาลาด" provinceE:@"KrabiProvince" code:@"G4.004" par:@"731/2518" type:@"ป่าสงวนแห่งชาติ" province:@"สกลนคร" date:@"8 เมษายน 2518" url:@"G4.004-2518.PDF" date_no:@"ครั้งที่ 2" area:@"341452289.363" area_rai:@"201285.78" ]; [self.SakonNakhonProvinces addObject:SakonNakhonProvince];
    SakonNakhonProvince = [[ItemGuide alloc] initWithName:@"ป่าดงพันนาและป่าดงพระเจ้า" provinceE:@"KrabiProvince" code:@"G4.009" par:@"776/2518" type:@"ป่าสงวนแห่งชาติ" province:@"สกลนคร" date:@"24 กุมภาพันธ์ 2519" url:@"G4.009-2519.PDF" date_no:@"ครั้งที่ 1" area:@"302984357.739" area_rai:@"82018" ]; [self.SakonNakhonProvinces addObject:SakonNakhonProvince];
    SakonNakhonProvince = [[ItemGuide alloc] initWithName:@"ป่าดงหม้อทอง" provinceE:@"KrabiProvince" code:@"G4.002" par:@"787/2520" type:@"ป่าสงวนแห่งชาติ" province:@"สกลนคร" date:@"25 ตุลาคม 2520" url:@"G4.002-2520.PDF" date_no:@"ครั้งที่ 2" area:@"278965395.684" area_rai:@"171687.5" ]; [self.SakonNakhonProvinces addObject:SakonNakhonProvince];
    SakonNakhonProvince = [[ItemGuide alloc] initWithName:@"ป่าดงอีบ่าง ป่าดงคำพลู และป่าดงคำกั้ง" provinceE:@"KrabiProvince" code:@"G4.003" par:@"742/2518" type:@"ป่าสงวนแห่งชาติ" province:@"สกลนคร" date:@"6 มิถุนายน 2518" url:@"G4.003-2518.PDF" date_no:@"ครั้งที่ 2" area:@"571549847.9" area_rai:@"326943" ]; [self.SakonNakhonProvinces addObject:SakonNakhonProvince];
    SakonNakhonProvince = [[ItemGuide alloc] initWithName:@"ป่าภูล้อมข้าวและป่าภูเพ็ก" provinceE:@"KrabiProvince" code:@"G4.007" par:@"890/2523" type:@"ป่าสงวนแห่งชาติ" province:@"สกลนคร" date:@"24 มิถุนายน 2523" url:@"G4.007-2523.PDF" date_no:@"ครั้งที่ 2" area:@"354869651.979" area_rai:@"195984" ]; [self.SakonNakhonProvinces addObject:SakonNakhonProvince];
    SakonNakhonProvince = [[ItemGuide alloc] initWithName:@"ป่าภูวง" provinceE:@"KrabiProvince" code:@"G4.014" par:@"1171/2529" type:@"ป่าสงวนแห่งชาติ" province:@"สกลนคร" date:@"3 กรกฎาคม 2529" url:@"G4.014-2529.PDF" date_no:@"ครั้งที่ 1" area:@"188926905.48" area_rai:@"115000" ]; [self.SakonNakhonProvinces addObject:SakonNakhonProvince];
    SakonNakhonProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองบัวโค้ง" provinceE:@"KrabiProvince" code:@"G4.010" par:@"777/2519" type:@"ป่าสงวนแห่งชาติ" province:@"สกลนคร" date:@"1 มิถุนายน 2519" url:@"G4.010-2519.PDF" date_no:@"ครั้งที่ 1" area:@"16980633.8687" area_rai:@"7700" ]; [self.SakonNakhonProvinces addObject:SakonNakhonProvince];
    SakonNakhonProvince = [[ItemGuide alloc] initWithName:@"ป่าอุ่มจาน" provinceE:@"KrabiProvince" code:@"G4.006" par:@"1205/2530" type:@"ป่าสงวนแห่งชาติ" province:@"สกลนคร" date:@"17 สิงหาคม 2530" url:@"G4.006-2530.PDF" date_no:@"ครั้งที่ 2" area:@"56762565.2036" area_rai:@"35469" ]; [self.SakonNakhonProvinces addObject:SakonNakhonProvince];
    self.SongkhlaProvinces = [[NSMutableArray alloc] init];  ItemGuide *SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่ากราด" provinceE:@"KrabiProvince" code:@"T1.014" par:@"136/2505" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"11 ธันวาคม 2505" url:@"T1.014-2505.PDF" date_no:@"ครั้งที่ 1" area:@"5676027.39181" area_rai:@"2575" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะเหลาะหนัง" provinceE:@"KrabiProvince" code:@"T1.038" par:@"701/2517" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"20 สิงหาคม 2517" url:@"T1.038-2517.PDF" date_no:@"ครั้งที่ 1" area:@"3847319.04855" area_rai:@"1187" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขากรวด" provinceE:@"KrabiProvince" code:@"T1.008" par:@"50/2502" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"1 กันยายน 2502" url:@"T1.008-2502.PDF" date_no:@"ครั้งที่ 1" area:@"2233425.26032" area_rai:@"3750" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาขวาง ป่าเขาว้องพริก และป่าควนเทศ" provinceE:@"KrabiProvince" code:@"T1.004" par:@"38/2501" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"30 ธันวาคม 2501" url:@"T1.004-2501.PDF" date_no:@"ครั้งที่ 1" area:@"4615805.99691" area_rai:@"8318.75" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาแดน ป่าเขาน้ำค้าง ป่าควนทางสยา ป่าควนเขาไหม้และป่าควนสิเหรง" provinceE:@"KrabiProvince" code:@"T1.018" par:@"48/2508" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"11 พฤษภาคม 2508" url:@"T1.018-2508.PDF" date_no:@"ครั้งที่ 1" area:@"150958194.146" area_rai:@"95000" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาแดน ป่าเขาน้ำค้าง และป่าควนสิเหรง" provinceE:@"KrabiProvince" code:@"T1.026" par:@"218/2510" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"5 กันยายน 2510" url:@"T1.026-2510.PDF" date_no:@"ครั้งที่ 1" area:@"98491809.1078" area_rai:@"61812" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาแดน ป่าเขาเสม็ด ป่าควนเสม็ดชุนและป่าควนเหรง" provinceE:@"KrabiProvince" code:@"T1.023" par:@"104/2508" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"31 ธันวาคม 2508" url:@"T1.023-2508.PDF" date_no:@"ครั้งที่ 1" area:@"42235994.6391" area_rai:@"21250" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาแดน ป่าควนเจดีย์ ป่าเขาพระยาไม้ และป่าควนกำแพง" provinceE:@"KrabiProvince" code:@"T1.015" par:@"33/2507" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"31 ธันวาคม 2507" url:@"T1.015-2507.PDF" date_no:@"ครั้งที่ 1" area:@"161940823.324" area_rai:@"153625" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาโพธิ ป่าควนแดน และป่าเขารังเกียจ" provinceE:@"KrabiProvince" code:@"T1.021" par:@"75/2508" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"28 กันยายน 2508" url:@"T1.021-2508.PDF" date_no:@"ครั้งที่ 1" area:@"54285975.1081" area_rai:@"30625" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขารังเกียจ ป่าเขาสัก ป่าเขาสูงและป่าควนแก้ว" provinceE:@"KrabiProvince" code:@"T1.006" par:@"187/2506" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"10 กันยายน 2506" url:@"T1.006-2506.PDF" date_no:@"ครั้งที่ 2" area:@"22671585.8158" area_rai:@"39226" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาวังซิง" provinceE:@"KrabiProvince" code:@"T1.037" par:@"448/2514" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"30 ธันวาคม 2514" url:@"T1.037-2514.PDF" date_no:@"ครั้งที่ 1" area:@"8583485.33621" area_rai:@"5037" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาวังพา" provinceE:@"KrabiProvince" code:@"T1.005" par:@"47/2502" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"1 กันยายน 2502" url:@"T1.005-2502.PDF" date_no:@"ครั้งที่ 1" area:@"115692835.634" area_rai:@"568.75" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาเหลี่ยม ป่าเขาจันดี และป่าเขาบ่อท่อ" provinceE:@"KrabiProvince" code:@"T1.024" par:@"127/2509" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"16 สิงหาคม 2509" url:@"T1.024-2509.PDF" date_no:@"ครั้งที่ 1" area:@"94629604.4941" area_rai:@"60000" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองล่าปัง" provinceE:@"KrabiProvince" code:@"T1.031" par:@"319/2511" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"4 มิถุนายน 2511" url:@"T1.031-2511.PDF" date_no:@"ครั้งที่ 1" area:@"35598453.9358" area_rai:@"22193" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนขี้แรต" provinceE:@"KrabiProvince" code:@"T1.002" par:@"17/2501" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"29 เมษายน 2501" url:@"T1.002-2501.PDF" date_no:@"ครั้งที่ 1" area:@"1157253.1726" area_rai:@"737.5" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนเขาจันทร์" provinceE:@"KrabiProvince" code:@"T1.040" par:@"884/2523" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"19 มิถุนายน 2523" url:@"T1.040-2523.PDF" date_no:@"ครั้งที่ 1" area:@"2010427.54569" area_rai:@"875" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนเขาวัง ป่าคลองต่อ และป่าเทือกเขาแก้ว" provinceE:@"KrabiProvince" code:@"T1.041" par:@"1037/2527" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"31 พฤษภาคม 2527" url:@"T1.041-2527.PDF" date_no:@"ครั้งที่ 1" area:@"46159090.5535" area_rai:@"30877" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนจำศิล" provinceE:@"KrabiProvince" code:@"T1.012" par:@"86/2505" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"15 พฤษภาคม 2505" url:@"T1.012-2505.PDF" date_no:@"ครั้งที่ 1" area:@"2027397.54086" area_rai:@"1437.5" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนดินแดง ป่าควนพัง ป่าควนหัวแหวน และป่าควนจอมแห" provinceE:@"KrabiProvince" code:@"T1.011" par:@"53/2502" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"1 กันยายน 2502" url:@"T1.011-2502.PDF" date_no:@"ครั้งที่ 1" area:@"8591265.16362" area_rai:@"11912.5" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนโต๊ะดุด ป่าควนทวด และป่าควนสามง่อน" provinceE:@"KrabiProvince" code:@"T1.022" par:@"85/2508" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"16 พฤศจิกายน 2508" url:@"T1.022-2508.PDF" date_no:@"ครั้งที่ 1" area:@"31383524.7956" area_rai:@"20552" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนทับช้าง" provinceE:@"KrabiProvince" code:@"T1.003" par:@"155/2506" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"5 กุมภาพันธ์ 2506" url:@"T1.003-2506.PDF" date_no:@"ครั้งที่ 2" area:@"77829657.9523" area_rai:@"56875" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนนายเส้น ป่าควนเหม็ดชุน ป่าควนแม่เขานา ป่าควนลูกหมี และป่าควนปาหยัง" provinceE:@"KrabiProvince" code:@"T1.039" par:@"809/2521" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"3 ตุลาคม 2521" url:@"T1.039-2521.PDF" date_no:@"ครั้งที่ 1" area:@"38755211.5374" area_rai:@"32525" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนพน" provinceE:@"KrabiProvince" code:@"T1.017" par:@"199/2507" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"3 มีนาคม 2507" url:@"T1.017-2507.PDF" date_no:@"ครั้งที่ 1" area:@"56377720.9957" area_rai:@"35568.75" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนราสอ ป่าควนน้ำร้อน ป่าควนสอหรอ ป่าควนบางพลา และป่าเขาโต๊ะเทพ" provinceE:@"KrabiProvince" code:@"T1.020" par:@"70/2508" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"10 สิงหาคม 2508" url:@"T1.020-2508.PDF" date_no:@"ครั้งที่ 1" area:@"48460571.1887" area_rai:@"36325" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนลัง" provinceE:@"KrabiProvince" code:@"T1.009" par:@"51/2502" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"1 กันยายน 2502" url:@"T1.009-2502.PDF" date_no:@"ครั้งที่ 1" area:@"894991.073546" area_rai:@"137500" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนเลียบ" provinceE:@"KrabiProvince" code:@"T1.013" par:@"88/2505" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"12 มิถุนายน 2505" url:@"T1.013-2505.PDF" date_no:@"ครั้งที่ 1" area:@"7655384.68722" area_rai:@"4512.5" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนสระ" provinceE:@"KrabiProvince" code:@"T1.007" par:@"49/2502" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"1 กันยายน 2502" url:@"T1.007-2502.PDF" date_no:@"ครั้งที่ 1" area:@"1673804.68479" area_rai:@"2343.75" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนหินผุด และป่ายอดเขาแก้ว" provinceE:@"KrabiProvince" code:@"T1.034" par:@"379/2511" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"28 พฤศจิกายน 2511" url:@"T1.034-2511.PDF" date_no:@"ครั้งที่ 1" area:@"72567777.8096" area_rai:@"52512" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนหินพัง ป่าควนชีล้อม ป่าควนอ่าวปลักก๊ก และป่าควนแหละหวัง" provinceE:@"KrabiProvince" code:@"T1.010" par:@"52/2502" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"1 กันยายน 2502" url:@"T1.010-2502.PDF" date_no:@"ครั้งที่ 1" area:@"4339252.19234" area_rai:@"2250" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนหินเภา" provinceE:@"KrabiProvince" code:@"T1.030" par:@"297/2511" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"30 เมษายน 2511" url:@"T1.030-2511.PDF" date_no:@"ครั้งที่ 1" area:@"42499644.1676" area_rai:@"22325" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนเหรง ป่าควนหนองหยี และป่าควนหัวแหวน" provinceE:@"KrabiProvince" code:@"T1.032" par:@"320/2511" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"4 มิถุนายน 2511" url:@"T1.032-2511.PDF" date_no:@"ครั้งที่ 1" area:@"8846034.03425" area_rai:@"6262" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าควนอ้ายโต้ และป่าควนนุ้ย" provinceE:@"KrabiProvince" code:@"T1.001" par:@"6/2499" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"7 สิงหาคม 2499" url:@"T1.001-2499.PDF" date_no:@"ครั้งที่ 1" area:@"4888721.3445" area_rai:@"3175" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งเคี่ยม" provinceE:@"KrabiProvince" code:@"T1.029" par:@"275/2510" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"28 ธันวาคม 2510" url:@"T1.029-2510.PDF" date_no:@"ครั้งที่ 1" area:@"9631427.94708" area_rai:@"5937" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งบางนกออก" provinceE:@"KrabiProvince" code:@"T1.019" par:@"66/2508" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"13 กรกฎาคม 2508" url:@"T1.019-2508.PDF" date_no:@"ครั้งที่ 1" area:@"12552429.422" area_rai:@"6250" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งแพร" provinceE:@"KrabiProvince" code:@"T1.025" par:@"143/2509" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"18 ตุลาคม 2509" url:@"T1.025-2509.PDF" date_no:@"ครั้งที่ 1" area:@"10738062.515" area_rai:@"4762" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาแก้ว" provinceE:@"KrabiProvince" code:@"T1.028" par:@"236/2510" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"7 พฤศจิกายน 2510" url:@"T1.028-2510.PDF" date_no:@"ครั้งที่ 1" area:@"110762887.614" area_rai:@"50625" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาแก้ว ป่าคลองเขาล่อน และป่าคลองปอม" provinceE:@"KrabiProvince" code:@"T1.035" par:@"388/2511" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"1 ธันวาคม 2511" url:@"T1.035-2511.PDF" date_no:@"ครั้งที่ 1" area:@"21986535.3383" area_rai:@"11562" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาโต๊ะเทพ และป่าควนหินลับ" provinceE:@"KrabiProvince" code:@"T1.036" par:@"402/2512" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"1 เมษายน 2512" url:@"T1.036-2512.PDF" date_no:@"ครั้งที่ 1" area:@"173976503.599" area_rai:@"105500" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าเทือกเขาสันกาลาคีรี" provinceE:@"KrabiProvince" code:@"T1.016" par:@"37/2507" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"31 ธันวาคม 2507" url:@"T1.016-2507.PDF" date_no:@"ครั้งที่ 1" area:@"70443862.5603" area_rai:@"52575" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่านาทุ่งเปราะ และป่าควนดินสอ" provinceE:@"KrabiProvince" code:@"T1.033" par:@"326/2511" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"30 กรกฎาคม 2511" url:@"T1.033-2511.PDF" date_no:@"ครั้งที่ 1" area:@"16286466.8535" area_rai:@"8925" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    SongkhlaProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่พรุ ป่าเทือกเขาไฟไหม้ และป่าคลองกั่ว" provinceE:@"KrabiProvince" code:@"T1.027" par:@"224/2510" type:@"ป่าสงวนแห่งชาติ" province:@"สงขลา" date:@"19 กันยายน 2510" url:@"T1.027-2510.PDF" date_no:@"ครั้งที่ 1" area:@"71317737.231" area_rai:@"46800" ]; [self.SongkhlaProvinces addObject:SongkhlaProvince];
    self.SatunProvinces = [[NSMutableArray alloc] init];  ItemGuide *SatunProvince = [[ItemGuide alloc] initWithName:@"ป่ากุปังและป่าปุโล็ด" provinceE:@"KrabiProvince" code:@"T2.012" par:@"140/2509" type:@"ป่าสงวนแห่งชาติ" province:@"สตูล" date:@"18 ตุลาคม 2509" url:@"T2.012-2509.PDF" date_no:@"ครั้งที่ 1" area:@"141040345.81" area_rai:@"107025" ]; [self.SatunProvinces addObject:SatunProvince];
    SatunProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาค้อม ป่าเขาแดง และป่าเขาใหญ่" provinceE:@"KrabiProvince" code:@"T2.003" par:@"790/2520" type:@"ป่าสงวนแห่งชาติ" province:@"สตูล" date:@"31 ธันวาคม 2520" url:@"T2.003-2520.PDF" date_no:@"ครั้งที่ 2" area:@"87054303.5484" area_rai:@"55408" ]; [self.SatunProvinces addObject:SatunProvince];
    SatunProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาหมาไม่หยก" provinceE:@"KrabiProvince" code:@"T2.017" par:@"286/2511" type:@"ป่าสงวนแห่งชาติ" province:@"สตูล" date:@"5 มีนาคม 2511" url:@"T2.017-2511.PDF" date_no:@"ครั้งที่ 1" area:@"16016704.6034" area_rai:@"13125" ]; [self.SatunProvinces addObject:SatunProvince];
    SatunProvince = [[ItemGuide alloc] initWithName:@"ป่าควนกาหลง" provinceE:@"KrabiProvince" code:@"T2.016" par:@"274/2510" type:@"ป่าสงวนแห่งชาติ" province:@"สตูล" date:@"28 ธันวาคม 2510" url:@"T2.016-2510.PDF" date_no:@"ครั้งที่ 1" area:@"18624667.2909" area_rai:@"11887" ]; [self.SatunProvinces addObject:SatunProvince];
    SatunProvince = [[ItemGuide alloc] initWithName:@"ป่าควนโต๊ะอม ป่าควนขี้หมา และป่าควนท่าหิน" provinceE:@"KrabiProvince" code:@"T2.010" par:@"105/2508" type:@"ป่าสงวนแห่งชาติ" province:@"สตูล" date:@"31 ธันวาคม 2508" url:@"T2.010-2508.PDF" date_no:@"ครั้งที่ 1" area:@"17050890.2379" area_rai:@"11306" ]; [self.SatunProvinces addObject:SatunProvince];
    SatunProvince = [[ItemGuide alloc] initWithName:@"ป่าควนทัง และป่าเขาขาว" provinceE:@"KrabiProvince" code:@"T2.008" par:@"35/2507" type:@"ป่าสงวนแห่งชาติ" province:@"สตูล" date:@"31 ธันวาคม 2507" url:@"T2.008-2507.PDF" date_no:@"ครั้งที่ 1" area:@"50020323.1597" area_rai:@"23619" ]; [self.SatunProvinces addObject:SatunProvince];
    SatunProvince = [[ItemGuide alloc] initWithName:@"ป่าควนบ่อน้ำ" provinceE:@"KrabiProvince" code:@"T2.001" par:@"3/2499" type:@"ป่าสงวนแห่งชาติ" province:@"สตูล" date:@"7 สิงหาคม 2499" url:@"T2.001-2499.PDF" date_no:@"ครั้งที่ 1" area:@"678861.638291" area_rai:@"400" ]; [self.SatunProvinces addObject:SatunProvince];
    SatunProvince = [[ItemGuide alloc] initWithName:@"ป่าควนบารายี ป่าควนโรงพัก และป่าควนสังหยุด" provinceE:@"KrabiProvince" code:@"T2.005" par:@"130/2505" type:@"ป่าสงวนแห่งชาติ" province:@"สตูล" date:@"6 พฤศจิกายน 2505" url:@"T2.005-2505.PDF" date_no:@"ครั้งที่ 1" area:@"17804972.6599" area_rai:@"9687.5" ]; [self.SatunProvinces addObject:SatunProvince];
    SatunProvince = [[ItemGuide alloc] initWithName:@"ป่าเจ๊ะบิลัง ป่าตันหยงโป และป่าตำมะลัง" provinceE:@"KrabiProvince" code:@"T2.011" par:@"118/2509" type:@"ป่าสงวนแห่งชาติ" province:@"สตูล" date:@"28 มิถุนายน 2509" url:@"T2.011-2509.PDF" date_no:@"ครั้งที่ 1" area:@"86172052.8552" area_rai:@"55687" ]; [self.SatunProvinces addObject:SatunProvince];
    SatunProvince = [[ItemGuide alloc] initWithName:@"ป่าดงเชือกช้าง" provinceE:@"KrabiProvince" code:@"T2.018" par:@"321/2511" type:@"ป่าสงวนแห่งชาติ" province:@"สตูล" date:@"4 มิถุนายน 2511" url:@"T2.018-2511.PDF" date_no:@"ครั้งที่ 1" area:@"39024860.4307" area_rai:@"28625" ]; [self.SatunProvinces addObject:SatunProvince];
    SatunProvince = [[ItemGuide alloc] initWithName:@"ป่าตระ ป่าห้วยหลอด และป่าเขาขุมทรัพย์" provinceE:@"KrabiProvince" code:@"T2.007" par:@"142/2505" type:@"ป่าสงวนแห่งชาติ" province:@"สตูล" date:@"11 ธันวาคม 2505" url:@"T2.007-2505.PDF" date_no:@"ครั้งที่ 1" area:@"135113273.554" area_rai:@"93750" ]; [self.SatunProvinces addObject:SatunProvince];
    SatunProvince = [[ItemGuide alloc] initWithName:@"ป่าพยอมงาม" provinceE:@"KrabiProvince" code:@"T2.006" par:@"138/2505" type:@"ป่าสงวนแห่งชาติ" province:@"สตูล" date:@"11 ธันวาคม 2505" url:@"T2.006-2505.PDF" date_no:@"ครั้งที่ 1" area:@"5655991.04463" area_rai:@"4187.5" ]; [self.SatunProvinces addObject:SatunProvince];
    SatunProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนจังหวัดสตูล ตอนที่ 1" provinceE:@"KrabiProvince" code:@"T2.015" par:@"261/2510" type:@"ป่าสงวนแห่งชาติ" province:@"สตูล" date:@"26 ธันวาคม 2510" url:@"T2.015-2510.PDF" date_no:@"ครั้งที่ 1" area:@"146084593.843" area_rai:@"89281" ]; [self.SatunProvinces addObject:SatunProvince];
    SatunProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนจังหวัดสตูล ตอนที่ 2" provinceE:@"KrabiProvince" code:@"T2.002" par:@"18/2501" type:@"ป่าสงวนแห่งชาติ" province:@"สตูล" date:@"29 เมษายน 2501" url:@"T2.002-2501.PDF" date_no:@"ครั้งที่ 1" area:@"96727424.7359" area_rai:@"25950" ]; [self.SatunProvinces addObject:SatunProvince];
    SatunProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนตอนที่ 3 ป่าปาเต๊ะ และป่าปลักจูด" provinceE:@"KrabiProvince" code:@"T2.004" par:@"122/2505" type:@"ป่าสงวนแห่งชาติ" province:@"สตูล" date:@"30 ตุลาคม 2505" url:@"T2.004-2505.PDF" date_no:@"ครั้งที่ 1" area:@"55706561.0601" area_rai:@"30593.75" ]; [self.SatunProvinces addObject:SatunProvince];
    SatunProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนตอนที่ 5" provinceE:@"KrabiProvince" code:@"T2.009" par:@"927/2524" type:@"ป่าสงวนแห่งชาติ" province:@"สตูล" date:@"8 มีนาคม 2524" url:@"T2.009-2524.PDF" date_no:@"ครั้งที่ 2" area:@"123958597.827" area_rai:@"75924.8" ]; [self.SatunProvinces addObject:SatunProvince];
    SatunProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยบ่วง ป่าเขาแดง และป่าเขาโต๊ะดู" provinceE:@"KrabiProvince" code:@"T2.013" par:@"141/2509" type:@"ป่าสงวนแห่งชาติ" province:@"สตูล" date:@"18 ตุลาคม 2509" url:@"T2.013-2509.PDF" date_no:@"ครั้งที่ 1" area:@"3634634.09662" area_rai:@"1875" ]; [self.SatunProvinces addObject:SatunProvince];
    SatunProvince = [[ItemGuide alloc] initWithName:@"ป่าหัวกะหมิง" provinceE:@"KrabiProvince" code:@"T2.014" par:@"142/2509" type:@"ป่าสงวนแห่งชาติ" province:@"สตูล" date:@"18 ตุลาคม 2509" url:@"T2.014-2509.PDF" date_no:@"ครั้งที่ 1" area:@"112894948.14" area_rai:@"91643" ]; [self.SatunProvinces addObject:SatunProvince];
    self.SamutSakhonProvinces = [[NSMutableArray alloc] init];  ItemGuide *SamutSakhonProvince = [[ItemGuide alloc] initWithName:@"ป่าอ่าวมหาชัยฝั่งตะวันตก" provinceE:@"KrabiProvince" code:@"P4.002" par:@"1202/2530" type:@"ป่าสงวนแห่งชาติ" province:@"สมุทรสาคร" date:@"26 พฤษภาคม 2530" url:@"P4.002-2530.PDF" date_no:@"ครั้งที่ 1" area:@"13388838.18" area_rai:@"8865" ]; [self.SamutSakhonProvinces addObject:SamutSakhonProvince];
    SamutSakhonProvince = [[ItemGuide alloc] initWithName:@"ป่าอ่าวมหาชัยฝั่งตะวันออก" provinceE:@"KrabiProvince" code:@"P4.001" par:@"1194/2529" type:@"ป่าสงวนแห่งชาติ" province:@"สมุทรสาคร" date:@"31 ธันวาคม 2529" url:@"P4.001-2529.PDF" date_no:@"ครั้งที่ 1" area:@"12218322.6959" area_rai:@"7343" ]; [self.SamutSakhonProvinces addObject:SamutSakhonProvince];
    self.SaKaeoProvinces = [[NSMutableArray alloc] init];  ItemGuide *SaKaeoProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาฉกรรจ์ ป่าโนนสาวเอ้ ป่าปลายคลองห้วยไคร้ และป่าพระสทึง" provinceE:@"KrabiProvince" code:@"C1.011" par:@"1088/2527" type:@"ป่าสงวนแห่งชาติ" province:@"สระแก้ว" date:@"27 ธันวาคม 2527" url:@"C1.011-2527.PDF" date_no:@"ครั้งที่ 1" area:@"1760225790.71" area_rai:@"1072500" ]; [self.SaKaeoProvinces addObject:SaKaeoProvince];
    SaKaeoProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาฉกรรจ์ฝั่งเหนือ" provinceE:@"KrabiProvince" code:@"C1.002" par:@"24/2507" type:@"ป่าสงวนแห่งชาติ" province:@"สระแก้ว" date:@"31 ธันวาคม 2507" url:@"C1.002-2507.PDF" date_no:@"ครั้งที่ 1" area:@"385424351.53" area_rai:@"232100" ]; [self.SaKaeoProvinces addObject:SaKaeoProvince];
    SaKaeoProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกสูง" provinceE:@"KrabiProvince" code:@"C1.005" par:@"259/2510" type:@"ป่าสงวนแห่งชาติ" province:@"สระแก้ว" date:@"26 ธันวาคม 2510" url:@"C1.005-2510.PDF" date_no:@"ครั้งที่ 1" area:@"633024627.347" area_rai:@"416484" ]; [self.SaKaeoProvinces addObject:SaKaeoProvince];
    SaKaeoProvince = [[ItemGuide alloc] initWithName:@"ป่าตาพระยา" provinceE:@"KrabiProvince" code:@"C1.008" par:@"497/2515" type:@"ป่าสงวนแห่งชาติ" province:@"สระแก้ว" date:@"5 ธันวาคม 2515" url:@"C1.008-2515.PDF" date_no:@"ครั้งที่ 1" area:@"585874816.147" area_rai:@"336950" ]; [self.SaKaeoProvinces addObject:SaKaeoProvince];
    SaKaeoProvince = [[ItemGuide alloc] initWithName:@"ป่าท่ากะบาก" provinceE:@"KrabiProvince" code:@"C1.006" par:@"1111/2528" type:@"ป่าสงวนแห่งชาติ" province:@"สระแก้ว" date:@"19 มิถุนายน 2528" url:@"C1.006-2528.PDF" date_no:@"ครั้งที่ 2" area:@"481033386.422" area_rai:@"281930" ]; [self.SaKaeoProvinces addObject:SaKaeoProvince];
    SaKaeoProvince = [[ItemGuide alloc] initWithName:@"ป่าท่าแยก" provinceE:@"KrabiProvince" code:@"C1.012" par:@"1114/2528" type:@"ป่าสงวนแห่งชาติ" province:@"สระแก้ว" date:@"30 กันยายน 2528" url:@"C1.012-2528.PDF" date_no:@"ครั้งที่ 1" area:@"61567245.9582" area_rai:@"37031" ]; [self.SaKaeoProvinces addObject:SaKaeoProvince];
    SaKaeoProvince = [[ItemGuide alloc] initWithName:@"ป่าวัฒนานคร" provinceE:@"KrabiProvince" code:@"C1.013" par:@"1130/2528" type:@"ป่าสงวนแห่งชาติ" province:@"สระแก้ว" date:@"27 พฤศจิกายน 2528" url:@"C1.013-2528.PDF" date_no:@"ครั้งที่ 1" area:@"138585857.736" area_rai:@"81937" ]; [self.SaKaeoProvinces addObject:SaKaeoProvince];
    SaKaeoProvince = [[ItemGuide alloc] initWithName:@"ป่าสักท่าระพา" provinceE:@"KrabiProvince" code:@"C1.003" par:@"203/2507" type:@"ป่าสงวนแห่งชาติ" province:@"สระแก้ว" date:@"3 มีนาคม 2507" url:@"C1.003-2507.PDF" date_no:@"ครั้งที่ 1" area:@"69774.431753" area_rai:@"38.75" ]; [self.SaKaeoProvinces addObject:SaKaeoProvince];
    self.SaraburiProvinces = [[NSMutableArray alloc] init];  ItemGuide *SaraburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาโป่ง และป่าเขาถ้ำเสือ" provinceE:@"KrabiProvince" code:@"A1.008" par:@"1075/2527" type:@"ป่าสงวนแห่งชาติ" province:@"สระบุรี" date:@"8 พฤศจิกายน 2527" url:@"A1.008-2527.PDF" date_no:@"ครั้งที่ 1" area:@"16548324.8444" area_rai:@"9900" ]; [self.SaraburiProvinces addObject:SaraburiProvince];
    SaraburiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาพระ" provinceE:@"KrabiProvince" code:@"A1.006" par:@"982/2525" type:@"ป่าสงวนแห่งชาติ" province:@"สระบุรี" date:@"16 กันยายน 2525" url:@"A1.006-2525.PDF" date_no:@"ครั้งที่ 1" area:@"8306806.72624" area_rai:@"5391" ]; [self.SaraburiProvinces addObject:SaraburiProvince];
    SaraburiProvince = [[ItemGuide alloc] initWithName:@"ป่าทับกวาง และป่ามวกเหล็ก แปลงที่ 1" provinceE:@"KrabiProvince" code:@"A1.007" par:@"1072/2527" type:@"ป่าสงวนแห่งชาติ" province:@"สระบุรี" date:@"8 พฤศจิกายน 2527" url:@"A1.007-2527.PDF" date_no:@"ครั้งที่ 1" area:@"174330994.115" area_rai:@"97350" ]; [self.SaraburiProvinces addObject:SaraburiProvince];
    SaraburiProvince = [[ItemGuide alloc] initWithName:@"ป่าท่าฤทธิ์ ป่าลำทองหลาง และป่าลำพญากลาง" provinceE:@"KrabiProvince" code:@"A1.003" par:@"985/2525" type:@"ป่าสงวนแห่งชาติ" province:@"สระบุรี" date:@"1 พฤศจิกายน 2525" url:@"A1.003-2525.PDF" date_no:@"ครั้งที่ 2" area:@"228114061.175" area_rai:@"124993.75" ]; [self.SaraburiProvinces addObject:SaraburiProvince];
    SaraburiProvince = [[ItemGuide alloc] initWithName:@"ป่าพระฉาย" provinceE:@"KrabiProvince" code:@"A1.001" par:@"126/2505" type:@"ป่าสงวนแห่งชาติ" province:@"สระบุรี" date:@"30 ตุลาคม 2505" url:@"A1.001-2505.PDF" date_no:@"ครั้งที่ 1" area:@"19323454.563" area_rai:@"15000" ]; [self.SaraburiProvinces addObject:SaraburiProvince];
    SaraburiProvince = [[ItemGuide alloc] initWithName:@"ป่าพระพุทธบาทและป่าพุแค" provinceE:@"KrabiProvince" code:@"A1.002" par:@"1073/2527" type:@"ป่าสงวนแห่งชาติ" province:@"สระบุรี" date:@"8 พฤศจิกายน 2527" url:@"A1.002-2527.PDF" date_no:@"ครั้งที่ 2" area:@"38120036.4266" area_rai:@"22000" ]; [self.SaraburiProvinces addObject:SaraburiProvince];
    SaraburiProvince = [[ItemGuide alloc] initWithName:@"ป่ามวกเหล็ก และป่าทับกวาง แปลงที่ 2" provinceE:@"KrabiProvince" code:@"A1.004" par:@"366/2511" type:@"ป่าสงวนแห่งชาติ" province:@"สระบุรี" date:@"26 พฤศจิกายน 2511" url:@"A1.004-2511.PDF" date_no:@"ครั้งที่ 1" area:@"195180214.644" area_rai:@"112425" ]; [self.SaraburiProvinces addObject:SaraburiProvince];
    SaraburiProvince = [[ItemGuide alloc] initWithName:@"ป่าลานท่าฤทธิ์" provinceE:@"KrabiProvince" code:@"A1.005" par:@"967/2524" type:@"ป่าสงวนแห่งชาติ" province:@"สระบุรี" date:@"30 ธันวาคม 2524" url:@"A1.005-2524.PDF" date_no:@"ครั้งที่ 1" area:@"11378640.6731" area_rai:@"5800" ]; [self.SaraburiProvinces addObject:SaraburiProvince];
    self.SukhothaiProvinces = [[NSMutableArray alloc] init];  ItemGuide *SukhothaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแก่งสัก" provinceE:@"KrabiProvince" code:@"N2.001" par:@"5/2499" type:@"ป่าสงวนแห่งชาติ" province:@"สุโขทัย" date:@"7 สิงหาคม 2499" url:@"N2.001-2499.PDF" date_no:@"ครั้งที่ 1" area:@"64791.5162598" area_rai:@"31.25" ]; [self.SukhothaiProvinces addObject:SukhothaiProvince];
    SukhothaiProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาหลวง" provinceE:@"KrabiProvince" code:@"N2.008" par:@"1227/2533" type:@"ป่าสงวนแห่งชาติ" province:@"สุโขทัย" date:@"13 กรกฎาคม 2533" url:@"N2.008-2533.PDF" date_no:@"ครั้งที่ 3" area:@"254180071.826" area_rai:@"143750" ]; [self.SukhothaiProvinces addObject:SukhothaiProvince];
    SukhothaiProvince = [[ItemGuide alloc] initWithName:@"ป่าดงข่า" provinceE:@"KrabiProvince" code:@"N2.012" par:@"953/2524" type:@"ป่าสงวนแห่งชาติ" province:@"สุโขทัย" date:@"27 กันยายน 2524" url:@"N2.012-2524.PDF" date_no:@"ครั้งที่ 1" area:@"5465365.82226" area_rai:@"2750" ]; [self.SukhothaiProvinces addObject:SukhothaiProvince];
    SukhothaiProvince = [[ItemGuide alloc] initWithName:@"ป่านครเดิฐ" provinceE:@"KrabiProvince" code:@"N2.003" par:@"117/2509" type:@"ป่าสงวนแห่งชาติ" province:@"สุโขทัย" date:@"28 มิถุนายน 2509" url:@"N2.003-2509.PDF" date_no:@"ครั้งที่ 1" area:@"20906022.5864" area_rai:@"14200" ]; [self.SukhothaiProvinces addObject:SukhothaiProvince];
    SukhothaiProvince = [[ItemGuide alloc] initWithName:@"ป่านาขุนไกร" provinceE:@"KrabiProvince" code:@"N2.011" par:@"544/2516" type:@"ป่าสงวนแห่งชาติ" province:@"สุโขทัย" date:@"17 กรกฎาคม 2516" url:@"N2.011-2516.PDF" date_no:@"ครั้งที่ 1" area:@"49111570.5793" area_rai:@"30000" ]; [self.SukhothaiProvinces addObject:SukhothaiProvince];
    SukhothaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่ท่าแพ" provinceE:@"KrabiProvince" code:@"N2.007" par:@"161/2509" type:@"ป่าสงวนแห่งชาติ" province:@"สุโขทัย" date:@"27 ธันวาคม 2509" url:@"N2.007-2509.PDF" date_no:@"ครั้งที่ 1" area:@"514229268.051" area_rai:@"402075" ]; [self.SukhothaiProvinces addObject:SukhothaiProvince];
    SukhothaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่พันลำ และป่าแม่มอก" provinceE:@"KrabiProvince" code:@"N2.006" par:@"156/2509" type:@"ป่าสงวนแห่งชาติ" province:@"สุโขทัย" date:@"27 ธันวาคม 2509" url:@"N2.006-2509.PDF" date_no:@"ครั้งที่ 1" area:@"755760747.409" area_rai:@"351650" ]; [self.SukhothaiProvinces addObject:SukhothaiProvince];
    SukhothaiProvince = [[ItemGuide alloc] initWithName:@"ป่าแม่สิน ป่าแม่สาน และป่าแม่สูงฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"N2.004" par:@"132/2509" type:@"ป่าสงวนแห่งชาติ" province:@"สุโขทัย" date:@"6 กันยายน 2509" url:@"N2.004-2509.PDF" date_no:@"ครั้งที่ 1" area:@"627138322.637" area_rai:@"329750" ]; [self.SukhothaiProvinces addObject:SukhothaiProvince];
    SukhothaiProvince = [[ItemGuide alloc] initWithName:@"ป่าสวนสักท่าไชย" provinceE:@"KrabiProvince" code:@"N2.002" par:@"61/2502" type:@"ป่าสงวนแห่งชาติ" province:@"สุโขทัย" date:@"26 เมษายน 2503" url:@"N2.002-2503.PDF" date_no:@"ครั้งที่ 1" area:@"75277511.5594" area_rai:@"46312.5" ]; [self.SukhothaiProvinces addObject:SukhothaiProvince];
    SukhothaiProvince = [[ItemGuide alloc] initWithName:@"ป่าสุเม่น" provinceE:@"KrabiProvince" code:@"N2.010" par:@"515/2515" type:@"ป่าสงวนแห่งชาติ" province:@"สุโขทัย" date:@"30 ธันวาคม 2515" url:@"N2.010-2515.PDF" date_no:@"ครั้งที่ 1" area:@"23948230.1558" area_rai:@"32500" ]; [self.SukhothaiProvinces addObject:SukhothaiProvince];
    SukhothaiProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองตูม" provinceE:@"KrabiProvince" code:@"N2.005" par:@"154/2529" type:@"ป่าสงวนแห่งชาติ" province:@"สุโขทัย" date:@"20 ธันวาคม 2509" url:@"N2.005-2509.PDF" date_no:@"ครั้งที่ 1" area:@"24597260.6357" area_rai:@"17500" ]; [self.SukhothaiProvinces addObject:SukhothaiProvince];
    SukhothaiProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยทรวง ป่าแม่สำ ป่าบ้านตึก และป่าห้วยไคร้" provinceE:@"KrabiProvince" code:@"N2.009" par:@"461/2515" type:@"ป่าสงวนแห่งชาติ" province:@"สุโขทัย" date:@"5 กันยายน 2515" url:@"N2.009-2515.PDF" date_no:@"ครั้งที่ 1" area:@"520415064.912" area_rai:@"360456" ]; [self.SukhothaiProvinces addObject:SukhothaiProvince];
    self.SuphanBuriProvinces = [[NSMutableArray alloc] init];  ItemGuide *SuphanBuriProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาตะโกปิดทอง และป่าเขาเพชรน้อย" provinceE:@"KrabiProvince" code:@"P3.005" par:@"1006/2526" type:@"ป่าสงวนแห่งชาติ" province:@"สุพรรณบุรี" date:@"15 กรกฎาคม 2526" url:@"P3.005-2526.PDF" date_no:@"ครั้งที่ 2" area:@"24454157.9749" area_rai:@"14972.52" ]; [self.SuphanBuriProvinces addObject:SuphanBuriProvince];
    SuphanBuriProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาทุ่งดินดำ และป่าเขาตาเก้า" provinceE:@"KrabiProvince" code:@"P3.006" par:@"717/2517" type:@"ป่าสงวนแห่งชาติ" province:@"สุพรรณบุรี" date:@"29 ธันวาคม 2517" url:@"P3.006-2517.PDF" date_no:@"ครั้งที่ 1" area:@"42390111.6655" area_rai:@"21250" ]; [self.SuphanBuriProvinces addObject:SuphanBuriProvince];
    SuphanBuriProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านโข้ง" provinceE:@"KrabiProvince" code:@"P3.007" par:@"1087/2527" type:@"ป่าสงวนแห่งชาติ" province:@"สุพรรณบุรี" date:@"27 ธันวาคม 2527" url:@"P3.007-2527.PDF" date_no:@"ครั้งที่ 1" area:@"16689025.2658" area_rai:@"10069" ]; [self.SuphanBuriProvinces addObject:SuphanBuriProvince];
    SuphanBuriProvince = [[ItemGuide alloc] initWithName:@"ป่าโป่งลาน และป่าทุ่งคอก" provinceE:@"KrabiProvince" code:@"P3.004" par:@"2/2507" type:@"ป่าสงวนแห่งชาติ" province:@"สุพรรณบุรี" date:@"24 พฤศจิกายน 2507" url:@"P3.004-2507.PDF" date_no:@"ครั้งที่ 1" area:@"37324074.0243" area_rai:@"20431.25" ]; [self.SuphanBuriProvinces addObject:SuphanBuriProvince];
    SuphanBuriProvince = [[ItemGuide alloc] initWithName:@"ป่าสักสระยายโสม" provinceE:@"KrabiProvince" code:@"P3.001" par:@"0/2494" type:@"ป่าสงวนแห่งชาติ" province:@"สุพรรณบุรี" date:@"6 พฤศจิกายน 2494" url:@"P3.001-2494.PDF" date_no:@"ครั้งที่ 1" area:@"676867.074087" area_rai:@"443.75" ]; [self.SuphanBuriProvinces addObject:SuphanBuriProvince];
    SuphanBuriProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยขมิ้น ป่าพุน้ำร้อน และป่าหนองหญ้าไทร" provinceE:@"KrabiProvince" code:@"P3.002" par:@"906/2523" type:@"ป่าสงวนแห่งชาติ" province:@"สุพรรณบุรี" date:@"9 ธันวาคม 2523" url:@"P3.002-2523.PDF" date_no:@"ครั้งที่ 2" area:@"483318998.659" area_rai:@"318561" ]; [self.SuphanBuriProvinces addObject:SuphanBuriProvince];
    SuphanBuriProvince = [[ItemGuide alloc] initWithName:@"ป่าองค์พระ ป่าเขาพุระกำ และป่าเขาห้วยพลู" provinceE:@"KrabiProvince" code:@"P3.003" par:@"905/2523" type:@"ป่าสงวนแห่งชาติ" province:@"สุพรรณบุรี" date:@"9 ธันวาคม 2523" url:@"P3.003-2523.PDF" date_no:@"ครั้งที่ 2" area:@"754637012.554" area_rai:@"439375" ]; [self.SuphanBuriProvinces addObject:SuphanBuriProvince];
    self.SuratThaniProvinces = [[NSMutableArray alloc] init];  ItemGuide *SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเกาะพะงัน" provinceE:@"KrabiProvince" code:@"R1.012" par:@"1030/2526" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"31 ธันวาคม 2526" url:@"R1.012-2526.PDF" date_no:@"ครั้งที่ 2" area:@"38353494.3015" area_rai:@"24450" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาแดงราม และป่าเขาหน้าราหู" provinceE:@"KrabiProvince" code:@"R1.026" par:@"1140/2528" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"27 พฤศจิกายน 2528" url:@"R1.026-2528.PDF" date_no:@"ครั้งที่ 1" area:@"34192958.4376" area_rai:@"17466" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาท่าเพชร" provinceE:@"KrabiProvince" code:@"R1.011" par:@"734/2518" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"22 เมษายน 2518" url:@"R1.011-2518.PDF" date_no:@"ครั้งที่ 2" area:@"4797066.24698" area_rai:@"2893" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาพนม และป่าพลูเถื่อน" provinceE:@"KrabiProvince" code:@"R1.025" par:@"1096/2528" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"2 พฤษภาคม 2528" url:@"R1.025-2528.PDF" date_no:@"ครั้งที่ 1" area:@"70582008.1504" area_rai:@"43359" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาพลู" provinceE:@"KrabiProvince" code:@"R1.009" par:@"72/2508" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"10 สิงหาคม 2508" url:@"R1.009-2508.PDF" date_no:@"ครั้งที่ 1" area:@"51559234.6268" area_rai:@"29375" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาพุทธทอง" provinceE:@"KrabiProvince" code:@"R1.001" par:@"1008/2526" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"15 กรกฎาคม 2526" url:@"R1.001-2526.PDF" date_no:@"ครั้งที่ 2" area:@"26561767.4243" area_rai:@"16250" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองท่าเนียน และป่าเลนคลองพุมเรียง" provinceE:@"KrabiProvince" code:@"R1.017" par:@"516/2515" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"30 ธันวาคม 2515" url:@"R1.017-2515.PDF" date_no:@"ครั้งที่ 1" area:@"10083439.8634" area_rai:@"5884" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองน้ำเฒ่า" provinceE:@"KrabiProvince" code:@"R1.008" par:@"27/2507" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"31 ธันวาคม 2507" url:@"R1.008-2507.PDF" date_no:@"ครั้งที่ 1" area:@"368381894.163" area_rai:@"396250" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองสก และป่าคลองพนม" provinceE:@"KrabiProvince" code:@"R1.021" par:@"800/2521" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"6 มิถุนายน 2521" url:@"R1.021-2521.PDF" date_no:@"ครั้งที่ 1" area:@"475152205.455" area_rai:@"295000" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองสินปุน" provinceE:@"KrabiProvince" code:@"R1.003" par:@"99/2505" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"17 กรกฎาคม 2505" url:@"R1.003-2505.PDF" date_no:@"ครั้งที่ 1" area:@"66730178.1544" area_rai:@"75000" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองเหยียน" provinceE:@"KrabiProvince" code:@"R1.004" par:@"119/2505" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"2 ตุลาคม 2505" url:@"R1.004-2505.PDF" date_no:@"ครั้งที่ 1" area:@"296614195.224" area_rai:@"178125" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าชัยคราม และป่าวัดประดู่" provinceE:@"KrabiProvince" code:@"R1.015" par:@"201/2510" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"27 มิถุนายน 2510" url:@"R1.015-2510.PDF" date_no:@"ครั้งที่ 1" area:@"459966647.423" area_rai:@"280340" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าไชยคราม และป่าวัดประดู่ แปลงที่สอง" provinceE:@"KrabiProvince" code:@"R1.024" par:@"1095/2527" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"30 ธันวาคม 2527" url:@"R1.024-2527.PDF" date_no:@"ครั้งที่ 1" area:@"174626386.243" area_rai:@"106744" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าท่าเคย ป่าคลองไทร ป่ามะลวน และป่าบางงอน" provinceE:@"KrabiProvince" code:@"R1.019" par:@"823/2521" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"29 ธันวาคม 2521" url:@"R1.019-2521.PDF" date_no:@"ครั้งที่ 2" area:@"158560395.19" area_rai:@"145937.5" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าท่าชนะ" provinceE:@"KrabiProvince" code:@"R1.014" par:@"158/2509" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"27 ธันวาคม 2509" url:@"R1.014-2509.PDF" date_no:@"ครั้งที่ 1" area:@"1260270181.26" area_rai:@"662781" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งรัง ควนเสียด บกไก่ฟ้า และคลองกงชัง" provinceE:@"KrabiProvince" code:@"R1.002" par:@"91/2505" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"12 มิถุนายน 2505" url:@"R1.002-2505.PDF" date_no:@"ครั้งที่ 1" area:@"188013160.908" area_rai:@"121737.5" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งใสไช" provinceE:@"KrabiProvince" code:@"R1.018" par:@"556/2516" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"7 สิงหาคม 2516" url:@"R1.018-2516.PDF" date_no:@"ครั้งที่ 1" area:@"5452753.49304" area_rai:@"5000" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำตกหินลาด" provinceE:@"KrabiProvince" code:@"R1.006" par:@"5/2507" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"24 พฤศจิกายน 2507" url:@"R1.006-2507.PDF" date_no:@"ครั้งที่ 1" area:@"10796972.018" area_rai:@"6943" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าบางเบา และป่าคลองเซียด" provinceE:@"KrabiProvince" code:@"R1.016" par:@"358/2511" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"22 พฤศจิกายน 2511" url:@"R1.016-2511.PDF" date_no:@"ครั้งที่ 1" area:@"267902924.671" area_rai:@"175837" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านนา ป่าท่าเรือ และป่าเคียนซา" provinceE:@"KrabiProvince" code:@"R1.013" par:@"153/2509" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"20 ธันวาคม 2509" url:@"R1.013-2509.PDF" date_no:@"ครั้งที่ 1" area:@"144285785.962" area_rai:@"89075" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านหมากและป่าปากพัง" provinceE:@"KrabiProvince" code:@"R1.020" par:@"599/2516" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"20 พฤศจิกายน 2516" url:@"R1.020-2516.PDF" date_no:@"ครั้งที่ 1" area:@"224203734.026" area_rai:@"187500" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าย่านยาว ป่าเขาวง และป่ากระซุม" provinceE:@"KrabiProvince" code:@"R1.022" par:@"807/2524" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"8 กรกฎาคม 2521" url:@"R1.022-2521.PDF" date_no:@"ครั้งที่ 1" area:@"960687443.364" area_rai:@"630000" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนดอนสัก" provinceE:@"KrabiProvince" code:@"R1.007" par:@"15/2507" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"31 ธันวาคม 2507" url:@"R1.007-2507.PDF" date_no:@"ครั้งที่ 1" area:@"24593962.6406" area_rai:@"19443" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเลนน้ำเค็มท่าฉาง" provinceE:@"KrabiProvince" code:@"R1.010" par:@"98/2508" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"31 ธันวาคม 2508" url:@"R1.010-2508.PDF" date_no:@"ครั้งที่ 1" area:@"17323200.0239" area_rai:@"8343" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าวัดประดู่" provinceE:@"KrabiProvince" code:@"R1.005" par:@"132/2505" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"6 พฤศจิกายน 2505" url:@"R1.005-2505.PDF" date_no:@"ครั้งที่ 1" area:@"10060838.4259" area_rai:@"5100" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    SuratThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าใสท้อน และป่าคลองโซง" provinceE:@"KrabiProvince" code:@"R1.023" par:@"940/2524" type:@"ป่าสงวนแห่งชาติ" province:@"สุราษฎร์ธานี" date:@"23 กรกฎาคม 2524" url:@"R1.023-2524.PDF" date_no:@"ครั้งที่ 1" area:@"183829884.994" area_rai:@"114762" ]; [self.SuratThaniProvinces addObject:SuratThaniProvince];
    self.SurinProvinces = [[NSMutableArray alloc] init];  ItemGuide *SurinProvince = [[ItemGuide alloc] initWithName:@"ป่ากำใสจาน" provinceE:@"KrabiProvince" code:@"E2.023" par:@"698/2517" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"13 สิงหาคม 2517" url:@"E2.023-2517.PDF" date_no:@"ครั้งที่ 1" area:@"24295275.1614" area_rai:@"15600" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาสวาย" provinceE:@"KrabiProvince" code:@"E2.019" par:@"555/2516" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"7 สิงหาคม 2516" url:@"E2.019-2516.PDF" date_no:@"ครั้งที่ 1" area:@"21669144.3828" area_rai:@"18143" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าจารพัด" provinceE:@"KrabiProvince" code:@"E2.002" par:@"958/2524" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"27 กันยายน 2524" url:@"E2.002-2524.PDF" date_no:@"ครั้งที่ 2" area:@"65753132.3721" area_rai:@"41820" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าดงสายทอ" provinceE:@"KrabiProvince" code:@"E2.006" par:@"291/2511" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"30 เมษายน 2511" url:@"E2.006-2511.PDF" date_no:@"ครั้งที่ 1" area:@"21250905.1654" area_rai:@"12968" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าท่าสว่างและป่าเพี้ยราม" provinceE:@"KrabiProvince" code:@"E2.010" par:@"371/2511" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"27 พฤศจิกายน 2511" url:@"E2.010-2511.PDF" date_no:@"ครั้งที่ 1" area:@"29842885.0412" area_rai:@"19412" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งมน ป่าบักได และป่าตาเบา แปลงที่สอง" provinceE:@"KrabiProvince" code:@"E2.017" par:@"824/2521" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"29 ธันวาคม 2521" url:@"E2.017-2521.PDF" date_no:@"ครั้งที่ 2" area:@"209955634.888" area_rai:@"145593" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งมน ป่าบักได และป่าตาเบา แปลงที่สาม" provinceE:@"KrabiProvince" code:@"E2.020" par:@"805/2521" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"8 กรกฎาคม 2521" url:@"E2.020-2521.PDF" date_no:@"ครั้งที่ 2" area:@"430989465.166" area_rai:@"270431" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งมน ป่าบักได และป่าตาเบา แปลงที่หนึ่ง" provinceE:@"KrabiProvince" code:@"E2.018" par:@"530/2516" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"19 มิถุนายน 2516" url:@"E2.018-2516.PDF" date_no:@"ครั้งที่ 1" area:@"5117118.79299" area_rai:@"2968" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าเทนมีย์" provinceE:@"KrabiProvince" code:@"E2.007" par:@"292/2511" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"30 เมษายน 2511" url:@"E2.007-2511.PDF" date_no:@"ครั้งที่ 1" area:@"20802355.7362" area_rai:@"12812" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าเนิกเหียรดัดสันตุด" provinceE:@"KrabiProvince" code:@"E2.016" par:@"426/2512" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"3 มิถุนายน 2512" url:@"E2.016-2512.PDF" date_no:@"ครั้งที่ 1" area:@"41363080.6064" area_rai:@"24375" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านกระวัน" provinceE:@"KrabiProvince" code:@"E2.024" par:@"708/2517" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"8 ตุลาคม 2517" url:@"E2.024-2517.PDF" date_no:@"ครั้งที่ 1" area:@"24287485.3716" area_rai:@"14325" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านเดียก" provinceE:@"KrabiProvince" code:@"E2.014" par:@"414/2512" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"8 เมษายน 2512" url:@"E2.014-2512.PDF" date_no:@"ครั้งที่ 1" area:@"41951578.6277" area_rai:@"26093" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าผักไหม" provinceE:@"KrabiProvince" code:@"E2.013" par:@"413/2512" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"8 เมษายน 2512" url:@"E2.013-2512.PDF" date_no:@"ครั้งที่ 1" area:@"19032007.2516" area_rai:@"11018" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าฝั่งขวาห้วยเสน" provinceE:@"KrabiProvince" code:@"E2.025" par:@"837/2522" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"15 พฤษภาคม 2522" url:@"E2.025-2522.PDF" date_no:@"ครั้งที่ 1" area:@"154756621.108" area_rai:@"90312" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าฝั่งซ้ายแม่น้ำมูล" provinceE:@"KrabiProvince" code:@"E2.029" par:@"1225/2532" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"20 กรกฎาคม 2532" url:@"E2.029-2532.PDF" date_no:@"ครั้งที่ 1" area:@"23414536.6804" area_rai:@"13922" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าฝั่งซ้ายห้วยกำโพด" provinceE:@"KrabiProvince" code:@"E2.015" par:@"550/2516" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"31 กรกฎาคม 2516" url:@"E2.015-2516.PDF" date_no:@"ครั้งที่ 2" area:@"69777318.9324" area_rai:@"43934" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าฝั่งซ้ายห้วยทับทัน แปลงที่หนึ่ง แปลงที่สอง และแปลงที่สาม" provinceE:@"KrabiProvince" code:@"E2.028" par:@"1223/2532" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"20 กรกฎาคม 2532" url:@"E2.028-2532.PDF" date_no:@"ครั้งที่ 1" area:@"254180453.371" area_rai:@"149375" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าฝั่งซ้ายห้วยสำราญ" provinceE:@"KrabiProvince" code:@"E2.027" par:@"1203/2530" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"26 พฤษภาคม 2530" url:@"E2.027-2530.PDF" date_no:@"ครั้งที่ 1" area:@"62184845.9947" area_rai:@"38048" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าฝั่งซ้ายห้วยเสน แปลงที่หนึ่ง และแปลงที่สอง" provinceE:@"KrabiProvince" code:@"E2.026" par:@"1148/2529" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"16 เมษายน 2529" url:@"E2.026-2529.PDF" date_no:@"ครั้งที่ 1" area:@"123385281.176" area_rai:@"77891" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าพนมดิน แปลงที่ 1" provinceE:@"KrabiProvince" code:@"E2.012" par:@"391/2512" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"20 กุมภาพันธ์ 2512" url:@"E2.012-2512.PDF" date_no:@"ครั้งที่ 1" area:@"18187149.0057" area_rai:@"11793" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าพนมดิน แปลงที่สอง" provinceE:@"KrabiProvince" code:@"E2.005" par:@"545/2516" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"17 กรกฎาคม 2516" url:@"E2.005-2516.PDF" date_no:@"ครั้งที่ 2" area:@"9928068.8583" area_rai:@"4754" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าพนมสวาย" provinceE:@"KrabiProvince" code:@"E2.021" par:@"641/2517" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"5 มีนาคม 2517" url:@"E2.021-2517.PDF" date_no:@"ครั้งที่ 1" area:@"5388547.71118" area_rai:@"2475" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าภูดิน" provinceE:@"KrabiProvince" code:@"E2.004" par:@"266/2510" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"28 ธันวาคม 2510" url:@"E2.004-2510.PDF" date_no:@"ครั้งที่ 1" area:@"13635143.5071" area_rai:@"7818" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าแสลงพัน" provinceE:@"KrabiProvince" code:@"E2.001" par:@"88/2508" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"16 พฤศจิกายน 2508" url:@"E2.001-2508.PDF" date_no:@"ครั้งที่ 1" area:@"2778411.6987" area_rai:@"1668" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองเยีย แปลงที่ 1" provinceE:@"KrabiProvince" code:@"E2.003" par:@"203/2510" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"27 มิถุนายน 2510" url:@"E2.003-2510.PDF" date_no:@"ครั้งที่ 1" area:@"2940107.23009" area_rai:@"1762" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองเยีย แปลงที่ 2" provinceE:@"KrabiProvince" code:@"E2.009" par:@"352/2511" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"22 พฤศจิกายน 2511" url:@"E2.009-2511.PDF" date_no:@"ครั้งที่ 1" area:@"439989.114305" area_rai:@"331" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองเยีย แปลงที่ 4" provinceE:@"KrabiProvince" code:@"E2.008" par:@"293/2511" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"30 เมษายน 2511" url:@"E2.008-2511.PDF" date_no:@"ครั้งที่ 1" area:@"684170.445652" area_rai:@"456" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองเหล็ก" provinceE:@"KrabiProvince" code:@"E2.022" par:@"695/2517" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"13 สิงหาคม 2517" url:@"E2.022-2517.PDF" date_no:@"ครั้งที่ 1" area:@"18029935.3366" area_rai:@"11225" ]; [self.SurinProvinces addObject:SurinProvince];
    SurinProvince = [[ItemGuide alloc] initWithName:@"ป่าหินล้ม" provinceE:@"KrabiProvince" code:@"E2.011" par:@"743/2518" type:@"ป่าสงวนแห่งชาติ" province:@"สุรินทร์" date:@"10 มิถุนายน 2518" url:@"E2.011-2518.PDF" date_no:@"ครั้งที่ 2" area:@"70016540.197" area_rai:@"43962" ]; [self.SurinProvinces addObject:SurinProvince];
    self.NongKhaiProvinces = [[NSMutableArray alloc] init];  ItemGuide *NongKhaiProvince = [[ItemGuide alloc] initWithName:@"ป่าดงชมภูพร" provinceE:@"KrabiProvince" code:@"G2.008" par:@"891/2523" type:@"ป่าสงวนแห่งชาติ" province:@"หนองคาย" date:@"24 มิถุนายน 2523" url:@"G2.008-2523.PDF" date_no:@"ครั้งที่ 1" area:@"97930505.7441" area_rai:@"61118" ]; [self.NongKhaiProvinces addObject:NongKhaiProvince];
    NongKhaiProvince = [[ItemGuide alloc] initWithName:@"ป่าดงเซกา ป่าดงสีชมพู ป่าภูทอกใหญ่ภูวัว และป่าดงซำบอนเซกา" provinceE:@"KrabiProvince" code:@"G2.006" par:@"217/2510" type:@"ป่าสงวนแห่งชาติ" province:@"หนองคาย" date:@"5 กันยายน 2510" url:@"G2.006-2510.PDF" date_no:@"ครั้งที่ 1" area:@"659684273.636" area_rai:@"366250" ]; [self.NongKhaiProvinces addObject:NongKhaiProvince];
    NongKhaiProvince = [[ItemGuide alloc] initWithName:@"ป่าดงดิบกะลา ป่าภูสิงห์ และป่าดงสีชมพู" provinceE:@"KrabiProvince" code:@"G2.005" par:@"209/2510" type:@"ป่าสงวนแห่งชาติ" province:@"หนองคาย" date:@"11 สิงหาคม 2510" url:@"G2.005-2510.PDF" date_no:@"ครั้งที่ 1" area:@"484906504.749" area_rai:@"258235" ]; [self.NongKhaiProvinces addObject:NongKhaiProvince];
    NongKhaiProvince = [[ItemGuide alloc] initWithName:@"ป่าดงภูวัว" provinceE:@"KrabiProvince" code:@"G2.002" par:@"205/2510" type:@"ป่าสงวนแห่งชาติ" province:@"หนองคาย" date:@"8 สิงหาคม 2510" url:@"G2.002-2510.PDF" date_no:@"ครั้งที่ 1" area:@"152998094.982" area_rai:@"89375" ]; [self.NongKhaiProvinces addObject:NongKhaiProvince];
    NongKhaiProvince = [[ItemGuide alloc] initWithName:@"ป่าดงสีชมพูโพนพิสัย" provinceE:@"KrabiProvince" code:@"G2.007" par:@"711/2517" type:@"ป่าสงวนแห่งชาติ" province:@"หนองคาย" date:@"22 ตุลาคม 2517" url:@"G2.007-2517.PDF" date_no:@"ครั้งที่ 2" area:@"1101324678.97" area_rai:@"735625" ]; [self.NongKhaiProvinces addObject:NongKhaiProvince];
    NongKhaiProvince = [[ItemGuide alloc] initWithName:@"ป่าดงหนองตอ และป่าดงสีชมพู" provinceE:@"KrabiProvince" code:@"G2.003" par:@"206/2510" type:@"ป่าสงวนแห่งชาติ" province:@"หนองคาย" date:@"11 สิงหาคม 2510" url:@"G2.003-2510.PDF" date_no:@"ครั้งที่ 1" area:@"343213490.946" area_rai:@"194375" ]; [self.NongKhaiProvinces addObject:NongKhaiProvince];
    NongKhaiProvince = [[ItemGuide alloc] initWithName:@"ป่าทุ่งหลวง" provinceE:@"KrabiProvince" code:@"G2.001" par:@"204/2510" type:@"ป่าสงวนแห่งชาติ" province:@"หนองคาย" date:@"27 มิถุนายน 2510" url:@"G2.001-2510.PDF" date_no:@"ครั้งที่ 1" area:@"81757344.8052" area_rai:@"39375" ]; [self.NongKhaiProvinces addObject:NongKhaiProvince];
    NongKhaiProvince = [[ItemGuide alloc] initWithName:@"ป่าพานพร้าว และป่าแก้งไก่" provinceE:@"KrabiProvince" code:@"G2.004" par:@"811/2521" type:@"ป่าสงวนแห่งชาติ" province:@"หนองคาย" date:@"3 ตุลาคม 2521" url:@"G2.004-2521.PDF" date_no:@"ครั้งที่ 2" area:@"505573824.396" area_rai:@"342422" ]; [self.NongKhaiProvinces addObject:NongKhaiProvince];
    self.NongBuaLamphuProvinces = [[NSMutableArray alloc] init];  ItemGuide *NongBuaLamphuProvince = [[ItemGuide alloc] initWithName:@"ป่าเก่ากลอยและป่านากลาง" provinceE:@"KrabiProvince" code:@"G1.020" par:@"942/2524" type:@"ป่าสงวนแห่งชาติ" province:@"หนองบัวลำภู" date:@"23 กรกฎาคม 2524" url:@"G1.020-2524.PDF" date_no:@"ครั้งที่ 1" area:@"1335882278.82" area_rai:@"756193" ]; [self.NongBuaLamphuProvinces addObject:NongBuaLamphuProvince];
    NongBuaLamphuProvince = [[ItemGuide alloc] initWithName:@"ป่าภูเก้า" provinceE:@"KrabiProvince" code:@"G1.006" par:@"490/2515" type:@"ป่าสงวนแห่งชาติ" province:@"หนองบัวลำภู" date:@"21 พฤศจิกายน 2515" url:@"G1.006-2515.PDF" date_no:@"ครั้งที่ 1" area:@"173152170.239" area_rai:@"103125" ]; [self.NongBuaLamphuProvinces addObject:NongBuaLamphuProvince];
    NongBuaLamphuProvince = [[ItemGuide alloc] initWithName:@"ป่าภูพาน" provinceE:@"KrabiProvince" code:@"G1.010" par:@"655/2517" type:@"ป่าสงวนแห่งชาติ" province:@"หนองบัวลำภู" date:@"10 พฤษภาคม 2517" url:@"G1.010-2517.PDF" date_no:@"ครั้งที่ 1" area:@"32900289.6819" area_rai:@"19081" ]; [self.NongBuaLamphuProvinces addObject:NongBuaLamphuProvince];
    NongBuaLamphuProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองบัว" provinceE:@"KrabiProvince" code:@"G1.014" par:@"751/2518" type:@"ป่าสงวนแห่งชาติ" province:@"หนองบัวลำภู" date:@"22 กรกฎาคม 2518" url:@"G1.014-2518.PDF" date_no:@"ครั้งที่ 1" area:@"4439447.8388" area_rai:@"2390" ]; [self.NongBuaLamphuProvinces addObject:NongBuaLamphuProvince];
    NongBuaLamphuProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองเรือ" provinceE:@"KrabiProvince" code:@"G1.021" par:@"944/2524" type:@"ป่าสงวนแห่งชาติ" province:@"หนองบัวลำภู" date:@"23 กรกฎาคม 2524" url:@"G1.021-2524.PDF" date_no:@"ครั้งที่ 1" area:@"819296746.941" area_rai:@"709008" ]; [self.NongBuaLamphuProvinces addObject:NongBuaLamphuProvince];
    NongBuaLamphuProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยส้มและป่าภูผาแดง" provinceE:@"KrabiProvince" code:@"G1.017" par:@"847/2522" type:@"ป่าสงวนแห่งชาติ" province:@"หนองบัวลำภู" date:@"1 กรกฎาคม 2522" url:@"G1.017-2522.PDF" date_no:@"ครั้งที่ 1" area:@"24187288.8268" area_rai:@"13850" ]; [self.NongBuaLamphuProvinces addObject:NongBuaLamphuProvince];
    self.AmnatCharoenProvinces = [[NSMutableArray alloc] init];  ItemGuide *AmnatCharoenProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกสองสลึง" provinceE:@"KrabiProvince" code:@"E1.032" par:@"760/2518" type:@"ป่าสงวนแห่งชาติ" province:@"อำนาจเจริญ" date:@"25 พฤศจิกายน 2518" url:@"E1.032-2518.PDF" date_no:@"ครั้งที่ 1" area:@"41584144.3403" area_rai:@"25975" ]; [self.AmnatCharoenProvinces addObject:AmnatCharoenProvince];
    AmnatCharoenProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกโสกใหญ่" provinceE:@"KrabiProvince" code:@"E1.045" par:@"1039/2527" type:@"ป่าสงวนแห่งชาติ" province:@"อำนาจเจริญ" date:@"31 พฤษภาคม 2527" url:@"E1.045-2527.PDF" date_no:@"ครั้งที่ 1" area:@"14376727.5964" area_rai:@"8904" ]; [self.AmnatCharoenProvinces addObject:AmnatCharoenProvince];
    AmnatCharoenProvince = [[ItemGuide alloc] initWithName:@"ป่าดง ป่ายางและป่าดงปู่ตา" provinceE:@"KrabiProvince" code:@"E1.026" par:@"676/2517" type:@"ป่าสงวนแห่งชาติ" province:@"อำนาจเจริญ" date:@"4 มิถุนายน 2517" url:@"E1.026-2517.PDF" date_no:@"ครั้งที่ 1" area:@"6461724.50415" area_rai:@"3400" ]; [self.AmnatCharoenProvinces addObject:AmnatCharoenProvince];
    AmnatCharoenProvince = [[ItemGuide alloc] initWithName:@"ป่าดงคำเดือย แปลงที่หนึ่ง" provinceE:@"KrabiProvince" code:@"E1.002" par:@"754/2518" type:@"ป่าสงวนแห่งชาติ" province:@"อำนาจเจริญ" date:@"15 สิงหาคม 2518" url:@"E1.002-2518.PDF" date_no:@"ครั้งที่ 2" area:@"457879405.45" area_rai:@"269862.88" ]; [self.AmnatCharoenProvinces addObject:AmnatCharoenProvince];
    AmnatCharoenProvince = [[ItemGuide alloc] initWithName:@"ป่าดงนาซีและป่าขี้แลน" provinceE:@"KrabiProvince" code:@"E1.015" par:@"489/2515" type:@"ป่าสงวนแห่งชาติ" province:@"อำนาจเจริญ" date:@"21 พฤศจิกายน 2515" url:@"E1.015-2515.PDF" date_no:@"ครั้งที่ 1" area:@"44970448.2136" area_rai:@"28668" ]; [self.AmnatCharoenProvinces addObject:AmnatCharoenProvince];
    AmnatCharoenProvince = [[ItemGuide alloc] initWithName:@"ป่าดงหนองบัว แปลงที่หนึ่ง" provinceE:@"KrabiProvince" code:@"E1.038" par:@"867/2522" type:@"ป่าสงวนแห่งชาติ" province:@"อำนาจเจริญ" date:@"1 ตุลาคม 2522" url:@"E1.038-2522.PDF" date_no:@"ครั้งที่ 1" area:@"46777390.2631" area_rai:@"29497" ]; [self.AmnatCharoenProvinces addObject:AmnatCharoenProvince];
    AmnatCharoenProvince = [[ItemGuide alloc] initWithName:@"ป่าดงหัวกอง และป่าดงปอ" provinceE:@"KrabiProvince" code:@"E1.053" par:@"1126/2528" type:@"ป่าสงวนแห่งชาติ" province:@"อำนาจเจริญ" date:@"27 พฤศจิกายน 2528" url:@"E1.053-2528.PDF" date_no:@"ครั้งที่ 1" area:@"93872066.9118" area_rai:@"57969" ]; [self.AmnatCharoenProvinces addObject:AmnatCharoenProvince];
    AmnatCharoenProvince = [[ItemGuide alloc] initWithName:@"ป่าดงหัวกองและป่าดงบังอี่" provinceE:@"KrabiProvince" code:@"E1.005" par:@"262/2510" type:@"ป่าสงวนแห่งชาติ" province:@"อำนาจเจริญ" date:@"26 ธันวาคม 2510" url:@"E1.005-2510.PDF" date_no:@"ครั้งที่ 1" area:@"308642079.504" area_rai:@"195181" ]; [self.AmnatCharoenProvinces addObject:AmnatCharoenProvince];
    AmnatCharoenProvince = [[ItemGuide alloc] initWithName:@"ป่าดงใหญ่" provinceE:@"KrabiProvince" code:@"E1.036" par:@"845/2522" type:@"ป่าสงวนแห่งชาติ" province:@"อำนาจเจริญ" date:@"1 กรกฎาคม 2522" url:@"E1.036-2522.PDF" date_no:@"ครั้งที่ 1" area:@"50722195.814" area_rai:@"32250" ]; [self.AmnatCharoenProvinces addObject:AmnatCharoenProvince];
    AmnatCharoenProvince = [[ItemGuide alloc] initWithName:@"ป่าฝนแสนห่า" provinceE:@"KrabiProvince" code:@"E1.034" par:@"789/2520" type:@"ป่าสงวนแห่งชาติ" province:@"อำนาจเจริญ" date:@"25 ตุลาคม 2520" url:@"E1.034-2520.PDF" date_no:@"ครั้งที่ 1" area:@"11486425.8934" area_rai:@"9450" ]; [self.AmnatCharoenProvinces addObject:AmnatCharoenProvince];
    AmnatCharoenProvince = [[ItemGuide alloc] initWithName:@"ป่ารังงาม" provinceE:@"KrabiProvince" code:@"E1.048" par:@"1054 /2527" type:@"ป่าสงวนแห่งชาติ" province:@"อำนาจเจริญ" date:@"30 สิงหาคม 2527" url:@"E1.048-2527.PDF" date_no:@"ครั้งที่ 1" area:@"41139109.378" area_rai:@"24695" ]; [self.AmnatCharoenProvinces addObject:AmnatCharoenProvince];
    AmnatCharoenProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองลุมพุก" provinceE:@"KrabiProvince" code:@"E1.009" par:@"442/2514" type:@"ป่าสงวนแห่งชาติ" province:@"อำนาจเจริญ" date:@"30 ธันวาคม 2514" url:@"E1.009-2514.PDF" date_no:@"ครั้งที่ 1" area:@"8565487.28052" area_rai:@"5487" ]; [self.AmnatCharoenProvinces addObject:AmnatCharoenProvince];
    AmnatCharoenProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองหลุบและป่าดงปู่ตา" provinceE:@"KrabiProvince" code:@"E1.023" par:@"611/2516" type:@"ป่าสงวนแห่งชาติ" province:@"อำนาจเจริญ" date:@"4 ธันวาคม 2516" url:@"E1.023-2516.PDF" date_no:@"ครั้งที่ 1" area:@"19462861.2034" area_rai:@"12781" ]; [self.AmnatCharoenProvinces addObject:AmnatCharoenProvince];
    self.UdonThaniProvinces = [[NSMutableArray alloc] init];  ItemGuide *UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่ากุดจับ" provinceE:@"KrabiProvince" code:@"G1.001" par:@"199/2510" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"23 พฤษภาคม 2510" url:@"G1.001-2510.PDF" date_no:@"ครั้งที่ 1" area:@"333493798.376" area_rai:@"193803" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเขือน้ำ" provinceE:@"KrabiProvince" code:@"G1.013" par:@"745/2518" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"10 มิถุนายน 2518" url:@"G1.013-2518.PDF" date_no:@"ครั้งที่ 1" area:@"508224127.932" area_rai:@"166250" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกทับถ่านและป่าโคกวังเดือนห้า" provinceE:@"KrabiProvince" code:@"G1.004" par:@"362/2511" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"26 พฤศจิกายน 2511" url:@"G1.004-2511.PDF" date_no:@"ครั้งที่ 1" area:@"127749693.448" area_rai:@"79375" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกน้ำเค็มและป่าโคกดอนโพธิ์" provinceE:@"KrabiProvince" code:@"G1.002" par:@"290/2511" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"23 เมษายน 2511" url:@"G1.002-2511.PDF" date_no:@"ครั้งที่ 1" area:@"186833136.021" area_rai:@"108750" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงหนองขุ่นและป่าดงหนองไฮ" provinceE:@"KrabiProvince" code:@"G1.015" par:@"775/2518" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"24 กุมภาพันธ์ 2519" url:@"G1.015-2519.PDF" date_no:@"ครั้งที่ 1" area:@"32017117.4642" area_rai:@"20650" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าตำบลเชียงหวาง ป่าตำบลเพ็ญ และป่าตำบลสุมเส้า" provinceE:@"KrabiProvince" code:@"G1.011" par:@"678/2517" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"18 มิถุนายน 2517" url:@"G1.011-2517.PDF" date_no:@"ครั้งที่ 1" area:@"128111828.242" area_rai:@"58083" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าทม และป่าข่า" provinceE:@"KrabiProvince" code:@"G1.026" par:@"1199/2530" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"27 มีนาคม 2530" url:@"G1.026-2530.PDF" date_no:@"ครั้งที่ 1" area:@"109185453.675" area_rai:@"68125" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่านายูง และป่าน้ำโสม" provinceE:@"KrabiProvince" code:@"G1.016" par:@"780/2519" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"29 มิถุนายน 2519" url:@"G1.016-2519.PDF" date_no:@"ครั้งที่ 1" area:@"1264769583.68" area_rai:@"668750" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าบะยาว ป่าหัวนาคำ ป่านายูง ป่าหนองกุงทับม้า และป่าหนองหญ้าไชย" provinceE:@"KrabiProvince" code:@"G1.009" par:@"558/2516" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"14 สิงหาคม 2516" url:@"G1.009-2516.PDF" date_no:@"ครั้งที่ 1" area:@"738096708.322" area_rai:@"446131" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านจัน แปลงที่สอง" provinceE:@"KrabiProvince" code:@"G1.018" par:@"887/2523" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"19 มิถุนายน 2523" url:@"G1.018-2523.PDF" date_no:@"ครั้งที่ 1" area:@"150769230.071" area_rai:@"99062" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านจัน แปลงที่หนึ่ง" provinceE:@"KrabiProvince" code:@"G1.022" par:@"1011/2526" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"30 สิงหาคม 2526" url:@"G1.022-2526.PDF" date_no:@"ครั้งที่ 1" area:@"17009119.5656" area_rai:@"9687" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านจีต ป่าไชยวาน ป่าหนองหลักและป่าคอนสาย" provinceE:@"KrabiProvince" code:@"G1.019" par:@"898/2523" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"1 พฤศจิกายน 2523" url:@"G1.019-2523.PDF" date_no:@"ครั้งที่ 1" area:@"345061498.268" area_rai:@"208937.5" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าบ้านดุงและป่าดงเย็น แปลงที่หนึ่ง และแปลงที่สอง" provinceE:@"KrabiProvince" code:@"G1.027" par:@"1219/2531" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"23 กุมภาพันธ์ 2531" url:@"G1.027-2531.PDF" date_no:@"ครั้งที่ 1" area:@"75026241.3078" area_rai:@"39501" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าปะโค ป่าโพธิ์ศรีสำราญ และป่าแสงสว่าง" provinceE:@"KrabiProvince" code:@"G1.025" par:@"1131/2528" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"27 พฤศจิกายน 2528" url:@"G1.025-2528.PDF" date_no:@"ครั้งที่ 1" area:@"153610121.515" area_rai:@"95234" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าไผท และป่าโคกไม้งาม" provinceE:@"KrabiProvince" code:@"G1.024" par:@"1124/2528" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"27 พฤศจิกายน 2528" url:@"G1.024-2528.PDF" date_no:@"ครั้งที่ 1" area:@"143917521.364" area_rai:@"88962" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าพันดอนและป่าปะโค" provinceE:@"KrabiProvince" code:@"G1.003" par:@"963/2524" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"30 ธันวาคม 2524" url:@"G1.003-2524.PDF" date_no:@"ครั้งที่ 2" area:@"308303942.417" area_rai:@"192356" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าโพธิ์ศรีสำราญ" provinceE:@"KrabiProvince" code:@"G1.008" par:@"548/2516" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"24 กรกฎาคม 2516" url:@"G1.008-2516.PDF" date_no:@"ครั้งที่ 1" area:@"112738541.13" area_rai:@"87386" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเวียงคำและป่าศรีธาตุ" provinceE:@"KrabiProvince" code:@"G1.012" par:@"724/2518" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"18 กุมภาพันธ์ 2518" url:@"G1.012-2518.PDF" date_no:@"ครั้งที่ 1" area:@"191757740.255" area_rai:@"115300" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองบุและป่าหนองหาน" provinceE:@"KrabiProvince" code:@"G1.007" par:@"507/2515" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"30 ธันวาคม 2515" url:@"G1.007-2515.PDF" date_no:@"ครั้งที่ 1" area:@"31497641.6915" area_rai:@"16131" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองหญ้าไซ ป่าท่าลาด ป่าวังชัย และป่าลำปาว" provinceE:@"KrabiProvince" code:@"G1.023" par:@"1119/2528" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"30 กันยายน 2528" url:@"G1.023-2528.PDF" date_no:@"ครั้งที่ 1" area:@"22146210.2803" area_rai:@"11875" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    UdonThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าหมากหญ้า" provinceE:@"KrabiProvince" code:@"G1.005" par:@"363/2511" type:@"ป่าสงวนแห่งชาติ" province:@"อุดรธานี" date:@"26 พฤศจิกายน 2511" url:@"G1.005-2511.PDF" date_no:@"ครั้งที่ 1" area:@"277726346.324" area_rai:@"134375" ]; [self.UdonThaniProvinces addObject:UdonThaniProvince];
    self.UttaraditProvinces = [[NSMutableArray alloc] init];  ItemGuide *UttaraditProvince = [[ItemGuide alloc] initWithName:@"ป่าเขากระทิง" provinceE:@"KrabiProvince" code:@"M2.013" par:@"1149/2529" type:@"ป่าสงวนแห่งชาติ" province:@"อุตรดิตถ์" date:@"16 เมษายน 2529" url:@"M2.013-2529.PDF" date_no:@"ครั้งที่ 1" area:@"19177889.5746" area_rai:@"11844" ]; [self.UttaraditProvinces addObject:UttaraditProvince];
    UttaraditProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาใหญ่" provinceE:@"KrabiProvince" code:@"M2.015" par:@"1196/2530" type:@"ป่าสงวนแห่งชาติ" province:@"อุตรดิตถ์" date:@"27 มีนาคม 2530" url:@"M2.015-2530.PDF" date_no:@"ครั้งที่ 1" area:@"91319454.0462" area_rai:@"56410" ]; [self.UttaraditProvinces addObject:UttaraditProvince];
    UttaraditProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองตรอนฝั่งขวา" provinceE:@"KrabiProvince" code:@"M2.004" par:@"193/2510" type:@"ป่าสงวนแห่งชาติ" province:@"อุตรดิตถ์" date:@"25 เมษายน 2510" url:@"M2.004-2510.PDF" date_no:@"ครั้งที่ 1" area:@"548576822.002" area_rai:@"323556" ]; [self.UttaraditProvinces addObject:UttaraditProvince];
    UttaraditProvince = [[ItemGuide alloc] initWithName:@"ป่าคลองตรอนฝั่งซ้าย" provinceE:@"KrabiProvince" code:@"M2.005" par:@"215/2510" type:@"ป่าสงวนแห่งชาติ" province:@"อุตรดิตถ์" date:@"1 กันยายน 2510" url:@"M2.005-2510.PDF" date_no:@"ครั้งที่ 1" area:@"745323431.626" area_rai:@"469175" ]; [self.UttaraditProvinces addObject:UttaraditProvince];
    UttaraditProvince = [[ItemGuide alloc] initWithName:@"ป่าจริม" provinceE:@"KrabiProvince" code:@"M2.009" par:@"817/2521" type:@"ป่าสงวนแห่งชาติ" province:@"อุตรดิตถ์" date:@"14 พฤศจิกายน 2521" url:@"M2.009-2521.PDF" date_no:@"ครั้งที่ 1" area:@"524661045.461" area_rai:@"313125" ]; [self.UttaraditProvinces addObject:UttaraditProvince];
    UttaraditProvince = [[ItemGuide alloc] initWithName:@"ป่าดงช้างดี" provinceE:@"KrabiProvince" code:@"M2.003" par:@"136/2509" type:@"ป่าสงวนแห่งชาติ" province:@"อุตรดิตถ์" date:@"27 กันยายน 2509" url:@"M2.003-2509.PDF" date_no:@"ครั้งที่ 1" area:@"29234835.3377" area_rai:@"18200" ]; [self.UttaraditProvinces addObject:UttaraditProvince];
    UttaraditProvince = [[ItemGuide alloc] initWithName:@"ป่านานกกก" provinceE:@"KrabiProvince" code:@"M2.011" par:@"1049/2527" type:@"ป่าสงวนแห่งชาติ" province:@"อุตรดิตถ์" date:@"31 พฤษภาคม 2527" url:@"M2.011-2527.PDF" date_no:@"ครั้งที่ 1" area:@"41312292.8198" area_rai:@"24850" ]; [self.UttaraditProvinces addObject:UttaraditProvince];
    UttaraditProvince = [[ItemGuide alloc] initWithName:@"ป่านาอิน-นายาง" provinceE:@"KrabiProvince" code:@"M2.001" par:@"60/2502" type:@"ป่าสงวนแห่งชาติ" province:@"อุตรดิตถ์" date:@"8 ธันวาคม 2502" url:@"M2.001-2502.PDF" date_no:@"ครั้งที่ 1" area:@"191673856.245" area_rai:@"118750" ]; [self.UttaraditProvinces addObject:UttaraditProvince];
    UttaraditProvince = [[ItemGuide alloc] initWithName:@"ป่าน้ำปาด" provinceE:@"KrabiProvince" code:@"M2.008" par:@"487/2515" type:@"ป่าสงวนแห่งชาติ" province:@"อุตรดิตถ์" date:@"21 พฤศจิกายน 2515" url:@"M2.008-2515.PDF" date_no:@"ครั้งที่ 1" area:@"2238397658.24" area_rai:@"1362806" ]; [self.UttaraditProvinces addObject:UttaraditProvince];
    UttaraditProvince = [[ItemGuide alloc] initWithName:@"ป่าบึงซ่าน" provinceE:@"KrabiProvince" code:@"M2.002" par:@"22/2507" type:@"ป่าสงวนแห่งชาติ" province:@"อุตรดิตถ์" date:@"31 ธันวาคม 2507" url:@"M2.002-2507.PDF" date_no:@"ครั้งที่ 1" area:@"66473.3097193" area_rai:@"50" ]; [self.UttaraditProvinces addObject:UttaraditProvince];
    UttaraditProvince = [[ItemGuide alloc] initWithName:@"ป่าปากห้วยฉลอง และป่าห้วยสีเสียด" provinceE:@"KrabiProvince" code:@"M2.006" par:@"404/2512" type:@"ป่าสงวนแห่งชาติ" province:@"อุตรดิตถ์" date:@"1 เมษายน 2512" url:@"M2.006-2512.PDF" date_no:@"ครั้งที่ 1" area:@"135641451.74" area_rai:@"94375" ]; [self.UttaraditProvinces addObject:UttaraditProvince];
    UttaraditProvince = [[ItemGuide alloc] initWithName:@"ป่าพระฝาง" provinceE:@"KrabiProvince" code:@"M2.014" par:@"1183/2529" type:@"ป่าสงวนแห่งชาติ" province:@"อุตรดิตถ์" date:@"8 ธันวาคม 2529" url:@"M2.014-2529.PDF" date_no:@"ครั้งที่ 1" area:@"17458176.3157" area_rai:@"10678.75" ]; [self.UttaraditProvinces addObject:UttaraditProvince];
    UttaraditProvince = [[ItemGuide alloc] initWithName:@"ป่าลำน้ำน่านฝั่งขวา" provinceE:@"KrabiProvince" code:@"M2.010" par:@"862/2522" type:@"ป่าสงวนแห่งชาติ" province:@"อุตรดิตถ์" date:@"3 สิงหาคม 2522" url:@"M2.010-Plus" date_no:@"ครั้งที่ 1" area:@"614277534.177" area_rai:@"361875" ]; [self.UttaraditProvinces addObject:UttaraditProvince];
    UttaraditProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยเกียงพา และป่าน้ำไคร้" provinceE:@"KrabiProvince" code:@"M2.012" par:@"1135/2528" type:@"ป่าสงวนแห่งชาติ" province:@"อุตรดิตถ์" date:@"27 พฤศจิกายน 2528" url:@"M2.012-2528.PDF" date_no:@"ครั้งที่ 1" area:@"199308762.565" area_rai:@"114375" ]; [self.UttaraditProvinces addObject:UttaraditProvince];
    UttaraditProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยช้าง และป่าปู่เจ้า" provinceE:@"KrabiProvince" code:@"M2.007" par:@"439/2514" type:@"ป่าสงวนแห่งชาติ" province:@"อุตรดิตถ์" date:@"30 ธันวาคม 2514" url:@"M2.007-2514.PDF" date_no:@"ครั้งที่ 1" area:@"31324653.7019" area_rai:@"19975" ]; [self.UttaraditProvinces addObject:UttaraditProvince];
    self.UthaiThaniProvinces = [[NSMutableArray alloc] init];  ItemGuide *UthaiThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาตำแย และป่าเขาราวเทียน" provinceE:@"KrabiProvince" code:@"O2.005" par:@"632/2516" type:@"ป่าสงวนแห่งชาติ" province:@"อุทัยธานี" date:@"25 ธันวาคม 2516" url:@"O2.005-2516.PDF" date_no:@"ครั้งที่ 1" area:@"262175366.33" area_rai:@"179375" ]; [self.UthaiThaniProvinces addObject:UthaiThaniProvince];
    UthaiThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาบางแกรก และป่าทุ่งโพธิ์" provinceE:@"KrabiProvince" code:@"O2.001" par:@"189/2506" type:@"ป่าสงวนแห่งชาติ" province:@"อุทัยธานี" date:@"29 ตุลาคม 2506" url:@"O2.001-2506.PDF" date_no:@"ครั้งที่ 1" area:@"38277212.08" area_rai:@"22625" ]; [self.UthaiThaniProvinces addObject:UthaiThaniProvince];
    UthaiThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาพุวันดี ป่าห้วยกระเสียว และป่าเขาราวเทียน" provinceE:@"KrabiProvince" code:@"O2.009" par:@"1174/2529" type:@"ป่าสงวนแห่งชาติ" province:@"อุทัยธานี" date:@"3 กรกฎาคม 2529" url:@"O2.009-2529.PDF" date_no:@"ครั้งที่ 1" area:@"228331199.491" area_rai:@"137335" ]; [self.UthaiThaniProvinces addObject:UthaiThaniProvince];
    UthaiThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเขาหลวง แปลงที่สอง" provinceE:@"KrabiProvince" code:@"O2.006" par:@"636/2516" type:@"ป่าสงวนแห่งชาติ" province:@"อุทัยธานี" date:@"29 ธันวาคม 2516" url:@"O2.006-2516.PDF" date_no:@"ครั้งที่ 1" area:@"26089279.2848" area_rai:@"16250" ]; [self.UthaiThaniProvinces addObject:UthaiThaniProvince];
    UthaiThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าปลายห้วยกระเสียว" provinceE:@"KrabiProvince" code:@"O2.003" par:@"41/2508" type:@"ป่าสงวนแห่งชาติ" province:@"อุทัยธานี" date:@"9 มีนาคม 2508" url:@"O2.003-2508.PDF" date_no:@"ครั้งที่ 1" area:@"235745333.695" area_rai:@"160625" ]; [self.UthaiThaniProvinces addObject:UthaiThaniProvince];
    UthaiThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าไผ่เขียว" provinceE:@"KrabiProvince" code:@"O2.002" par:@"215/2507" type:@"ป่าสงวนแห่งชาติ" province:@"อุทัยธานี" date:@"16 เมษายน 2529" url:@"O2.002-2529.PDF" date_no:@"ครั้งที่ 3" area:@"161464136.788" area_rai:@"89000" ]; [self.UthaiThaniProvinces addObject:UthaiThaniProvince];
    UthaiThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยขาแข้ง" provinceE:@"KrabiProvince" code:@"O2.007" par:@"902/2523" type:@"ป่าสงวนแห่งชาติ" province:@"อุทัยธานี" date:@"1 พฤศจิกายน 2523" url:@"O2.007-2523.PDF" date_no:@"ครั้งที่ 1" area:@"2266352664.55" area_rai:@"1403125" ]; [self.UthaiThaniProvinces addObject:UthaiThaniProvince];
    UthaiThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยทับเสลา และป่าห้วยคอกควาย" provinceE:@"KrabiProvince" code:@"O2.008" par:@"1122/2528" type:@"ป่าสงวนแห่งชาติ" province:@"อุทัยธานี" date:@"30 กันยายน 2528" url:@"O2.008-2528.PDF" date_no:@"ครั้งที่ 1" area:@"1178474230.35" area_rai:@"649500" ]; [self.UthaiThaniProvinces addObject:UthaiThaniProvince];
    UthaiThaniProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยท่ากวย และป่าห้วยกระเวน" provinceE:@"KrabiProvince" code:@"O2.004" par:@"157/2509" type:@"ป่าสงวนแห่งชาติ" province:@"อุทัยธานี" date:@"27 ธันวาคม 2509" url:@"O2.004-2509.PDF" date_no:@"ครั้งที่ 1" area:@"257724187.143" area_rai:@"170350" ]; [self.UthaiThaniProvinces addObject:UthaiThaniProvince];
    self.UbonRatchathaniProvinces = [[NSMutableArray alloc] init];  ItemGuide *UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่ากลางใหญ่" provinceE:@"KrabiProvince" code:@"E1.028" par:@"688/2517" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"23 กรกฎาคม 2517" url:@"E1.028-2517.PDF" date_no:@"ครั้งที่ 1" area:@"2241676.01671" area_rai:@"1375" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่ากุดกระเสียนและป่าดงชี" provinceE:@"KrabiProvince" code:@"E1.013" par:@"470/2515" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"7 พฤศจิกายน 2515" url:@"E1.013-2515.PDF" date_no:@"ครั้งที่ 1" area:@"40536161.6236" area_rai:@"19312" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่ากุดชมพู" provinceE:@"KrabiProvince" code:@"E1.003" par:@"826/2521" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"29 ธันวาคม 2521" url:@"E1.003-2521.PDF" date_no:@"ครั้งที่ 2" area:@"45473969.5196" area_rai:@"33142" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าคันหินขวาง" provinceE:@"KrabiProvince" code:@"E1.041" par:@"918/2523" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"30 ธันวาคม 2523" url:@"E1.041-2523.PDF" date_no:@"ครั้งที่ 1" area:@"3078893.08327" area_rai:@"2003" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกน้ำคำ" provinceE:@"KrabiProvince" code:@"E1.016" par:@"504/2515" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"12 ธันวาคม 2515" url:@"E1.016-2515.PDF" date_no:@"ครั้งที่ 1" area:@"89295972.5025" area_rai:@"55625" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าโคกหินอ่าง" provinceE:@"KrabiProvince" code:@"E1.052" par:@"1123/2528" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"27 พฤศจิกายน 2528" url:@"E1.052-2528.PDF" date_no:@"ครั้งที่ 1" area:@"3609199.90392" area_rai:@"2188" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าช่องเม็ก" provinceE:@"KrabiProvince" code:@"E1.057" par:@"1211/2530" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"2 ธันวาคม 2530" url:@"E1.057-2530.PDF" date_no:@"ครั้งที่ 1" area:@"27556626.9113" area_rai:@"21859" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงกระบูน" provinceE:@"KrabiProvince" code:@"E1.011" par:@"452/2514" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"30 ธันวาคม 2514" url:@"E1.011-2514.PDF" date_no:@"ครั้งที่ 1" area:@"14758205.5211" area_rai:@"10156" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงเก้าต้น" provinceE:@"KrabiProvince" code:@"E1.024" par:@"652/2517" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"10 พฤษภาคม 2517" url:@"E1.024-2517.PDF" date_no:@"ครั้งที่ 1" area:@"62334579.4625" area_rai:@"40827" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงขุมคำ" provinceE:@"KrabiProvince" code:@"E1.044" par:@"1016/2526" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"6 ธันวาคม 2526" url:@"E1.044-2526.PDF" date_no:@"ครั้งที่ 1" area:@"196010012.47" area_rai:@"120831" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงคันไทร" provinceE:@"KrabiProvince" code:@"E1.007" par:@"380/2511" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"28 พฤศจิกายน 2511" url:@"E1.007-2511.PDF" date_no:@"ครั้งที่ 1" area:@"61885087.4724" area_rai:@"36875" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงแดง" provinceE:@"KrabiProvince" code:@"E1.030" par:@"736/2518" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"22 เมษายน 2518" url:@"E1.030-2518.PDF" date_no:@"ครั้งที่ 1" area:@"12077703.8316" area_rai:@"7825" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงตาดไก่ แปลงที่หนึ่ง แปลงที่สอง และแปลงที่สาม" provinceE:@"KrabiProvince" code:@"E1.039" par:@"869/2522" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"26 ธันวาคม 2522" url:@"E1.039-2522.PDF" date_no:@"ครั้งที่ 1" area:@"11502156.7459" area_rai:@"6750" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงตาหวัง" provinceE:@"KrabiProvince" code:@"E1.056" par:@"1209/2530" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"9 พฤศจิกายน 2530" url:@"E1.056-2530.PDF" date_no:@"ครั้งที่ 1" area:@"106277775.84" area_rai:@"54692" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงนาแก" provinceE:@"KrabiProvince" code:@"E1.046" par:@"1040/2527" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"31 พฤษภาคม 2527" url:@"E1.046-2527.PDF" date_no:@"ครั้งที่ 1" area:@"379105599.86" area_rai:@"230625" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงน้ำคำ" provinceE:@"KrabiProvince" code:@"E1.025" par:@"654/2517" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"10 พฤษภาคม 2517" url:@"E1.025-2517.PDF" date_no:@"ครั้งที่ 1" area:@"5476989.44417" area_rai:@"3025" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงบ้านน้ำคำน้อย" provinceE:@"KrabiProvince" code:@"E1.012" par:@"468/2515" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"7 พฤศจิกายน 2515" url:@"E1.012-2515.PDF" date_no:@"ครั้งที่ 1" area:@"12124861.1946" area_rai:@"8100" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงเปือย" provinceE:@"KrabiProvince" code:@"E1.055" par:@"1182/2529" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"8 ธันวาคม 2529" url:@"E1.055-2529.PDF" date_no:@"ครั้งที่ 1" area:@"15931813.0998" area_rai:@"9859" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงผักขา" provinceE:@"KrabiProvince" code:@"E1.020" par:@"594/2516" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"13 พฤศจิกายน 2516" url:@"E1.020-2516.PDF" date_no:@"ครั้งที่ 1" area:@"30118023.8843" area_rai:@"20422" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงฟ้าห่วน" provinceE:@"KrabiProvince" code:@"E1.004" par:@"253/2510" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"26 ธันวาคม 2510" url:@"E1.004-2510.PDF" date_no:@"ครั้งที่ 1" area:@"5656127.60476" area_rai:@"3400" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงภูเมย ป่าเขาสวนตาล และป่าพลานไหแตก" provinceE:@"KrabiProvince" code:@"E1.049" par:@"1055/2527" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"30 สิงหาคม 2527" url:@"E1.049-2527.PDF" date_no:@"ครั้งที่ 1" area:@"396342114.337" area_rai:@"238125" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงภูโหล่น" provinceE:@"KrabiProvince" code:@"E1.021" par:@"603/2516" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"27 พฤศจิกายน 2516" url:@"E1.021-2516.PDF" date_no:@"ครั้งที่ 1" area:@"1143744528.03" area_rai:@"689535" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงสคามหรือดงกะบาก" provinceE:@"KrabiProvince" code:@"E1.010" par:@"446/2514" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"30 ธันวาคม 2514" url:@"E1.010-2514.PDF" date_no:@"ครั้งที่ 1" area:@"18159565.8886" area_rai:@"12300" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงหนองบัว แปลงที่ 2" provinceE:@"KrabiProvince" code:@"E1.008" par:@"433/2514" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"24 สิงหาคม 2514" url:@"E1.008-2514.PDF" date_no:@"ครั้งที่ 1" area:@"2741643.26719" area_rai:@"893" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงหินกอง" provinceE:@"KrabiProvince" code:@"E1.001" par:@"1014/2526" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"6 ธันวาคม 2526" url:@"E1.001-2526.PDF" date_no:@"ครั้งที่ 4" area:@"47221073.7876" area_rai:@"30443.75" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดงใหญ่" provinceE:@"KrabiProvince" code:@"E1.042" par:@"919/2523" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"30 ธันวาคม 2523" url:@"E1.042-2523.PDF" date_no:@"ครั้งที่ 1" area:@"31238950.5417" area_rai:@"20135" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าดอนเม้า" provinceE:@"KrabiProvince" code:@"E1.027" par:@"679/2517" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"18 มิถุนายน 2517" url:@"E1.027-2517.PDF" date_no:@"ครั้งที่ 1" area:@"1721084.12587" area_rai:@"781" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าตุงลุง" provinceE:@"KrabiProvince" code:@"E1.014" par:@"485/2515" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"14 พฤศจิกายน 2515" url:@"E1.014-2515.PDF" date_no:@"ครั้งที่ 1" area:@"14741616.386" area_rai:@"12188" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าทรายพูล" provinceE:@"KrabiProvince" code:@"E1.037" par:@"855/2522" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"3 สิงหาคม 2522" url:@"E1.037-2522.PDF" date_no:@"ครั้งที่ 1" area:@"2616776.68593" area_rai:@"1512" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าโนนโหนน" provinceE:@"KrabiProvince" code:@"E1.054" par:@"1139/2528" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"27 พฤศจิกายน 2528" url:@"E1.054-2528.PDF" date_no:@"ครั้งที่ 1" area:@"15247476.4612" area_rai:@"9520" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าโนนฮังรังแร้ง" provinceE:@"KrabiProvince" code:@"E1.006" par:@"287/2511" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"5 มีนาคม 2511" url:@"E1.006-2511.PDF" date_no:@"ครั้งที่ 1" area:@"41832859.3749" area_rai:@"24843" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าบุณฑริก" provinceE:@"KrabiProvince" code:@"E1.031" par:@"1010/2526" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"22 กรกฎาคม 2526" url:@"E1.031-2526.PDF" date_no:@"ครั้งที่ 2" area:@"1308687647.89" area_rai:@"740578" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าฝั่งซ้ายลำโดมใหญ่" provinceE:@"KrabiProvince" code:@"E1.050" par:@"1063/2527" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"6 กันยายน 2527" url:@"E1.050-Plus.PDF" date_no:@"ครั้งที่ 1" area:@"893690076.845" area_rai:@"435625" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าฝั่งซ้ายห้วยตองแวด" provinceE:@"KrabiProvince" code:@"E1.022" par:@"609/2516" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"4 ธันวาคม 2516" url:@"E1.022-2516.PDF" date_no:@"ครั้งที่ 1" area:@"37891061.3535" area_rai:@"27500" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าสนดงติ้ว" provinceE:@"KrabiProvince" code:@"E1.047" par:@"1044/2527" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"31 พฤษภาคม 2527" url:@"E1.047-2527.PDF" date_no:@"ครั้งที่ 1" area:@"6033607.5772" area_rai:@"3540" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าสีสุก" provinceE:@"KrabiProvince" code:@"E1.019" par:@"577/2516" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"2 ตุลาคม 2516" url:@"E1.019-2516.PDF" date_no:@"ครั้งที่ 1" area:@"39702276.7029" area_rai:@"24812" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าสุวรรณวารี" provinceE:@"KrabiProvince" code:@"E1.040" par:@"901/2523" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"1 พฤศจิกายน 2523" url:@"E1.040-2523.PDF" date_no:@"ครั้งที่ 1" area:@"47864605.8921" area_rai:@"30100" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าโสกชัน" provinceE:@"KrabiProvince" code:@"E1.018" par:@"512/2515" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"30 ธันวาคม 2515" url:@"E1.018-2515.PDF" date_no:@"ครั้งที่ 1" area:@"76848385.95" area_rai:@"47037" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าหนองฮี" provinceE:@"KrabiProvince" code:@"E1.051" par:@"1118/2528" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"30 กันยายน 2528" url:@"E1.051-2528.PDF" date_no:@"ครั้งที่ 1" area:@"29708899.2078" area_rai:@"17891" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าหลังภู" provinceE:@"KrabiProvince" code:@"E1.058" par:@"1215/2531" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"18 กุมภาพันธ์ 2531" url:@"E1.058-2531.PDF" date_no:@"ครั้งที่ 1" area:@"18317736.9511" area_rai:@"10825" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยแม่นนท์" provinceE:@"KrabiProvince" code:@"E1.043" par:@"956/2524" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"27 กันยายน 2524" url:@"E1.043-2524.PDF" date_no:@"ครั้งที่ 1" area:@"29438791.2616" area_rai:@"16240" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าห้วยยอดมน" provinceE:@"KrabiProvince" code:@"E1.029" par:@"1176/2529" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"16 กรกฎาคม 2529" url:@"E1.029-2529.PDF" date_no:@"ครั้งที่ 2" area:@"358373276.231" area_rai:@"245339" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าหินน้ำรอบ" provinceE:@"KrabiProvince" code:@"E1.017" par:@"511/2515" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"30 ธันวาคม 2515" url:@"E1.017-2515.PDF" date_no:@"ครั้งที่ 1" area:@"7894665.78313" area_rai:@"5295" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าเหนืออ่างเก็บน้ำหนองเหล่าหิน" provinceE:@"KrabiProvince" code:@"E1.033" par:@"765/2518" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"9 ธันวาคม 2518" url:@"E1.033-2518.PDF" date_no:@"ครั้งที่ 1" area:@"32853743.5343" area_rai:@"20850" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];
    UbonRatchathaniProvince = [[ItemGuide alloc] initWithName:@"ป่าแอวมอง" provinceE:@"KrabiProvince" code:@"E1.035" par:@"839/2522" type:@"ป่าสงวนแห่งชาติ" province:@"อุบลราชธานี" date:@"15 พฤษภาคม 2522" url:@"E1.035-2522.PDF" date_no:@"ครั้งที่ 1" area:@"13632859.0409" area_rai:@"8937" ]; [self.UbonRatchathaniProvinces addObject:UbonRatchathaniProvince];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isFiltered)
        return 1;
    else
        return 66;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.isFiltered)
        return @"ค้นหาสถานที่";
    else
        return sections[section];//[NSString stringWithFormat:@"%@ (%@)",sections[section],];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return [self.locations count];
    
    NSInteger rowCount;
    if(self.isFiltered)
        rowCount = filteredTableData.count;
    else
        if (section == 0) { rowCount = _KrabiProvinces.count; } else
            if (section == 1) { rowCount = _KanchanaburiProvinces.count; } else
                if (section == 2) { rowCount = _KalasinProvinces.count; } else
                    if (section == 3) { rowCount = _KamphaengPhetProvinces.count; } else
                        if (section == 4) { rowCount = _KhonKaenProvinces.count; } else
                            if (section == 5) { rowCount = _ChanthaburiProvinces.count; } else
                                if (section == 6) { rowCount = _ChachoengsaoProvinces.count; } else
                                    if (section == 7) { rowCount = _ChonburiProvinces.count; } else
                                        if (section == 8) { rowCount = _ChainatProvinces.count; } else
                                            if (section == 9) { rowCount = _ChaiyaphumProvinces.count; } else
                                                if (section == 10) { rowCount = _ChumphonProvinces.count; } else
                                                    if (section == 11) { rowCount = _ChiangRaiProvinces.count; } else
                                                        if (section == 12) { rowCount = _ChiangMaiProvinces.count; } else
                                                            if (section == 13) { rowCount = _TrangProvinces.count; } else
                                                                if (section == 14) { rowCount = _TratProvinces.count; } else
                                                                    if (section == 15) { rowCount = _TakProvinces.count; } else
                                                                        if (section == 16) { rowCount = _NakhonPhanomProvinces.count; } else
                                                                            if (section == 17) { rowCount = _NakhonRatchasimaProvinces.count; } else
                                                                                if (section == 18) { rowCount = _NakhonSiThammaratProvinces.count; } else
                                                                                    if (section == 19) { rowCount = _NakhonSawanProvinces.count; } else
                                                                                        if (section == 20) { rowCount = _NarathiwatProvinces.count; } else
                                                                                            if (section == 21) { rowCount = _NanProvinces.count; } else
                                                                                                if (section == 22) { rowCount = _BuriramProvinces.count; } else
                                                                                                    if (section == 23) { rowCount = _PrachuapKhiriKhanProvinces.count; } else
                                                                                                        if (section == 24) { rowCount = _PrachinburiProvinces.count; } else
                                                                                                            if (section == 25) { rowCount = _PattaniProvinces.count; } else
                                                                                                                if (section == 26) { rowCount = _PhayaoProvinces.count; } else
                                                                                                                    if (section == 27) { rowCount = _PhangNgaProvinces.count; } else
                                                                                                                        if (section == 28) { rowCount = _PhatthalungProvinces.count; } else
                                                                                                                            if (section == 29) { rowCount = _PhichitProvinces.count; } else
                                                                                                                                if (section == 30) { rowCount = _PhitsanulokProvinces.count; } else
                                                                                                                                    if (section == 31) { rowCount = _PhetchaburiProvinces.count; } else
                                                                                                                                        if (section == 32) { rowCount = _PhetchabunProvinces.count; } else
                                                                                                                                            if (section == 33) { rowCount = _PhraeProvinces.count; } else
                                                                                                                                                if (section == 34) { rowCount = _PhuketProvinces.count; } else
                                                                                                                                                    if (section == 35) { rowCount = _MahaSarakhamProvinces.count; } else
                                                                                                                                                        if (section == 36) { rowCount = _MukdahanProvinces.count; } else
                                                                                                                                                            if (section == 37) { rowCount = _MaeHongSonProvinces.count; } else
                                                                                                                                                                if (section == 38) { rowCount = _YasothonProvinces.count; } else
                                                                                                                                                                    if (section == 39) { rowCount = _YalaProvinces.count; } else
                                                                                                                                                                        if (section == 40) { rowCount = _RoiEtProvinces.count; } else
                                                                                                                                                                            if (section == 41) { rowCount = _RanongProvinces.count; } else
                                                                                                                                                                                if (section == 42) { rowCount = _RayongProvinces.count; } else
                                                                                                                                                                                    if (section == 43) { rowCount = _RatchaburiProvinces.count; } else
                                                                                                                                                                                        if (section == 44) { rowCount = _LopburiProvinces.count; } else
                                                                                                                                                                                            if (section == 45) { rowCount = _LampangProvinces.count; } else
                                                                                                                                                                                                if (section == 46) { rowCount = _LamphunProvinces.count; } else
                                                                                                                                                                                                    if (section == 47) { rowCount = _LoeiProvinces.count; } else
                                                                                                                                                                                                        if (section == 48) { rowCount = _SisaketProvinces.count; } else
                                                                                                                                                                                                            if (section == 49) { rowCount = _SakonNakhonProvinces.count; } else
                                                                                                                                                                                                                if (section == 50) { rowCount = _SongkhlaProvinces.count; } else
                                                                                                                                                                                                                    if (section == 51) { rowCount = _SatunProvinces.count; } else
                                                                                                                                                                                                                        if (section == 52) { rowCount = _SamutSakhonProvinces.count; } else
                                                                                                                                                                                                                            if (section == 53) { rowCount = _SaKaeoProvinces.count; } else
                                                                                                                                                                                                                                if (section == 54) { rowCount = _SaraburiProvinces.count; } else
                                                                                                                                                                                                                                    if (section == 55) { rowCount = _SukhothaiProvinces.count; } else
                                                                                                                                                                                                                                        if (section == 56) { rowCount = _SuphanBuriProvinces.count; } else
                                                                                                                                                                                                                                            if (section == 57) { rowCount = _SuratThaniProvinces.count; } else
                                                                                                                                                                                                                                                if (section == 58) { rowCount = _SurinProvinces.count; } else
                                                                                                                                                                                                                                                    if (section == 59) { rowCount = _NongKhaiProvinces.count; } else
                                                                                                                                                                                                                                                        if (section == 60) { rowCount = _NongBuaLamphuProvinces.count; } else
                                                                                                                                                                                                                                                            if (section == 61) { rowCount = _AmnatCharoenProvinces.count; } else
                                                                                                                                                                                                                                                                if (section == 62) { rowCount = _UdonThaniProvinces.count; } else
                                                                                                                                                                                                                                                                    if (section == 63) { rowCount = _UttaraditProvinces.count; } else
                                                                                                                                                                                                                                                                        if (section == 64) { rowCount = _UthaiThaniProvinces.count; } else
                                                                                                                                                                                                                                                                            { rowCount = _UbonRatchathaniProvinces.count; }

    
    return rowCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:13];
    header.textLabel.textColor = [UIColor blackColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        
        cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir Next" size:8];
        
       /* UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70.0, 25.0)];
        distanceLabel.font = [UIFont fontWithName:@"Futura" size:12.0f];
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.textColor = [UIColor grayColor];
        //  distanceLabel.textAlignment = UITextAlignmentRight;
        cell.accessoryView = distanceLabel;*/
        
        cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    ItemGuide *ml ;// = [self.locations objectAtIndex:indexPath.row];
    {
        
        if(isFiltered)
            ml = filteredTableData[indexPath.row];
        else
            if (indexPath.section == 0) { ml = _KrabiProvinces[indexPath.row]; } else
                if (indexPath.section == 1) { ml = _KanchanaburiProvinces[indexPath.row]; } else
                    if (indexPath.section == 2) { ml = _KalasinProvinces[indexPath.row]; } else
                        if (indexPath.section == 3) { ml = _KamphaengPhetProvinces[indexPath.row]; } else
                            if (indexPath.section == 4) { ml = _KhonKaenProvinces[indexPath.row]; } else
                                if (indexPath.section == 5) { ml = _ChanthaburiProvinces[indexPath.row]; } else
                                    if (indexPath.section == 6) { ml = _ChachoengsaoProvinces[indexPath.row]; } else
                                        if (indexPath.section == 7) { ml = _ChonburiProvinces[indexPath.row]; } else
                                            if (indexPath.section == 8) { ml = _ChainatProvinces[indexPath.row]; } else
                                                if (indexPath.section == 9) { ml = _ChaiyaphumProvinces[indexPath.row]; } else
                                                    if (indexPath.section == 10) { ml = _ChumphonProvinces[indexPath.row]; } else
                                                        if (indexPath.section == 11) { ml = _ChiangRaiProvinces[indexPath.row]; } else
                                                            if (indexPath.section == 12) { ml = _ChiangMaiProvinces[indexPath.row]; } else
                                                                if (indexPath.section == 13) { ml = _TrangProvinces[indexPath.row]; } else
                                                                    if (indexPath.section == 14) { ml = _TratProvinces[indexPath.row]; } else
                                                                        if (indexPath.section == 15) { ml = _TakProvinces[indexPath.row]; } else
                                                                            if (indexPath.section == 16) { ml = _NakhonPhanomProvinces[indexPath.row]; } else
                                                                                if (indexPath.section == 17) { ml = _NakhonRatchasimaProvinces[indexPath.row]; } else
                                                                                    if (indexPath.section == 18) { ml = _NakhonSiThammaratProvinces[indexPath.row]; } else
                                                                                        if (indexPath.section == 19) { ml = _NakhonSawanProvinces[indexPath.row]; } else
                                                                                            if (indexPath.section == 20) { ml = _NarathiwatProvinces[indexPath.row]; } else
                                                                                                if (indexPath.section == 21) { ml = _NanProvinces[indexPath.row]; } else
                                                                                                    if (indexPath.section == 22) { ml = _BuriramProvinces[indexPath.row]; } else
                                                                                                        if (indexPath.section == 23) { ml = _PrachuapKhiriKhanProvinces[indexPath.row]; } else
                                                                                                            if (indexPath.section == 24) { ml = _PrachinburiProvinces[indexPath.row]; } else
                                                                                                                if (indexPath.section == 25) { ml = _PattaniProvinces[indexPath.row]; } else
                                                                                                                    if (indexPath.section == 26) { ml = _PhayaoProvinces[indexPath.row]; } else
                                                                                                                        if (indexPath.section == 27) { ml = _PhangNgaProvinces[indexPath.row]; } else
                                                                                                                            if (indexPath.section == 28) { ml = _PhatthalungProvinces[indexPath.row]; } else
                                                                                                                                if (indexPath.section == 29) { ml = _PhichitProvinces[indexPath.row]; } else
                                                                                                                                    if (indexPath.section == 30) { ml = _PhitsanulokProvinces[indexPath.row]; } else
                                                                                                                                        if (indexPath.section == 31) { ml = _PhetchaburiProvinces[indexPath.row]; } else
                                                                                                                                            if (indexPath.section == 32) { ml = _PhetchabunProvinces[indexPath.row]; } else
                                                                                                                                                if (indexPath.section == 33) { ml = _PhraeProvinces[indexPath.row]; } else
                                                                                                                                                    if (indexPath.section == 34) { ml = _PhuketProvinces[indexPath.row]; } else
                                                                                                                                                        if (indexPath.section == 35) { ml = _MahaSarakhamProvinces[indexPath.row]; } else
                                                                                                                                                            if (indexPath.section == 36) { ml = _MukdahanProvinces[indexPath.row]; } else
                                                                                                                                                                if (indexPath.section == 37) { ml = _MaeHongSonProvinces[indexPath.row]; } else
                                                                                                                                                                    if (indexPath.section == 38) { ml = _YasothonProvinces[indexPath.row]; } else
                                                                                                                                                                        if (indexPath.section == 39) { ml = _YalaProvinces[indexPath.row]; } else
                                                                                                                                                                            if (indexPath.section == 40) { ml = _RoiEtProvinces[indexPath.row]; } else
                                                                                                                                                                                if (indexPath.section == 41) { ml = _RanongProvinces[indexPath.row]; } else
                                                                                                                                                                                    if (indexPath.section == 42) { ml = _RayongProvinces[indexPath.row]; } else
                                                                                                                                                                                        if (indexPath.section == 43) { ml = _RatchaburiProvinces[indexPath.row]; } else
                                                                                                                                                                                            if (indexPath.section == 44) { ml = _LopburiProvinces[indexPath.row]; } else
                                                                                                                                                                                                if (indexPath.section == 45) { ml = _LampangProvinces[indexPath.row]; } else
                                                                                                                                                                                                    if (indexPath.section == 46) { ml = _LamphunProvinces[indexPath.row]; } else
                                                                                                                                                                                                        if (indexPath.section == 47) { ml = _LoeiProvinces[indexPath.row]; } else
                                                                                                                                                                                                            if (indexPath.section == 48) { ml = _SisaketProvinces[indexPath.row]; } else
                                                                                                                                                                                                                if (indexPath.section == 49) { ml = _SakonNakhonProvinces[indexPath.row]; } else
                                                                                                                                                                                                                    if (indexPath.section == 50) { ml = _SongkhlaProvinces[indexPath.row]; } else
                                                                                                                                                                                                                        if (indexPath.section == 51) { ml = _SatunProvinces[indexPath.row]; } else
                                                                                                                                                                                                                            if (indexPath.section == 52) { ml = _SamutSakhonProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                if (indexPath.section == 53) { ml = _SaKaeoProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                    if (indexPath.section == 54) { ml = _SaraburiProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                        if (indexPath.section == 55) { ml = _SukhothaiProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                            if (indexPath.section == 56) { ml = _SuphanBuriProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                                if (indexPath.section == 57) { ml = _SuratThaniProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                                    if (indexPath.section == 58) { ml = _SurinProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                                        if (indexPath.section == 59) { ml = _NongKhaiProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                                            if (indexPath.section == 60) { ml = _NongBuaLamphuProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                                                if (indexPath.section == 61) { ml = _AmnatCharoenProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                                                    if (indexPath.section == 62) { ml = _UdonThaniProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                                                        if (indexPath.section == 63) { ml = _UttaraditProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                                                            if (indexPath.section == 64) { ml = _UthaiThaniProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                                                                if (indexPath.section == 65) { ml = _UbonRatchathaniProvinces[indexPath.row]; }

    }
    
    cell.textLabel.text = ml.name;
    //  cell.detailTextLabel.text = ml.address;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / [ ฉบับที่/ปีที่ ประกาศ : %@ ] / จ.%@", ml.code,ml.par,ml.province];
    
    
    //  UILabel *distanceLabel = (UILabel *)cell.accessoryView;
    //  distanceLabel.text = ml.address;
   
    //= [self.locations objectAtIndex:indexPath.row];
   /* NSAssert([item isKindOfClass:[item class]], @"DataSource must provide array of PDLocations");
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:Location.coordinate.latitude longitude:Location.coordinate.longitude];
    
    CLLocationDistance distance = [_userLocation distanceFromLocation:location];
    if (distance == 0) {
        
    } else {
        UILabel *distanceLabel = (UILabel *)cell.accessoryView;
        distanceLabel.text = [NSString stringWithFormat:@"%.01f Km", distance/1000];
    }*/
    
    
    return cell;
}

#pragma mark - Table view delegate

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        
        filteredTableData = [[NSMutableArray alloc] init];
        
        for (ItemGuide* ml in _KrabiProvinces )  {
            NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _KanchanaburiProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _KalasinProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _KamphaengPhetProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _KhonKaenProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _ChanthaburiProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _ChachoengsaoProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _ChonburiProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _ChainatProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _ChaiyaphumProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _ChumphonProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _ChiangRaiProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _ChiangMaiProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _TrangProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _TratProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _TakProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _NakhonPhanomProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _NakhonRatchasimaProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _NakhonSiThammaratProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _NakhonSawanProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _NarathiwatProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _NanProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _BuriramProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _PrachuapKhiriKhanProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _PrachinburiProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _PattaniProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _PhayaoProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _PhangNgaProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _PhatthalungProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _PhichitProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _PhitsanulokProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _PhetchaburiProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _PhetchabunProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _PhraeProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _PhuketProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _MahaSarakhamProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _MukdahanProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _MaeHongSonProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _YasothonProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _YalaProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _RoiEtProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _RanongProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _RayongProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _RatchaburiProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _LopburiProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _LampangProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _LamphunProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _LoeiProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _SisaketProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _SakonNakhonProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _SongkhlaProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _SatunProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _SamutSakhonProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _SaKaeoProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _SaraburiProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _SukhothaiProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _SuphanBuriProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _SuratThaniProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _SurinProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _NongKhaiProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _NongBuaLamphuProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _AmnatCharoenProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _UdonThaniProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _UttaraditProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _UthaiThaniProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
        
        for (ItemGuide* ml in _UbonRatchathaniProvinces )  {
           NSRange nameRange = [ml.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange codeRange = [ml.code rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange areaRange = [ml.area rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange typeRange = [ml.type rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange provinceRange = [ml.province rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange dateRange = [ml.date rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange area_raiRange = [ml.area_rai rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange parRange = [ml.par rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || codeRange.location != NSNotFound || areaRange.location != NSNotFound || typeRange.location != NSNotFound || provinceRange.location != NSNotFound || dateRange.location != NSNotFound || area_raiRange.location != NSNotFound || parRange.location != NSNotFound)
            {
                [filteredTableData addObject:ml];
            }
        }
       
    }
    [self.tableView reloadData];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"พื้นที่เป้าหมาย"
                                                      message:[NSString stringWithFormat: @"เลือกพื้นที่ป่าสงวนแห่งชาติที่ต้องการ %@",indexPath]
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"+ NRF Layer",@"ประกาศท้ายกฏฯ",nil];
    [message show];*/
    
    ItemGuide *ml ;// = [self.locations objectAtIndex:indexPath.row];
    {
        
        if(isFiltered)
            ml = filteredTableData[indexPath.row];
        else
            if (indexPath.section == 0) { ml = _KrabiProvinces[indexPath.row]; } else
                if (indexPath.section == 1) { ml = _KanchanaburiProvinces[indexPath.row]; } else
                    if (indexPath.section == 2) { ml = _KalasinProvinces[indexPath.row]; } else
                        if (indexPath.section == 3) { ml = _KamphaengPhetProvinces[indexPath.row]; } else
                            if (indexPath.section == 4) { ml = _KhonKaenProvinces[indexPath.row]; } else
                                if (indexPath.section == 5) { ml = _ChanthaburiProvinces[indexPath.row]; } else
                                    if (indexPath.section == 6) { ml = _ChachoengsaoProvinces[indexPath.row]; } else
                                        if (indexPath.section == 7) { ml = _ChonburiProvinces[indexPath.row]; } else
                                            if (indexPath.section == 8) { ml = _ChainatProvinces[indexPath.row]; } else
                                                if (indexPath.section == 9) { ml = _ChaiyaphumProvinces[indexPath.row]; } else
                                                    if (indexPath.section == 10) { ml = _ChumphonProvinces[indexPath.row]; } else
                                                        if (indexPath.section == 11) { ml = _ChiangRaiProvinces[indexPath.row]; } else
                                                            if (indexPath.section == 12) { ml = _ChiangMaiProvinces[indexPath.row]; } else
                                                                if (indexPath.section == 13) { ml = _TrangProvinces[indexPath.row]; } else
                                                                    if (indexPath.section == 14) { ml = _TratProvinces[indexPath.row]; } else
                                                                        if (indexPath.section == 15) { ml = _TakProvinces[indexPath.row]; } else
                                                                            if (indexPath.section == 16) { ml = _NakhonPhanomProvinces[indexPath.row]; } else
                                                                                if (indexPath.section == 17) { ml = _NakhonRatchasimaProvinces[indexPath.row]; } else
                                                                                    if (indexPath.section == 18) { ml = _NakhonSiThammaratProvinces[indexPath.row]; } else
                                                                                        if (indexPath.section == 19) { ml = _NakhonSawanProvinces[indexPath.row]; } else
                                                                                            if (indexPath.section == 20) { ml = _NarathiwatProvinces[indexPath.row]; } else
                                                                                                if (indexPath.section == 21) { ml = _NanProvinces[indexPath.row]; } else
                                                                                                    if (indexPath.section == 22) { ml = _BuriramProvinces[indexPath.row]; } else
                                                                                                        if (indexPath.section == 23) { ml = _PrachuapKhiriKhanProvinces[indexPath.row]; } else
                                                                                                            if (indexPath.section == 24) { ml = _PrachinburiProvinces[indexPath.row]; } else
                                                                                                                if (indexPath.section == 25) { ml = _PattaniProvinces[indexPath.row]; } else
                                                                                                                    if (indexPath.section == 26) { ml = _PhayaoProvinces[indexPath.row]; } else
                                                                                                                        if (indexPath.section == 27) { ml = _PhangNgaProvinces[indexPath.row]; } else
                                                                                                                            if (indexPath.section == 28) { ml = _PhatthalungProvinces[indexPath.row]; } else
                                                                                                                                if (indexPath.section == 29) { ml = _PhichitProvinces[indexPath.row]; } else
                                                                                                                                    if (indexPath.section == 30) { ml = _PhitsanulokProvinces[indexPath.row]; } else
                                                                                                                                        if (indexPath.section == 31) { ml = _PhetchaburiProvinces[indexPath.row]; } else
                                                                                                                                            if (indexPath.section == 32) { ml = _PhetchabunProvinces[indexPath.row]; } else
                                                                                                                                                if (indexPath.section == 33) { ml = _PhraeProvinces[indexPath.row]; } else
                                                                                                                                                    if (indexPath.section == 34) { ml = _PhuketProvinces[indexPath.row]; } else
                                                                                                                                                        if (indexPath.section == 35) { ml = _MahaSarakhamProvinces[indexPath.row]; } else
                                                                                                                                                            if (indexPath.section == 36) { ml = _MukdahanProvinces[indexPath.row]; } else
                                                                                                                                                                if (indexPath.section == 37) { ml = _MaeHongSonProvinces[indexPath.row]; } else
                                                                                                                                                                    if (indexPath.section == 38) { ml = _YasothonProvinces[indexPath.row]; } else
                                                                                                                                                                        if (indexPath.section == 39) { ml = _YalaProvinces[indexPath.row]; } else
                                                                                                                                                                            if (indexPath.section == 40) { ml = _RoiEtProvinces[indexPath.row]; } else
                                                                                                                                                                                if (indexPath.section == 41) { ml = _RanongProvinces[indexPath.row]; } else
                                                                                                                                                                                    if (indexPath.section == 42) { ml = _RayongProvinces[indexPath.row]; } else
                                                                                                                                                                                        if (indexPath.section == 43) { ml = _RatchaburiProvinces[indexPath.row]; } else
                                                                                                                                                                                            if (indexPath.section == 44) { ml = _LopburiProvinces[indexPath.row]; } else
                                                                                                                                                                                                if (indexPath.section == 45) { ml = _LampangProvinces[indexPath.row]; } else
                                                                                                                                                                                                    if (indexPath.section == 46) { ml = _LamphunProvinces[indexPath.row]; } else
                                                                                                                                                                                                        if (indexPath.section == 47) { ml = _LoeiProvinces[indexPath.row]; } else
                                                                                                                                                                                                            if (indexPath.section == 48) { ml = _SisaketProvinces[indexPath.row]; } else
                                                                                                                                                                                                                if (indexPath.section == 49) { ml = _SakonNakhonProvinces[indexPath.row]; } else
                                                                                                                                                                                                                    if (indexPath.section == 50) { ml = _SongkhlaProvinces[indexPath.row]; } else
                                                                                                                                                                                                                        if (indexPath.section == 51) { ml = _SatunProvinces[indexPath.row]; } else
                                                                                                                                                                                                                            if (indexPath.section == 52) { ml = _SamutSakhonProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                if (indexPath.section == 53) { ml = _SaKaeoProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                    if (indexPath.section == 54) { ml = _SaraburiProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                        if (indexPath.section == 55) { ml = _SukhothaiProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                            if (indexPath.section == 56) { ml = _SuphanBuriProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                                if (indexPath.section == 57) { ml = _SuratThaniProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                                    if (indexPath.section == 58) { ml = _SurinProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                                        if (indexPath.section == 59) { ml = _NongKhaiProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                                            if (indexPath.section == 60) { ml = _NongBuaLamphuProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                                                if (indexPath.section == 61) { ml = _AmnatCharoenProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                                                    if (indexPath.section == 62) { ml = _UdonThaniProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                                                        if (indexPath.section == 63) { ml = _UttaraditProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                                                            if (indexPath.section == 64) { ml = _UthaiThaniProvinces[indexPath.row]; } else
                                                                                                                                                                                                                                                                                if (indexPath.section == 65) { ml = _UbonRatchathaniProvinces[indexPath.row]; }
        
    }
    NSString *urlStringPDF = [NSString stringWithFormat: @"%@/%@",kPDFURL,ml.url];
    _urlPDF = [NSURL URLWithString:urlStringPDF];
    
   /* NSString *urlStringLayer = [NSString stringWithFormat: @"%@/NRF_%@.geojson",kLayerURL,ml.provinceE];
    _urlLayer = urlStringLayer;

    if ([_delegate respondsToSelector:@selector(guideWebViewController:name:province:urlDelegateLayer:urlDelegate:)]) {
        
        [_delegate guideWebViewController:self name:ml.name province:ml.province urlDelegateLayer:_urlLayer urlDelegate:_urlPDF];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [searchBar resignFirstResponder];*/
    
    [self performSegueWithIdentifier:@"guideToWeb" sender:self];
    
    //--[tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"guideToWeb"]) {
        if ([segue.destinationViewController isKindOfClass:[GuideWebViewController class]]) {
            
            GuideWebViewController *webViewController = (GuideWebViewController *)segue.destinationViewController;
            webViewController.url = _urlPDF;
        }
    }
    [searchBar resignFirstResponder];
}

#pragma mark - FishEye Data Source

- (NSUInteger)numberOfItemsInFishEyeView:(MCSFishEyeView *)fishEyeView
{
    if (self.isFiltered)
        return 0;
    else
        return 66;
}

- (void)fishEyeView:(MCSFishEyeView *)fishEyeView configureItem:(MCSDemoFishEyeItem *)item atIndex:(NSUInteger)index
{
    if (self.isFiltered) {
        item.label.text = nil;
    } else {
        if (index == 0) { item.label.text =  @"กระบี่"; } else
            if (index == 1) { item.label.text =  @"กาญจนบุรี"; } else
                if (index == 2) { item.label.text =  @"กาฬสินธุ์"; } else
                    if (index == 3) { item.label.text =  @"กำแพงเพชร"; } else
                        if (index == 4) { item.label.text =  @"ขอนแก่น"; } else
                            if (index == 5) { item.label.text =  @"จันทบุรี"; } else
                                if (index == 6) { item.label.text =  @"ฉะเชิงเทรา"; } else
                                    if (index == 7) { item.label.text =  @"ชลบุรี"; } else
                                        if (index == 8) { item.label.text =  @"ชัยนาท"; } else
                                            if (index == 9) { item.label.text =  @"ชัยภูมิ"; } else
                                                if (index == 10) { item.label.text =  @"ชุมพร"; } else
                                                    if (index == 11) { item.label.text =  @"เชียงราย"; } else
                                                        if (index == 12) { item.label.text =  @"เชียงใหม่"; } else
                                                            if (index == 13) { item.label.text =  @"ตรัง"; } else
                                                                if (index == 14) { item.label.text =  @"ตราด"; } else
                                                                    if (index == 15) { item.label.text =  @"ตาก"; } else
                                                                        if (index == 16) { item.label.text =  @"นครพนม"; } else
                                                                            if (index == 17) { item.label.text =  @"นครราชสีมา"; } else
                                                                                if (index == 18) { item.label.text =  @"นครศรีธรรมราช"; } else
                                                                                    if (index == 19) { item.label.text =  @"นครสวรรค์"; } else
                                                                                        if (index == 20) { item.label.text =  @"นราธิวาส"; } else
                                                                                            if (index == 21) { item.label.text =  @"น่าน"; } else
                                                                                                if (index == 22) { item.label.text =  @"บุรีรัมย์"; } else
                                                                                                    if (index == 23) { item.label.text =  @"ประจวบคีรีขันธ์"; } else
                                                                                                        if (index == 24) { item.label.text =  @"ปราจีนบุรี"; } else
                                                                                                            if (index == 25) { item.label.text =  @"ปัตตานี"; } else
                                                                                                                if (index == 26) { item.label.text =  @"พะเยา"; } else
                                                                                                                    if (index == 27) { item.label.text =  @"พังงา"; } else
                                                                                                                        if (index == 28) { item.label.text =  @"พัทลุง"; } else
                                                                                                                            if (index == 29) { item.label.text =  @"พิจิตร"; } else
                                                                                                                                if (index == 30) { item.label.text =  @"พิษณุโลก"; } else
                                                                                                                                    if (index == 31) { item.label.text =  @"เพชรบุรี"; } else 
                                                                                                                                        if (index == 32) { item.label.text =  @"เพชรบูรณ์"; } else 
                                                                                                                                            if (index == 33) { item.label.text =  @"แพร่"; } else 
                                                                                                                                                if (index == 34) { item.label.text =  @"ภูเก็ต"; } else 
                                                                                                                                                    if (index == 35) { item.label.text =  @"มหาสารคาม"; } else 
                                                                                                                                                        if (index == 36) { item.label.text =  @"มุกดาหาร"; } else 
                                                                                                                                                            if (index == 37) { item.label.text =  @"แม่ฮ่องสอน"; } else 
                                                                                                                                                                if (index == 38) { item.label.text =  @"ยโสธร"; } else 
                                                                                                                                                                    if (index == 39) { item.label.text =  @"ยะลา"; } else 
                                                                                                                                                                        if (index == 40) { item.label.text =  @"ร้อยเอ็ด"; } else 
                                                                                                                                                                            if (index == 41) { item.label.text =  @"ระนอง"; } else 
                                                                                                                                                                                if (index == 42) { item.label.text =  @"ระยอง"; } else 
                                                                                                                                                                                    if (index == 43) { item.label.text =  @"ราชบุรี"; } else 
                                                                                                                                                                                        if (index == 44) { item.label.text =  @"ลพบุรี"; } else 
                                                                                                                                                                                            if (index == 45) { item.label.text =  @"ลำปาง"; } else 
                                                                                                                                                                                                if (index == 46) { item.label.text =  @"ลำพูน"; } else 
                                                                                                                                                                                                    if (index == 47) { item.label.text =  @"เลย"; } else 
                                                                                                                                                                                                        if (index == 48) { item.label.text =  @"ศรีสะเกษ"; } else 
                                                                                                                                                                                                            if (index == 49) { item.label.text =  @"สกลนคร"; } else 
                                                                                                                                                                                                                if (index == 50) { item.label.text =  @"สงขลา"; } else 
                                                                                                                                                                                                                    if (index == 51) { item.label.text =  @"สตูล"; } else 
                                                                                                                                                                                                                        if (index == 52) { item.label.text =  @"สมุทรสาคร"; } else 
                                                                                                                                                                                                                            if (index == 53) { item.label.text =  @"สระแก้ว"; } else 
                                                                                                                                                                                                                                if (index == 54) { item.label.text =  @"สระบุรี"; } else 
                                                                                                                                                                                                                                    if (index == 55) { item.label.text =  @"สุโขทัย"; } else 
                                                                                                                                                                                                                                        if (index == 56) { item.label.text =  @"สุพรรณบุรี"; } else 
                                                                                                                                                                                                                                            if (index == 57) { item.label.text =  @"สุราษฎร์ธานี"; } else 
                                                                                                                                                                                                                                                if (index == 58) { item.label.text =  @"สุรินทร์"; } else 
                                                                                                                                                                                                                                                    if (index == 59) { item.label.text =  @"หนองคาย"; } else 
                                                                                                                                                                                                                                                        if (index == 60) { item.label.text =  @"หนองบัวลำภู"; } else 
                                                                                                                                                                                                                                                            if (index == 61) { item.label.text =  @"อำนาจเจริญ"; } else 
                                                                                                                                                                                                                                                                if (index == 62) { item.label.text =  @"อุดรธานี"; } else 
                                                                                                                                                                                                                                                                    if (index == 63) { item.label.text =  @"อุตรดิตถ์"; } else 
                                                                                                                                                                                                                                                                        if (index == 64) { item.label.text =  @"อุทัยธานี"; } else 
                                                                                                                                                                                                                                                                        { item.label.text =  @"อุบลราชธานี";}

        
    }
}

-(void)fishEyeView:(MCSFishEyeView *)fishEyeView didSelectItemAtIndex:(NSUInteger)index {
 
    [fishEyeView deselectSelectedItemAnimated:YES];
}
-(void)fishEyeView:(MCSFishEyeView *)fishEyeView didHighlightItemAtIndex:(NSUInteger)index
{
    if (self.isFiltered) {
       
    } else {
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:YES];
    }
}

#pragma mark - FishEye Delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (MCSFishEyeView *fishEye in self.fishEyeViews) {
        [fishEye deselectSelectedItemAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}


@end
