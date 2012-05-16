//
//  com_SecondViewController.m
//  EmotionalJourney
//
//  Created by Administrator on 21/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "com_SecondViewController.h"
#import "DatabaseOperations.h"
#import "EmotionsHistoryView.h"
#import "EmotionsHistoryView.h"
#import "GraphView.h"

@implementation com_SecondViewController

@synthesize labelInputPrompt;
@synthesize labelFromDate;
@synthesize labelToDate;
@synthesize buttonDateChosen;
@synthesize datePicker;
@synthesize historyFromDate;
@synthesize historyToDate;
@synthesize whichView;
@synthesize controllers;

static CGFloat const FONTSIZE = 14.0;
DatabaseOperations *dbOps;
EmotionsHistoryView *historyView;
NSArray *moodHistory;
GraphView *graphView;


/**
 * This method gets automatically triggered when the 'From' date is chosen
 */
-(IBAction) fromDateChosen: (id)sender {
    
    NSString *buttonTitle = @"I've chosen the 'FROM' date";
    
    if ([[buttonDateChosen currentTitle] isEqualToString:buttonTitle]) { 
        
        NSLog(@"User has chosen the 'From' date");
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        
        // Get the chosen date value
        NSDate *fromDate = [datePicker date];
        NSString *dateOrig = [dateFormatter stringFromDate:fromDate];
        NSLog(@"date original: %@", dateOrig);
        historyFromDate = fromDate;
        
        //[self setDates:fromDate withType:0];
        
        // Set the 'to' date label to reflect the user's choice
        labelFromDate.text = [dateFormatter stringFromDate:historyFromDate];
        NSLog(@"'From' Date Chosen:%@", historyFromDate);
        //[dateFormatter stringFromDate:[datePicker date]]);
        
        // Change the label at the top to ask the user to choose the 'To' date
        [labelInputPrompt setText:@"Choose the 'To' Date now"];
        
    }
}



/**
 * This method gets automatically triggered when the 'To' date is chosen
 */
-(IBAction) toDateChosen:(id)sender {
    
    NSString *buttonTitle = @"I've chosen the 'FROM' date";
    
    if (![[buttonDateChosen currentTitle] isEqualToString:buttonTitle]) { 
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        //[dateFormatter stringFromDate:[datePicker date]]);
        
        // Get the chosen date value
        historyToDate = [datePicker date];
        NSLog(@"'From': %@, 'To': %@", historyFromDate, historyToDate); 
        
        // TODO : build on this
        whichView = @"2";
        
        NSArray *moodHistory = [self fetchTheMoodHistoryWithFromDate:historyFromDate withToDate:historyToDate];
        //[historyView setMoodHistoryData:moodHistory];
        [graphView setMoodHistoryData:moodHistory];
        [self presentModalViewController:graphView animated:YES];

        //[self.view addSubview:graphView];
        
        
        //        [UIView beginAnimations:nil context:nil];
        //        [UIView setAnimationDuration:1.5];
        //        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];    
        //        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        //        
        //        [self viewWillDisappear:YES];
        //        [historyView viewWillAppear:YES];
        //        self.view.hidden = YES;
        //        historyView.view.hidden = NO;
        //        [self viewDidDisappear:YES];
        //        [historyView viewDidAppear:YES];
        //        
        //        [UIView commitAnimations];
        
        //graphView.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        //graphView.modalPresentationStyle = UIModalPresentationFullScreen;
        
        // Curl up the view :)
        //UIView *container = self.view.window;
        //[historyView viewWillAppear:YES];
        //historyView.self.view.bounds = CGRectMake(0, 5, 200, 200);
        
        /*[UIView transitionWithView:container duration:1.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                [self.navigationController.view removeFromSuperview];
                [container addSubview: historyView.view];
            } 
            completion:^(BOOL finished) {
                [self presentModalViewController:historyView animated:NO];
            }];
         */
         
        //[self.navigationController popViewControllerAnimated:YES];

    }
    
    // Change the button's text
    [buttonDateChosen setTitle:@"Now show me my Mood History!"
                      forState:UIControlStateNormal];
    
    //alpha fading
    //    modalController.view.alpha = 0.0;
    //    [self.view.window.rootViewController presentModalViewController:modalController animated:NO];
    //    [UIView animateWithDuration:0.5
    //                     animations:^{modalController.view.alpha = 1.0;}];
}



/**
 * This method gets automatically triggered when the user is in the process of choosing the date
 */
-(IBAction) dateBeingChosen:(id)sender {
    
    NSString *buttonTitle = @"I've chosen the 'FROM' date";
    
    if ([[buttonDateChosen currentTitle] isEqualToString:buttonTitle]) { 
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        
        // Set the 'from' date label to reflect the user's choice
        labelFromDate.text = [dateFormatter stringFromDate:[datePicker date]];
        
    } else {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        
        // Set the 'to' date label to reflect the user's choice
        labelToDate.text = [dateFormatter stringFromDate:[datePicker date]];
        
    }
}



/**
 * Fetches the mood history between the given dates
 */
-(NSArray *) fetchTheMoodHistoryWithFromDate:(NSDate *)fromDate withToDate:(NSDate *)toDate {
    
    NSLog(@"fetchTheMoodHistory: begin");
    NSLog(@"Calling fetchTheMoodHistory for the period %@ to %@", historyFromDate, historyToDate);
    NSArray *history = [dbOps getDataBetweenDates:@"Emotionssys" 
                                        withStartDate:fromDate 
                                        withEndDate:toDate];
    NSLog(@"fetchTheMoodHistory: end");
    return history;
}



/**
 * calculate the height for the message
 */
-(CGFloat) labelHeight:(NSString *) text {
    CGSize maximumLabelSize = CGSizeMake((56 * 3) - 25,9999);
    CGSize expectedLabelSize = [text sizeWithFont:[UIFont systemFontOfSize: FONTSIZE] 
                                constrainedToSize:maximumLabelSize 
                                    lineBreakMode:UILineBreakModeWordWrap]; 
    return expectedLabelSize.height;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"My Mood history";

    graphView = [[GraphView alloc] init];
    
    dbOps = [DatabaseOperations dbOpsSingleton];

    [dbOps createTableNamed:@"Emotionssys"
                 withField1:@"time" 
                 withField2:@"emotion"
                 withField3:@"text"
                 withField4:@"picture"];
    
    //historyView = [[EmotionsHistoryView alloc] init];
    // historyView.view.self.bounds = self.view.bounds;
    //self.navigationItem.title = @"Just a title";
    //[self.navigationController pushViewController:historyView animated:YES];

    // Set the date-range that you can allow the user to select from
    // TODO : @production - change this min date value for date picker to something appropriate
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *minDate = [formatter dateFromString:@"2012-04-14 06:00"];
    [datePicker setMinimumDate:minDate];
    NSDate *maxDate = [[NSDate alloc] init];
    [datePicker setMaximumDate:maxDate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.controllers = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
