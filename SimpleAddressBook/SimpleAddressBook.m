//
//  SimpleAddressBook.m
//  SimpleAB
//
//  Created by Jason Salerno on 6/23/14.
//  Copyright (c) 2014 Jason Salerno. All rights reserved.
//

#import "SimpleAddressBook.h"

@interface SimpleAddressBook ()
    @property (nonatomic, strong) SimpleAddressBook *simpleAB;
@end

@implementation SimpleAddressBook

@synthesize simpleABSet = _simpleABSet;
@synthesize simpleAB = _simpleAB;

- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
        _simpleABSet = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (NSOrderedSet *) list {
    NSMutableOrderedSet *mSets = [[NSMutableOrderedSet alloc]init];
    
    if ([self.checkSimpleAB valueForKeyPath:@"ACCESS"]) {
        ABAddressBookRef addressBook = (__bridge ABAddressBookRef)([self.checkSimpleAB valueForKeyPath:@"SABRef"]);
        
        //ABRecordRef source = ABAddressBookCopyArrayOfAllSources(addressBook);
        ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
            // or get the source with ABPersonCopySource(somePersonsABRecordRef);
        
        NSArray *arr = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByLastName);
        
        for( int j = 0 ; j < arr.count ; j++ ) {
            ABRecordRef ref = (__bridge ABRecordRef)[arr objectAtIndex:j];

            
            NSString* kFirstName = (__bridge_transfer NSString *)ABRecordCopyValue(ref,kABPersonFirstNameProperty);
            NSString* kLastName = (__bridge_transfer NSString*)ABRecordCopyValue(ref,kABPersonLastNameProperty);
            NSString* kFirstCharLastName = [[kLastName substringToIndex:1] uppercaseString];

            NSNumber *recordId = [NSNumber numberWithInteger: ABRecordGetRecordID(ref)];
            
            NSMutableDictionary *contactFullList = [[NSMutableDictionary alloc] init];
            
            [contactFullList setValue:kFirstCharLastName forKey:@"HEADER"];
            [contactFullList setValue:kFirstName forKey:@"FIRSTNAME"];
            [contactFullList setValue:kLastName forKey:@"LASTNAME"];
            [contactFullList setValue:recordId forKey:@"ID"];
            
            [mSets addObject:contactFullList];
            [_simpleABSet setObject:mSets forKey:@"LIST"];
        }
        CFRelease(addressBook);
        CFRelease(source);

    } else {

        // Display an error.
        [_simpleABSet setValue:@"DENIED" forKey:@"ERROR"];
    }
    NSOrderedSet *sets = [[NSOrderedSet alloc] init];
    sets = [[_simpleABSet valueForKeyPath:@"LIST"] copy];
    return sets;
    //return [_simpleABSet valueForKeyPath:@"LIST"];
}

//- (NSArray *) showList:(NSOrderedSet *)sets {
- (NSArray *) showList {
    if ([_simpleABSet valueForKeyPath:@"LIST"] == nil) {
        NSOrderedSet *list = self.list;
        #pragma unused(list)
    }
    //NSLog(@"%@",[_simpleABSet valueForKeyPath:@"LIST"]);
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"LASTNAME" ascending:YES selector:@selector(compare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObject:nameSort];
    NSArray *sortedArray = [[_simpleABSet valueForKeyPath:@"LIST"] sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}

- (NSInteger) total {
    return (long)[[_simpleABSet valueForKeyPath:@"LIST"] count];
}

- (ABRecordRef) checkRecordID:(long)recordID {
    if ((long)[_simpleABSet valueForKeyPath:@"RecordID"] != recordID) {
        [self SABRecordRef:recordID];
    }
    return (__bridge ABAddressBookRef)([self.checkSimpleAB valueForKeyPath:@"SABPerson"]);
}

- (void) SABRecordRef:(long)recordID {
    ABAddressBookRef addressBook = (__bridge ABAddressBookRef)([self.checkSimpleAB valueForKeyPath:@"SABRef"]);
    
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, (ABRecordID)recordID);
    [_simpleABSet setValue:[NSNumber numberWithInteger:recordID] forKey:@"RecordID"];
    [_simpleABSet setObject:(__bridge id)(person) forKey:@"SABPerson"];
}

- (NSMutableDictionary *) checkSimpleAB {
    __block BOOL userDidGrantAddressBookAccess;
    CFErrorRef abError = NULL;
    
    if ( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized ) {
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &abError);
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
            userDidGrantAddressBookAccess = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        [_simpleABSet setObject:(__bridge id)(addressBook) forKey:@"SABRef"];
        [_simpleABSet setValue:[NSNumber numberWithBool:YES] forKey:@"ACCESS"];
    } else {
        if ( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
            ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted ) {
            [_simpleABSet setValue:@"Not authorizated to access Contact" forKey:@"Reason"];
            [_simpleABSet setValue:[NSNumber numberWithBool:NO] forKey:@"ACCESS"];
        }
    }
    return _simpleABSet;
}

-(void) getRecord:(NSInteger)recordID {
    _simpleAB = [[SimpleAddressBook alloc] init];
    [self setRecordID:recordID];
    _simpleAB.prefix = [self prefix];
    _simpleAB.firstName = [self firstName];
    _simpleAB.middleName = [self middleName];
    _simpleAB.lastName = [self lastName];
    _simpleAB.suffix = [self suffix];
    _simpleAB.nickName = [self nickName];
    _simpleAB.firstNamePhonetic = [self firstNamePhonetic];
    _simpleAB.middleNamePhonetic = [self middleNamePhonetic];
    _simpleAB.lastNamePhonetic = [self lastNamePhonetic];
    _simpleAB.organization = [self organization];
    _simpleAB.jobTitle = [self jobTitle];
    _simpleAB.department = [self department];
    _simpleAB.birthday = [self birthday];
    _simpleAB.note = [self note];
    _simpleAB.createDate = [self createDate];
    _simpleAB.modificationDate = [self modificationDate];
    _simpleAB.image = [self image];
    _simpleAB.email = [self email];
    _simpleAB.phoneNumber = [self phoneNumber];
    _simpleAB.address = [self address];
}

- (void) setRecordID:(NSInteger)recordID {
    if (recordID != 0) {
        [_simpleABSet setValue:[NSNumber numberWithInteger:recordID] forKey:@"RecordID"];
    }
}

- (NSString *) prefix {
    return [self prefix:[[_simpleABSet valueForKeyPath:@"RecordID"] intValue]];
}

- (NSString *) firstName {
    return [self firstName:[[_simpleABSet valueForKeyPath:@"RecordID"] intValue]];
}

- (NSString *) middleName {
        return [self middleName:[[_simpleABSet valueForKeyPath:@"RecordID"] intValue]];
}

- (NSString *) lastName {
    return [self lastName:[[_simpleABSet valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) suffix {
    return [self suffix:[[_simpleABSet valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) nickName {
    return [self nickName:[[_simpleABSet valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) firstNamePhonetic {
    return [self firstNamePhonetic:[[_simpleABSet valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) middleNamePhonetic {
    return [self middleNamePhonetic:[[_simpleABSet valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) lastNamePhonetic {
    return [self lastNamePhonetic:[[_simpleABSet valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) organization {
    return [self organization:[[_simpleABSet valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) jobTitle {
    return [self jobTitle:[[_simpleABSet valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) department {
    return [self department:[[_simpleABSet valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) birthday {
    return [self birthday:[[_simpleABSet valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) note {
    return [self note:[[_simpleABSet valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) createDate {
    return [self createDate:[[_simpleABSet valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) modificationDate {
    return [self modificationDate:[[_simpleABSet valueForKeyPath:@"RecordID"]intValue]];
}

- (UIImage *) image {
    return [self image:[[_simpleABSet valueForKeyPath:@"RecordID"]intValue]];
}

- (NSDictionary *) email {
    return [self email:[[_simpleABSet valueForKeyPath:@"RecordID"]intValue]];
}

- (NSDictionary *) phoneNumber {
    return [self phoneNumber:[[_simpleABSet valueForKeyPath:@"RecordID"]intValue]];
}

- (NSDictionary *) address {
    return [self address:[[_simpleABSet valueForKeyPath:@"RecordID"]intValue]];
}


// returns
- (NSString *) prefix:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonPrefixProperty)? nil : @"";
}

- (NSString *) firstName:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonFirstNameProperty)? nil : @"";
}

- (NSString *) middleName:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonMiddleNameProperty)? nil : @"";
}

- (NSString *) lastName:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonLastNameProperty)? nil : @"";
}

- (NSString *) suffix:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonSuffixProperty)? nil : @"";
}

- (NSString *) nickName:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonNicknameProperty)? nil : @"";
}

- (NSString *) firstNamePhonetic:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonFirstNamePhoneticProperty)? nil : @"";
}

- (NSString *) middleNamePhonetic:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonMiddleNamePhoneticProperty)? nil : @"";
}

- (NSString *) lastNamePhonetic:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonLastNamePhoneticProperty)? nil : @"";
}

- (NSString *) organization:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonOrganizationProperty)? nil : @"";
}

- (NSString *) jobTitle:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonJobTitleProperty)? nil : @"";
}

- (NSString *) department:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonDepartmentProperty)? nil : @"";
}

- (NSString *) birthday:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonBirthdayProperty)? nil : @"";
}

- (NSString *) note:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonNoteProperty)? nil : @"";
}

- (NSString *) createDate:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonCreationDateProperty)? nil : @"";
}

- (NSString *) modificationDate:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonModificationDateProperty)? nil : @"";
}

- (UIImage *) image:(NSInteger)recordID {
    return [UIImage imageWithData:(__bridge_transfer NSData *)ABPersonCopyImageData([self checkRecordID:recordID])];
}

- (NSDictionary *) phoneNumber:(NSInteger)recordID {
    NSMutableDictionary *phoneNumbers = [[NSMutableDictionary alloc] init];
    
    ABMultiValueRef phoneRecord = ABRecordCopyValue([self checkRecordID:recordID],            kABPersonPhoneProperty);
    
    if (ABMultiValueGetCount(phoneRecord) > 0) {
        for (int i=0; i < ABMultiValueGetCount(phoneRecord); i++) {
            
            [phoneNumbers setValue:[[NSString alloc] initWithFormat:@"%@",ABAddressBookCopyLocalizedLabel( ABMultiValueCopyLabelAtIndex( phoneRecord,i))] forKey:[[NSString alloc] initWithFormat:@"%@",ABAddressBookCopyLocalizedLabel( ABMultiValueCopyLabelAtIndex( phoneRecord,i))]];
            CFRelease(ABAddressBookCopyLocalizedLabel( ABMultiValueCopyLabelAtIndex( phoneRecord,i)));
            
        }
    }
    
    CFRelease(phoneRecord);
    NSDictionary *phones = [[NSDictionary alloc] init];
    phones = [phoneNumbers copy];
    return phones;
}

- (NSDictionary *) email:(NSInteger)recordID {
    NSMutableDictionary *emails = [[NSMutableDictionary alloc] init];
    
    ABMultiValueRef emailRecord = ABRecordCopyValue([self checkRecordID:recordID],kABPersonEmailProperty);
    
    if (ABMultiValueGetCount(ABRecordCopyValue([self checkRecordID:recordID],kABPersonEmailProperty)) > 0) {
        for (int i=0; i < ABMultiValueGetCount(emailRecord); i++) {

            [emails setValue:[[NSString alloc] initWithFormat:@"%@",ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(emailRecord,i))] forKey:[[NSString alloc] initWithFormat:@"%@",(__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(emailRecord, i)]];
        }
    }

    CFRelease(emailRecord);
    NSDictionary *email = [[NSDictionary alloc] init];
    email = [emails copy];
    return email;
}

- (NSDictionary *) address:(NSInteger)recordID {
    NSMutableDictionary *addresses = [[NSMutableDictionary alloc] init];
    
    ABMultiValueRef addressRecord = ABRecordCopyValue([self checkRecordID:recordID], kABPersonAddressProperty);
    
    if (ABMultiValueGetCount(addressRecord) > 0) {
        for (int i=0; i < ABMultiValueGetCount(addressRecord); i++) {
            NSMutableDictionary * fullAddress = [[NSMutableDictionary alloc] init];
            
            CFDictionaryRef dictRef = ABMultiValueCopyValueAtIndex(addressRecord,i);
            
            if ((__bridge_transfer NSString*)CFDictionaryGetValue(dictRef, kABPersonAddressStreetKey) != nil) {
                
                [fullAddress setValue:[[NSString alloc] initWithFormat:@"%@", (__bridge_transfer NSString*)CFDictionaryGetValue(dictRef, kABPersonAddressStreetKey)] forKey:@"STREET"];
            }
            if ((__bridge_transfer NSString*)CFDictionaryGetValue(dictRef, kABPersonAddressCityKey) != nil) {
                
                [fullAddress setValue:[[NSString alloc] initWithFormat:@"%@",(__bridge_transfer NSString*)CFDictionaryGetValue(dictRef,kABPersonAddressCityKey)] forKey:@"CITY"];
            }
            if ((__bridge_transfer NSString*)CFDictionaryGetValue(dictRef, kABPersonAddressStateKey) != nil) {
        
                [fullAddress setValue:[[NSString alloc] initWithFormat:@"%@",(__bridge_transfer NSString*)CFDictionaryGetValue(dictRef, kABPersonAddressStateKey)] forKey:@"STATE"];
            }
            if ((__bridge_transfer NSString*)CFDictionaryGetValue(dictRef, kABPersonAddressZIPKey) != nil) {
                
                [fullAddress setValue:[[NSString alloc] initWithFormat:@"%@",(__bridge_transfer NSString*)CFDictionaryGetValue(dictRef, kABPersonAddressZIPKey)] forKey:@"ZIP"];
            }
            if ((__bridge_transfer NSString*)CFDictionaryGetValue(dictRef, kABPersonAddressCountryKey) != nil) {
                
                [fullAddress setValue:[[NSString alloc] initWithFormat:@"%@",(__bridge_transfer NSString*)CFDictionaryGetValue(dictRef, kABPersonAddressCountryKey)] forKey:@"COUNTRY"];
            }
            //NSLog(@"fullAddress:%@",fullAddress);
            
            /* NSString *kAddress = [[NSString alloc] initWithFormat:@"%@",(__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(address, i)];*/
            [addresses setValue:fullAddress forKey:[[NSString alloc] initWithFormat:@"%@",ABAddressBookCopyLocalizedLabel( ABMultiValueCopyLabelAtIndex( addressRecord,i))]];
            CFRelease(dictRef);
            //if(!dictRef) CFRelease(dictRef);
        }
    }
    CFRelease(addressRecord);
    NSDictionary *address = [[NSDictionary alloc] init];
    address = [addresses copy];
    return address;
}


@end
