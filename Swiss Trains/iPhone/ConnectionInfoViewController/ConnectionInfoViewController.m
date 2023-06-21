//
//  ConnectionInfoViewController.m
//  Swiss Trains
//
//  Created by Alain on 28.12.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "ConnectionInfoViewController.h"

@interface ConnectionInfoViewController ()

@end

@implementation ConnectionInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        self.tableView.backgroundColor = [UIColor greyBackgroundPatternImageColor];
        
        //self.view.frame = CGRectMake(0, 0, 200, 300);
    
        self.tableView.rowHeight = 50;
        //self.overViewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorColor = [UIColor lightGrayColor];
        self.tableView.backgroundColor = [UIColor overviewTableviewBackgroundColor];
        //self.overViewTableView.backgroundColor = [UIColor blackColor];
        [self.tableView registerClass:[ConnectionInfoCell class] forCellReuseIdentifier: @"ConnectionInfoCell"];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        //UIView *dummyHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
        UIView *dummyFooterView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
        
        self.tableView.tableFooterView = dummyFooterView;
        //self.tableView.tableHeaderView = dummyHeaderView;
    }
    return self;
}

- (void) updateConnectionInfoTableViewWithInfoFromConnectionWithIndex:(NSUInteger)index {
    self.selectedIndex = index;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([[SBBAPIController sharedSBBAPIController] getNumberOfConnectionInfosForConnectionResultWithIndex: self.selectedIndex]) {
        NSLog(@"Connection infos, number of rowns: %d", [[SBBAPIController sharedSBBAPIController] getNumberOfConnectionInfosForConnectionResultWithIndex: self.selectedIndex]);
        return [[SBBAPIController sharedSBBAPIController] getNumberOfConnectionInfosForConnectionResultWithIndex: self.selectedIndex];
    }
    return 0;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    ConnectionInfo *connectionInfo = [[SBBAPIController sharedSBBAPIController] getConnectioninfoForConnectionResultWithIndexAndConnectioninfoIndex: self.selectedIndex infoIndex: indexPath.row];
    ConnectionInfoCell *connectionInfoCell = (ConnectionInfoCell *)cell;
    
    [connectionInfoCell setConnectionInfoText: connectionInfo.text];    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConnectionInfo *connectionInfo = [[SBBAPIController sharedSBBAPIController] getConnectioninfoForConnectionResultWithIndexAndConnectioninfoIndex: self.selectedIndex infoIndex: indexPath.row];
    NSString *infoText = connectionInfo.text;
    return [ConnectionInfoCell neededHeightForInfo: infoText constrainedToWidth:tableView.bounds.size.width];
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"Dequeue connectioninfo cell");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConnectionInfoCell"];

    [self configureCell: cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath: indexPath animated:NO];
}

// override to support editing the table view
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return  NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
