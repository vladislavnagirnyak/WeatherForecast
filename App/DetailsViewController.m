//
//  DetailsViewController.m
//  App
//
//  Created by Влад Нагирняк on 15.11.15.
//  Copyright (c) 2015 Влад Нагирняк. All rights reserved.
//

#import "DetailsViewController.h"
#import "GDNetworkController.h"

@implementation DetailsViewController {
    NSDictionary *_data;
    UIActivityIndicatorView *_activity;
    NSMutableDictionary *_images;
}

- (NSString *)selectById: (NSInteger)section row:(NSInteger)row hasSection:(BOOL)hasSection outValue:(NSString *__autoreleasing*)outValue {
    NSDictionary *tmp = [_data objectForKey:@"data"];
    NSArray *tmpArr = nil;
    NSString *label = nil;
    NSString *key = nil;
    if (tmp) {
        tmpArr = [tmp objectForKey:@"weather"];
        if (tmpArr)
            tmp = [tmpArr objectAtIndex:section];
    }
    
    if (hasSection)
        return [tmp objectForKey:@"date"];
    
    switch (row) {
        case 0:
            tmpArr = [tmp objectForKey:@"hourly"];
            if (tmpArr)
                tmp = [tmpArr objectAtIndex: 0];
            tmpArr = [tmp objectForKey:@"weatherDesc"];
            if (tmpArr)
                tmp = [tmpArr objectAtIndex:0];
            if (tmp)
                label = [tmp objectForKey:@"value"];
            break;
        case 1:
            label = @"Max temp C";
            key = @"maxtempC";
            break;
        case 2:
            label = @"Min temp C";
            key = @"mintempC";
            break;
        case 3:
            label = @"Sunrise";
            tmpArr = [tmp objectForKey:@"astronomy"];
            if (tmpArr) {
                tmp = [tmpArr objectAtIndex: 0];
                key = @"sunrise";
            }
            break;
        case 4:
            label = @"Sunset";
            tmpArr = [tmp objectForKey:@"astronomy"];
            if (tmpArr) {
                tmp = [tmpArr objectAtIndex: 0];
                key = @"sunset";
            }
            break;
        case 5:
            label = @"Wind speed";
            tmpArr = [tmp objectForKey:@"hourly"];
            if (tmpArr) {
                tmp = [tmpArr objectAtIndex: 0];
                key = @"windspeedKmph";
            }
            break;
        case -1:
            tmpArr = [tmp objectForKey:@"hourly"];
            if (tmpArr)
                tmp = [tmpArr objectAtIndex: 0];
            tmpArr = [tmp objectForKey:@"weatherIconUrl"];
            if (tmpArr)
                tmp = [tmpArr objectAtIndex:0];
            if (tmp)
                label = [tmp objectForKey:@"value"];
            break;
        default:
            break;
    }
    
    if (key && tmp && outValue) {
        *outValue = [tmp objectForKey: key];
    }
    
    return label;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _images = [NSMutableDictionary new];
    
    self.title = [self.city stringByAppendingString: @" Weather Forecast"];
    
    CGRect rect = { self.view.center, 200, 200 };
    rect.origin.x -= rect.size.width * .5;
    rect.origin.y -= rect.size.height * .5;
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:rect];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _activity.color = [UIColor blueColor];
    _activity.hidesWhenStopped = YES;
    [_activity setAutoresizingMask:
     UIViewAutoresizingFlexibleLeftMargin |
     UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleTopMargin |
     UIViewAutoresizingFlexibleBottomMargin ];
    
    [self.navigationController.view addSubview:_activity];
    [_activity startAnimating];
    
    [[GDNetworkController sharedInstance] getWeatherByCity:self.city numOfDays: 6 completion:^(NSError *error, NSData *data) {
        _data = (NSDictionary*)data;
        [self.tableView reloadData];
        [_activity stopAnimating];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_activity removeFromSuperview];
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
    return [self selectById: section row: 0 hasSection:TRUE outValue:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"val";
    UITableViewCellStyle style = UITableViewCellStyleValue2;
    NSMutableString *value = nil;
    if (indexPath.row == 0) {
        ident = @"def";
        style = UITableViewCellStyleDefault;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: ident];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:ident];
    
    cell.textLabel.text = [self selectById:indexPath.section row:indexPath.row hasSection: FALSE outValue:&value];
    
    if (indexPath.row > 0)
        cell.detailTextLabel.text = value;
    else {
        NSString *imageUrl = [self selectById:indexPath.section row:-1 hasSection:FALSE outValue:nil];
        
        if (imageUrl) {
            UIImage *tmpImage = [_images objectForKey:imageUrl];
            
            if (tmpImage == [NSNull null] || tmpImage == nil) {
                cell.imageView.image = [UIImage imageNamed:@"no-image.png"];
                UIActivityIndicatorView *activImage = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                activImage.color = [UIColor blueColor];
                activImage.hidesWhenStopped = TRUE;
                activImage.frame = CGRectMake(1, 0, cell.frame.size.height, cell.frame.size.height);
                [cell.imageView addSubview: activImage];
                [activImage startAnimating];
            }
            else cell.imageView.image = tmpImage;
            
            if (![_images.allKeys containsObject:imageUrl]) {
                [_images setObject:[NSNull null] forKey:imageUrl];
                [[GDNetworkController sharedInstance] getDataByUrl:imageUrl completion:^(NSError *error, NSData *data) {
                    if (!error && data) {
                        UIImage *img = [UIImage imageWithData: data];
                        [_images setObject: img forKey:imageUrl];
                    
                        NSMutableArray *indexPaths = [NSMutableArray new];
                        NSInteger sectionCount = [self numberOfSectionsInTableView:self.tableView];
                        for (NSInteger i = 0; i < sectionCount; i++) {
                            NSString *tmpImageUrl = [self selectById:i row:-1 hasSection:FALSE outValue:nil];
                            if ([tmpImageUrl isEqualToString: imageUrl])
                                [indexPaths addObject:[NSIndexPath indexPathForRow:0 inSection:i]];
                        }
                        [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                    }
                }];
            }
        }
    }
    
    if (indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:.5f];
    else cell.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    return cell;
}

@end
