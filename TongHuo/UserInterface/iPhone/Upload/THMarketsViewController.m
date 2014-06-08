//
//  THMarketsViewController.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THMarketsViewController.h"

#import "MarketsViewModel.h"
#import "ShopsViewModel.h"
#import "THTableViewMarketCell.h"
#import "THShopsViewController.h"
#import "THConfigration.h"

@interface THMarketsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation THMarketsViewController

#pragma mark - UIViewController Overrides

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)loadView
{
    CGRect windowFrame = [UIScreen mainScreen].bounds;
    
    UIView * view = [[UIView alloc] initWithFrame:windowFrame];
    
    self.tableView = [[UITableView alloc] initWithFrame:windowFrame];
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
    
    self.title = NSLocalizedString(@"档口", nil);
    
    [self.tableView registerClass:[THTableViewMarketCell class]
           forCellReuseIdentifier:@"Cell"];
    
    @weakify(self);
    
    THConfigration * configration = [THConfigration sharedConfigration];
    BOOL needToSync = !configration.isMarketsSynced;
    if (needToSync)
    {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"加载中...", nil)
                             maskType:SVProgressHUDMaskTypeGradient];
        
        [self.viewModel.refreshSignal subscribeNext:^(NSArray * x) {
            [SVProgressHUD dismiss];
            if (x)
            {
                configration.marketsSynced = YES;
                
                NSLog(@"---- Markets: %@", x);
            }
        } error:^(NSError *error) {
            [SVProgressHUD dismiss];
            NSLog(@"---- Refresh error: %@", error);
        }];
    }
    
    [self.viewModel.updatedContentSignal subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"---- %@ reloadData", NSStringFromClass([self class]));
        [self.tableView reloadData];
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.viewModel.active = YES;
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
    THTableViewMarketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    // Always return YES.
    return YES;
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
    ShopsViewModel * shopsViewModel = [[ShopsViewModel alloc] initWithModel:self.viewModel.model];
    shopsViewModel.market = [self.viewModel marketAtIndexPath:indexPath];
    
    THShopsViewController * shopViewController = [[THShopsViewController alloc] init];
    shopViewController.viewModel = shopsViewModel;
    
    [self.navigationController pushViewController:shopViewController animated:YES];
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

- (void)configureCell:(THTableViewMarketCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Markets * market = [self.viewModel marketAtIndexPath:indexPath];
    
    [cell updateWithMarket:market atIndexPath:indexPath];
}


@end
