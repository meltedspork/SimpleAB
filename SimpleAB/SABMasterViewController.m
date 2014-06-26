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
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    NSLog(@"-------------------------------------");
    NSLog(@"List: %@",[_simpleAB list]);
    NSLog(@"Total: %ld",[_simpleAB total]);
    
    NSLog(@"------------ method with recordID----------------");
    NSLog(@"[_simpleAB firstName:1]: %@",[_simpleAB firstName:1]);
    NSLog(@"[_simpleAB middleName:1]: %@",[_simpleAB middleName:1]);
    NSLog(@"[_simpleAB lastName:1]: %@",[_simpleAB lastName:1]);
    NSLog(@"[_simpleAB birthday:1]: %@",[_simpleAB birthday:1]);
    
    NSLog(@"------------ method with setRecordID----------------");
    [_simpleAB setRecordID:2];
    NSLog(@"[_simpleAB setRecordID:2]");
    NSLog(@"[_simpleAB firstName]: %@",[_simpleAB firstName]);
    NSLog(@"[_simpleAB middleName]: %@",[_simpleAB middleName]);
    NSLog(@"[_simpleAB lastName]: %@",[_simpleAB lastName]);
    NSLog(@"[_simpleAB birthday]: %@",[_simpleAB birthday]);
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

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

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

    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
