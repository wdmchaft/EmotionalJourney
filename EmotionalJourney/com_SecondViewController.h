//
//  com_SecondViewController.h
//  EmotionalJourney
//
//  Created by Administrator on 21/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmotionsHistoryView.h"

@interface com_SecondViewController : UIViewController {
    UILabel *labelInputPrompt;
    UILabel *labelFromDate;
    UILabel *labelToDate;
    UIButton *buttonDateChosen;
    UIDatePicker *datePicker;
}

@property (nonatomic, retain) IBOutlet UILabel *labelInputPrompt;
@property (nonatomic, retain) IBOutlet UILabel *labelFromDate;
@property (nonatomic, retain) IBOutlet UILabel *labelToDate;
@property (nonatomic, retain) IBOutlet UIButton *buttonDateChosen;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) NSDate *historyFromDate;
@property (nonatomic, retain) NSDate *historyToDate;
// TODO : Probably change this to a number? String might be an overdo.
@property (nonatomic, retain) NSString *whichView;
@property (strong, nonatomic) NSArray *controllers;

-(IBAction) fromDateChosen: (id)sender;
-(IBAction) toDateChosen: (id)sender;
-(IBAction) dateBeingChosen:(id)sender;
-(NSArray *) fetchTheMoodHistoryWithFromDate:(NSDate *)fromDate
                                withToDate:(NSDate *)toDate;

@end
