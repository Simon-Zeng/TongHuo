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
#import "THConfigration.h"

// View Controllers
#import "THMenuViewController.h"
#import "THSignInViewController.h"
#import "THProductsViewController.h"

// View Models
#import "MenuViewModel.h"
#import "SignInViewModel.h"
#import "ProductsViewModel.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

#import "Product.h"
#import "Product+Access.h"
#import "Orders.h"
#import "Orders+Access.h"

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
    
    UIColor * cursorColor = [[UIColor colorWithRed:242.0/255
                                            green:39.0/255
                                             blue:131.0/255
                                            alpha:1.0] colorWithAlphaComponent:0.3];
    
    [[UITextField appearance] setTintColor:cursorColor];
    [[UITextView appearance] setTintColor:cursorColor];
    
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
    
    THProductsViewController * ordersViewController = [[THProductsViewController alloc] init];
    ordersViewController.viewModel = (ProductsViewModel *)[menuModel viewModelForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    THNavigationController * navControlloer = [[THNavigationController alloc] initWithRootViewController:ordersViewController];
    
    // Seup app root
    _sidePanelController = [[JASidePanelController alloc] init];
    
    _sidePanelController.leftPanel = menuViewController;
    _sidePanelController.centerPanel = navControlloer;
    _sidePanelController.rightPanel = nil;

    [viewControllers addObject:_sidePanelController];
    
    THAuthorizer * authorizer = [THAuthorizer sharedAuthorizer];
    if (!authorizer.isLoggedIn)
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
    
    // Schedule sync
    @weakify(self);
    [authorizer.updateSignal subscribeNext:^(id x) {
        @strongify(self);
        
        if (x) {
            [self scheduleOrdersUpdate];
        }
    }];
    
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

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[self refreshSignal] subscribeNext:^(id x) {
        NSLog(@"--- Scheduled synchronization succeed!");
    } error:^(NSError *error) {
        NSLog(@"--- Scheduled synchronization error: %@", error);
    }];
}

- (RACSignal *)refreshSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        THAPI * apiCenter = [THAPI apiCenter];
        
        return [RACObserve(apiCenter, accountUserIdentifier) subscribeNext:^(id x) {
            if (x)
            {
                RACSignal * request = [[THAPI apiCenter] postAndGetOrders:[NSArray array]];
                
                [request subscribeNext:^(id x) {
                    NSDictionary * response = x;
                    
                    if (response && [response isKindOfClass:[NSDictionary class]])
                    {
                        NSArray * ordersInfo = [response objectForKey:@"fh"];
                        NSArray * productsInfo = [response objectForKey:@"pro"];
                        
                        for (NSDictionary * aDict1 in ordersInfo)
                        {
                            [Orders objectFromDictionary:aDict1];
                        }
                        
                        for (NSDictionary * aDict2 in productsInfo)
                        {
                            [Product objectFromDictionary:aDict2];
                        }
                    }
                    
                    [[THCoreDataStack defaultStack] saveContext];
                    
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                } error:^(NSError *error) {
                    [subscriber sendError:error];
                } completed:^{
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
            }
        }];
    }];
}

+ (void)logout
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [[THAuthorizer sharedAuthorizer] logout];
    [Product removeAllProducts];
    
    THConfigration * configration = [THConfigration sharedConfigration];
    configration.hasOrdersToSync = YES;
    configration.hasProductsToSync = YES;

    
    THSignInViewController *signInViewController = [[THSignInViewController alloc] init];
    
    [[AppDelegate rootNavigationController] pushViewController:signInViewController animated:YES];
}

- (void)scheduleOrdersUpdate
{
    NSArray * scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    if (scheduledNotifications.count == 0)
    {
        [self scheduleNotificationAt:13*3600 withMessage:@"亲，您该同步您的59订单了哦."];
        [self scheduleNotificationAt:23*3600 withMessage:@"亲，您该同步您的59订单了哦."];
    }
}

- (void)scheduleNotificationAt:(NSUInteger)tOffDay withMessage:(NSString *)message
{
    NSInteger alarmHour = (int)(floor(tOffDay)/3600);
    NSInteger alarmMinute = (int)((int)floorf(tOffDay)%3600/60);
    NSInteger alarmSecond = (int)((int)floorf(tOffDay)%60);
    
    NSDate * nowDate = [NSDate date];
    
    NSCalendarUnit flag = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *componentsOfToday = [[NSCalendar currentCalendar] components:flag fromDate:nowDate];
    
    NSInteger dayOffset = 0;
    //按日重复
    if (tOffDay > (componentsOfToday.hour * 3600 + componentsOfToday.minute * 60 + componentsOfToday.second))
    {
        //在今天允许响
        dayOffset = 0;
    }
    else
    {
        //明天及以后允许
        dayOffset = 1;
    }
    
    NSDateComponents * components = [[NSCalendar currentCalendar] components:flag fromDate:[nowDate dateByAddingTimeInterval:3600 * 24 * dayOffset]];
    components.hour = alarmHour;
    components.minute = alarmMinute;
    components.second = alarmSecond;
    
    NSDate * alarmDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    
    UILocalNotification * syncNotification = [[UILocalNotification alloc] init];
    syncNotification.repeatCalendar = [NSCalendar currentCalendar];
    syncNotification.repeatInterval = NSDayCalendarUnit;
    syncNotification.hasAction = YES;
    syncNotification.soundName = UILocalNotificationDefaultSoundName;
    syncNotification.fireDate = alarmDate;
    syncNotification.userInfo = @{@"alarmName":@"reminder", @"alarmTime":[NSNumber numberWithDouble:tOffDay]};
    syncNotification.alertBody = message;
    syncNotification.alertLaunchImage = nil;
    syncNotification.alertAction = @"知道了";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:syncNotification];

}

@end
