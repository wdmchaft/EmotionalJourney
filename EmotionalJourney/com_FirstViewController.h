//
//  com_FirstViewController.h
//  EmotionalJourney
//
//  Created by Administrator on 21/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeScroller.h"

@interface com_FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, TimeScrollerDelegate> {
    
    UITableView *table;
    UIButton *buttonEmotionHappy;
    UIButton *buttonEmotionLaugh;
    UIButton *buttonEmotionWink;
    UIButton *buttonEmotionLove;
    UIButton *buttonEmotionSad;
    UIButton *buttonEmotionCry;
    UIButton *buttonPenThis;
    UITextField *textFieldUserInput;
    NSMutableArray *arrayInput;
    NSMutableDictionary *dictionary;
    //UIScrollView *scrollView;
    TimeScroller * _timeScroller;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionHappy;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionLaugh;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionWink;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionLove;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionSad;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionCry;
@property (nonatomic, retain) IBOutlet UIButton *buttonPenThis;
@property (nonatomic, retain) IBOutlet UITextField *textFieldUserInput;
@property (nonatomic, retain) IBOutlet NSArray *arrayInput;
@property (nonatomic, retain) IBOutlet NSMutableDictionary *dictionary;
@property (nonatomic, retain) TimeScroller * _timeScroller;
//@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

-(IBAction)buttonPressed:(id)sender;
-(IBAction)emotionExpressed:(id)sender;
-(IBAction)textFieldEditingDone:(id)sender;
-(IBAction)backgroundTapped:(id)sender;
-(void) addToInputArray: (NSString *)userInput;
-(void) actOnUserInput;
-(void) loadEarlierConversation;
-(void) scheduleLocalNotification;

@end
