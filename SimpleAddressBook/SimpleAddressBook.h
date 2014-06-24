//
//  SimpleAddressBook.h
//  SimpleAB
//
//  Created by Jason Salerno on 6/23/14.
//  Copyright (c) 2014 Jason Salerno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface SimpleAddressBook : NSObject

@property (strong, nonatomic) NSMutableOrderedSet *contactDetailList;

- (NSMutableOrderedSet *)list;
- (NSInteger)total;

@end
