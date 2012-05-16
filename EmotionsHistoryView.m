//
//  EmotionsHistoryView.m
//  EmotionalJourney
//
//  Created by Administrator on 04/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EmotionsHistoryView.h"
#import "Utility.h"

#define kEmotionJustOkay 0
#define kEmotionHappy 1
#define kEmotionOverjoyed 2
#define kEmotionRomantic 3
#define kEmotionSad 4
#define kEmotionDepressed 5
#define kEmotionAngry 6

#define EMOTION_OK          @"Okay"
#define EMOTION_HAPPY       @"Happy"
#define EMOTION_OVERJOYED   @"Overjoyous Moments"
#define EMOTION_ROMANTIC    @"Romantic"
#define EMOTION_SAD         @"Sorrow"
#define EMOTION_DEPRESSED   @"Depressed"
#define EMOTION_ANGRY       @"Angry"


@implementation EmotionsHistoryView

@synthesize graph;

NSArray *moodHistoryData;
int moodTotal = 0;



-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    NSLog(@"EmotionsHistoryView: numberOfRecordsForPlot: MoodHistory count: %d", (int)[moodHistoryData count]);
    return [moodHistoryData count];
}


-(NSNumber *) numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {   
    NSLog(@"EmotionsHistoryView: numberForPlot");
    return [moodHistoryData objectAtIndex:index];
}


-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
   
    NSLog(@"EmotionsHistoryView: dataLabelForPlot");
    static CPTMutableTextStyle *textStyle = nil;
    NSString *currentlabel;
    NSString *moodRatio;
    int indexInt = (int)index;
    
    NSLog(@"dataLabelForPlot for mood type %d", indexInt);
    
    switch (index) {
        case kEmotionJustOkay: {
            moodRatio = [self getMoodRatioForMood:indexInt];
            NSArray *stringArray = [[NSArray alloc] initWithObjects:EMOTION_OK, moodRatio, @"%", nil];
            currentlabel = [Utility concatenateStringsInArray:stringArray];
            break;
        }
        case kEmotionHappy: {
            moodRatio = [self getMoodRatioForMood:indexInt];
            NSArray *stringArray = [[NSArray alloc] initWithObjects:EMOTION_HAPPY, moodRatio, @"%", nil];
            currentlabel = [Utility concatenateStringsInArray:stringArray];
            break;
        }
        case kEmotionOverjoyed: {
            moodRatio = [self getMoodRatioForMood:indexInt];
            NSArray *stringArray = [[NSArray alloc] initWithObjects:EMOTION_OVERJOYED, moodRatio, @"%", nil];
            currentlabel = [Utility concatenateStringsInArray:stringArray];
            break;
        }
        case kEmotionRomantic: {
            moodRatio = [self getMoodRatioForMood:indexInt];
            NSArray *stringArray = [[NSArray alloc] initWithObjects:EMOTION_ROMANTIC, moodRatio, @"%", nil];
            currentlabel = [Utility concatenateStringsInArray:stringArray];
            break;
        }
        case kEmotionSad: {
            moodRatio = [self getMoodRatioForMood:indexInt];
            NSArray *stringArray = [[NSArray alloc] initWithObjects:EMOTION_SAD, moodRatio, @"%", nil];
            currentlabel = [Utility concatenateStringsInArray:stringArray];
            break;
        }
        case kEmotionDepressed: {
            moodRatio = [self getMoodRatioForMood:indexInt];
            NSArray *stringArray = [[NSArray alloc] initWithObjects:EMOTION_DEPRESSED, moodRatio, @"%", nil];
            currentlabel = [Utility concatenateStringsInArray:stringArray];
            break;
        }
        case kEmotionAngry: {
            moodRatio = [self getMoodRatioForMood:indexInt];
            NSArray *stringArray = [[NSArray alloc] initWithObjects:EMOTION_ANGRY, moodRatio, @"%", nil];
            currentlabel = [Utility concatenateStringsInArray:stringArray];
            break;
        }
        default: {
            currentlabel = @"";
        }
    }
    
    NSLog(@"Mood ratio for mood type %d is %@", indexInt, currentlabel);
    
    
    /*if (indexInt == 6) {
        UIImage *pie = pieChart.imageOfLayer;
        // For pdf -> NSData *pdfRepresentation = pieChart.dataForPDFRepresentationOfLayer;
        NSData *newPNG=UIImagePNGRepresentation(pie);
        NSString *filePath=[NSString stringWithFormat:@"%@/graph.png", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
        if([newPNG writeToFile:filePath atomically:YES]) {
            NSLog(@"Created new file successfully");
        }
    }
    */
    
    if(!textStyle) {
        textStyle = [[CPTMutableTextStyle alloc] init];
        textStyle.color = [CPTColor whiteColor]; //colorWithComponentRed:70 green:130 blue:180 alpha:0];
    }
    CPTLayer *layer = [[CPTLayer alloc] initWithFrame:CGRectMake(50, 50, 70, 15)];
    CPTTextLayer *newLayer = nil;
    newLayer = [[CPTTextLayer alloc] initWithText:currentlabel style:textStyle];
    [layer addSublayer:newLayer];
    return layer;
}



-(CPTFill *) sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    NSLog(@"EmotionsHistoryView: sliceFillForPieChart");
    CPTGradient *gradientFill = [CPTGradient gradientWithBeginningColor:[CPTColor grayColor] 
                                                            endingColor:[CPTColor blueColor]];
                                                                         //colorWithComponentRed:70 green:130 blue:180 
                                                                         //alpha:1]];
    gradientFill.gradientType = CPTGradientTypeAxial;
    gradientFill.angle = 90;
    CPTFill *fill = [[CPTFill alloc] initWithGradient:gradientFill];
    return fill;
}



/**
 * Initialize the graph for display
 * @created 4th May 2012
 */
-(void) initializeGraph {
    
    NSLog(@"EmotionsHistoryView: initializeGraph");
    
    graph = [[CPTXYGraph alloc] init];
    
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:theme];

    CPTGraphHostingView *hostingView = (CPTGraphHostingView *) self;
    hostingView.hostedGraph = graph;  
    //hostingView.bounds = CGRectMake(5, 5, 70, 70);
    [self initializePieChart];
    
    

    /*
    // A Core Plot graph can have many Plot Spaces.
    // Here, we are using just one plot space
    // We are setting the 'x' and 'y' range of the plot space
    // The range is set in terms of the position & length,not on the min,max values
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)
                                                    length:CPTDecimalFromFloat(12)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)
                                                    length:CPTDecimalFromFloat(12)];
    
    
    CPTLineStyle *lineStyle = [CPTLineStyle lineStyle];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet;
    
    //axisSet.xAxis.majorIntervalLength = [NSDecimal
    axisSet.xAxis.minorTicksPerInterval = 4;
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.minorTickLength = 5.0f;
    axisSet.xAxis.majorTickLength = 7.0f;
    axisSet.xAxis.labelOffset = 3.0f;
    
    //axisSet.yAxis.majorIntervalLength = [NSDecimal decimalNumberWithString:@"5"];
    axisSet.yAxis.minorTicksPerInterval = 4;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.minorTickLength = 5.0f;
    axisSet.yAxis.majorTickLength = 7.0f;
    axisSet.yAxis.labelOffset = 3.0f;
    
    
    
    CPTScatterPlot *xSquaredPlot = [[CPTScatterPlot alloc] 
                                    initWithFrame:graph.plotAreaFrame.bounds];
    xSquaredPlot.dataSource = self;
    [graph addPlot:xSquaredPlot];
    
    xSquaredPlot.identifier = @"X Squared Plot";
    xSquaredPlot.dataSource = self;
    [graph addPlot:xSquaredPlot];
    
    CPTPlotSymbol *greenCirclePlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    greenCirclePlotSymbol.fill = [CPTFill fillWithColor:[CPTColor greenColor]];
    greenCirclePlotSymbol.size = CGSizeMake(2.0, 2.0);
    xSquaredPlot.plotSymbol = greenCirclePlotSymbol;
    
    CPTScatterPlot *xInversePlot = [[CPTScatterPlot alloc] 
                                    initWithFrame:graph.plotAreaFrame.bounds];
    xInversePlot.identifier = @"X Inverse Plot";
    xInversePlot.dataSource = self;
    [graph addPlot:xInversePlot];
     */
}



/** 
 * Initialize the pie chart for display
 * @created 5th May 2012
 */
-(void) initializePieChart {
    
    NSLog(@"EmotionsHistoryView: initializePieChart");
    pieChart = [[CPTPieChart alloc] init];
    pieChart.dataSource = self;
    pieChart.pieRadius = 100.0;
    pieChart.opaque = FALSE;
    //pieChart.pieRadius = 60;
    pieChart.shadowOffset = CGSizeMake(-1, 1);
    pieChart.identifier = @"PieChart";
    pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPTPieDirectionCounterClockwise;
    pieChart.labelOffset = -0.6;
    [graph addPlot:pieChart];
    
    // Adding a legend
    // See CorePlot_0.4/Source/examples/CorePlotGallery/src/plots/SimpleScatterPlot.m
    /*
     _graph.legend = [CPTLegend legendWithGraph:_graph];
    _graph.legend.textStyle = x.titleTextStyle;
    _graph.legend.fill = [CPTFill fillWithColor:[CPTColor darkGrayColor]];
    _graph.legend.borderLineStyle = x.axisLineStyle;
    _graph.legend.cornerRadius = 5.0;
    _graph.legend.swatchSize = CGSizeMake(25.0, 25.0);
    _graph.legendAnchor = CPTRectAnchorBottom;
    _graph.legendDisplacement = CGPointMake(0.0, 12.0);
    */
    
    NSLog(@"added pie chart to the graph view");
}



/**
 * Sets the mood history data (i.e. the count of the various mood types)
 * so that they can be used to chart it.
 * @created 5th May 2012
 */
-(void) setMoodHistoryData:(NSArray *)moodHistory {
    NSLog(@"EmotionsHistoryView: setMoodHistoryData");
    moodHistoryData = moodHistory;
}



-(NSString *) getMoodRatioForMood: (int)moodType {
    
    NSUInteger index;
    NSNumber *currentMoodCount;
    int moodOfInterest;
    NSLog(@"Calculating the total mood count");
    bool calcCount = false;
    
    // Is the total being calculated for the first time? If yes, set 'calcCount' to true
    if (moodTotal == 0) {
        calcCount = true;
    }

    for (index=0; index < [moodHistoryData count]; index++) {
            currentMoodCount = [moodHistoryData objectAtIndex:index];
            if (calcCount) {
                moodTotal = moodTotal + [currentMoodCount intValue];
                NSLog(@"Adding %@ to the total moodcount", currentMoodCount);
            }
            // Check if this' the mood type for which the ratio needs to be calculated
            if (index == moodType) {
                moodOfInterest = [currentMoodCount intValue];
            }
    }
    NSLog(@"Total Mood Count: %d, MoodOfInterest:%d", moodTotal, moodOfInterest);
    float moodRatio = (float)moodOfInterest / (float)moodTotal * 100.0;
    NSLog(@"Mood Ratio for mood %d : %f", moodOfInterest, moodRatio);
    //currentMoodCount = [NSNumber numberWithFloat:moodRatio];
    NSString *moodRatioStr = [NSString stringWithFormat:@"%.02f",moodRatio];
    return moodRatioStr;
}

/*
-(id) init {
    self = [super init];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/


#pragma mark - View lifecycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

