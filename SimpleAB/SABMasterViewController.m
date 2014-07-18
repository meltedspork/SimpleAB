//
//  SABMasterViewController.m
//  SimpleAB
//
//  Created by Jason Salerno (MeltedSpork) on 6/23/14.
//  Copyright (c) 2014 Jason Salerno. All rights reserved.
//

#import "SABMasterViewController.h"
#import "SABDetailViewController.h"


@interface SABMasterViewController () {
    NSMutableArray *_objects;
    SimpleAddressBook *_simpleAB;
}
@end

@implementation SABMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _simpleAB = [[SimpleAddressBook alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

   // UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    
    //NSLog(@"-------------------------");
    //NSLog(@"List: %@",[_simpleAB list]);
    //[_simpleAB list];

    /*
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"LASTNAME" ascending:YES selector:@selector(compare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObject:nameSort];
    _objects2 = [[_simpleAB list] sortedArrayUsingDescriptors:sortDescriptors];
     */

    //NSLog(@"showList: %@",[_simpleAB showList]);
    _objects = [[_simpleAB showList] mutableCopy];
    //NSLog(@"_objects: %@",_objects);
    
    //NSLog(@"Total: %ld",[_simpleAB total]);
    /*
    NSLog(@"------------ method with recordID");
    NSLog(@"[_simpleAB firstName:1]: %@",[_simpleAB firstName:1]);
    NSLog(@"[_simpleAB middleName:1]: %@",[_simpleAB middleName:1]);
    NSLog(@"[_simpleAB lastName:1]: %@",[_simpleAB lastName:1]);
    NSLog(@"[_simpleAB birthday:1]: %@",[_simpleAB birthday:1]);
    NSLog(@"Email: %@",[_simpleAB email:1]);
    
    NSLog(@"------------ method with setRecordID");*/
    //[_simpleAB getRecord:2];
    //NSLog(@"_simpleAB.firstName: %@",_simpleAB.firstName);
    
}

/*
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSMutableOrderedSet* theList = [SimpleAddressBook contactList];
    NSLog(@"reloaded!");
    NSLog(@"%@",theList);
}
*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
*/
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *firstName = [_objects[indexPath.row] valueForKeyPath:@"FIRSTNAME"];
    NSString *lastName = [_objects[indexPath.row] valueForKeyPath:@"LASTNAME"];
    cell.textLabel.text = [NSString stringWithFormat: @"%@ %@", firstName, lastName];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
*/



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSNumber *recordID = [_objects[indexPath.row] valueForKeyPath:@"ID"];
        //[[segue destinationViewController] setDetailItem:recordID];
        SABDetailViewController *SABDetail = (SABDetailViewController *)[segue destinationViewController];
        SABDetail.recordID = [recordID stringValue];
    }
}

@end
