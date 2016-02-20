//
//  ViewController.m
//  App
//
//  Created by Влад Нагирняк on 27.10.15.
//  Copyright (c) 2015 Влад Нагирняк. All rights reserved.
//

#import "ViewController.h"
#import "CitiesViewController.h"
#import "DetailsViewController.h"
#import "inc.h"

#define CITIES_PATH NS_IN_DOCUMENTS(@"SelectedCities.plist")

@interface ViewController () <UIGestureRecognizerDelegate>
@end

@implementation ViewController {
    NSMutableArray *_data;
}

- (void) onCitiesInit: (NSNotification*)notify {
    CitiesViewController *cities = notify.object;
    cities = [cities initWithoutSelected:_data];
    __weak CitiesViewController *wc = cities;
    cities.OnSelectCity = ^(NSString *item) {
        [_data addObject:item];
        [self.tableView reloadData];
        [_data writeToFile:CITIES_PATH atomically:TRUE];
        [wc.navigationController popViewControllerAnimated:TRUE];
        //[wc performSegueWithIdentifier:@"BackToMainSegue" sender:nil];
    };
}

- (void) onCitySet:(NSNotification*)notify {
    DetailsViewController *details = notify.object;
    if (details)
        details.city = [_data objectAtIndex:self.tableView.indexPathForSelectedRow.row];
}

- (void)swiped:(UISwipeGestureRecognizer *)swipe {
    if (swipe.state == UIGestureRecognizerStateEnded &&
        swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self performSegueWithIdentifier:@"ShowMapSegue" sender:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCitiesInit:) name: @"InitCities" object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCitySet:) name: @"detailCity" object: nil];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    swipe.delegate = self;
    [self.view addGestureRecognizer:swipe];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    NSData *plistData = [NSData dataWithContentsOfFile:NS_IN_DOCUMENTS(@"SelectedCities.plist")];
    if (plistData) {
        NSError *error = nil;
        _data = (NSMutableArray *)[NSPropertyListSerialization propertyListWithData:plistData
                                                                        options:NSPropertyListMutableContainersAndLeaves
                                                                         format:nil
                                                                          error:&error];
        if (error)
            NSLog(@"error: %@", error);
    }
    else _data = [NSMutableArray array];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_data removeObjectAtIndex:indexPath.row];
        [_data writeToFile:CITIES_PATH atomically:TRUE];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //add code here for when you hit delete
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"SelectCityId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    if (indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:.4f];
    else cell.backgroundColor = [UIColor colorWithWhite:1 alpha:.7f];
    
    cell.textLabel.text = [_data objectAtIndex:indexPath.row];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%@", @"ViewController is destroyed");
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
