//
//  THDeliveryViewController.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THDeliveriesViewController.h"

#import "DeliveriesViewModel.h"
#import "THTableViewDeliveryCell.h"
#import "THConfigration.h"

#import "Orders+Access.h"

#import "ScanPostViewModel.h"
#import "THScanPostViewController.h"

@interface THDeliveriesViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic,strong) UISearchDisplayController *searchDisplayVC;

@property (nonatomic, strong) FUISegmentedControl * stateControl;

@property (nonatomic, strong) UIBarButtonItem * rightBarButtonItem;

@end

@implementation THDeliveriesViewController

#pragma mark - UIViewController Overrides

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)loadView
{
    CGRect windowFrame = [UIScreen mainScreen].bounds;
    
    UIView * view = [[UIView alloc] initWithFrame:windowFrame];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, windowFrame.size.width, windowFrame.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [view addSubview:self.tableView];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = NSLocalizedString(@"发货中心", nil);
    
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    
    self.stateControl = [[FUISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"未发货", nil), NSLocalizedString(@"已发货", nil)]];
    self.stateControl.bounds = CGRectMake(0, 0, 120, 31);
    self.stateControl.selectedColor = [UIColor colorWithRed:242.0/255
                                                      green:39.0/255
                                                       blue:131.0/255
                                                      alpha:1.0];
    self.stateControl.deselectedColor = [UIColor clearColor];
    [self.stateControl addTarget:self
                          action:@selector(stateControlDidChangeValue:)
                forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = self.stateControl;
    
    self.stateControl.selectedSegmentIndex = 0;
    self.viewModel.state = @(self.stateControl.selectedSegmentIndex);
    
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"同步", nil)
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(synchronizeOrders:)];
    //    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

    
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    searchBar.showsCancelButton = NO;
//    searchBar.text = nil;
//    searchBar.placeholder = NSLocalizedString(@"搜索", nil);
//    searchBar.delegate = self;
//    [self.view addSubview:searchBar];
//    
//    self.searchDisplayVC = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    self.searchDisplayVC.delegate = self;
//    self.searchDisplayVC.searchResultsDataSource = self;
//    self.searchDisplayVC.searchResultsDelegate = self;
//    [self.searchDisplayVC setActive:NO];
//    
    [self.tableView registerClass:[THTableViewDeliveryCell class]
           forCellReuseIdentifier:@"Cell"];
//    [self.searchDisplayVC.searchResultsTableView registerClass:[THTableViewDeliveryCell class]
//                                        forCellReuseIdentifier:@"Cell"];
//    self.searchDisplayVC.searchResultsTableView.backgroundColor = [UIColor clearColor];
//    self.searchDisplayVC.searchResultsTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    self.searchDisplayVC.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    @weakify(self);
    
    RAC(self.navigationItem, rightBarButtonItem) = [RACObserve(self.stateControl, selectedSegmentIndex) map:^id(NSNumber * value) {
        @strongify(self);
        if (0 == value.longLongValue)
        {
            return nil;
        }
        else
        {
            return self.rightBarButtonItem;
        }
    }];
    
    [self.viewModel.updatedContentSignal subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"---- %@ reloadData", NSStringFromClass([self class]));
        if (self.searchDisplayVC.isActive)
        {
            [self.searchDisplayVC.searchResultsTableView reloadData];
        }
        else
        {
            [self.tableView reloadData];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([THAuthorizer sharedAuthorizer].isLoggedIn)
    {
        self.viewModel.active = YES;
        
        THConfigration * configration = [THConfigration sharedConfigration];
        BOOL needToSync = configration.hasOrdersToSync;
        
        if (needToSync) {
            [SVProgressHUD showWithStatus:NSLocalizedString(@"加载中...", nil)
                                 maskType:SVProgressHUDMaskTypeGradient];
            
            [self.viewModel.refreshSignal subscribeNext:^(NSArray * x) {
                [SVProgressHUD dismiss];
                configration.hasOrdersToSync = NO;
            } error:^(NSError *error) {
                [SVProgressHUD dismiss];
                NSLog(@"---- Refresh error: %@", error);
            }];
        }
    }
}

#pragma mark -
- (void)stateControlDidChangeValue:(FUISegmentedControl *)control
{
    NSNumber * index = @(control.selectedSegmentIndex);
    
    self.viewModel.state = index;
}

- (void)synchronizeOrders:(id)sender
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"同步中...", nil)
                         maskType:SVProgressHUDMaskTypeGradient];
    
    [self.viewModel.synchronizeSignal subscribeNext:^(id x) {
        [SVProgressHUD dismiss];
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"--- Synchronization error: %@", error);
    }];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    THTableViewDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    @weakify(self);
    [cell.scanPostSignal subscribeNext:^(Orders * anOrder) {
        @strongify(self);
        NSLog(@"Scan post for %@", anOrder);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isAppeared)
            {
                ScanPostViewModel * scanpostViewModel = [[ScanPostViewModel alloc] initWithModel:self.viewModel.model];
                scanpostViewModel.order = anOrder;
                
                THScanPostViewController * scanpostViewController = [[THScanPostViewController alloc] init];
                scanpostViewController.viewModel = scanpostViewModel;
                
                [self.navigationController pushViewController:scanpostViewController
                                                     animated:YES];
            }
        });
    }];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    // Always return YES.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.viewModel deleteObjectAtIndexPath:indexPath];
    }
}
//
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [self.viewModel titleForSection:section];
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    Orders * order = [self.viewModel orderAtIndexPath:indexPath];
//    
//    ScanPostViewModel * scanpostViewModel = [[ScanPostViewModel alloc] initWithModel:self.viewModel.model];
//    scanpostViewModel.order = order;
//    
//    THScanPostViewController * scanpostViewController = [[THScanPostViewController alloc] init];
//    scanpostViewController.viewModel = scanpostViewModel;
//    
//    [self.navigationController pushViewController:scanpostViewController
//                                         animated:YES];
}

#pragma mark

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 112.0;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return (self.editing == NO);
}

#pragma mark - Private Methods

- (void)configureCell:(THTableViewDeliveryCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Orders * order = [self.viewModel orderAtIndexPath:indexPath];
    
    [cell updateWithOrder:order atIndexPath:indexPath];
}



#pragma mark - UISearchBar delegate

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [self.tableView removeFromSuperview];
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    
}
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    [self.navigationController.navigationBar layoutSubviews];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.hidden = NO;
    
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    tableView.hidden = YES;
    
    tableView.delegate = nil;
    tableView.dataSource = nil;
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchDisplayVC setActive:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //
}

#pragma mark - UISearchDisplayDelegate methods related

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.viewModel.searchString = searchString;
    
    return NO;
}

@end

