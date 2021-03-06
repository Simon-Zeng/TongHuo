//
//  THMenuViewController.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THMenuViewController.h"

#import <CoreFoundation/CoreFoundation.h>

#import "AppDelegate.h"
#import "Account+Access.h"
#import "THAuthorizer.h"

#import "MenuViewModel.h"
#import "THTableViewMenuCell.h"
#import "THSignInViewController.h"

#import "UMSocialSnsPlatformManager.h"
#import "UMSocialSnsService.h"

@interface THMenuViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation THMenuViewController

#pragma mark - UIViewController Overrides

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)loadView
{
    CGRect windowFrame = [UIScreen mainScreen].bounds;
    
    UIView * view = [[UIView alloc] initWithFrame:windowFrame];
    view.backgroundColor = [UIColor colorWithRed:230.0/255
                                           green:230.0/255
                                            blue:230.0/255
                                           alpha:1.0];
    // Add navbar
    UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, windowFrame.size.width, 44)];
    
    // create navbaritem
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 0, windowFrame.size.width-30.0, 44)];
    titleLabel.font = [UIFont systemFontOfSize:20.0];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"欢迎";
    
    self.titleLabel = titleLabel;
    
    UINavigationItem *NavTitle = [[UINavigationItem alloc] init];
    NavTitle.titleView = titleLabel;
    
    [nav pushNavigationItem:NavTitle animated:YES];
    
    [view addSubview:nav];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, windowFrame.size.width, windowFrame.size.height-64.0f)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [view addSubview:self.tableView];
    
    // Add addtional text
    UILabel * descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, 240, 20)];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.font = [UIFont systemFontOfSize:13.0];
    descriptionLabel.text = NSLocalizedString(@"59批发网，荣誉出品", nil);
    
    [view addSubview:descriptionLabel];
    
    UILabel * urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 420, 240, 20)];
    urlLabel.textAlignment = NSTextAlignmentCenter;
    urlLabel.font = [UIFont systemFontOfSize:13.0];
    urlLabel.text = NSLocalizedString(@"www.59pi.com", nil);
    
    [view addSubview:urlLabel];
    
    NSDictionary * infoDict = [NSBundle mainBundle].infoDictionary;
    NSString * versionString = [infoDict objectForKey:@"CFBundleShortVersionString"];

    UILabel * versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 440, 240, 20)];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont systemFontOfSize:13.0];
    versionLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"版本", nil), versionString];
    
    [view addSubview:versionLabel];

    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;

    [self.tableView registerClass:[THTableViewMenuCell class]
           forCellReuseIdentifier:@"Cell"];
    
    @weakify(self);
    [self.viewModel.updateNameSignal subscribeNext:^(NSManagedObjectID * x) {
        if (x)
        {
            Account * account = (Account *)[[THCoreDataStack defaultStack].threadManagedObjectContext objectWithID:x];
            NSString * loginName = account.loginname;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.titleLabel.text = [NSString stringWithFormat:@"欢迎: %@", loginName];
            });
        }
    }];
    
    THAuthorizer * authorizer = [THAuthorizer sharedAuthorizer];
    
    @weakify(authorizer);
    [authorizer.updateSignal subscribeNext:^(id x) {
        @strongify(authorizer);
        if (x)
        {
            [authorizer refreshTBAuthenticationFor:authorizer.userIdentifier];
        }
    }];
    
    [self.viewModel.updatedContentSignal subscribeNext:^(id x) {
        @strongify(self);
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.viewModel titleForSection:section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(![self.viewModel presentViewControllerForIndexPath:indexPath])
    {
        if (indexPath.row == 3)
        {
            // Share
            NSString * shareMessage = NSLocalizedString(@"全国最大的在线服装批发市场，59批发，http://www.59pi.com", nil);
            NSArray * shareNames = [NSArray arrayWithObjects:UMShareToWechatSession,UMShareToSina,UMShareToEmail,UMShareToSms,nil];
            [UMSocialSnsService presentSnsIconSheetView:self.parentViewController
                                                 appKey:kUMengAppKey
                                              shareText:shareMessage
                                             shareImage:[UIImage imageNamed:@"icon.png"]
                                        shareToSnsNames:shareNames
                                               delegate:nil];
        }
        else if (indexPath.row == 6)
        {
            // Logout
            [AppDelegate logout];
        }
    }
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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = [self.viewModel titleAtIndexPath:indexPath];
    cell.detailTextLabel.text = [self.viewModel subtitleAtIndexPath:indexPath];
}


@end
