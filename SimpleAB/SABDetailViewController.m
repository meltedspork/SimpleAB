//
//  SABDetailViewController.m
//  SimpleAB
//
//  Created by Jason Salerno (MeltedSpork) on 6/23/14.
//  Copyright (c) 2014 Jason Salerno. All rights reserved.
//

#import "SABDetailViewController.h"
#import "SimpleAddressBook.h"

@interface SABDetailViewController ()
   // - (void)configureView;
    @property (nonatomic, strong) SimpleAddressBook *simpleAB;
@end

@implementation SABDetailViewController

@synthesize recordID = _recordID;

#pragma mark - Managing the detail item
/*
- (void)setDetailItem:(id)newDetailItem
{
    //[[self simpleAB] getRecord:3];

    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        //[self configureView];
        [self setPersonSAB:[[self.detailItem description] intValue]];
    }

}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
        [self setPersonSAB:[[self.detailItem description] intValue]];
    }
}*/
/*
- (void)setPersonSAB: (int)recoredID {
    self.simpleAB = [[SimpleAddressBook alloc] init];
    [[self simpleAB] getRecord:recoredID];
    NSLog(@"First Name: %@",_simpleAB.firstName);
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    //[self configureView];
    self.simpleAB = [[SimpleAddressBook alloc] init];
    ////[[self simpleAB] setRecordID:[_recordID intValue]];
   // NSLog(@"First Name: %@",_simpleAB.firstName);
    //NSLog(@"First Name: %@",_simpleAB.firstName);
   // NSLog(@"[_simpleAB firstName:1]: %@",[_simpleAB firstName:1]);
    //[self setPersonSAB:[[self.detailItem description] intValue]];
   // NSLog(@"%d",_recordID);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
