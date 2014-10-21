//
//  GuideViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 4/20/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPDFURL @"http://pirun.ku.ac.th/~b521030091/PDF/NRF"
#define kLayerURL @"http://pirun.ku.ac.th/~b521030091/GeoJSON"

@protocol GuideWebViewControllerDelegate;

@interface GuideViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *KrabiProvinces;
@property (strong, nonatomic) NSMutableArray *KanchanaburiProvinces;
@property (strong, nonatomic) NSMutableArray *KalasinProvinces;
@property (strong, nonatomic) NSMutableArray *KamphaengPhetProvinces;
@property (strong, nonatomic) NSMutableArray *KhonKaenProvinces;
@property (strong, nonatomic) NSMutableArray *ChanthaburiProvinces;
@property (strong, nonatomic) NSMutableArray *ChachoengsaoProvinces;
@property (strong, nonatomic) NSMutableArray *ChonburiProvinces;
@property (strong, nonatomic) NSMutableArray *ChainatProvinces;
@property (strong, nonatomic) NSMutableArray *ChaiyaphumProvinces;
@property (strong, nonatomic) NSMutableArray *ChumphonProvinces;
@property (strong, nonatomic) NSMutableArray *ChiangRaiProvinces;
@property (strong, nonatomic) NSMutableArray *ChiangMaiProvinces;
@property (strong, nonatomic) NSMutableArray *TrangProvinces;
@property (strong, nonatomic) NSMutableArray *TratProvinces;
@property (strong, nonatomic) NSMutableArray *TakProvinces;
@property (strong, nonatomic) NSMutableArray *NakhonPhanomProvinces;
@property (strong, nonatomic) NSMutableArray *NakhonRatchasimaProvinces;
@property (strong, nonatomic) NSMutableArray *NakhonSiThammaratProvinces;
@property (strong, nonatomic) NSMutableArray *NakhonSawanProvinces;
@property (strong, nonatomic) NSMutableArray *NarathiwatProvinces;
@property (strong, nonatomic) NSMutableArray *NanProvinces;
@property (strong, nonatomic) NSMutableArray *BuriramProvinces;
@property (strong, nonatomic) NSMutableArray *PrachuapKhiriKhanProvinces;
@property (strong, nonatomic) NSMutableArray *PrachinburiProvinces;
@property (strong, nonatomic) NSMutableArray *PattaniProvinces;
@property (strong, nonatomic) NSMutableArray *PhayaoProvinces;
@property (strong, nonatomic) NSMutableArray *PhangNgaProvinces;
@property (strong, nonatomic) NSMutableArray *PhatthalungProvinces;
@property (strong, nonatomic) NSMutableArray *PhichitProvinces;
@property (strong, nonatomic) NSMutableArray *PhitsanulokProvinces;
@property (strong, nonatomic) NSMutableArray *PhetchaburiProvinces;
@property (strong, nonatomic) NSMutableArray *PhetchabunProvinces;
@property (strong, nonatomic) NSMutableArray *PhraeProvinces;
@property (strong, nonatomic) NSMutableArray *PhuketProvinces;
@property (strong, nonatomic) NSMutableArray *MahaSarakhamProvinces;
@property (strong, nonatomic) NSMutableArray *MukdahanProvinces;
@property (strong, nonatomic) NSMutableArray *MaeHongSonProvinces;
@property (strong, nonatomic) NSMutableArray *YasothonProvinces;
@property (strong, nonatomic) NSMutableArray *YalaProvinces;
@property (strong, nonatomic) NSMutableArray *RoiEtProvinces;
@property (strong, nonatomic) NSMutableArray *RanongProvinces;
@property (strong, nonatomic) NSMutableArray *RayongProvinces;
@property (strong, nonatomic) NSMutableArray *RatchaburiProvinces;
@property (strong, nonatomic) NSMutableArray *LopburiProvinces;
@property (strong, nonatomic) NSMutableArray *LampangProvinces;
@property (strong, nonatomic) NSMutableArray *LamphunProvinces;
@property (strong, nonatomic) NSMutableArray *LoeiProvinces;
@property (strong, nonatomic) NSMutableArray *SisaketProvinces;
@property (strong, nonatomic) NSMutableArray *SakonNakhonProvinces;
@property (strong, nonatomic) NSMutableArray *SongkhlaProvinces;
@property (strong, nonatomic) NSMutableArray *SatunProvinces;
@property (strong, nonatomic) NSMutableArray *SamutSakhonProvinces;
@property (strong, nonatomic) NSMutableArray *SaKaeoProvinces;
@property (strong, nonatomic) NSMutableArray *SaraburiProvinces;
@property (strong, nonatomic) NSMutableArray *SukhothaiProvinces;
@property (strong, nonatomic) NSMutableArray *SuphanBuriProvinces;
@property (strong, nonatomic) NSMutableArray *SuratThaniProvinces;
@property (strong, nonatomic) NSMutableArray *SurinProvinces;
@property (strong, nonatomic) NSMutableArray *NongKhaiProvinces;
@property (strong, nonatomic) NSMutableArray *NongBuaLamphuProvinces;
@property (strong, nonatomic) NSMutableArray *AmnatCharoenProvinces;
@property (strong, nonatomic) NSMutableArray *UdonThaniProvinces;
@property (strong, nonatomic) NSMutableArray *UttaraditProvinces;
@property (strong, nonatomic) NSMutableArray *UthaiThaniProvinces;
@property (strong, nonatomic) NSMutableArray *UbonRatchathaniProvinces;

@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray* filteredTableData;

@property (assign, nonatomic) bool isFiltered;

@property (strong, nonatomic) NSURL *urlDelegate;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *urlDelegateLayer;

@property (strong, nonatomic) id<GuideWebViewControllerDelegate> delegate;

@end

@protocol GuideWebViewControllerDelegate <NSObject>

- (void)guideWebViewController:(GuideViewController *)controller name:(NSString*)name province:(NSString*)province urlDelegateLayer:(NSString*)urlDelegateLayer urlDelegate:(NSURL*)urlDelegate;

@end
