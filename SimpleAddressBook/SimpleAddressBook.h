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

- (NSString *) prefix;
- (NSString *) firstName;
- (NSString *) middleName;
- (NSString *) lastName;
- (NSString *) suffix;
- (NSString *) nickName;
- (NSString *) firstNamePhonetic;
- (NSString *) middleNamePhonetic;
- (NSString *) lastNamePhonetic;
- (NSString *) organization;
- (NSString *) jobTitle;
- (NSString *) department;
- (NSString *) birthday;
- (NSString *) note;
- (NSString *) createDate;
- (NSString *) modificationDate;

- (NSString *) prefix:(NSInteger)recordID;
- (NSString *) firstName:(NSInteger)recordID;
- (NSString *) middleName:(NSInteger)recordID;
- (NSString *) lastName:(NSInteger)recordID;
- (NSString *) suffix:(NSInteger)recordID;
- (NSString *) nickName:(NSInteger)recordID;
- (NSString *) firstNamePhonetic:(NSInteger)recordID;
- (NSString *) middleNamePhonetic:(NSInteger)recordID;
- (NSString *) lastNamePhonetic:(NSInteger)recordID;
- (NSString *) organization:(NSInteger)recordID;
- (NSString *) jobTitle:(NSInteger)recordID;
- (NSString *) department:(NSInteger)recordID;
- (NSString *) birthday:(NSInteger)recordID;
- (NSString *) note:(NSInteger)recordID;
- (NSString *) createDate:(NSInteger)recordID;
- (NSString *) modificationDate:(NSInteger)recordID;

@end
