//
//  ViewController.m
//  PlotSample
//
//  Created by takuya on 2012/11/04.
//  Copyright (c) 2012年 takuya. All rights reserved.
//

#import "GraphViewController.h"
#import "WeightData.h"
#import "InputViewController.h"
#import "WeightCollection.h"
#import <Twitter/Twitter.h>

#import "Flurry.h"

@interface GraphViewController ()
@property (retain, nonatomic) CPTXYGraph* graph;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *graphView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scaleBar;
@property (retain, nonatomic) NSDate* refDate;
- (IBAction)inputButtonPushed:(id)sender;
- (IBAction)scaleButtonChanged:(id)sender;
@end

@implementation GraphViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Graph", @"Graph");
        self.tabBarItem.image = [UIImage imageNamed:@"graph"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self drawGraph];
    [Flurry logEvent:@"Graph_View"];
    self.tweetButton.hidden = NSClassFromString(@"TWTweetComposeViewController") == nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Plot Data Source Methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
	return self.data.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot
					 field:(NSUInteger)fieldEnum
			   recordIndex:(NSUInteger)index
{
    WeightData* data = [self.data objectAtIndex:index];
	if(fieldEnum == CPTScatterPlotFieldX)
	{
        float diffWithRefDate = [data.date timeIntervalSinceDate:self.refDate];
        return [NSNumber numberWithFloat:diffWithRefDate];
    }
	else
	{
        return [NSNumber numberWithFloat:data.weight];
	}
}

-(void)drawGraph
{
    // background color
    self.menuView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    self.view.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    
    // data
    NSTimeInterval oneDay = 24.0f * 60.0f * 60.0f;
    
    float minWeight = [[[WeightCollection alloc] init] minWeightWithPeriod:self.xDays];
    float maxWeight = [[[WeightCollection alloc] init] maxWeightWithPeriod:self.xDays];
    float minY = minWeight - 0.2f;
    float maxY = maxWeight + 0.2f;
	
    // Theme
    self.graph = [[CPTXYGraph alloc] initWithFrame: CGRectZero];
    CPTTheme* theme = [CPTTheme themeNamed:kCPTStocksTheme];
    [self.graph applyTheme:theme];
    
    // padding
    self.graph.paddingTop = 0.0f;
    self.graph.paddingBottom = 10.0f;
    self.graph.paddingLeft = 10.0f;
    self.graph.paddingRight = 10.0f;
    
    // Plot Area
    self.graph.plotAreaFrame.borderLineStyle = nil;
    self.graph.plotAreaFrame.paddingTop = 10.0f;
    self.graph.plotAreaFrame.paddingBottom = 10.0f;
    self.graph.plotAreaFrame.paddingLeft = 10.0f;
    self.graph.plotAreaFrame.paddingRight = 10.0f;
    
    // Plot Space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    CPTXYAxis *xAxis = axisSet.xAxis;
    CPTXYAxis *yAxis = axisSet.yAxis;
    xAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:30.0];
    yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:30.0];
    
	// X Axis
    NSDateFormatter* refDateFormattter = [[NSDateFormatter alloc] init];
    [refDateFormattter setDateFormat:WEIGHT_DATE_FORMAT];
    NSDate* today = [refDateFormattter dateFromString:[refDateFormattter stringFromDate:[NSDate date]]];
    self.refDate = [NSDate dateWithTimeInterval:-(self.xDays-1.0f) * oneDay sinceDate:today];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(oneDay * 0.0f) length:CPTDecimalFromFloat(oneDay*self.xDays)];
    
    xAxis.majorIntervalLength = CPTDecimalFromFloat(self.xDays/7.0 * oneDay);
    xAxis.minorTicksPerInterval = 0;
    CPTMutableTextStyle* xLabelTextStyle = [CPTTextStyle textStyle];
    xLabelTextStyle.fontSize = 14.0f;
    xLabelTextStyle.fontName = @"Helvetica";
    xLabelTextStyle.color = [CPTColor whiteColor];
    xAxis.labelTextStyle = xLabelTextStyle;
    xAxis.labelRotation = 0.5f;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd"];
    CPTTimeFormatter* timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
    timeFormatter.referenceDate = self.refDate;
    xAxis.labelFormatter = timeFormatter;
    
    // Y Axis
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(minY) length:CPTDecimalFromFloat(maxY - minY)];
    float yRange = maxWeight - minWeight;
    if (yRange <= 2.0f) {
        yAxis.majorIntervalLength = CPTDecimalFromFloat(0.2f);
        yAxis.minorTicksPerInterval = 1.0f;
    } else if (yRange <= 4.0f) {
        yAxis.majorIntervalLength = CPTDecimalFromFloat(0.4f);
        yAxis.minorTicksPerInterval = 1.0f;
    } else if (yRange <= 10.0f){
        yAxis.majorIntervalLength = CPTDecimalFromFloat(0.5f);
        yAxis.minorTicksPerInterval = 1.0f;
    } else {
        yAxis.majorIntervalLength = CPTDecimalFromFloat(1.0f);
        yAxis.minorTicksPerInterval = 1.0f;
    }
    
    // Scatter Plot
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot.identifier = @"My Plot";
    dataSourceLinePlot.dataSource = self;
    
    // Line style
    CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];
    lineStyle.lineColor = [CPTColor colorWithComponentRed:51.0f/255.0f green:204.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    lineStyle.lineWidth = 1.5f;
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    // Plot style
    CPTPlotSymbol* plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:255.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
    CPTMutableLineStyle* plotLineStyle = [[CPTMutableLineStyle alloc] init];
    plotLineStyle.lineColor = [CPTColor colorWithComponentRed:255.0f/255.0f green:51.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    plotLineStyle.lineWidth = 2.0f;
    plotSymbol.lineStyle = plotLineStyle;
    plotSymbol.size = CGSizeMake(8.0, 8.0);
    dataSourceLinePlot.plotSymbol = plotSymbol;
    
    [self.graph addPlot:dataSourceLinePlot];
    
    // graph view
    CPTGraphHostingView* hostingView = (CPTGraphHostingView*)self.graphView;
    hostingView.collapsesLayers = NO;
    hostingView.hostedGraph = self.graph;
}

- (IBAction)inputButtonPushed:(id)sender {
    UIViewController *inputViewController = [[InputViewController alloc] initWithNibName:@"InputViewController" bundle:nil];
    [self presentViewController:inputViewController animated:YES completion:^{
        ;
    }];
}

- (IBAction)scaleButtonChanged:(id)sender {
    NSInteger index = self.scaleBar.selectedSegmentIndex;
    if (index == 0) {
        self.xDays = 7.0f;
    } else {
        self.xDays = 30.0f;
    }
    [self drawGraph];
}

- (IBAction)tweetButtonTapped:(id)sender {
    Class TWTweetComposeViewController = NSClassFromString(@"TWTweetComposeViewController");
    if (TWTweetComposeViewController) {
        float weight = ((WeightData*)[[self.data sortedArrayUsingComparator:^NSComparisonResult(WeightData* obj1, WeightData* obj2) {
          return [obj1.date compare:obj2.date];
        }] lastObject]).weight;
        id vc = [[TWTweetComposeViewController alloc] init];
        [vc setInitialText:[NSString stringWithFormat:@"My current weight is %.1fkg #weightlogger", weight]];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

@end
