//
//  EmotionsHistoryView.h
//  EmotionalJourney
//
//  Created by Administrator on 04/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface EmotionsHistoryView : CPTGraphHostingView <CPTPlotDataSource> {
    CPTXYGraph *graph;
    CPTPieChart *pieChart;
}

@property (nonatomic, retain) CPTXYGraph *graph;

-(void) initializeGraph;
-(void) initializePieChart;
-(void) setMoodHistoryData:(NSArray *)moodHistory;
-(NSString *) getMoodRatioForMood: (int)moodType;

@end
