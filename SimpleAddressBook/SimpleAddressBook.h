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
@property (strong, nonatomic) NSMutableDictionary *simpleABPerson;

- (NSMutableOrderedSet *) list;
- (NSArray *) showList;
//- (NSArray *) showList:(NSOrderedSet *)sets;
- (NSInteger) total;
- (NSMutableOrderedSet *) letterList:(NSMutableOrderedSet *)preLetterList;

//-(void) getRecord:(NSInteger)recordID;

//@property (nonatomic) NSInteger recordID;
//@property (strong, nonatomic) NSString *prefix;
//@property (strong, nonatomic) NSString *firstName;
/*@property (strong, nonatomic) NSString *middleName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *suffix;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *firstNamePhonetic;
@property (strong, nonatomic) NSString *middleNamePhonetic;
@property (strong, nonatomic) NSString *lastNamePhonetic;
@property (strong, nonatomic) NSString *organization;
@property (strong, nonatomic) NSString *jobTitle;
@property (strong, nonatomic) NSString *department;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *note;
@property (strong, nonatomic) NSString *createDate;
@property (strong, nonatomic) NSString *modificationDate;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSDictionary *email;
@property (strong, nonatomic) NSDictionary *phoneNumber;
@property (strong, nonatomic) NSDictionary *address;
*/

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
- (UIImage *) image:(NSInteger)recordID;
- (NSDictionary *) email:(NSInteger)recordID;
- (NSDictionary *) phoneNumber:(NSInteger)recordID;
- (NSDictionary *) address:(NSInteger)recordID;

@end
