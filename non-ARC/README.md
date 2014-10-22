SimpleAB
========

####Simple Address Book library for iOS 7

This is very early stage but I aim to make this library very easy to import (yes, it means no framework!) and only thing you would have to worry about is take those two files into your project and know which method to use.


###to use this library.

```
_simpleAB = [[SimpleAddressBook alloc] init];


NSLog(@"%ld",[_simpleAB total]); // returns the total of contacts (including linked cards)

```

```
NSLog(@"%@", [_simpleAB list]); // returns all contacts (including linked cards)
```

###List of methods that you can use..
```
- (NSMutableOrderedSet *) list;
- (NSInteger) total;


// an method to define record ID for the methods without parameters

// for an method with record ID as parameter
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
```

More to come!
