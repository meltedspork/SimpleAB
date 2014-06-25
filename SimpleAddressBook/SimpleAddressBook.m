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

- (NSMutableDictionary *) list {
    if (!_simpleAB) {
        _simpleAB = [[NSMutableDictionary alloc]init];
    }
    NSMutableOrderedSet *contactDetailList = [[NSMutableOrderedSet alloc]init];
    
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
            [contactFullList setValue:kFirstName forKey:@"FIRST"];
            [contactFullList setValue:kLastName forKey:@"LAST"];
            [contactFullList setValue:recordId forKey:@"ID"];
            
            [contactDetailList addObject:contactFullList];
            [_simpleAB setObject:contactDetailList forKey:@"LIST"];
        }
        CFRelease(addressBook);
        CFRelease(source);

    } else {

        // Display an error.
        [_simpleAB setValue:@"DENIED" forKey:@"ERROR"];
    }
    return [_simpleAB valueForKeyPath:@"LIST"];
}

- (NSInteger) total {
    return (long)[[_simpleAB valueForKeyPath:@"LIST"][0] count];
}

- (NSString *) firstName:(NSInteger)recordID {
    ABRecordRef person = [self SABRecordRef:recordID];
    return (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonFirstNameProperty);
}

- (NSString *) lastName:(NSInteger)recordID {
    ABRecordRef person = [self SABRecordRef:recordID];
    return (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonLastNameProperty);
}

- (NSString *) birthDay:(NSInteger)recordID {
    ABRecordRef person = [self SABRecordRef:recordID];
    return (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonBirthdayProperty);
}

- (ABRecordRef) SABRecordRef:(long)recordID {
    ABAddressBookRef addressBook = (__bridge ABAddressBookRef)([self.checkSimpleAB valueForKeyPath:@"SABRef"]);
    return ABAddressBookGetPersonWithRecordID(addressBook, (ABRecordID)recordID);
}

- (NSMutableDictionary *) checkSimpleAB {
    if (!_simpleAB) {
        _simpleAB = [[NSMutableDictionary alloc]init];
    }
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

@end
