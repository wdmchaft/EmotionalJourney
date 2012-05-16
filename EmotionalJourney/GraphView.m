//
//  GraphView.m
//  EmotionalJourney
//
//  Created by Administrator on 10/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView

//@synthesize gView;
@synthesize buttonBack;
@synthesize emotionsHistoryView;


-(void) setMoodHistoryData:(NSArray *)moodHistory {
    NSLog(@"GraphView: setMoodHistoryData");
    [emotionsHistoryView setMoodHistoryData:moodHistory];
    //[self.view addSubview:emotionsHistoryView];
}


-(id) init {
    self = [super init];
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    emotionsHistoryView = [[EmotionsHistoryView alloc] init];
    //sub = [[subviewtest alloc] initWithFrame:self.view.bounds];
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSLog(@"GraphView: viewDidLoad");
    [super viewDidLoad];
    
    //emotionsHistoryView = (EmotionsHistoryView *) subviewGraph;
    [emotionsHistoryView initializeGraph];
    //[self.view addSubview:sub];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
