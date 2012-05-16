//
//  com_FirstViewController.m
//  EmotionalJourney
//
//  Created by Administrator on 21/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "com_FirstViewController.h"
#import "com_SecondViewController.h"
#import "DatabaseOperations.h"
#import "Utility.h"
#import "TimeScroller.h"
#import "EmotionNoteTableCell.h"
#import "ImageNoteTableCell.h"
#import "TextNoteTableCell.h"

#define kEmotionHappy 1
#define kEmotionOverjoyed 2
#define kEmotionRomantic 3
#define kEmotionSad 4
#define kEmotionDepressed 5
#define kEmotionAngry 6

#define kActPhoto 0
#define kActText 1
#define kActEmotion 2


@implementation com_FirstViewController

@synthesize table;
@synthesize buttonEmotionOk;
@synthesize buttonEmotionHappy;
@synthesize buttonEmotionOverjoyed;
@synthesize buttonEmotionRomantic;
@synthesize buttonEmotionSad;
@synthesize buttonEmotionDepressed;
@synthesize buttonEmotionAngry;
@synthesize buttonPenThis;
@synthesize buttonSaveText;
@synthesize textFieldUserInput;
@synthesize arrayInput;
@synthesize dictionary;
@synthesize imageView;
@synthesize imageFrame;
@synthesize image;
@synthesize text;
@synthesize moviePlayer;
@synthesize movieURL;
@synthesize lastChosenMediaType;
@synthesize mailComposer;
@synthesize _timeScroller;
@synthesize awesomeMenu;
@synthesize menuItem1;
@synthesize menuItem2;
@synthesize menuItem3;
@synthesize emoticonsView;
@synthesize textNoteLive;
@synthesize emoticonNoteLive;
@synthesize imageNoteLive;
@synthesize controllers;

int myEmotionNum;
int currentTime;
int rowHasPicture;
DatabaseOperations *dbOps;
UILocalNotification *notification;
static UIImage *shrinkImage(UIImage *original, CGSize size);


/**
 * Called when the button's pressed
 * sender : the button which's pressed, consequently invoking this
 */
-(IBAction)buttonPressed:(id)sender {
        
    NSLog(@"Button Pressed");
    
    NSString *str = textFieldUserInput.text;
    self.text = str;
    str = nil;
    
    // Reset everything please!!!
    self.textFieldUserInput.text = @"";
    self.emoticonNoteLive.image = nil;    
    [self actOnUserInput];
}


-(IBAction)saveThisText:(id)sender {
    self.text = textFieldUserInput.text;
    [textFieldUserInput resignFirstResponder];

}


-(IBAction)emotionExpressed:(id)sender {
   
//    // Let the text field appear for the user to enter his/her emotion in words
//    [UIView beginAnimations:nil context:NULL];
//    self.textFieldUserInput.alpha = 1;
//    [UIView commitAnimations];
    
    if (sender == buttonEmotionHappy) {
        NSLog(@"Am happy");
        myEmotionNum = kEmotionHappy;
        emoticonNoteLive.image = [UIImage imageNamed:@"1.png"];
        
    } else if (sender == buttonEmotionOverjoyed) {
        NSLog(@"Am overjoyed");
        myEmotionNum = kEmotionOverjoyed;
        
    } else if (sender == buttonEmotionRomantic) {
        NSLog(@"Am feeling romantic");
        myEmotionNum = kEmotionRomantic;
        emoticonNoteLive.image = [UIImage imageNamed:@"8.png"];
        
    } else if (sender == buttonEmotionSad) {
        NSLog(@"Am sad");
        myEmotionNum = kEmotionSad;
        
    } else if (sender == buttonEmotionDepressed) {
        NSLog(@"Am depressed");
        myEmotionNum = kEmotionDepressed;
        
    } else if (sender == buttonEmotionAngry) {
        NSLog(@"Am angry");
        myEmotionNum = kEmotionAngry;
    }
    
    [UIView transitionWithView:emoticonsView  
                      duration:1.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{ self.emoticonsView.hidden = YES;
                    }  
                    completion:NULL]; 
    //[textFieldUserInput becomeFirstResponder];
    emoticonNoteLive.contentMode = UIViewContentModeScaleAspectFill;
}



-(IBAction)textFieldEditingDone:(id)sender {

    NSString *str = textFieldUserInput.text;
    self.text = str;
    str = nil;
    
    [sender resignFirstResponder];
    textFieldUserInput.text = @"";
    
    // Make the text field disappear
    [UIView beginAnimations:nil context:NULL];
    self.textFieldUserInput.alpha = 0;
    self.buttonSaveText.alpha = 0;
    [UIView commitAnimations]; 
}



-(IBAction)textBeingEntered:(id)sender {
    textNoteLive.text = self.textFieldUserInput.text;
}



-(IBAction)backgroundTapped:(id)sender {
    [textFieldUserInput resignFirstResponder];
}



/**
 * Method that will act on the user input, once the button's pressed.
 * 1. This updates the UI to reflect user's entry.
 * 2. Persists the data into the database
 *
 * @created Apr 23, 2012
 */
-(void) actOnUserInput {

    [self addToInputArray];
    
    if (self.image != nil) {
        NSLog(@"actOnUserInput: User input has an image");
    }
        
    [dbOps insertRecordIntoTableNamed:@"Emotionssys"
                           withField1:@"time" 
                           field1Value:currentTime
                           withField2:@"emotion"
                           field2Value:myEmotionNum 
                           withField3:@"text" 
                           field3Value:self.text
                           withField4:@"picture"
                           field4Value:self.image];
   
    [dbOps getAllRowsFromTableNamed:@"Emotionssys"];
    
    [table reloadData];
    
    // Reset everything please!!! Reminents aren't any good!
    self.image = nil;
    myEmotionNum = -1;
    self.text = nil;
}


/**
 * Adds the user input to a dictionary
 */
-(void) addToInputArray {
    
    NSDate *now = [NSDate date];
    currentTime = [Utility getDateAsInt:now];
    NSLog(@"addToInputArray: currentTime = %d", currentTime);
    NSLog(@"addToInputArray: currentTime converted: %@", [Utility getIntAsDate:currentTime]);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 self.text,                             @"text", 
                                 [NSNumber numberWithInt:myEmotionNum], @"emotion", 
                                 [NSNumber numberWithInt:currentTime],  @"time",
                                 self.image,                            @"picture",
                                 nil];
    [arrayInput insertObject:dict atIndex:0];
    NSLog(@"Added %@ to User-Input-Array", self.text);
}


/**
 * Loads the user's data, stored in earlier visits
 * @created 24th Apr 2012
 */
-(void) loadEarlierConversation {
    NSLog(@"Loading earlier conversations");
    NSMutableArray *array = [dbOps getAllRowsFromTableNamed:@"Emotionssys"];
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



/**
 * Method that's called (automatically) soon after the modal window 
 * (action sheet) is shown and the user chooses one of the buttons.
 * The modal window is shown when the user chooses to add a image/video
 */
-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSLog(@"Clicked button index: %d", buttonIndex);
    
    if (buttonIndex == 1) {
        NSLog(@"The user wants to choose from existing pic/video library");
        [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];

    } else if (buttonIndex == 2) {
        NSLog(@"The user wants to shoot a pic/video right now");
        [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];

    } else if (buttonIndex == [actionSheet cancelButtonIndex]) { // index 0
        NSLog(@"User chose to cancel adding a video/pic");
    }
    
    // [self updateDisplay];
}



/**
 * Method to add a pic or video to the emotion-note
 * @created May 2012
 */
-(void)addPicOrVideo {
    
    NSLog(@"addPicOrVideo: The user has chosen to add a pic/video");
    self.image = nil;
    imageFrame = [imageView frame];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:@"Capture your moment with a photo or video"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"Add existing photo/video"];
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle:@"Capture one right now"];
    }
    [actionSheet showFromTabBar:self.tabBarController.tabBar];

}



/**
 * This can be called from viewDidAppear
 * is called both when the view is first created and 
 * then again after the user picks an image or video and dismisses the image picker.
 * Because of this dual usage, it needs to make a few checks to see what's what 
 * and set up the GUI accordingly. The MPMoviePlayerController doesn't let us change the URL it reads from, 
 * so each time we want to display a movie, we'll need to make a new controller. All of that is handled here. 
 */
- (void)updateDisplay {
    
    if ([lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        imageView.image = image;
        imageView.hidden = NO; 
        moviePlayer.view.hidden = YES;
        
    } else if ([lastChosenMediaType isEqual:(NSString *)kUTTypeMovie]) { 
    
        [self.moviePlayer.view removeFromSuperview]; 
        self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        moviePlayer.view.frame = imageFrame; 
        moviePlayer.view.clipsToBounds = YES; 
        [self.view addSubview:moviePlayer.view]; 
        imageView.hidden = YES;
    } 
}



/**
 * This is the one that both of our action methods call.
 * It creates and configures an image picker, using the passed-in sourceType 
 * to determine whether to bring up the camera or the media library.
 */
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType { 

    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && ([mediaTypes count] > 0)) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
    
    } else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Error accessing media"
                              message:@"Device doesn't support the media source"
                              delegate:nil
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:nil];
        [alert show];
    }
}



/**
 * Intializes the spring-like menu
 * @created  
 */
-(void) initializeSpringMenu {
    NSLog(@"InitializeSpringMenu: entered");
    UIImage *imageAddPhoto    = [UIImage imageNamed:@"Button_Photo.png"];
    UIImage *imageAddText     = [UIImage imageNamed:@"Button_Text.png"];
    UIImage *imageAddEmoticon = [UIImage imageNamed:@"Button_Emoticon.png"];

    menuItem1 = [[AwesomeMenuItem alloc] 
                            initWithImage:imageAddPhoto
                            highlightedImage:nil
                            ContentImage:imageAddPhoto
                            highlightedContentImage:nil];
    menuItem2 = [[AwesomeMenuItem alloc] 
                            initWithImage:imageAddText
                            highlightedImage:nil
                            ContentImage:imageAddText 
                            highlightedContentImage:nil];
    menuItem3 = [[AwesomeMenuItem alloc] 
                 initWithImage:imageAddEmoticon
                 highlightedImage:nil
                 ContentImage:imageAddEmoticon 
                 highlightedContentImage:nil];
    
    
    // Now, setup the menu and the options
    awesomeMenu = [[AwesomeMenu alloc] 
                    initWithFrame:CGRectMake(15.0, 35.0, 25.0, 25.0) 
                    menus:[NSArray arrayWithObjects:menuItem1, menuItem2, menuItem3, nil]];
    awesomeMenu.startPoint = CGPointMake(15.0, 35.0);
    awesomeMenu.rotateAngle = 90.0;
    awesomeMenu.menuWholeAngle = M_PI / 2;
    awesomeMenu.timeOffset = 0.036f;
    // Set the distance between the "Add" button and Menu Items
    awesomeMenu.endRadius = 120.0f;
    
    awesomeMenu.farRadius = 140.0f;
    awesomeMenu.nearRadius = 110.0f;
    
    //awesomeMenu = [[AwesomeMenu alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    awesomeMenu.delegate = self;
    //awesomeMenu.frame = CGRectMake(10, 3, 50, 50);
    //awesomeMenu.bounds = CGRectMake(10, 3, 50, 50);
    //[self presentModalViewController:awesomeMenu //animated:YES];
    [self.view addSubview:awesomeMenu];
    NSLog(@"initializeSpringMenu: Done initializing it");
}


- (void)AwesomeMenuItemTouchesEnd:(AwesomeMenuItem *)item {
    [awesomeMenu AwesomeMenuItemTouchesEnd:item];
    NSLog(@"awesome menu item touches ended");
}


- (IBAction)history:(id)sender {
    [UIView transitionWithView:self.tabBarController.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{ 
                       self.tabBarController.selectedIndex = 1;
                    }  
                    completion:NULL];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
 
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    
    self.title = @"Home";
    
    NSMutableArray *array = [[NSMutableArray alloc] init]; 
    self.controllers = array;
    
    _timeScroller = [[TimeScroller alloc] initWithDelegate:self];
    
    // These need to be displayed only when the user chooses to enter some text
    self.textFieldUserInput.hidden = YES;
    self.buttonSaveText.hidden = YES;
    self.buttonPenThis.hidden = YES;
    
    //Set the max char limit on the text field
    textFieldUserInput.delegate = self;
    
    rowHasPicture = 0;
    dictionary = [[NSMutableDictionary alloc] init];
    NSLog(@"viewDidLoad: Home View");
    dbOps = [DatabaseOperations dbOpsSingleton];
    NSLog(@"got the singleton");
    [dbOps createTableNamed:@"Emotionssys"
                 withField1:@"time" 
                 withField2:@"emotion"
                 withField3:@"text"
                 withField4:@"picture"];
    [self initializeSpringMenu];
    [self scheduleLocalNotification];
    // Load the user's data from previous encounters
    [self loadEarlierConversation];
    self.emoticonsView.hidden = YES;
    
    // Tag:Nav
    UIBarButtonItem *historyButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"History" style:UIBarButtonItemStyleBordered target:self action:@selector(history:)];
    historyButton.width = 3.0;
    self.navigationItem.rightBarButtonItem = historyButton;
    //historyButton.image.size = CGRectMake(0, 0, 5, 3);
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Be a good Memory Citizen please!
    self.arrayInput = nil;
    self.buttonPenThis = nil;
    self.buttonEmotionHappy = nil;
    self.buttonEmotionSad = nil;
    self.buttonSaveText = nil;
    self.textFieldUserInput = nil;
    self.imageView = nil;
    self.moviePlayer = nil;
    self.image = nil;
    self.controllers = nil;
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
    
    /*
     * Here, we deal with different types of cells to meet varying display needs:
     * Type 1 : EmotionNoteTableCell
     *     One that takes the call when the table row has all the info present
     * Type 2 : ImageNoteTableCell
     *     One that handles the display when the cell has only an image, & no text
     * 
     */
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    static NSString *ImageCellIdentifier = @"ImageCellIdentifier";
    static NSString *TextCellIdentifier = @"TextCellIdentifier";

    static BOOL nibsRegistered = NO;
    
    // Load the nib files
    if(!nibsRegistered) {
        UINib *cellNib = [UINib nibWithNibName:@"EmotionNoteTableCell" bundle:nil];
        [table registerNib:cellNib forCellReuseIdentifier:SimpleTableIdentifier];
        
        UINib *imageCellNib = [UINib nibWithNibName:@"ImageNoteTableCell" bundle:nil];
        [table registerNib:imageCellNib forCellReuseIdentifier:ImageCellIdentifier];
        
        UINib *textCellNib = [UINib nibWithNibName:@"TextNoteTableCell" bundle:nil];
        [table registerNib:textCellNib forCellReuseIdentifier:TextCellIdentifier];
        
        nibsRegistered = YES;
    }
    
    // Get the data, to be displayed, for the cell
    NSUInteger row = [indexPath row];
    NSString *noteText = [[arrayInput objectAtIndex:row] objectForKey:@"text"];
    int emotion = [[[arrayInput objectAtIndex:row] objectForKey:@"emotion"] intValue];
    UIImage *pic = [[arrayInput objectAtIndex:row] objectForKey:@"picture"];

    // Type : ImageNoteTableCell
    if (((noteText == nil) || (noteText.length == 0)) && (pic != nil)) {
        
        ImageNoteTableCell *imageCell = [tableView dequeueReusableCellWithIdentifier:ImageCellIdentifier];
        [imageCell setFirstViewController:self];

        imageCell.noteEmotion = [self getEmoticonForCode:emotion];
        
        UIImage *image = [pic copy];
        imageCell.noteImage = shrinkImage(image, CGSizeMake(185.0, 185.0));
        image = nil;
        imageCell.noteImageView.frame = CGRectMake(85.0, 60.0, 185.0, 185.0);
        imageCell.picView.frame = CGRectMake(57.0, 6.0, 255.0, 272.0);
        rowHasPicture = 1;
        
        return imageCell;
    } 
    
    // Type : EmotionNoteTableCell
    else if (((noteText != nil) && (noteText.length != 0)) && (pic != nil)) {
        EmotionNoteTableCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        [cell setFirstViewController:self];
 
        cell.noteEmotion = [self getEmoticonForCode:emotion];

        UIImage *image = [pic copy];
        cell.noteImage = shrinkImage(image, CGSizeMake(185.0, 185.0));
        image = nil;        
        cell.noteImageView.frame = CGRectMake(85.0, 77.0, 185.0, 185.0);
        cell.picView.frame = CGRectMake(57.0, 6.0, 255.0, 285.0);
        //cell.noteImageView.clipsToBounds = YES;
        //cell.noteImageView.layer.cornerRadius = 3.0;
        //cell.noteImageView.layer.masksToBounds = YES;
        //cell.noteImageView.layer.borderColor = [UIColor blackColor].CGColor;
        //imageView.layer.borderWidth = 1.0;
        rowHasPicture = 1;
        
        return cell;
    }
    
    // Type : TextNoteTableCell / Default
    else {
        TextNoteTableCell *textCell = [tableView dequeueReusableCellWithIdentifier:TextCellIdentifier];
        [textCell setFirstViewController:self];
        
        if ((noteText == nil) || (noteText.length == 0)) {
            textCell.noteTextLabel.alpha = 0;
        } else {
            textCell.noteTextLabel.alpha = 1;
            textCell.noteText = noteText;
        }
        
        rowHasPicture = 0;

        return textCell;
    }

    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
    
    NSUInteger row = [indexPath row];
    UIImage *pic = [[arrayInput objectAtIndex:row] objectForKey:@"picture"];
    if (pic != nil) {
        return 250.0;
        NSLog(@"This row has a pic");
    }
    
    NSLog(@"This row doesn't have a pic");
    return 100.0;
}


/**
 * Returns the smiley image that maps to the given code
 * @param   emoticonCode  int  The code for the emoticon that the user chose for the note
 * @return  UIImage            The image corresponding to the input emoticon-code
 * @created 14th May 2012
 */
-(UIImage *) getEmoticonForCode: (int) emoticonCode {
    
    UIImage *emoticon = nil;
    
    switch (emoticonCode) {

        case kEmotionHappy:
            emoticon = [UIImage imageNamed:@"SmileyHappy.png"];
            break;
            
        case kEmotionOverjoyed:
            emoticon = [UIImage imageNamed:@"SmileyOverjoyed.png"];
            break;
            
        case kEmotionSad:
            emoticon = [UIImage imageNamed:@"SmileySad.png"];
            break;
            
        case kEmotionDepressed:
            emoticon = [UIImage imageNamed:@"SmileyDepressed.png"];
            break;
            
        case kEmotionAngry:
            emoticon = [UIImage imageNamed:@"SmileyAngry.png"];
            break;
            
        default:
            NSLog(@"Smiley '%d' selection invalid", emoticonCode);
            break;
    }
    return emoticon;
}


/*
 * The UITableView that you'd like the TimeScroller to be in
 */
- (UITableView *)tableViewForTimeScroller: (TimeScroller *)timeScroller {
    //NSLog(@"tableViewForTimeScroller : returned UITableView");
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
    //NSLog(@"scrollViewDidScroll");
    [_timeScroller scrollViewDidScroll];       
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //NSLog(@"scrollViewDidEndDecelerating");
    [_timeScroller scrollViewDidEndDecelerating];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //NSLog(@"scrollViewWillBeginDragging");
    [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {        
    //NSLog(@"scrollViewDidEndDragging");
    if (!decelerate) {                        
        [_timeScroller scrollViewDidEndDecelerating];                                      
    }                                               
}



#pragma mark UIImagePickerController delegate methods

/**
 * This checks to see whether a picture or video was chosen, 
 * makes note of the selection 
 * then dismisses the modal image picker
 */
-(void)imagePickerController:(UIImagePickerController *)picker
                            didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.lastChosenMediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
        // TODO : check the error when calling shrinkImage
        // doens't work right now
        //UIImage *shrunkenImage = shrinkImage(chosenImage, imageFrame.size);
        //self.image = shrunkenImage;
        self.image = chosenImage;
        if (self.image != nil) {
            NSLog(@"I have now saved the chosen picture");
        }
        
    } else if ([lastChosenMediaType isEqual:(NSString *)kUTTypeMovie]) {
        self.movieURL = [info objectForKey:UIImagePickerControllerMediaURL]; 
    }
    
    [picker dismissModalViewControllerAnimated:YES]; 
    [self actOnUserInput];
}


/**
 *  This dismisses the image picker
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker { 
    [picker dismissModalViewControllerAnimated:YES];
}



#pragma mark -
static UIImage *shrinkImage(UIImage *original, CGSize size) {
    
    CGFloat scale = [UIScreen mainScreen].scale; 
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSLog(@"going to get the context");
    CGContextRef context = CGBitmapContextCreate(
                                                 NULL, 
                                                 size.width*scale,
                                                 size.height*scale, 
                                                 8, 0, 
                                                 colorSpace, 
                                    kCGImageAlphaPremultipliedFirst);
    NSLog(@"got the context");
    CGContextDrawImage(context,
                       CGRectMake(0, 0, 
                                  size.width * scale, 
                                  size.height * scale),
                                  original.CGImage);
    NSLog(@"called CGContextDrawImage");
    CGImageRef shrunken = CGBitmapContextCreateImage(context);
    NSLog(@"called shrunken");
    UIImage *final = [UIImage imageWithCGImage:shrunken];
    NSLog(@"called final");
    CGContextRelease(context); 
    CGImageRelease(shrunken);
    return final;
}




// ********************** METHODS FOR THE EMAIL FEATURE ************************************

/**
 * This can run on devices running iPhone OS 2.0 or later  
 * The MFMailComposeViewController class is only available in iPhone OS 3.0 or later. 
 * So, we must verify the existence of the above class and provide a workaround for devices running 
 * earlier versions of the iPhone OS. 
 * The method displays an email composition interface if MFMailComposeViewController exists and the device can send emails.
 * It then launches the Mail application on the device, otherwise.
 */
-(void)showEmailComposerWithText:(NSString *) noteText
                     withEmotion:(UIImage *) emotion
                     withPicture:(UIImage *) picture {
    
    NSLog(@"showEmailComposer: begin");
    
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail]) {
            NSLog(@"showEmailComposer: Calling displayComposerSheet");
			[self displayComposerSheetWithText:(NSString *) noteText
                                   withEmotion:(UIImage *) emotion
                                   withPicture:(UIImage *) picture];
            
		} else {
            NSLog(@"showEmailComposer: Calling launchMailAppOnDevice");
			[self launchMailAppOnDevice];
		}
	}
	else {
        NSLog(@"showEmailComposer: Calling launchMailAppOnDevice");
		[self launchMailAppOnDevice];
	}
}




#pragma mark -
#pragma mark Compose Mail

-(void) displayComposerSheetWithText:(NSString *) noteText
                         withEmotion:(UIImage *) emotion
                         withPicture:(UIImage *) picture {

    NSLog(@"displayComposerSheet: begin");
    mailComposer = [[MFMailComposeViewController alloc] init];
    //mailComposer.messageComposeDelegate = self;
    mailComposer.mailComposeDelegate = self;

    // Set the mail title
    [mailComposer setSubject:@"My Moment of Emotion"];
    
    // Set the recipients
    // NSArray *toRecipients = [NSArray arrayWithObject:@"toRecipient@mail.com"];
    // [mailComposer setToRecipients:toRecipients];
    // [mailComposer setCcRecipients:ccRecipients];
    // [mailComposer setBccRecipients:bccRecipients];
    
    // TODO : check on how-to for mail attachment
    // Attach an image to the email
    /* NSString *picPath = [[NSBundle mainBundle] pathForResource:@"CuteDoggy" ofType:@"jpg"];
     NSData *picData = [NSData dataWithContentsOfFile:picPath];
     [mailComposer addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
     */
    
    // EMail Body
    NSString *mailBody = noteText;
    [mailComposer setMessageBody:mailBody isHTML:YES];
    
    NSLog(@"present the modal view ctlr");
    [self presentModalViewController:mailComposer animated:YES];
}



/**
 * Dissmiss the email composition interface when the users tap 'Cancel'/'Send'
 * Proceeds to update the 'message' field with the text, if any
 */
-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    NSString *alertTitle;
    NSString *alertMsg;
    
    // Notifies users on errors, if any
    switch (result) {
            
        case MFMailComposeResultCancelled:
            alertTitle = @"Cancelled";
            alertMsg = @"Mail composition got cancelled";
            break;
        case MFMailComposeResultSaved:
            alertTitle = @"Success - Saved";
            alertMsg = @"Mail got saved successfully!";
            break;
        case MFMailComposeResultSent:
            alertTitle = @"Success - Sent";
            alertMsg = @"Mail sent successfully!";
            break;
        case MFMailComposeResultFailed:
            alertTitle = @"Failure";
            alertMsg = @"Sending the mail failed";
            break;
        default:
            alertTitle = @"Failure";
            alertMsg = @"Mail could not be sent";
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:alertTitle
                          message:alertMsg
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    
    [self dismissModalViewControllerAnimated:YES];
}



#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
	NSString *body = @"&body=It is raining in sunny California!";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}



/**
 * Resoponds to the selection i.e. user choice in the menu
 * @param  menu  AwesomeMenu  The menu instance of interest
 * @param  idx   NSInteger    The choice in the menu that the user selected
 * @created 13th May 2012
 */
- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
    
    int userAct = (int) idx;
    
    
    switch (userAct) {
            
        case kActPhoto: {
            NSLog(@"didSelectIndex: User has chosen to add a photo");
            [self addPicOrVideo];
            self.buttonPenThis.hidden = NO;
            break;
        }
            
        case kActEmotion: {
            NSLog(@"didSelectIndex: User has chosen to add an emoticon");
            [UIView transitionWithView:emoticonsView  
                              duration:1.5
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{ self.emoticonsView.hidden = NO;
                                        }  
                            completion:NULL];
            self.buttonPenThis.hidden = NO;
            break;
        }    
            
        case kActText: {
            NSLog(@"didSelectIndex: Usr has chosen to add some text");
            [UIView transitionWithView:self.textFieldUserInput  
                              duration:1.5
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{ 
                                self.textFieldUserInput.hidden = NO;
                                self.buttonSaveText.hidden = NO;
                                self.buttonPenThis.hidden = NO;
                            }  
                            completion:NULL];              
            [self.textFieldUserInput becomeFirstResponder];
        }
    
        default: {
            break;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 15) ? NO : YES;
}

@end
