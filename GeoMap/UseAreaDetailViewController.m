//
//  UseAreaDetailViewController.m
//  GeoMap
//
//  Created by SchwarzArthur on 9/11/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import "UseAreaDetailViewController.h"
#import "MATableViewSection.h"
#import "MAActionCell.h"
#import "SubUseAreaDetailViewController.h"

@interface UseAreaDetailViewController ()

@end

@implementation UseAreaDetailViewController

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
    // Do any additional setup after loading the view.
    self.navigationItem.title = [NSString stringWithFormat:@"สรุปการใช้ประโยชน์ฯ"];
    
   /* ___tableView.tableHeaderView = ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 30.0f)];
       
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, 0, 0)];
        label.text = @"สรุปการใช้ประโยชน์พื้นที่";
        label.font = [UIFont systemFontOfSize:20];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        [label sizeToFit];
        
        [view addSubview:label];
        
        view;
    });*/
    
    [self generateTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)generateTableView {
    
    MAActionCell *areaEchoRCell = [MAActionCell actionCellWithTitle:@"ขนาดพื้นที่ตามประกาศ" subtitle:[NSString stringWithFormat:@"%@  ไร่",_AREAECHOR] accessory:nil action:^{
    }];
    
    MAActionCell *areaGISRCell = [MAActionCell actionCellWithTitle:@"ขนาดพื้นที่ตามระบบภูมิสารสนเทศ (GIS)" subtitle:[NSString stringWithFormat:@"%@  ไร่",_AREAGISR] accessory:nil action:^{
    }];

    MAActionCell *watershedCell = [MAActionCell actionCellWithTitle:@"ชั้นคุณภาพลุ่มนํ้าชั้นที่ 1 และ 2" subtitle:[NSString stringWithFormat:@"%@  ไร่",_WATERSHAD] accessory:nil action:^{
    }];
    
    MAActionCell *forest55_56Cell = [MAActionCell actionCellWithTitle:@"พื้นที่คงสภาพป่า ปี พ.ศ. 2555 - 2556" subtitle:[NSString stringWithFormat:@"%@  ไร่",_FOREST55_56] accessory:nil action:^{
    }];
    
    if (([_SURVEYAREA_PEOPLE isEqualToString:@"(null)"] || [_SURVEYAREA_PEOPLE isEqualToString:@""] || [_SURVEYAREA_PEOPLE isEqualToString:nil]) && ([_SURVEYAREA_PLOT isEqualToString:@"(null)"] || [_SURVEYAREA_PLOT isEqualToString:@""] || [_SURVEYAREA_PLOT isEqualToString:nil]) && ([_SURVEYAREA_AREA isEqualToString:@"(null)"] || [_SURVEYAREA_AREA isEqualToString:@""] || [_SURVEYAREA_AREA isEqualToString:nil])){
        
        _SurveyArea = [NSString stringWithFormat:@"( รอการเพิ่มเติมข้อมูล )"];
    } else {
        if ([_SURVEYAREA_PEOPLE isEqualToString:@"(null)"] || [_SURVEYAREA_PEOPLE isEqualToString:@""] || [_SURVEYAREA_PEOPLE isEqualToString:nil]){
            
            _SURVEYAREA_PEOPLE = [NSString stringWithFormat:@"-"];
        } else {
        }
        if ([_SURVEYAREA_PLOT isEqualToString:@"(null)"] || [_SURVEYAREA_PLOT isEqualToString:@""] || [_SURVEYAREA_PLOT isEqualToString:nil]){
            
            _SURVEYAREA_PLOT = [NSString stringWithFormat:@"-"];
        } else {
        }
        if ([_SURVEYAREA_AREA isEqualToString:@"(null)"] || [_SURVEYAREA_AREA isEqualToString:@""] || [_SURVEYAREA_AREA isEqualToString:nil]){
            
            _SURVEYAREA_AREA = [NSString stringWithFormat:@"-"];
        } else {
        }
        _SurveyArea = [NSString stringWithFormat:@"[ %@  ราย | %@  แปลง | %@  ไร่ ]",_SURVEYAREA_PEOPLE,_SURVEYAREA_PLOT,_SURVEYAREA_AREA];
    }
    
    MAActionCell *surveyarea_areaCell = [MAActionCell actionCellWithTitle:@"พื้นที่รังวัดตามมติ ครม. 30 มิ.ย. 2541" subtitle:_SurveyArea accessory:nil action:^{
    }];
    
    if (([_USEDAREA_PEOPLE isEqualToString:@"(null)"] || [_USEDAREA_PEOPLE isEqualToString:@""] || [_USEDAREA_PEOPLE isEqualToString:nil]) && ([_USEDAREA_PLOT isEqualToString:@"(null)"] || [_USEDAREA_PLOT isEqualToString:@""] || [_USEDAREA_PLOT isEqualToString:nil]) && ([_USEDAREA_AREA isEqualToString:@"(null)"] || [_USEDAREA_AREA isEqualToString:@""] || [_USEDAREA_AREA isEqualToString:nil])){
        
        _UsedArea = [NSString stringWithFormat:@"( รอการเพิ่มเติมข้อมูล )"];
    } else {
        if ([_USEDAREA_PEOPLE isEqualToString:@"(null)"] || [_USEDAREA_PEOPLE isEqualToString:@""] || [_USEDAREA_PEOPLE isEqualToString:nil]){
            
            _USEDAREA_PEOPLE = [NSString stringWithFormat:@"-"];
        } else {
        }
        if ([_USEDAREA_PLOT isEqualToString:@"(null)"] || [_USEDAREA_PLOT isEqualToString:@""] || [_USEDAREA_PLOT isEqualToString:nil]){
            
            _USEDAREA_PLOT = [NSString stringWithFormat:@"-"];
        } else {
        }
        if ([_USEDAREA_AREA isEqualToString:@"(null)"] || [_USEDAREA_AREA isEqualToString:@""] || [_USEDAREA_AREA isEqualToString:nil]){
            
            _USEDAREA_AREA = [NSString stringWithFormat:@"-"];
        } else {
        }
        
        _UsedArea = [NSString stringWithFormat:@"[ %@  ราย | %@  แปลง | %@  ไร่ ]",_USEDAREA_PEOPLE,_USEDAREA_PLOT,_USEDAREA_AREA];
    }
    MAActionCell *usedarea_areaCell = [MAActionCell actionCellWithTitle:@"แปลงอนุญาตใช้ประโยชน์ที่ดินป่าไม้" subtitle:_UsedArea accessory:@"button" action:^{
        [self pushSomething];
    }];
    
    if (([_RELATEFOREST_PEOPLE isEqualToString:@"(null)"] || [_RELATEFOREST_PEOPLE isEqualToString:@""] || [_RELATEFOREST_PEOPLE isEqualToString:nil]) && ( [_RELATEFOREST_PLOT isEqualToString:@"(null)"] || [_RELATEFOREST_PLOT isEqualToString:@""] || [_RELATEFOREST_PLOT isEqualToString:nil]) && ([_RELATEFOREST_AREA isEqualToString:@"(null)"] || [_RELATEFOREST_AREA isEqualToString:@""] || [_RELATEFOREST_AREA isEqualToString:nil])){
        
        _RelateForest = [NSString stringWithFormat:@"( รอการเพิ่มเติมข้อมูล )"];
    } else {
        if ([_RELATEFOREST_PEOPLE isEqualToString:@"(null)"] || [_RELATEFOREST_PEOPLE isEqualToString:@""] || [_RELATEFOREST_PEOPLE isEqualToString:nil]){
            
            _RELATEFOREST_PEOPLE = [NSString stringWithFormat:@"-"];
        } else {
        }
        if ([_RELATEFOREST_PLOT isEqualToString:@"(null)"] || [_RELATEFOREST_PLOT isEqualToString:@""] || [_RELATEFOREST_PLOT isEqualToString:nil]){
            
            _RELATEFOREST_PLOT = [NSString stringWithFormat:@"-"];
        } else {
        }
        if ([_RELATEFOREST_AREA isEqualToString:@"(null)"] || [_RELATEFOREST_AREA isEqualToString:@""] || [_RELATEFOREST_AREA isEqualToString:nil]){
            
            _RELATEFOREST_AREA = [NSString stringWithFormat:@"-"];
        } else {
        }
        
        _RelateForest = [NSString stringWithFormat:@"[ %@  ราย | %@  แปลง | %@  ไร่ ]",_RELATEFOREST_PEOPLE,_RELATEFOREST_PLOT,_RELATEFOREST_AREA];
    }
    MAActionCell *relateforestCell = [MAActionCell actionCellWithTitle:@"แปลงปลูกป่า ( กรมป่าไม้ )" subtitle:_RelateForest accessory:nil action:^{
    }];
    
    MAActionCell *permanentforestCell = [MAActionCell actionCellWithTitle:@"ป่าไม้ถาวร" subtitle:[NSString stringWithFormat:@"%@  ไร่",_PERMANENTFOREST] accessory:nil action:^{
    }];
    
    if (([_CRIME_PEOPLE isEqualToString:@"(null)"] || [_CRIME_PEOPLE isEqualToString:@""] || [_CRIME_PEOPLE isEqualToString:nil]) && ([_CRIME_AREA isEqualToString:@"(null)"] || [_CRIME_AREA isEqualToString:@""] || [_CRIME_AREA isEqualToString:nil])){
        
        _Crime = [NSString stringWithFormat:@"( รอการเพิ่มเติมข้อมูล )"];
    } else {
        if ([_CRIME_PEOPLE isEqualToString:@"(null)"] || [_CRIME_PEOPLE isEqualToString:@""] || [_CRIME_PEOPLE isEqualToString:nil]){
            
            _CRIME_PEOPLE = [NSString stringWithFormat:@"-"];
        } else {
        }
        if ([_CRIME_AREA isEqualToString:@"(null)"] || [_CRIME_AREA isEqualToString:@""] || [_CRIME_AREA isEqualToString:nil]){
            
            _CRIME_AREA = [NSString stringWithFormat:@"-"];
        } else {
        }
        
        _Crime = [NSString stringWithFormat:@"[ %@  ราย | %@  ไร่ ]",_CRIME_PEOPLE,_CRIME_AREA];
    }
    MAActionCell *crimeCell = [MAActionCell actionCellWithTitle:@"คดีบุกรุก" subtitle:_Crime accessory:nil action:^{
    }];
    
    if (([_CRIME_PEOPLE isEqualToString:@"(null)"] || [_CRIME_PEOPLE isEqualToString:@""] || [_CRIME_PEOPLE isEqualToString:nil]) && ([_CRIME_AREA isEqualToString:@"(null)"] || [_CRIME_AREA isEqualToString:@""] || [_CRIME_AREA isEqualToString:nil])){
        
        _CommunityForest = [NSString stringWithFormat:@"( รอการเพิ่มเติมข้อมูล )"];
    } else {
        if ([_COMMUNITYFOREST_PROJECT isEqualToString:@"(null)"] || [_COMMUNITYFOREST_PROJECT isEqualToString:@""] || [_COMMUNITYFOREST_PROJECT isEqualToString:nil]){
            
            _COMMUNITYFOREST_PROJECT = [NSString stringWithFormat:@"-"];
        } else {
        }
        if ([_COMMUNITYFOREST_AREA isEqualToString:@"(null)"] || [_COMMUNITYFOREST_AREA isEqualToString:@""] || [_COMMUNITYFOREST_AREA isEqualToString:nil]){
            
            _COMMUNITYFOREST_AREA = [NSString stringWithFormat:@"-"];
        } else {
        }
        
        _CommunityForest = [NSString stringWithFormat:@"[ %@  โครงการ | %@  ไร่ ]",_COMMUNITYFOREST_PROJECT,_COMMUNITYFOREST_AREA];
    }
    MAActionCell *communityforestCell = [MAActionCell actionCellWithTitle:@"ป่าชุมชน" subtitle:_CommunityForest accessory:nil action:^{
    }];
    
    MAActionCell *intersecDNPCell = [MAActionCell actionCellWithTitle:@"ทับซ้อนพื้นที่อุทยานแห่งชาติ" subtitle:[NSString stringWithFormat:@"%@  ไร่",_INTERSECDNP] accessory:nil action:^{
    }];
    
    MAActionCell *intersecWLSCell = [MAActionCell actionCellWithTitle:@"ทับซ้อนพื้นที่เขตรักษาพันธุ์สัตว์ป่า" subtitle:[NSString stringWithFormat:@"%@  ไร่",_INTERSECWLS] accessory:nil action:^{
    }];

    MAActionCell *intersecNHACell = [MAActionCell actionCellWithTitle:@"ทับซ้อนพื้นที่เขตห้ามล่าสัตว์ป่า" subtitle:[NSString stringWithFormat:@"%@  ไร่",_INTERSECNHA] accessory:nil action:^{
    }];
    
    MAActionCell *intersecFPCell = [MAActionCell actionCellWithTitle:@"ทับซ้อนพื้นที่วนอุทยาน" subtitle:[NSString stringWithFormat:@"%@  ไร่",_INTERSECFP] accessory:nil action:^{
    }];
    
    if (([_ALR_PEOPLE isEqualToString:@"(null)"] || [_ALR_PEOPLE isEqualToString:@""] || [_ALR_PEOPLE isEqualToString:nil]) && ([_ALR_PLOT isEqualToString:@"(null)"] || [_ALR_PLOT isEqualToString:@""] || [_ALR_PLOT isEqualToString:nil]) && ([_ALR_AREA isEqualToString:@"(null)"] || [_ALR_AREA isEqualToString:@""] || [_ALR_AREA isEqualToString:nil])){
        
        _ALR = [NSString stringWithFormat:@"( รอการเพิ่มเติมข้อมูล )"];
    } else {
        if ([_ALR_PEOPLE isEqualToString:@"(null)"] || [_ALR_PEOPLE isEqualToString:@""] || [_ALR_PEOPLE isEqualToString:nil]){
            
            _ALR_PEOPLE = [NSString stringWithFormat:@"-"];
        } else {
        }
        if ([_ALR_PLOT isEqualToString:@"(null)"] || [_ALR_PLOT isEqualToString:@""] || [_ALR_PLOT isEqualToString:nil]){
            
            _ALR_PLOT = [NSString stringWithFormat:@"-"];
        } else {
        }
        if ([_ALR_AREA isEqualToString:@"(null)"] || [_ALR_AREA isEqualToString:@""] || [_ALR_AREA isEqualToString:nil]){
            
            _ALR_AREA = [NSString stringWithFormat:@"-"];
        } else {
        }
        
        _ALR = [NSString stringWithFormat:@"[ %@  ราย | %@  แปลง | %@  ไร่ ]",_ALR_PEOPLE,_ALR_PLOT,_ALR_AREA];
    }
    MAActionCell *ALR_areaCell = [MAActionCell actionCellWithTitle:@"ส่งมอบ ส.ป.ก." subtitle:_ALR accessory:nil action:^{
    }];
    
    if (([_SELFCOLONY_PEOPLE isEqualToString:@"(null)"] || [_SELFCOLONY_PEOPLE isEqualToString:@""] || [_SELFCOLONY_PEOPLE isEqualToString:nil]) && ([_SELFCOLONY_PLOT isEqualToString:@"(null)"] || [_SELFCOLONY_PLOT isEqualToString:@""] || [_SELFCOLONY_PLOT isEqualToString:nil]) && ([_SELFCOLONY_AREA isEqualToString:@"(null)"] || [_SELFCOLONY_AREA isEqualToString:@""] || [_SELFCOLONY_AREA isEqualToString:nil])){
        
        _SelfColony = [NSString stringWithFormat:@"( รอการเพิ่มเติมข้อมูล )"];
    } else {
        if ([_SELFCOLONY_PEOPLE isEqualToString:@"(null)"] || [_SELFCOLONY_PEOPLE isEqualToString:@""] || [_SELFCOLONY_PEOPLE isEqualToString:nil]){
            
            _SELFCOLONY_PEOPLE = [NSString stringWithFormat:@"-"];
        } else {
        }
        if ([_SELFCOLONY_PLOT isEqualToString:@"(null)"] || [_SELFCOLONY_PLOT isEqualToString:@""] || [_SELFCOLONY_PLOT isEqualToString:nil]){
            
            _SELFCOLONY_PLOT = [NSString stringWithFormat:@"-"];
        } else {
        }
        if ([_SELFCOLONY_AREA isEqualToString:@"(null)"] || [_SELFCOLONY_AREA isEqualToString:@""] || [_SELFCOLONY_AREA isEqualToString:nil]){
            
            _SELFCOLONY_AREA = [NSString stringWithFormat:@"-"];
        } else {
        }
        
        _SelfColony = [NSString stringWithFormat:@"[ %@  ราย | %@  แปลง | %@  ไร่ ]",_SELFCOLONY_PEOPLE,_SELFCOLONY_PLOT,_SELFCOLONY_AREA];
    }
    MAActionCell *selfcolonyCell = [MAActionCell actionCellWithTitle:@"นิคมสร้างตนเอง" subtitle:_SelfColony accessory:nil action:^{
    }];
    
    if (([_COOPERATIVECOLONY_PEOPLE isEqualToString:@"(null)"] || [_COOPERATIVECOLONY_PEOPLE isEqualToString:@""] || [_COOPERATIVECOLONY_PEOPLE isEqualToString:nil]) && ([_COOPERATIVECOLONY_PLOT isEqualToString:@"(null)"] || [_COOPERATIVECOLONY_PLOT isEqualToString:@""] || [_COOPERATIVECOLONY_PLOT isEqualToString:nil]) && ([_COOPERATIVECOLONY_AREA isEqualToString:@"(null)"] || [_COOPERATIVECOLONY_AREA isEqualToString:@""] || [_COOPERATIVECOLONY_AREA isEqualToString:nil])){
        
        _CooperativeColony = [NSString stringWithFormat:@"( รอการเพิ่มเติมข้อมูล )"];
    } else {
    if ([_COOPERATIVECOLONY_PEOPLE isEqualToString:@"(null)"] || [_COOPERATIVECOLONY_PEOPLE isEqualToString:@""] || [_COOPERATIVECOLONY_PEOPLE isEqualToString:nil]){
        
        _COOPERATIVECOLONY_PEOPLE = [NSString stringWithFormat:@"-"];
    } else {
    }
    if ([_COOPERATIVECOLONY_PLOT isEqualToString:@"(null)"] || [_COOPERATIVECOLONY_PLOT isEqualToString:@""] || [_COOPERATIVECOLONY_PLOT isEqualToString:nil]){
        
        _COOPERATIVECOLONY_PLOT = [NSString stringWithFormat:@"-"];
    } else {
    }
    if ([_COOPERATIVECOLONY_AREA isEqualToString:@"(null)"] || [_COOPERATIVECOLONY_AREA isEqualToString:@""] || [_COOPERATIVECOLONY_AREA isEqualToString:nil]){
        
        _COOPERATIVECOLONY_AREA = [NSString stringWithFormat:@"-"];
    } else {
    }

        _CooperativeColony = [NSString stringWithFormat:@"[ %@  ราย | %@  แปลง | %@  ไร่ ]",_COOPERATIVECOLONY_PEOPLE,_COOPERATIVECOLONY_PLOT,_COOPERATIVECOLONY_AREA];
    }
    MAActionCell *cooperativecolonyCell = [MAActionCell actionCellWithTitle:@"นิคมสหกรณ์" subtitle:_CooperativeColony accessory:nil action:^{
    }];
    
    if (([_USED_STK_PEOPLE isEqualToString:@"(null)"] || [_USED_STK_PEOPLE isEqualToString:@""] || [_USED_STK_PEOPLE isEqualToString:nil]) && ([_USED_STK_PLOT isEqualToString:@"(null)"] || [_USED_STK_PLOT isEqualToString:@""] || [_USED_STK_PLOT isEqualToString:nil]) && ([_USED_STK_AREA isEqualToString:@"(null)"] || [_USED_STK_AREA isEqualToString:@""] || [_USED_STK_AREA isEqualToString:nil])){
        
        _Used_STK = [NSString stringWithFormat:@"( รอการเพิ่มเติมข้อมูล )"];
    } else {
        if ([_USED_STK_PEOPLE isEqualToString:@"(null)"] || [_USED_STK_PEOPLE isEqualToString:@""] || [_USED_STK_PEOPLE isEqualToString:nil]){
            
            _USED_STK_PEOPLE = [NSString stringWithFormat:@"-"];
        } else {
        }
        if ([_USED_STK_PLOT isEqualToString:@"(null)"] || [_USED_STK_PLOT isEqualToString:@""] || [_USED_STK_PLOT isEqualToString:nil]){
            
            _USED_STK_PLOT = [NSString stringWithFormat:@"-"];
        } else {
        }
        if ([_USED_STK_AREA isEqualToString:@"(null)"] || [_USED_STK_AREA isEqualToString:@""] || [_USED_STK_AREA isEqualToString:nil]){
            
            _USED_STK_AREA = [NSString stringWithFormat:@"-"];
        } else {
        }
        
        _Used_STK = [NSString stringWithFormat:@"[ %@  ราย | %@  แปลง | %@  ไร่ ]",_USED_STK_PEOPLE,_USED_STK_PLOT,_USED_STK_AREA];
    }
    MAActionCell *usedSTKCell = [MAActionCell actionCellWithTitle:@"พื้นที่ สทก." subtitle:_Used_STK accessory:nil action:^{
    }];

  
    MATableViewSection *firstSection = [MATableViewSection sectionWithTitle:@"" footer:@"" cells:@[areaEchoRCell, areaGISRCell]];
    MATableViewSection *secondSection = [MATableViewSection sectionWithTitle:@"" footer:@"" cells:@[watershedCell]];
    MATableViewSection *thirdSection = [MATableViewSection sectionWithTitle:@"" footer:@"" cells:@[forest55_56Cell]];//ผลการแปลภาพถ่ายดาวเทียม Theos และ Landsat 8\nปี 2555 - 2556
    MATableViewSection *fourthSection = [MATableViewSection sectionWithTitle:@"" footer:@"" cells:@[surveyarea_areaCell, usedarea_areaCell, relateforestCell, permanentforestCell, crimeCell, communityforestCell]];
    MATableViewSection *fifthSection = [MATableViewSection sectionWithTitle:@"" footer:@"" cells:@[intersecDNPCell, intersecWLSCell, intersecNHACell, intersecFPCell]];
    MATableViewSection *sixthSection = [MATableViewSection sectionWithTitle:@"" footer:[NSString stringWithFormat:@"*พื้นที่ ส.ป.ก. คงสภาพป่า %@ ไร่",_ALR_FOREST55_56] cells:@[ALR_areaCell, selfcolonyCell, cooperativecolonyCell, usedSTKCell]];
    
    
    
    /* UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kittens.jpg"]];
     MATableViewSection *thirdSection = [MATableViewSection sectionWithView:headerImageView height:80 cells:@[fourthCell]];*/
    
    _sections = @[firstSection, secondSection, thirdSection, fourthSection, fifthSection, sixthSection];
}


#pragma mark - Actions

- (void)pushSomething {
    [self performSegueWithIdentifier:@"UseAreaDetailTableToSubUseAreaDetail" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MATableViewSection *mySection = _sections[section];
    return mySection.cells.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MATableViewSection *mySection = _sections[section];
    return mySection.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 50;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:13];
    header.textLabel.textColor = [UIColor blackColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    MATableViewSection *mySection = _sections[section];
    return mySection.headerHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    MATableViewSection *mySection = _sections[section];
    return mySection.title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    MATableViewSection *mySection = _sections[section];
    return mySection.footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MATableViewSection *mySection = _sections[indexPath.section];
    
    return mySection.cells[indexPath.row];
}


#pragma  mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MATableViewSection *mySection = _sections[indexPath.section];
    MAActionCell *selectedCell = mySection.cells[indexPath.row];
    selectedCell.actionBlock();
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"UseAreaDetailTableToSubUseAreaDetail"]) {
        if ([segue.destinationViewController isKindOfClass:[SubUseAreaDetailViewController class]]) {
            SubUseAreaDetailViewController *controller = (SubUseAreaDetailViewController *)segue.destinationViewController;

            controller.LAW_A_PEOPLE = _LAW_A_PEOPLE;
            controller.LAW_A_AREA = _LAW_A_AREA;
            controller.LAW_B_PEOPLE = _LAW_B_PEOPLE;
            controller.LAW_B_AREA = _LAW_B_AREA;
            controller.LAW_C_PEOPLE = _LAW_C_PEOPLE;
            controller.LAW_C_AREA = _LAW_C_AREA;
            controller.LAW_D_PEOPLE = _LAW_D_PEOPLE;
            controller.LAW_D_AREA = _LAW_D_AREA;
            controller.LAW_E_PEOPLE = _LAW_E_PEOPLE;
            controller.LAW_E_AREA = _LAW_E_AREA;
            controller.LAW_F_PEOPLE = _LAW_F_PEOPLE;
            controller.LAW_F_AREA = _LAW_F_AREA;
            controller.LAW_G_PEOPLE = _LAW_G_PEOPLE;
            controller.LAW_G_AREA = _LAW_G_AREA;
            controller.LAW_H_PEOPLE = _LAW_H_PEOPLE;
            controller.LAW_H_AREA = _LAW_H_AREA;
        }
    }
}


@end
