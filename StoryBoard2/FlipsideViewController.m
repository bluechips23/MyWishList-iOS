//
//  FlipsideViewController.m
//  StoryBoard2
//
//  Created by SUDIPAN MISHRA on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define googleURLPart1 [NSURL URLWithString: @"https://www.googleapis.com/shopping/search/v1/public/products?country=US&maxResults=5&q=shirt&startIndex=1&pp=1&key=AIzaSyA1nwGPXd9gBqUJOMkgum4FBVd8i_71g4E"] 


#import "FlipsideViewController.h"


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


@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

@synthesize viewResults = _viewResults;
@synthesize delegate = _delegate;
@synthesize infoRequest = _infoRequest;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //_viewResults.text = [self.infoRequest description];
    NSLog(@"FVCViewDidLoad - infoRequest: %@", [self.infoRequest description]);
    [self searchDone];
    
}

- (void)displayResult:(NSString*)withValue {
    NSLog(@"DisplayResult: %@", withValue);
    _viewResults.text = withValue;
}

- (void)viewDidUnload
{
    [self setViewResults:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)searchDone {
    NSString *searchText = [self.infoRequest description];
    NSLog(@"Search Value = %@", searchText);
    
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString const *googleURL1 = @"https://www.googleapis.com/shopping/search/v1/public/products?country=US&maxResults=5&q=";
    NSString const *googleURL2 = @"&startIndex=1&pp=1&key=AIzaSyA1nwGPXd9gBqUJOMkgum4FBVd8i_71g4E";
    
    NSString *searchValue = @"";
    searchValue = [searchValue stringByAppendingFormat:@"%@%@%@", googleURL1, searchText, googleURL2];
    NSURL *googleURL = [NSURL URLWithString:searchValue];
    
    dispatch_async(kBgQueue, ^{
        NSData* data2 = [NSData dataWithContentsOfURL: googleURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data2 waitUntilDone:YES];
    });
    
}

- (void)fetchedData:(NSData *)responseData {
    // 1) Parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData //1
                                                         options:kNilOptions 
                                                           error:&error];
    NSArray* allItems = [json objectForKey:@"items"]; //2
    NSLog(@"Number of Items: %i", [allItems count]);
    
    
    NSString* showResult = @"";
    // 2) Get the data out from Google's JSON reply
    for(int i = 0; i < [allItems count]; i++) {
        NSString* title = [[[allItems objectAtIndex:i] objectForKey:@"product"] objectForKey:@"title"];
        NSLog(@"Title: %@", title);
        
        NSArray* inventory = [[[allItems objectAtIndex:i] objectForKey:@"product"] objectForKey:@"inventories"];
        NSString* price = [[inventory objectAtIndex:0] objectForKey:@"price"];
        NSLog(@"Price: %@", price);
                
        NSString* store =[[[[allItems objectAtIndex:i] objectForKey:@"product"] objectForKey:@"author"] objectForKey:@"name"];
        NSLog(@"Name: %@", store);

        showResult = [showResult stringByAppendingFormat:@"%i%@%@\n", (i+1), @": ", title];
        showResult = [showResult stringByAppendingFormat:@"%@%@\n", @"Store: ", store];
        showResult = [showResult stringByAppendingFormat:@"Price: $%@\n", price];
        showResult = [showResult stringByAppendingFormat:@"%@\n", @""];
    }
    
    // 3) Set the label appropriately
    
    _viewResults.text = showResult;
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
