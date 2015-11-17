//
//  CitiesViewController.m
//  App
//
//  Created by Влад Нагирняк on 10.11.15.
//  Copyright (c) 2015 Влад Нагирняк. All rights reserved.
//

#import "CitiesViewController.h"

@interface CitiesViewController ()

@end

@implementation CitiesViewController {
    NSMutableArray *_data;
}

- (instancetype) initWithoutSelected: (NSArray*) selected {
    if (self = [super init]) {
        self.title = @"Cities";
        NSData *plistData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DefaultCities" ofType:@"plist"]];
        NSError *error = nil;
        _data = (NSMutableArray *)[NSPropertyListSerialization propertyListWithData:plistData
                                                                 options:NSPropertyListMutableContainersAndLeaves
                                                                  format:nil
                                                                   error:&error];
    
        [_data removeObjectsInArray:selected];
    
        if (error)
            NSLog(@"error: %@", error);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    if (self.OnSelectCity)
        self.OnSelectCity([_data objectAtIndex:indexPath.row]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    if (indexPath.row % 2 == 0)
        cell.backgroundColor = [[UIColor alloc] initWithWhite:.85f alpha:1.f];
    else cell.backgroundColor = [[UIColor alloc] initWithWhite:1.f alpha:1.f];
    
    cell.textLabel.text = [_data objectAtIndex:indexPath.row];
    return cell;
}

@end
