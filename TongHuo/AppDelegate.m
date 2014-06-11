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
#import "THAuthorizer.h"

// View Controllers
#import "THMenuViewController.h"
#import "THSignInViewController.h"
#import "THOrdersViewController.h"

// View Models
#import "MenuViewModel.h"
#import "SignInViewModel.h"
#import "OrdersViewModel.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize sidePanelController = _sidePanelController;

+ (UINavigationController *)rootNavigationController
{
    return (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [UMSocialData setAppKey:kUMengAppKey];

    //设置微信AppId，和分享url
    [UMSocialWechatHandler setWXAppId:kWeChatAppID url:kWeChatCallBackURL];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationBackground"]
                                       forBarMetrics:UIBarMetricsDefault];
    [[UILabel appearance] setTextColor:[UIColor whiteColor]];
    
    NSDictionary * barButtonItemTitleAttribute = @{
                                                   NSForegroundColorAttributeName: [UIColor whiteColor]
                                                   };
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:barButtonItemTitleAttribute
                                                                                            forState:UIControlStateNormal];
    // Setup window
    self.window.tintColor = [UIColor whiteColor];
    
    // Setup model
    [[THCoreDataStack defaultStack] ensureInitialLoad];
    
    // Set up view controllers
    NSMutableArray * viewControllers = [NSMutableArray array];
    
    // Setup Menu controller
    THMenuViewController * menuViewController = [[THMenuViewController alloc] init];
    
    MenuViewModel * menuModel =[[MenuViewModel alloc] initWithModel:[THCoreDataStack defaultStack].managedObjectContext];
    menuViewController.viewModel = menuModel;
    
    THOrdersViewController * ordersViewController = [[THOrdersViewController alloc] init];
    ordersViewController.viewModel = (OrdersViewModel *)[menuModel viewModelForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    THNavigationController * navControlloer = [[THNavigationController alloc] initWithRootViewController:ordersViewController];
    
    // Seup app root
    _sidePanelController = [[JASidePanelController alloc] init];
    
    _sidePanelController.leftPanel = menuViewController;
    _sidePanelController.centerPanel = navControlloer;
    _sidePanelController.rightPanel = nil;

    [viewControllers addObject:_sidePanelController];
    
    if (![THAuthorizer sharedAuthorizer].isLoggedIn)
    {
        THSignInViewController *signInViewController = [[THSignInViewController alloc] init];
        
        [viewControllers addObject:signInViewController];
    }

    THNavigationController * rootNavController = [[THNavigationController alloc] init];
    rootNavController.navigationBarHidden = YES;
    [rootNavController setViewControllers:viewControllers];
    
    self.window.rootViewController = rootNavController;
    
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
    
    // Saves changes in the application's managed object context before the application terminates.
    [[THCoreDataStack defaultStack] saveContext];
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

+ (void)logout
{
    [[THAuthorizer sharedAuthorizer] logout];
    
    THSignInViewController *signInViewController = [[THSignInViewController alloc] init];
    
    [[AppDelegate rootNavigationController] pushViewController:signInViewController animated:YES];
}

@end
