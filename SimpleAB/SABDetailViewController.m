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

    self.simpleAB = [[SimpleAddressBook alloc] init];
    NSLog(@"first: %@",[self.simpleAB firstName:[_recordID intValue]]);
    self.detailDescriptionLabel.text = [self.simpleAB firstName:[_recordID intValue]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
