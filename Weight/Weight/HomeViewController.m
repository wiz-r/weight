//
//  FirstViewController.m
//  Weight
//
//  Created by takuya on 2012/11/11.
//  Copyright (c) 2012年 takuya. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"
#import "InputViewController.h"

#import "Flurry.h"

@interface HomeViewController ()
@property (strong, nonatomic) IBOutlet UIView *view;

- (IBAction)inputButtonPushed:(id)sender;
- (IBAction)boardButtonPushed:(id)sender;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Home", @"Home");
        self.tabBarItem.image = [UIImage imageNamed:@"home"];
        UIImage *backgroundImage = [UIImage imageNamed:@"cream.jpg"];
        self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    }
    
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView_.adUnitID = @"a150912ee3eb5b0";
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    [bannerView_ loadRequest:[GADRequest request]];
    
    [Flurry logEvent:@"Home_View"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)inputButtonPushed:(id)sender {
    UIViewController *inputViewController = [[InputViewController alloc] initWithNibName:@"InputViewController" bundle:nil];
    [self presentViewController:inputViewController animated:YES completion:^{
        ;
    }];
}

- (IBAction)boardButtonPushed:(id)sender {
    [self showBord];
}

-(IBAction)showBord
{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != nil) {
        leaderboardController.leaderboardDelegate = self;
        [self presentViewController: leaderboardController animated:YES completion:nil];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [[self presentedViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
