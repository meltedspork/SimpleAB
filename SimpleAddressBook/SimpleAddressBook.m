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
@synthesize simpleABPerson = _simpleABPerson;

- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
        _simpleABSet = [[NSMutableDictionary alloc]init];
        _simpleABSet = [self checkSimpleAB:_simpleABSet];
        _simpleABPerson = [[NSMutableDictionary alloc]init];
        _simpleABPerson = [self checkSimpleAB:_simpleABPerson];
    }
    return self;
}

- (NSOrderedSet *) list {
    NSMutableOrderedSet *mSets = [[NSMutableOrderedSet alloc]init];
    //NSLog(@"_simpleABSet: %@",_simpleABSet);
    if ([_simpleABSet valueForKeyPath:@"ACCESS"]) {
        /*
         CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, nil, kABPersonSortByLastName);
         
         CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
         
         for (int i = 0; i < nPeople; i++) {
         ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        */
        
        
        ABAddressBookRef addressBook = (__bridge ABAddressBookRef)([_simpleABSet valueForKeyPath:@"SABRef"]);
        
        //ABRecordRef source = ABAddressBookCopyArrayOfAllSources(addressBook);
        ABRecordRef source = ABAddressBookCopyArrayOfAllSources(addressBook);
        // or get the source with ABPersonCopySource(somePersonsABRecordRef);
        //ABRecordRef source = ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        //ABAddressBookRef addressBook = ABAddressBookCreate();
        //CFArrayRef source = ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        //NSArray *arr = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByLastName);
        NSArray *arr = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, nil, kABPersonSortByLastName);
        
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
            
            NSArray *linkedRecordsArray = (__bridge NSArray *)ABPersonCopyArrayOfAllLinkedPeople(ref);
            
            NSLog(@"linked %@: %@",recordId,linkedRecordsArray);
            for( int k = 0 ; k < linkedRecordsArray.count ; k++ ) {
                NSNumber *lrecord = [NSNumber numberWithInteger: ABRecordGetRecordID((__bridge ABRecordRef)(linkedRecordsArray[k]))];
                NSLog(@"linked %@: %@",recordId,lrecord);
            }
            
          // [contactFullList setObject:linkedRecordsArray forKey:"LINKED"];
            
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
    NSLog(@"sets: %@",sets);
    return sets;
    //return [_simpleABSet valueForKeyPath:@"LIST"];
}

//- (NSArray *) showList:(NSOrderedSet *)sets {
- (NSArray *) showList {
    if ([_simpleABSet valueForKeyPath:@"LIST"] == nil) {
        NSOrderedSet *list = [self list];
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
    //NSLog(@"checked! %@",[NSString stringWithFormat:@"%ld", recordID]);
    //NSLog(@"check old value %@",[_simpleABPerson valueForKeyPath:@"Record"]);
    if (![[_simpleABPerson valueForKeyPath:@"Record"] isEqualToString:[NSString stringWithFormat:@"%ld", recordID]]) {
        //NSLog(@"not same");
        ABAddressBookRef addressBook = (__bridge ABAddressBookRef)([_simpleABPerson valueForKeyPath:@"SABRef"]);
        
        ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, (ABRecordID)recordID);
        [_simpleABPerson setValue:[NSNumber numberWithInteger:recordID] forKey:@"RecordID"];
        [_simpleABPerson setObject:(__bridge id)(person) forKey:@"SABPerson"];
        [_simpleABPerson setValue:[NSNumber numberWithInteger:recordID] forKey:@"RecordID"];
        [_simpleABPerson setValue:[NSString stringWithFormat:@"%ld", recordID] forKey:@"Record"];
        //NSLog(@"_simpleABPerson2: %@",_simpleABPerson);
        
        return person;
    }
    //NSLog(@"_simpleABPerson: %@",_simpleABPerson);
    return (__bridge ABAddressBookRef)([_simpleABPerson valueForKeyPath:@"SABPerson"]);
}

- (NSMutableDictionary *) checkSimpleAB:(NSMutableDictionary*)SABDict {
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
        
        [SABDict setObject:(__bridge id)(addressBook) forKey:@"SABRef"];
        [SABDict setValue:[NSNumber numberWithBool:YES] forKey:@"ACCESS"];
    } else {
        if ( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
            ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted ) {
            [SABDict setValue:@"Not authorizated to access Contact" forKey:@"Reason"];
            [SABDict setValue:[NSNumber numberWithBool:NO] forKey:@"ACCESS"];
        }
    }
    //NSLog(@"SABDict: %@",SABDict);
    return SABDict;
}

/* TO DO :: Try to create setter/getter
-(void) getRecord:(NSInteger)recordID {
    NSLog(@"getR: %ld",(long)recordID);
    _simpleAB = [[SimpleAddressBook alloc] init];
    [self setRecordID:recordID];
   // _simpleAB.prefix = [self prefix:recordID];
    _simpleAB.firstName = [self firstName:recordID];
    NSLog(@"%@",_simpleAB.firstName);
    _simpleAB.middleName = [self middleName:recordID];
    _simpleAB.lastName = [self lastName:recordID];
    _simpleAB.suffix = [self suffix:recordID];
    _simpleAB.nickName = [self nickName:recordID];
    _simpleAB.firstNamePhonetic = [self firstNamePhonetic:recordID];
    _simpleAB.middleNamePhonetic = [self middleNamePhonetic:recordID];
    _simpleAB.lastNamePhonetic = [self lastNamePhonetic:recordID];
    _simpleAB.organization = [self organization:recordID];
    _simpleAB.jobTitle = [self jobTitle:recordID];
    _simpleAB.department = [self department:recordID];
    _simpleAB.birthday = [self birthday:recordID];
    _simpleAB.note = [self note:recordID];
    _simpleAB.createDate = [self createDate:recordID];
    _simpleAB.modificationDate = [self modificationDate:recordID];
    _simpleAB.image = [self image:recordID];
    _simpleAB.email = [self email:recordID];
    _simpleAB.phoneNumber = [self phoneNumber:recordID];
    _simpleAB.address = [self address:recordID];
}
 */

// returns

- (NSString *) prefix:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonPrefixProperty);
}

- (NSString *) firstName:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonFirstNameProperty);
}

- (NSString *) middleName:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonMiddleNameProperty);
}

- (NSString *) lastName:(NSInteger)recordID {
    return (__bridge_transfer NSString *)ABRecordCopyValue([self checkRecordID:recordID],kABPersonLastNameProperty);
}

- (NSString *) suffix:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonSuffixProperty);
}

- (NSString *) nickName:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonNicknameProperty);
}

- (NSString *) firstNamePhonetic:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonFirstNamePhoneticProperty);
}

- (NSString *) middleNamePhonetic:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonMiddleNamePhoneticProperty);
}

- (NSString *) lastNamePhonetic:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonLastNamePhoneticProperty);
}

- (NSString *) organization:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonOrganizationProperty);
}

- (NSString *) jobTitle:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonJobTitleProperty);
}

- (NSString *) department:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonDepartmentProperty);
}

- (NSString *) birthday:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonBirthdayProperty);
}

- (NSString *) note:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonNoteProperty);
}

- (NSString *) createDate:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonCreationDateProperty);
}

- (NSString *) modificationDate:(NSInteger)recordID {
    return (__bridge_transfer NSString*)ABRecordCopyValue([self checkRecordID:recordID],kABPersonModificationDateProperty);
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
