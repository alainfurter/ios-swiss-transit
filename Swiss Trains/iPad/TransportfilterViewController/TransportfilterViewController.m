//
//  TransportfilterViewController.m
//  Swiss Trains
//
//  Created by Alain on 30.03.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "TransportfilterViewController.h"

@implementation TransportfilterViewController

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
        [self.tableView registerClass:[CRTableViewCell class] forCellReuseIdentifier: @"CRTableViewCell"];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        //UIView *dummyHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
        UIView *dummyFooterView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
        
        self.tableView.tableFooterView = dummyFooterView;
        //self.tableView.tableHeaderView = dummyHeaderView;
        
        NSArray *transporttitles = [[NSArray alloc] initWithObjects:
                                   @"Fast trains",
                                   @"Regional trains",
                                   @"Ship",
                                   @"Bus",
                                   @"Tram",
                                   @"Funi/Cablecar",
                                   nil];
        
        self.productimagetitles = transporttitles;
        
        
        NSArray *transporttexts = [[NSArray alloc] initWithObjects:
                      @"ICE/TGV/RJ/EN/CNL/EC/IC/ICN/OEC/IR/ARZ/EXT",
                      @"RE/D/S/SN/R",
                      @"",
                      @"",
                      @"",
                      @"",
                      nil];
        
        self.productimagetexts = transporttexts;
        
        NSArray *transportimages = [[NSArray alloc] initWithObjects:
                                   @"TrainFast.png",
                                   @"Train.png",
                                   @"Ship.png",
                                   @"Bus.png",
                                   @"Tram.png",
                                   @"Funi.png",
                                   nil];
        
        self.productimagenames = transportimages;

    }
    return self;
}

- (void) updateFilterTableviewWithProductString:(NSString *)productstring {
    if (productstring) {
        NSArray *productarray = [productstring componentsSeparatedByString:@":"];
        self.productsstring = productstring;
        self.productflags = nil;
        for (NSString *flag in productarray) {
            if ([flag isEqualToString:@"1"]) {
                [self.productflags addObject: [NSNumber numberWithInt: 1]];
            } else {
                [self.productflags addObject: [NSNumber numberWithInt: 0]];
            }
        }
    }
    
    [self.tableView reloadData];
}





#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productflags count];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    CRTableViewCell *crcell = (CRTableViewCell *)cell;
    
    NSString *text = [self.productimagetitles objectAtIndex:[indexPath row]];
    crcell.isSelected = [[self.productflags objectAtIndex: [indexPath row]] integerValue] == 1;
    crcell.textLabel.text = text;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CRTableViewCell"];
    
    [self configureCell: cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.productflags objectAtIndex: [indexPath row]] integerValue] == 1)// Is selected?
        [self.productflags replaceObjectAtIndex:[indexPath row] withObject: [NSNumber numberWithInt: 0]];
    else
        [self.productflags replaceObjectAtIndex:[indexPath row] withObject: [NSNumber numberWithInt: 1]];
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
