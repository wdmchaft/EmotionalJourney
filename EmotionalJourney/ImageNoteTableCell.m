//
//  EmotionNoteTableCell.m
//  EmotionalJourney
//
//  Created by Administrator on 01/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageNoteTableCell.h"
#import "com_FirstViewController.h"

#define kNoteEmotionTag 1
#define kNoteTextTag    2
#define kNoteImageTag   3
#define kNameValueTag   4
#define kColorValueTag  5


@implementation ImageNoteTableCell

@synthesize buttonShare;
@synthesize noteEmotion;
@synthesize noteImage;
@synthesize noteShare;
@synthesize noteEmotionView;
@synthesize noteImageView;
@synthesize viewController;
@synthesize picView;


/*
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // For displaying the Emoticon
        // CGRect -> x, y, width, height
        CGRect noteEmotionRect = CGRectMake(0, 5, 27, 13);
        noteEmotionView = [[UIImageView alloc] initWithFrame:noteEmotionRect];
        noteEmotionView.tag = kNoteEmotionTag;
        [self.contentView addSubview:noteEmotionView];
        
        // For displaying the button that enables sharing
        CGRect noteButtonRect = CGRectMake(0, 26, 70, 15);
        buttonShare = [[UIButton alloc] initWithFrame:noteButtonRect];
        //buttonShare.titleLabel.text = @"Share";
        buttonShare.alpha=1;
        [self.contentView addSubview:buttonShare];
        
        // For displaying the text
        CGRect noteTextRect = CGRectMake(80, 5, 200, 15); 
        noteTextLabel = [[UILabel alloc] initWithFrame:noteTextRect];
        noteTextLabel.tag = kNoteTextTag;
        [self.contentView addSubview:noteTextLabel];
        
        // For displaying the image, if any, chosen by the user
        CGRect noteImageRect = CGRectMake(80, 25, 200, 15); 
        noteImageView = [[UIImageView alloc] initWithFrame:noteImageRect];
        noteImageView.tag = kNoteImageTag;
        [self.contentView addSubview:noteImageView];
    }
    return self;
}
*/


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
      


-(void)setNoteEmotion:(UIImage *)emotion {
    NSLog(@"setNoteEmotion");
    noteEmotion = [emotion copy];
    //noteEmotionView = (UIImageView *)[self.contentView viewWithTag:kNoteEmotionTag];
    noteEmotionView.image = noteEmotion;
    noteEmotionView.contentMode = UIViewContentModeScaleAspectFill;
}



- (void)setNoteImage:(UIImage *)image {
    NSLog(@"setNoteImage");
    noteImage = [image copy];
    //noteImageView = (UIImageView *)[self.contentView viewWithTag:kNoteImageTag];
    noteImageView.image = noteImage;
    noteImageView.contentMode = UIViewContentModeScaleAspectFill;
}



-(void)setFirstViewController:(com_FirstViewController *)controller {
    viewController = [[com_FirstViewController alloc] init];
    viewController = controller;
    NSLog(@"Done setting the FirstViewController instance in the cell");
}



-(IBAction)showMailComposer:(id)sender {
    NSLog(@"showMailComposer triggered. Calling showEmailComposer in FirstViewController");
    [self.viewController showEmailComposerWithText:nil
                                       withEmotion:noteEmotion
                                       withPicture:noteImage];
}
              
@end
