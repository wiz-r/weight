//
//  FirstViewController.m
//  Weight
//
//  Created by takuya on 2012/11/11.
//  Copyright (c) 2012年 takuya. All rights reserved.
//

#import "HomeViewController.h"
#import "InputViewController.h"

@interface HomeViewController ()
@property (strong, nonatomic) IBOutlet UIView *view;

- (IBAction)inputButtonPushed:(id)sender;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Home", @"Home");
        self.tabBarItem.image = [UIImage imageNamed:@"home"];
    }
    
    UIImage *backgroundImage = [UIImage imageNamed:@"cream.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = @"a150912ee3eb5b0";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)inputButtonPushed:(id)sender {
    UIViewController *inputViewController = [[InputViewController alloc] initWithNibName:@"InputViewController" bundle:nil];
    [self presentViewController:inputViewController animated:YES completion:^{
        ;
    }];
}

@end
