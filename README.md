SimpleAB
========

Simple Address Book library for iOS 7

This is very early stage but I aim to make this library very easy to import and only thing you would have to worry about is know which function to use.

to use this library.


_simpleAB = [[SimpleAddressBook alloc] init];


NSLog(@"%ld",_simpleAB.total); // returns the total of contacts (including linked cards)


NSMutableOrderedSet* theList = _simpleAB.list;
NSLog(@"%@",theList); // returns all contacts (including linked cards)

More to come!
