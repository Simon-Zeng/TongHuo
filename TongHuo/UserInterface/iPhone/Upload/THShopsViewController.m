//
//  THShopsViewController.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THShopsViewController.h"

#import "ShopsViewModel.h"
#import "GoodsViewModel.h"
#import "THTableViewShopCell.h"
#import "THGoodsViewController.h"
#import "THConfigration.h"

#import "Markets+Access.h"

@interface THShopsViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic,strong) UISearchDisplayController *searchDisplayVC;

@end

@implementation THShopsViewController

#pragma mark - UIViewController Overrides

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)loadView
{
    CGRect windowFrame = [UIScreen mainScreen].bounds;
    
    UIView * view = [[UIView alloc] initWithFrame:windowFrame];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, windowFrame.size.width, windowFrame.size.height - 44)];
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
    
    self.title = self.viewModel.market.name;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    searchBar.placeholder = NSLocalizedString(@"搜索", nil);
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    
    self.searchDisplayVC = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchDisplayVC.delegate = self;
    self.searchDisplayVC.searchResultsDataSource = self;
    self.searchDisplayVC.searchResultsDelegate = self;
    [self.searchDisplayVC setActive:NO];
    
    [self.tableView registerClass:[THTableViewShopCell class]
           forCellReuseIdentifier:@"Cell"];
    [self.searchDisplayVC.searchResultsTableView registerClass:[THTableViewShopCell class]
                                        forCellReuseIdentifier:@"Cell"];
    self.searchDisplayVC.searchResultsTableView.backgroundColor = [UIColor clearColor];
    self.searchDisplayVC.searchResultsTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.searchDisplayVC.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    @weakify(self);
    
    THConfigration * configration = [THConfigration sharedConfigration];
    BOOL needToSync = !configration.isShopsSynced;
    if (needToSync && [THAuthorizer sharedAuthorizer].isLoggedIn)
    {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"加载中...", nil)
                             maskType:SVProgressHUDMaskTypeGradient];
        
        [self.viewModel.refreshSignal subscribeNext:^(NSArray * x) {
            [SVProgressHUD dismiss];
            
            configration.shopsSynced = YES;
        } error:^(NSError *error) {
            [SVProgressHUD dismiss];
            NSLog(@"---- Refresh error: %@", error);
        }];
    }

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
    }
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
    THTableViewShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
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

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [self.viewModel titleForSection:section];
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsViewModel * goodsViewModel = [[GoodsViewModel alloc] initWithModel:self.viewModel.model];
    goodsViewModel.shop = [self.viewModel shopAtIndexPath:indexPath];
    
    THGoodsViewController * goodsViewController = [[THGoodsViewController alloc] init];
    goodsViewController.viewModel = goodsViewModel;
    
    [self.navigationController pushViewController:goodsViewController animated:YES];
}

#pragma mark

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57.0;
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

- (void)configureCell:(THTableViewShopCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Shops * shop = [self.viewModel shopAtIndexPath:indexPath];
    
    [cell updateWithShop:shop atIndexPath:indexPath];
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
    self.viewModel.searchString = @"";
    
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
