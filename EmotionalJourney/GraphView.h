//
//  GraphView.h
//  EmotionalJourney
//
//  Created by Administrator on 10/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmotionsHistoryView.h"

@interface GraphView : UIViewController {
    //subviewtest *sub;
}

    @property (strong, nonatomic) IBOutlet EmotionsHistoryView *emotionsHistoryView;
    //@property (strong, nonatomic) IBOutlet UIView *gView;
    @property (strong, nonatomic) IBOutlet UIButton *buttonBack;


    -(void) setMoodHistoryData:(NSArray *)moodHistory;
    -(void) showGraph;

@end

