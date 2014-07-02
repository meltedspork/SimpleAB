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
    - (void)configureView;
    @property (nonatomic, strong) SimpleAddressBook *simpleAB;
@end

@implementation SABDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    self.simpleAB = [[SimpleAddressBook alloc] init];
    [[self simpleAB] getRecord:3];

    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        NSLog(@"%@",_simpleAB.firstName);
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
