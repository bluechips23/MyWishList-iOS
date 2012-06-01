//
//  FlipsideViewController.h
//  StoryBoard2
//
//  Created by SUDIPAN MISHRA on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *viewResults;

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, strong) id infoRequest;

- (IBAction)done:(id)sender;
- (void)displayResult:(NSString*)withValue;

@end
