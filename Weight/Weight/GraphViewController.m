//
//  ViewController.m
//  PlotSample
//
//  Created by takuya on 2012/11/04.
//  Copyright (c) 2012年 takuya. All rights reserved.
//

#import "GraphViewController.h"
#import "WeightData.h"

@interface GraphViewController ()
@property (retain, nonatomic) CPTXYGraph* graph;
@property (retain, nonatomic) NSDate* refDate;
@end

@implementation GraphViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Graph", @"Graph");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // data
    NSTimeInterval oneDay = 24.0f * 60.0f * 60.0f;
    
    float minWeight = 0.0f;
    float maxWeight = 0.0f;
    for (int i = 0; i < self.data.count; i++) {
        WeightData* data = [self.data objectAtIndex:i];
        if (i == 0) {
            minWeight = maxWeight = data.weight;
        } else {
            minWeight = MIN(data.weight, minWeight);
            maxWeight = MAX(data.weight, maxWeight);
        }
    }
    float minY = minWeight - 0.2f;
    float maxY = maxWeight + 0.2f;
	
    // Theme
    self.graph = [[CPTXYGraph alloc] initWithFrame: CGRectZero];
    CPTTheme* theme = [CPTTheme themeNamed:kCPTStocksTheme];
    [self.graph applyTheme:theme];
    
    // padding
    self.graph.paddingTop = 10.0;
    self.graph.paddingBottom = 10.0;
    self.graph.paddingLeft = 10.0;
    self.graph.paddingRight = 10.0;
    
    // plotArea
    self.graph.plotAreaFrame.borderLineStyle = nil;
    self.graph.plotAreaFrame.paddingTop = 25.0;
    self.graph.plotAreaFrame.paddingBottom = 35.0;
    self.graph.plotAreaFrame.paddingLeft = 35.0;
    self.graph.plotAreaFrame.paddingRight = 20.0;
    
    // X/Y Axis
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    
	// X Axis
    self.refDate = [NSDate dateWithTimeIntervalSinceNow:-(self.xDays-1.0f) * oneDay];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(oneDay * 0.0f) length:CPTDecimalFromFloat(oneDay*self.xDays)];
    
    CPTXYAxis *xAxis = axisSet.xAxis;
    xAxis.majorIntervalLength = CPTDecimalFromFloat(self.xDays/7.0 * oneDay);
    xAxis.minorTicksPerInterval = 0;
    CPTMutableTextStyle* xLabelTextStyle = [CPTTextStyle textStyle];
    xLabelTextStyle.fontSize = 14.0f;
    xLabelTextStyle.fontName = @"Helvetica";
    xLabelTextStyle.color = [CPTColor whiteColor];
    xAxis.labelTextStyle = xLabelTextStyle;
    xAxis.labelRotation = 0.5f;
    xAxis.orthogonalCoordinateDecimal = CPTDecimalFromFloat(minY);
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd"];
    CPTTimeFormatter* timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
    timeFormatter.referenceDate = self.refDate;
    xAxis.labelFormatter = timeFormatter;
    
    // Y Axis
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(minY) length:CPTDecimalFromFloat(maxY - minY)];
    
    CPTXYAxis *yAxis = axisSet.yAxis;
    yAxis.majorIntervalLength = CPTDecimalFromFloat(0.2f);
    yAxis.minorTicksPerInterval = 3.0f;
    
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
    CPTGraphHostingView* hostingView = (CPTGraphHostingView*)self.view;
    hostingView.collapsesLayers = NO;
    hostingView.hostedGraph = self.graph;
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

@end
