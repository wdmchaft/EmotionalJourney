//
//  com_FirstViewController.h
//  EmotionalJourney
//
//  Created by Administrator on 21/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeScroller.h"
#import "AwesomeMenu.h"
#import "AwesomeMenuItem.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "EmoticonsView.h"


/**
 * Controller class for the First/Home View in the App
 * UITableViewDelegate, UITableViewDataSource : For the table which displays the user text
 * TimeScrollerDelegate: for the time/clock that shows the time dynamically as the screen is scrolled
 * UIImagePickerControllerDelegate, UINavigationControllerDelegate : For the image/video selection
 */
@interface com_FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, 
    TimeScrollerDelegate, 
    AwesomeMenuDelegate,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    UIActionSheetDelegate,
    UITextFieldDelegate,
    MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate> {
    
    UITableView *table;
    UIButton *buttonEmotionOk;    
    UIButton *buttonEmotionHappy;
    UIButton *buttonEmotionOverjoyed;
    UIButton *buttonEmotionRomantic;
    UIButton *buttonEmotionSad;
    UIButton *buttonEmotionDepressed;
    UIButton *buttonEmotionAngry;
    UIButton *buttonPenThis;
    UITextField *textFieldUserInput;
    NSMutableArray *arrayInput;
    NSMutableDictionary *dictionary;
    //UIScrollView *scrollView;
    TimeScroller * _timeScroller;
}



// Table View
@property (nonatomic, retain) IBOutlet UITableView *table;

// Buttons representing Emotions
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionOk;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionHappy;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionOverjoyed;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionRomantic;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionSad;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionDepressed;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmotionAngry;
@property (nonatomic, retain) IBOutlet UIButton *buttonPenThis;
@property (nonatomic, retain) IBOutlet UIButton *buttonSaveText;

@property (nonatomic, retain) IBOutlet UITextField *textFieldUserInput;

@property (nonatomic, retain) IBOutlet AwesomeMenu *awesomeMenu;
@property (nonatomic, retain) IBOutlet AwesomeMenuItem *menuItem1;
@property (nonatomic, retain) IBOutlet AwesomeMenuItem *menuItem2;
@property (nonatomic, retain) IBOutlet AwesomeMenuItem *menuItem3;

// User input text
@property (nonatomic, retain) IBOutlet NSArray *arrayInput;

// Dictionary to hold user inputs on emotions
@property (nonatomic, retain) IBOutlet NSMutableDictionary *dictionary;

// The magical time/clock :)
@property (nonatomic, retain) TimeScroller *_timeScroller;

// For the image / vide selection feature
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) NSURL *movieURL;
@property (nonatomic, copy) NSString *lastChosenMediaType;
@property (nonatomic, retain) MFMailComposeViewController *mailComposer;
@property (nonatomic, retain) IBOutlet UIView *emoticonsView;
@property (nonatomic, retain) IBOutlet UILabel *textNoteLive;

@property (nonatomic, retain) IBOutlet UIImageView *emoticonNoteLive;
@property (nonatomic, retain) IBOutlet UIImageView *imageNoteLive;
@property (strong, nonatomic) NSArray *controllers;


// Triggered when the user presses the button to persist the input
-(IBAction)buttonPressed:(id)sender;
// Triggered when the user chooses an emotion icon from the given list
-(IBAction)emotionExpressed:(id)sender;
// Triggered when the user is done with entering the text in the text-field
-(IBAction)textFieldEditingDone:(id)sender;
// Triggered when the user taps anywhere in the bakground of the app
// This method will, in consequence, in order to dismiss the keypad
-(IBAction)backgroundTapped:(id)sender;
-(IBAction)textBeingEntered:(id)sender;

// Triggered when the user chooses to shoot a pic/video with the device cam
//-(IBAction) shootPicOrVideo:(id)sender;
// Trigerred when the user chooses to select form already-existing pics or videos in the device
//-(IBAction)selectExistingPicOrVideo:(id)sender;
-(void)addPicOrVideo;


// Adds the user's input to a data structure for persistence
-(void) addToInputArray;
// Called once the user inputs data. This will take care of the work flow after that point of time
-(void) actOnUserInput;
// Called when the app is started, in order to load the historical inputs of the user from persistent store
-(void) loadEarlierConversation;
// Schedules the local notification
-(void) scheduleLocalNotification;

// For the 'add the photo / video' feature
- (void)updateDisplay;
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType;


-(void)showEmailComposerWithText:(NSString *)text
                     withEmotion:(UIImage *)emotion
                     withPicture:(UIImage *)picture;
-(void) displayComposerSheetWithText:(NSString *) text
                         withEmotion:(UIImage *) emotion
                         withPicture:(UIImage *) picture;
-(void)launchMailAppOnDevice;
-(void) initializeSpringMenu;
-(UIImage *) getEmoticonForCode: (int) emoticonCode;
- (IBAction)history:(id)sender;

@end

