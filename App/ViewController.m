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

@interface ViewController ()
@end

@implementation ViewController {
    NSMutableArray *_data;
    UIBarButtonItem *_listBtn;
}

- (void)displayListCities {
    CitiesViewController *list = [[CitiesViewController alloc] initWithoutSelected:_data];
    list.OnSelectCity = ^(NSString *item) {
        [_data addObject:item];
        [self.tableView reloadData];
        [_data writeToFile:CITIES_PATH atomically:TRUE];
        [self.navigationController popViewControllerAnimated:TRUE];
        //[self dismissViewControllerAnimated:TRUE completion:nil];
    };
    [self.navigationController pushViewController:list animated:TRUE];
    //[self presentViewController:[[UINavigationController alloc] initWithRootViewController: list ] animated:TRUE completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _listBtn = [[UIBarButtonItem alloc]
             initWithTitle:@"Add"
             style:UIBarButtonItemStylePlain
             target:self
             action:@selector(displayListCities)];
    
    self.navigationItem.rightBarButtonItem = _listBtn;
    self.title = @"Selected cities";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsViewController *details = [[DetailsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    details.city = [_data objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:details animated:TRUE];

    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"root";
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

@end
