//
//  AppDelegate.m
//  TongHuo
//
//  Created by zeng songgen on 14-5-23.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "AppDelegate.h"

#import "THCoreDataStack.h"
#import "THNavigationController.h"

// View Controllers
#import "THMenuViewController.h"
#import "THSignInViewController.h"
#import "THOrdersViewController.h"

// View Models
#import "MenuViewModel.h"
#import "SignInViewModel.h"
#import "OrdersViewModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize sidePanelController = _sidePanelController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationBackground"]
                                       forBarMetrics:UIBarMetricsDefault];
    // Setup window
//    self.window.tintColor = [UIColor colorWithHexString:@"9E4B10"];

    // Setup Menu controller
    THMenuViewController * menuViewController = [[THMenuViewController alloc] init];
    
    MenuViewModel * menuModel =[[MenuViewModel alloc] initWithModel:[THCoreDataStack defaultStack].managedObjectContext];
    menuViewController.viewModel = menuModel;
    
    THNavigationController * navControlloer = [[THNavigationController alloc] init];
    
    THOrdersViewController * ordersViewController = [[THOrdersViewController alloc] init];
    ordersViewController.viewModel = (OrdersViewModel *)[menuModel viewModelForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [navControlloer setViewControllers:@[ordersViewController]];

    // Setup model
    [[THCoreDataStack defaultStack] ensureInitialLoad];
    
    // Seup app root
    _sidePanelController = [[JASidePanelController alloc] init];
    
    _sidePanelController.leftPanel = menuViewController;
    _sidePanelController.centerPanel = navControlloer;
    _sidePanelController.rightPanel = nil;
    
    navControlloer.navigationItem.leftBarButtonItem = _sidePanelController.leftButtonForCenterPanel;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        _sidePanelController.edgesForExtendedLayout = UIRectEdgeNone;
        _sidePanelController.extendedLayoutIncludesOpaqueBars = NO;
        _sidePanelController.modalPresentationCapturesStatusBarAppearance = NO;
        _sidePanelController.automaticallyAdjustsScrollViewInsets = YES;
    }
#endif
    
    self.window.rootViewController = _sidePanelController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // Saves changes in the application's managed object context before the application terminates.
    [[THCoreDataStack defaultStack] saveContext];
}

@end
