//
//  THGoodsViewController.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THGoodsViewController.h"

#import "GoodsViewModel.h"
#import "UploadViewModel.h"
#import "THTableViewGoodCell.h"

#import "Shops+Access.h"

#import "THUploadGoodsViewController.h"

#import "UMSocialSnsPlatformManager.h"
#import "UMSocialSnsService.h"

@interface THGoodsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSNumber * shopIdentifier;

@end

@implementation THGoodsViewController

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
    
    self.title = self.viewModel.shop.name;
    self.shopIdentifier = self.viewModel.shop.identifier;
    
    [self.tableView registerClass:[THTableViewGoodCell class]
           forCellReuseIdentifier:@"Cell"];
    
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ShareButton"]
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    @weakify(self);
    [SVProgressHUD showWithStatus:NSLocalizedString(@"加载中...", nil)
                         maskType:SVProgressHUDMaskTypeGradient];
    
    [self.viewModel.refreshSignal subscribeNext:^(NSArray * x) {
        [SVProgressHUD dismiss];
        if (x)
        {
            NSLog(@"---- Goods: %@", x);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"---- Refresh error: %@", error);
    }];
    
    [self.viewModel.updatedContentSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
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
    THTableViewGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
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
    UploadViewModel * uploadViewModel = [[UploadViewModel alloc] initWithModel:self.viewModel.model];
    uploadViewModel.good = [self.viewModel goodAtIndexPath:indexPath];
    
    THUploadGoodsViewController * uploadGoodsViewController = [[THUploadGoodsViewController alloc] init];
    uploadGoodsViewController.viewModel = uploadViewModel;
    
    [self.navigationController pushViewController:uploadGoodsViewController animated:YES];}

#pragma mark

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81.0;
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

- (void)configureCell:(THTableViewGoodCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Goods * good = [self.viewModel goodAtIndexPath:indexPath];
    
    [cell updateWithGood:good atIndexPath:indexPath];
}

- (void)share:(UIButton *)sender
{
    // Share
    NSString * shareMessage = [NSString stringWithFormat:NSLocalizedString(@"全国最大的在线服装批发市场，59批发，http://www.59pi.com/shop/%@.html", nil), self.shopIdentifier];
    NSArray * shareNames = [NSArray arrayWithObjects:UMShareToWechatSession,UMShareToSina,UMShareToEmail,UMShareToSms,nil];
    [UMSocialSnsService presentSnsIconSheetView:self.parentViewController
                                         appKey:kUMengAppKey
                                      shareText:shareMessage
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:shareNames
                                       delegate:nil];
}

@end
