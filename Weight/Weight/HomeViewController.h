//
//  FirstViewController.h
//  Weight
//
//  Created by takuya on 2012/11/11.
//  Copyright (c) 2012年 takuya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "GADBannerView.h"

@interface HomeViewController : UIViewController<GKLeaderboardViewControllerDelegate> {
    GADBannerView *bannerView_;
}
@end
