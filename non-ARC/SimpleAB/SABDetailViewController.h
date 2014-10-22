//
//  SABDetailViewController.h
//  SimpleAB
//
//  Created by Jason Salerno (MeltedSpork) on 6/23/14.
//  Copyright (c) 2014 Jason Salerno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SABDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSString *recordID;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
