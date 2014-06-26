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

@property (strong, nonatomic) NSMutableDictionary *simpleABSet;

- (NSMutableOrderedSet *) list;
- (NSInteger) total;

- (void) setRecordID:(NSInteger)recordID;

- (NSString *) firstName;
- (NSString *) middleName;
- (NSString *) lastName;
- (NSString *) birthday;

- (NSString *) firstName:(NSInteger)recordID;
- (NSString *) middleName:(NSInteger)recordID;
- (NSString *) lastName:(NSInteger)recordID;
- (NSString *) birthday:(NSInteger)recordID;

@end
