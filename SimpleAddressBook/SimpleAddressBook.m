//
//  SimpleAddressBook.m
//  SimpleAB
//
//  Created by Jason Salerno on 6/23/14.
//  Copyright (c) 2014 Jason Salerno. All rights reserved.
//

#import "SimpleAddressBook.h"

@implementation SimpleAddressBook

@synthesize contactDetailList = _contactDetailList;

- (NSMutableOrderedSet *) list {
    _contactDetailList = [[NSMutableOrderedSet alloc]init];
    
    __block BOOL userDidGrantAddressBookAccess;
    CFErrorRef addressBookError = NULL;
    
    if ( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized ) {
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &addressBookError);

        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
            userDidGrantAddressBookAccess = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
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

            [_contactDetailList addObject:contactFullList];
        }
        CFRelease(addressBook);
        CFRelease(source);
    } else {
        if ( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
            ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted ) {
            // Display an error.
            [_contactDetailList setValue:@"Not authorizated to access Contact" forKey:@"ERROR"];
        }
    }
    return _contactDetailList;
}

- (NSInteger) total {
    return (long)[_contactDetailList count];
}

- (NSString *) firstName:(NSInteger)recordID {
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, (ABRecordID)recordID);
    return (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonFirstNameProperty);
    //return kFirstName;
}

@end
