//
//  MainViewController.m
//  StoryBoard2
//
//  Created by SUDIPAN MISHRA on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define googleURLPart1 [NSURL URLWithString: @"https://www.googleapis.com/shopping/search/v1/public/products?country=US&maxResults=5&q=shirt&startIndex=1&pp=1&key=AIzaSyA1nwGPXd9gBqUJOMkgum4FBVd8i_71g4E"] 

#import "MainViewController.h"

@interface NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress;
-(NSData*)toJSON;
@end

@implementation NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress
{
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: urlAddress] ];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

-(NSData*)toJSON
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;    
}
@end

@interface MainViewController () 
@end

@implementation MainViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize searchField = _searchField;
@synthesize cancelButton = _cancelButton;
@synthesize startSearch = _startSearch;

NSString* showStuff = @"";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setSearchField:nil];
    [self setCancelButton:nil];
    [self setStartSearch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)searchDone:(id)sender {
    [sender resignFirstResponder];
   }


- (IBAction)backgroundTap:(id)sender {
    [_searchField resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"search"]) {
        //[[segue destinationViewController] setDelegate:self];
        NSLog(@"Inside second view controller!");
        FlipsideViewController *flipVC = [segue destinationViewController];
       
        flipVC.infoRequest = self.searchField.text;

    }

}

@end
