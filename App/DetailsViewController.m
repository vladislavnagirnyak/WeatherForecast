//
//  DetailsViewController.m
//  App
//
//  Created by Влад Нагирняк on 15.11.15.
//  Copyright (c) 2015 Влад Нагирняк. All rights reserved.
//

#import "DetailsViewController.h"

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self.city stringByAppendingString: @" Weather Forecast"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[NSString alloc] initWithFormat:@"Section #%ld", (long)section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (cell == nil) {
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"def"];
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"val"];
        }
    }
    else {
        if (indexPath.row == 0)
            cell = [tableView dequeueReusableCellWithIdentifier:@"def"];
        else cell = [tableView dequeueReusableCellWithIdentifier:@"val"];
    }
    
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"Row #%ld", (long)indexPath.row];
    if (indexPath.row > 0)
        cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"Details #%ld", (long)indexPath.section];
    
    if (indexPath.row % 2 == 0)
        cell.backgroundColor = [[UIColor alloc] initWithWhite:1 alpha:.5f];
    else cell.backgroundColor = [[UIColor alloc] initWithWhite:1 alpha:1];
    
    return cell;
}


@end
