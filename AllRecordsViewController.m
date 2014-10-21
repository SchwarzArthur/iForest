//
//  AllRecordsViewController.m
//  DatabaseManager

#import "AllRecordsViewController.h"
#import "MyDatabaseManager.h"
#import "RecordCell.h"
#import "DetailDatabaseViewController.h"
#import "ViewController.h"

@interface AllRecordsViewController ()
{
    NSArray *records;
    NSArray *filteredRecords;
    RecordTables *selectedRecord;
    NSString *sortingAttribute;
}

-(void)deleteAllRecords:(id)sender;
-(void)ShowActionSheet:(id)sender;

@end

@implementation AllRecordsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Pin", nil);

    UIBarButtonItem *closeTransparentView = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeTransparentView)];
    UIBarButtonItem *editTabledelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTableDelete)];
    
    NSArray* buttonArrays = [[NSArray alloc] initWithObjects:closeTransparentView,editTabledelete, nil];
    self.navigationItem.rightBarButtonItems = buttonArrays;
    
    [self.tableView setEditing:YES animated:YES];
    self.tableView.allowsSelectionDuringEditing = YES;
    
    filteredRecords = [NSMutableArray arrayWithCapacity:[records count]];
    
    [self.tableView reloadData];

}

-(void)refreshTable
{
    records = [[[MyDatabaseManager sharedManager] allRecordsSortByAttribute:sortingAttribute] mutableCopy];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredRecords count];
    }
    else
    {
        return [records count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"recordCells";

    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        RecordTables *record = [filteredRecords objectAtIndex:indexPath.row];

        cell.textLabel.text = record.name;
        cell.detailTextLabel.text = record.type;
        return cell;

    }
    else
    {
        RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[RecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        RecordTables *record = [records objectAtIndex:indexPath.row];
        cell.labelName.text = [NSString stringWithFormat:@": %@", record.name];
        cell.labelType.text = [NSString stringWithFormat:@": %@", record.type];
        cell.labelCoordinate.text = [NSString stringWithFormat:@": %@ / %@",record.coordinate_y, record.coordinate_x];
        cell.labelComment.text = [NSString stringWithFormat:@": %@", record.descriptions];
        
        return cell;
    }
    //from viewController
   /* if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        RecordTables *record = [filteredRecords objectAtIndex:indexPath.row];
        
        cell.textLabel.text = record.name;
        cell.detailTextLabel.text = record.type;
        return cell;
        
    } else if (cell_type_to_display == TBL_CELL_NONE) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        
        RecordTables *record = [records objectAtIndex:indexPath.row];
        
        UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90.0, 40.0)];//140 for Lat.Lon
        distanceLabel.font = [UIFont systemFontOfSize:12.0f];
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.textColor = [UIColor grayColor];
        
        CLLocationCoordinate2D addCoordinate;
        addCoordinate.latitude = [record.coordinate_y doubleValue];
        addCoordinate.longitude = [record.coordinate_x doubleValue];
        
        GeodeticUTMConverter *utmConverter = [[GeodeticUTMConverter alloc] init];
        UTMCoordinates utmCoordinates = [utmConverter latitudeAndLongitudeToUTMCoordinates:addCoordinate];
        
        cell.textLabel.text = record.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"E: %.1f N: %.1f Zone: %u",utmCoordinates.easting,utmCoordinates.northing,utmCoordinates.gridZone];
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        
        //  distanceLabel.text = [NSString stringWithFormat:@"Lat: %.2f , Lon: %.2f",addCoordinate.latitude,addCoordinate.longitude];
        distanceLabel.text = record.type;
        distanceLabel.textAlignment = NSTextAlignmentRight;
        cell.accessoryView = distanceLabel;
        cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        return cell;*/
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        selectedRecord = [filteredRecords objectAtIndex:indexPath.row];
    } else {
        selectedRecord = [records objectAtIndex:indexPath.row];
    }

    [self performSegueWithIdentifier:@"TableToDetails" sender:self];
    //from viewController
    /* if (tableView == self.searchDisplayController.searchResultsTableView) {
     selectedRecord = [filteredRecords objectAtIndex:indexPath.row];
     } else {
     selectedRecord = [records objectAtIndex:indexPath.row];
     }
     
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
     
     [self performSegueWithIdentifier:@"TableToDetails" sender:self];
     } else {
     
     if (detailDatabasePopoverController == nil) {
     
     UIView *btn = [UIView new];
     btn.frame = CGRectMake(0, 0, _mapView.frame.size.width*2 - 80 , 80);
     
     DetailDatabaseViewController *detailDatabaseViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailDatabaseViewController"];
     detailDatabaseViewController.preferredContentSize = CGSizeMake(320, 480);
     
     if (tableView == self.searchDisplayController.searchResultsTableView) {
     selectedRecord = [filteredRecords objectAtIndex:indexPath.row];
     detailDatabaseViewController.record = selectedRecord;
     } else {
     selectedRecord = [records objectAtIndex:indexPath.row];
     detailDatabaseViewController.record = selectedRecord;
     }
     detailDatabaseViewController.modalInPopover = NO;
     
     UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:detailDatabaseViewController];
     
     detailDatabasePopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
     detailDatabasePopoverController.delegate = self;
     detailDatabasePopoverController.passthroughViews = @[btn];
     detailDatabasePopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
     detailDatabasePopoverController.wantsDefaultContentAppearance = NO;
     
     [detailDatabasePopoverController presentPopoverFromRect:btn.bounds
     inView:self.view
     permittedArrowDirections:WYPopoverArrowDirectionAny
     animated:YES
     options:WYPopoverAnimationOptionFadeWithScale];
     } else {
     //  [self close:nil];
     }
     }
*/
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        RecordTables *aRecord = [records objectAtIndex: indexPath.row];
        [[MyDatabaseManager sharedManager] deleteTableRecord:aRecord];

        [self refreshTable];
    }
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    filteredRecords = [[MyDatabaseManager sharedManager] allRecordsSortByAttribute:nil where:scope contains:searchText];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

-(void)deleteAllRecords:(id)sender
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                      message:@"Do you want to delete all records"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Delete", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Delete"])
    {
        [[MyDatabaseManager sharedManager] deleteAllTableRecord];
        
        [self refreshTable];

        NSLog(@"Delete was selected.");
    }
    else if([title isEqualToString:@"Cancel"])
    {
        NSLog(@"Cancel was selected.");
    }
}

-(void)ShowActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Sort List"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:kName,kType,kComment,KDate, nil];
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if (![buttonTitle isEqualToString:@"Cancel"])
    {
        sortingAttribute = buttonTitle;
        [self refreshTable];
    }
}
/*-(void)showTableDatabase {//from viewController
    
    [_transparentView close];
    [drawer hideAnimated:YES];
    
 
    //    self.switchUpdateIfExist.hidden = YES;
    
    _transparentView = [[HATransparentView alloc] init];
    _transparentView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        _transparentView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, _transparentView.frame.size.width, _transparentView.frame.size.height - self.searchDisplayController.searchBar.frame.size.height - 20)];
        
        self.navigationItem.title = [NSString stringWithFormat:@"%lu Pins",(unsigned long)[records count]];
    } else {
        _transparentView.frame = CGRectMake(428, 80, 320, 500); //iPad
        _transparentView.layer.cornerRadius = 16.0f;
        _transparentView.layer.borderWidth = 1.0f;
        _transparentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _transparentView.layer.masksToBounds = YES;
        _transparentView.opaque = NO;
        _transparentView.alpha = .95f;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, _transparentView.frame.size.width, _transparentView.frame.size.height - self.searchDisplayController.searchBar.frame.size.height )];
        
        self.navigationItem.title = NSLocalizedString(@"Map", nil);
        
        UILabel *list = [[UILabel alloc] initWithFrame:CGRectMake(0,10, _transparentView.frame.size.width, 20)];
        list.text = [NSString stringWithFormat:@"%lu Pins",(unsigned long)[records count]];
        list.font = [UIFont boldSystemFontOfSize:17];
        list.backgroundColor = [UIColor clearColor];
        list.textColor = [UIColor colorWithRed:24.0/255.0 green:116.0/255.0 blue:255.0/255.0 alpha:1];
        list.textAlignment = NSTextAlignmentCenter;
        [_transparentView addSubview:list];
        
        UIView *lineUnder = [UIView new];
        lineUnder.frame = CGRectMake( 0, 39, _transparentView.frame.size.width, 1.0f);
        lineUnder.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:1.0f];
        [_transparentView addSubview:lineUnder];
    }
    [_transparentView open];
    [self.view addSubview:_transparentView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    cell_type_to_display = TBL_CELL_NONE;
    
    [_transparentView addSubview:_tableView];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        self.searchDisplayController.searchBar.frame = CGRectMake(0, 0, _tableView.frame.size.width, 44);
    } else {
        self.searchDisplayController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    }
    self.tableView.tableHeaderView = self.searchDisplayController.searchBar;
    self.tableView.contentOffset = CGPointMake(0,self.searchDisplayController.searchBar.frame.size.height);
    
    self.searchDisplayController.searchResultsTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.f, 0.f, 0.f);
    
    [self.tableView insertSubview:self.searchDisplayController.searchBar aboveSubview:self.tableView];
    
    
    UIBarButtonItem *closeTransparentView = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeTransparentView)];
    UIBarButtonItem *editTabledelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTableDelete)];
    
    NSArray* buttonArrays = [[NSArray alloc] initWithObjects:closeTransparentView,editTabledelete, nil];
    self.navigationItem.rightBarButtonItems = buttonArrays;
}
//- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
// if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
 
// } else{
// self.searchDisplayController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
// [self.tableView insertSubview:self.searchDisplayController.searchBar aboveSubview:self.tableView];
// }
// 
 }

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    
    self.searchDisplayController.searchBar.frame = CGRectMake(0, 0, _tableView.frame.size.width, 44);
    [self.tableView insertSubview:self.searchDisplayController.searchBar aboveSubview:self.tableView];
}*/

-(void)editTableDelete {
    [self.tableView setEditing:YES animated:YES];
    self.tableView.allowsSelectionDuringEditing = YES;
    self.navigationItem.title = NSLocalizedString(@"", nil);
    
    UIBarButtonItem *actionSheetButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(ShowActionSheet:)];
    UIBarButtonItem *deleteAllRecords = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAllRecords:)];
    UIBarButtonItem *doneTabledelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTableDelete)];
    
    NSArray* buttonArrays = [[NSArray alloc] initWithObjects:doneTabledelete,deleteAllRecords,actionSheetButton, nil];
    self.navigationItem.rightBarButtonItems = buttonArrays;
}

-(void)doneTableDelete {
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.title = [NSString stringWithFormat:@"%lu Pins",(unsigned long)[records count]];
    
    UIBarButtonItem *closeTransparentView = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeTransparentView)];
    UIBarButtonItem *editTabledelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTableDelete)];
    
    NSArray* buttonArrays = [[NSArray alloc] initWithObjects:closeTransparentView,editTabledelete, nil];
    self.navigationItem.rightBarButtonItems = buttonArrays;
}

-(void)closeTransparentView {
    
   /* [_transparentView close];
    
    [self reloadAnnotations];
    
    MKUserTrackingBarButtonItem *buttonItem =
    [[MKUserTrackingBarButtonItem alloc] initWithMapView:_mapView];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    UIBarButtonItem *showTableDatabases = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico-to-do-list"] style:UIBarButtonItemStylePlain target:self action:@selector(showTableDatabase)];
    
    buttonArray = [[NSArray alloc] initWithObjects:buttonItem,showTableDatabases, nil];
    
    self.navigationItem.rightBarButtonItems = buttonArray;
    
    self.navigationItem.title = NSLocalizedString(@"Map", nil);*/
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TableToDetails"])
    {
        DetailDatabaseViewController *controller = [segue destinationViewController];
        controller.record = selectedRecord;
    }
    //from viewController
    /* else if ([segue.identifier isEqualToString:@"TableToDetails"])
     {
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
     DetailDatabaseViewController *controller = [segue destinationViewController];
     controller.record = selectedRecord;
     
     } else {
     WYStoryboardPopoverSegue *popoverSegue = (WYStoryboardPopoverSegue *)segue;
     
     detailDatabasePopoverController = [popoverSegue popoverControllerWithSender:sender
     permittedArrowDirections:WYPopoverArrowDirectionDown
     animated:YES
     options:WYPopoverAnimationOptionFadeWithScale];
     detailDatabasePopoverController.delegate = self;
     }
     }*/
}


@end
