//
//  SimpleAddressBook.m
//  SimpleAB
//
//  Created by Jason Salerno on 6/23/14.
//  Copyright (c) 2014 Jason Salerno. All rights reserved.
//

#import "SimpleAddressBook.h"

@implementation SimpleAddressBook

@synthesize simpleABSet = _simpleAB;

- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
        _simpleAB = [[NSMutableDictionary alloc]init];
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
            [_simpleAB setObject:mSets forKey:@"LIST"];
        }
        CFRelease(addressBook);
        CFRelease(source);

    } else {

        // Display an error.
        [_simpleAB setValue:@"DENIED" forKey:@"ERROR"];
    }
    NSOrderedSet *sets = [[NSOrderedSet alloc] init];
    sets = [[_simpleAB valueForKeyPath:@"LIST"] copy];
    return sets;
    //return [_simpleAB valueForKeyPath:@"LIST"];
}

//- (NSArray *) showList:(NSOrderedSet *)sets {
- (NSArray *) showList {
    if ([_simpleAB valueForKeyPath:@"LIST"] == nil) {
        NSOrderedSet *list = self.list;
        #pragma unused(list)
    }
    //NSLog(@"%@",[_simpleAB valueForKeyPath:@"LIST"]);
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"LASTNAME" ascending:YES selector:@selector(compare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObject:nameSort];
    NSArray *sortedArray = [[_simpleAB valueForKeyPath:@"LIST"] sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}

- (NSInteger) total {
    return (long)[[_simpleAB valueForKeyPath:@"LIST"] count];
}

- (ABRecordRef) checkRecordID:(long)recordID {
    if ((long)[_simpleAB valueForKeyPath:@"RecordID"] != recordID) {
        [self SABRecordRef:recordID];
    }
    return (__bridge ABAddressBookRef)([self.checkSimpleAB valueForKeyPath:@"SABPerson"]);
}

- (void) SABRecordRef:(long)recordID {
    ABAddressBookRef addressBook = (__bridge ABAddressBookRef)([self.checkSimpleAB valueForKeyPath:@"SABRef"]);
    
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, (ABRecordID)recordID);
    [_simpleAB setValue:[NSNumber numberWithInteger:recordID] forKey:@"RecordID"];
    [_simpleAB setObject:(__bridge id)(person) forKey:@"SABPerson"];
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
        
        [_simpleAB setObject:(__bridge id)(addressBook) forKey:@"SABRef"];
        [_simpleAB setValue:[NSNumber numberWithBool:YES] forKey:@"ACCESS"];
    } else {
        if ( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
            ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted ) {
            [_simpleAB setValue:@"Not authorizated to access Contact" forKey:@"Reason"];
            [_simpleAB setValue:[NSNumber numberWithBool:NO] forKey:@"ACCESS"];
        }
    }
    return _simpleAB;
}

- (void) setRecordID:(NSInteger)recordID {
    if (recordID != 0) {
        [_simpleAB setValue:[NSNumber numberWithInteger:recordID] forKey:@"RecordID"];
    }
}

- (NSString *) prefix {
    return [self prefix:[[_simpleAB valueForKeyPath:@"RecordID"] intValue]];
}

- (NSString *) firstName {
    return [self firstName:[[_simpleAB valueForKeyPath:@"RecordID"] intValue]];
}

- (NSString *) middleName {
        return [self middleName:[[_simpleAB valueForKeyPath:@"RecordID"] intValue]];
}

- (NSString *) lastName {
    return [self lastName:[[_simpleAB valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) suffix {
    return [self suffix:[[_simpleAB valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) nickName {
    return [self nickName:[[_simpleAB valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) firstNamePhonetic {
    return [self firstNamePhonetic:[[_simpleAB valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) middleNamePhonetic {
    return [self middleNamePhonetic:[[_simpleAB valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) lastNamePhonetic {
    return [self lastNamePhonetic:[[_simpleAB valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) organization {
    return [self organization:[[_simpleAB valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) jobTitle {
    return [self jobTitle:[[_simpleAB valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) department {
    return [self department:[[_simpleAB valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) birthday {
    return [self birthday:[[_simpleAB valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) note {
    return [self note:[[_simpleAB valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) createDate {
    return [self createDate:[[_simpleAB valueForKeyPath:@"RecordID"]intValue]];
}

- (NSString *) modificationDate {
    return [self modificationDate:[[_simpleAB valueForKeyPath:@"RecordID"]intValue]];
}

- (UIImage *) image {
    return [self image:[[_simpleAB valueForKeyPath:@"RecordID"]intValue]];
}

- (NSMutableDictionary *) email {
    return [self email:[[_simpleAB valueForKeyPath:@"RecordID"]intValue]];
}

- (NSMutableDictionary *) phoneNumber {
    return [self phoneNumber:[[_simpleAB valueForKeyPath:@"RecordID"]intValue]];
}

- (NSMutableDictionary *) address {
    return [self address:[[_simpleAB valueForKeyPath:@"RecordID"]intValue]];
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

- (NSMutableDictionary *) phoneNumber:(NSInteger)recordID {
    NSMutableDictionary *phoneNumbers = [[NSMutableDictionary alloc] init];
    
    ABMultiValueRef phoneRecord = ABRecordCopyValue([self checkRecordID:recordID],            kABPersonPhoneProperty);
    
    if (ABMultiValueGetCount(phoneRecord) > 0) {
        for (int i=0; i < ABMultiValueGetCount(phoneRecord); i++) {
            
            [phoneNumbers setValue:[[NSString alloc] initWithFormat:@"%@",ABAddressBookCopyLocalizedLabel( ABMultiValueCopyLabelAtIndex( phoneRecord,i))] forKey:[[NSString alloc] initWithFormat:@"%@",ABAddressBookCopyLocalizedLabel( ABMultiValueCopyLabelAtIndex( phoneRecord,i))]];
            CFRelease(ABAddressBookCopyLocalizedLabel( ABMultiValueCopyLabelAtIndex( phoneRecord,i)));
            
        }
    }
    
    CFRelease(phoneRecord);
    return phoneNumbers;
}

- (NSMutableDictionary *) email:(NSInteger)recordID {
    NSMutableDictionary *emails = [[NSMutableDictionary alloc] init];
    
    ABMultiValueRef emailRecord = ABRecordCopyValue([self checkRecordID:recordID],kABPersonEmailProperty);
    
    if (ABMultiValueGetCount(ABRecordCopyValue([self checkRecordID:recordID],kABPersonEmailProperty)) > 0) {
        for (int i=0; i < ABMultiValueGetCount(emailRecord); i++) {

            [emails setValue:[[NSString alloc] initWithFormat:@"%@",ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(emailRecord,i))] forKey:[[NSString alloc] initWithFormat:@"%@",(__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(emailRecord, i)]];
        }
    }

    CFRelease(emailRecord);
    return emails;
}

- (NSMutableDictionary *) address:(NSInteger)recordID {
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
    return addresses;
}


@end
