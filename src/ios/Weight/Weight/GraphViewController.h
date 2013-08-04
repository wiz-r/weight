//
//  ViewController.h
//  PlotSample
//
//  Created by takuya on 2012/11/04.
//  Copyright (c) 2012年 takuya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface GraphViewController : UIViewController <CPTPlotDataSource>
@property (assign, nonatomic) IBOutlet UIButton* tweetButton;
@property (retain, nonatomic) NSArray* data;
@property (assign, nonatomic) float xDays;
-(void)drawGraph;
-(IBAction)tweetButtonTapped:(id)sender;
@end
