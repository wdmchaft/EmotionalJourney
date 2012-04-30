//
//  com_FirstViewController.m
//  EmotionalJourney
//
//  Created by Administrator on 21/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "com_FirstViewController.h"
#import "DatabaseOperations.h"
#import "Utility.h"
#import "TimeScroller.h"

@implementation com_FirstViewController

@synthesize table;
@synthesize buttonEmotionHappy;
@synthesize buttonEmotionLaugh;
@synthesize buttonEmotionWink;
@synthesize buttonEmotionLove;
@synthesize buttonEmotionSad;
@synthesize buttonEmotionCry;
@synthesize buttonPenThis;
@synthesize textFieldUserInput;
@synthesize arrayInput;
@synthesize dictionary;
//@synthesize scrollView;

int myEmotionNum;
int currentTime;
DatabaseOperations *dbOps;
UILocalNotification *notification;



/**
 * Called when the button's pressed
 * sender : the button which's pressed, consequently invoking this
 */
-(IBAction)buttonPressed:(id)sender {
        
    NSLog(@"Button Pressed");
  
    [textFieldUserInput resignFirstResponder];
    [self actOnUserInput];
}



-(IBAction)emotionExpressed:(id)sender {
    
    // Let the text field appear for the user to enter his/her emotion in words
    [UIView beginAnimations:nil context:NULL];
    self.textFieldUserInput.alpha = 1;
    [UIView commitAnimations];
    
    if (sender == buttonEmotionHappy) {
        
        NSLog(@"Am happy today!");
        //imageEmotion = [UIImage imageNamed:@"SmileyHappy.png"];
        myEmotionNum = 1;
        
    } else if (sender == buttonEmotionSad) {
        
        NSLog(@"Am sad today!");
        //imageEmotion = [UIImage imageNamed:@"SmileySad.png"];
        myEmotionNum = 2;
    }
    
    [textFieldUserInput becomeFirstResponder];
}



-(IBAction)textFieldEditingDone:(id)sender {
    [sender resignFirstResponder];
    [self actOnUserInput];
}



-(IBAction)backgroundTapped:(id)sender {
    [textFieldUserInput resignFirstResponder];
    [self actOnUserInput];
}



/**
 * Method that will act on the user input, once the button's pressed.
 * 1. This updates the UI to reflect user's entry.
 * 2. Persists the data into the database
 *
 * @created Apr 23, 2012
 */
-(void) actOnUserInput {

    NSString *userText = [textFieldUserInput text];
    [self addToInputArray:userText];
    
    [dbOps insertRecordIntoTableNamed:@"Emotionys"
                           withField1:@"time" 
                           field1Value:currentTime
                           withField2:@"emotion"
                           field2Value:myEmotionNum 
                           withField3:@"text" 
                           field3Value:userText];
   
    [dbOps getAllRowsFromTableNamed:@"Emotiony"];
    
    [table reloadData];
    textFieldUserInput.text = @"";
    
    // Make the text field disappear
    [UIView beginAnimations:nil context:NULL];
    self.textFieldUserInput.alpha = 0;
    [UIView commitAnimations];
}


/**
 * Adds the user input to a dictionary
 */
-(void) addToInputArray: (NSString *)userInput {
    
    NSDate *now = [NSDate date];
    currentTime = [Utility getDateAsInt:now];
    NSLog(@"addToInputArray: currentTime = %d", currentTime);
    NSLog(@"addToInputArray: currentTime converted: %@", [Utility getIntAsDate:currentTime]);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 userInput,                             @"text", 
                                 [NSNumber numberWithInt:myEmotionNum], @"emotion", 
                                 [NSNumber numberWithInt:currentTime],  @"time",
                                 nil];
    [arrayInput insertObject:dict atIndex:0];
    NSLog(@"Added %@ to User-Input-Array", userInput);
}


/**
 * Loads the user's data, stored in earlier visits
 * @created 24th Apr 2012
 */
-(void) loadEarlierConversation {
    NSLog(@"Loading earlier conversations");
    NSMutableArray *array = [dbOps getAllRowsFromTableNamed:@"Emotionys"];
    NSLog(@"loadEarlierConversation: Array size:%d", [array count]);
    self.arrayInput = [[NSMutableArray alloc] initWithArray:array];
    [table reloadData];
}



/**
 * Schedules a local notification
 */
-(void) scheduleLocalNotification {
    
    notification = [[UILocalNotification alloc] init];
    if (notification == nil) {
        return;
    }
    [notification setFireDate:[[NSDate date] dateByAddingTimeInterval:60]];
    [notification setTimeZone:[NSTimeZone defaultTimeZone]];
    notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"Just a local notification", nil)];
    notification.alertAction = NSLocalizedString(@"View Details", nil);
    notification.soundName = @"glass.wav";
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

- (void)viewDidLoad {
 
    [super viewDidLoad];
    _timeScroller = [[TimeScroller alloc] initWithDelegate:self];
    self.textFieldUserInput.alpha = 0;
    dictionary = [[NSMutableDictionary alloc] init];
    NSLog(@"viewDidLoad: Home View");
    dbOps = [DatabaseOperations dbOpsSingleton];
    NSLog(@"got the singleton");
    [dbOps createTableNamed:@"Emotionys"
                 withField1:@"time" 
                 withField2:@"emotion"
                 withField3:@"text"];
    [self scheduleLocalNotification];
    // Load the user's data from previous encounters
    [self loadEarlierConversation];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Be a good Memory Citizen please!
    self.arrayInput = nil;
    self.buttonPenThis = nil;
    self.buttonEmotionHappy = nil;
    self.buttonEmotionSad = nil;
    self.textFieldUserInput = nil;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
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




#pragma mark -
#pragma mark Table View Data Source Methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.arrayInput count];
}



-(UITableViewCell *) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] 
                    initWithStyle:UITableViewCellStyleDefault 
                    reuseIdentifier:SimpleTableIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [[arrayInput objectAtIndex:row] objectForKey:@"text"];
    cell.textLabel.font = [UIFont fontWithName:@"Helevetica" size:6.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    int emotion = [[[arrayInput objectAtIndex:row] objectForKey:@"emotion"] intValue]; 
    
    if (emotion == 1) {
        cell.imageView.image = [UIImage imageNamed:@"SmileyHappy.png"];

    } else if (emotion == 2) {
        cell.imageView.image = [UIImage imageNamed:@"SmileySad.png"];        
    }
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
    return 45;
}



//The UITableView that you'd like the TimeScroller to be in
- (UITableView *)tableViewForTimeScroller: (TimeScroller *)timeScroller {
    NSLog(@"tableViewForTimeScroller : returned UITableView");
    return table;
}



//The date for a given cell
- (NSDate *)dateForCell:(UITableViewCell *)cell {
    
    NSIndexPath *indexPath = [table indexPathForCell:cell];
    int timeInt = [[[arrayInput objectAtIndex:[indexPath row]] objectForKey:@"time"] intValue]; 
    NSDate *time = [Utility getIntAsDate:timeInt];
    NSLog(@"returned time for scroller: %@", time);
    return time;                        
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScroll");
    [_timeScroller scrollViewDidScroll];       
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndDecelerating");
    [_timeScroller scrollViewDidEndDecelerating];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scrollViewWillBeginDragging");
    [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {        
    NSLog(@"scrollViewDidEndDragging");
    if (!decelerate) {                        
        [_timeScroller scrollViewDidEndDecelerating];                                      
    }                                               
}

@end


