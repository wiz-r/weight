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
@property (weak, nonatomic) IBOutlet UIButton *fbButton;

- (IBAction)inputButtonPushed:(id)sender;
- (IBAction)fbButtonPushed:(id)sender;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStateChanged:) name:FBSessionStateChangedNotification object:nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)inputButtonPushed:(id)sender {
    UIViewController *inputViewController = [[InputViewController alloc] initWithNibName:@"InputViewController" bundle:nil];
    [self presentViewController:inputViewController animated:YES completion:^{
        ;
    }];
}

- (IBAction)fbButtonPushed:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (FBSession.activeSession.isOpen) {
        NSLog(@"already logged in");
    } else {
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        self.fbButton.hidden = YES;
    } else {
        [self.fbButton setTitle:@"FB" forState:UIControlStateNormal];
    }
}

@end
