//
//  AppDelegate.m
//  Weight
//
//  Created by takuya on 2012/11/11.
//  Copyright (c) 2012年 takuya. All rights reserved.
//

#import "AppDelegate.h"

#import <GameKit/GameKit.h>

#import "HomeViewController.h"
#import "GraphViewController.h"
#import "WeightCollection.h"
#import "SettingViewController.h"
#import "InputViewController.h"
#import "Setting.h"

#import "Chartboost.h"
#import "Flurry.h"
#import "TapjoyConnect.h"

NSString *const FBSessionStateChangedNotification = @"com.wiz-r.Weight:FBSessionStateChangedNotification";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Flurry startSession:@"D5S79JRK4DNKT3MHVQXS"];
    
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
    
    UILocalNotification *notify = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notify) {
        [Flurry logEvent:@"Launch_With_Notify"];
        NSLog(@"launch with nofitication");
    }
    
    // Gamecenter
    NSString *reqSysVer = @"6.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
    {
        // Gamekit login for ios 6
        [[GKLocalPlayer localPlayer] setAuthenticateHandler:(^(UIViewController* viewcontroller, NSError *error) {
            if (viewcontroller != nil) {
                [self.window.rootViewController presentViewController:viewcontroller animated:YES completion:nil];
            } else if ([GKLocalPlayer localPlayer].authenticated) {
                ;;
            }
        })];
    } else {
        // Gamekit login for ios 5
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error){}];
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    }
    
    // Tapjoy
    [TapjoyConnect requestTapjoyConnect:@"54488a08-b30c-47a6-955b-1c2a1c6950a8" secretKey:@"TZgK749ZhdV3rIxKCN8U"];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(inputViewClosedEventReceived:) name:INPUT_CLOSE_NOTIFICATION_NAME object:nil];
    
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
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self initializeChartboost];
    Setting* setting = [[Setting alloc] init];
    [setting setAlarmNotification];
    
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
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
    cb.appId = @"50c4498217ba47de0e000001";
    cb.appSignature = @"e00046ca8f407cffd953be0a29932b3564bded93";
    [cb startSession];
    [cb showInterstitial];
}

-(void)inputViewClosedEventReceived:(NSNotification*)center{
    NSArray* data = [[[WeightCollection alloc] init] array];
    self.graphViewController.data = data;
    [self.graphViewController drawGraph];
    
    if ([self.tabBarController.selectedViewController isKindOfClass:[HomeViewController class]]) {
        self.tabBarController.selectedViewController = self.graphViewController;
    }
}

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                NSLog(@"User session found");
                [Flurry logEvent:@"FB_Login"];
            }
            break;
        case FBSessionStateClosed:
            NSLog(@"User session closed");
            [Flurry logEvent:@"FB_Logout"];
            break;
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            @"user_likes",
                            //@"publish_actions",
                            nil];
    return [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:allowLoginUI completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
            [self sessionStateChanged:session state:state error:error];
    }];
}

- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}
@end
