//
//  AppDelegate.m
//  Weight
//
//  Created by takuya on 2012/11/11.
//  Copyright (c) 2012年 takuya. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"
#import "GraphViewController.h"
#import "WeightCollection.h"
#import "SettingViewController.h"
#import "Chartboost.h"
#import "Setting.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController_iPhone" bundle:nil];
    self.graphViewController = [[GraphViewController alloc] initWithNibName:@"GraphViewController_iPhone" bundle:nil];
    self.settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    
    // Initial data
    NSArray* data = [[[WeightCollection alloc] init] array];
    self.graphViewController.data = data;
    self.graphViewController.xDays = 7.0f;
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = @[self.homeViewController, self.graphViewController, self.settingViewController];
    self.window.rootViewController = self.tabBarController;
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
    [self initializeChartboost];
    Setting* setting = [[Setting alloc] init];
    [setting setAlarmNotification];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[GraphViewController class]]) {
        NSArray* data = [[[WeightCollection alloc] init] array];
        self.graphViewController.data = data;
        [self.graphViewController drawGraph];
    }
}

- (void)initializeChartboost
{
    Chartboost *cb = [Chartboost sharedChartboost];
    cb.appId = @"50c2c2da17ba47c54f000002";
    cb.appSignature = @"95a65217245e29793b2b9f7ed5d3a310e9bcf246";
    [cb startSession];
    [cb showInterstitial];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
