//
//  DetailsViewController.m
//  App
//
//  Created by Влад Нагирняк on 15.11.15.
//  Copyright (c) 2015 Влад Нагирняк. All rights reserved.
//

#import "DetailsViewController.h"
#import "NVNetworkController.h"
#import <CoreData/CoreData.h>

@implementation DetailsViewController {
    NSDictionary *_data;
    UIActivityIndicatorView *_activity;
    NSMutableDictionary *_images;
    NSManagedObjectContext *_dbCont;
    
    /*NSString*(^date)(NSInteger section);
    NSString*(^weatherDesc)(NSInteger section);
    NSString*(^maxTemp)(NSInteger section);
    NSString*(^minTemp)(NSInteger section);
    NSString*(^sunrise)(NSInteger section);
    NSString*(^sunset)(NSInteger section);
    NSString*(^windSpeed)(NSInteger section);
    NSString*(^iconUrl)(NSInteger section);*/
    
}

/*- (void) loadWeather {
    NSDictionary *tmp = [_data objectForKey:@"data"];
    NSArray *tmpArr = tmp ? [tmp objectForKey:@"weather"] : nil;
    
    NSDictionary*(^hourly)(NSInteger section) = ^(NSInteger section) {
        NSDictionary *bTmp = [tmpArr objectAtIndex:section];
        NSArray *wdTmpArr = bTmp ? [bTmp objectForKey:@"hourly"] : nil;
        return wdTmpArr ? [wdTmpArr objectAtIndex:0] : nil;
    };
    
    NSDictionary*(^astronomy)(NSInteger section) = ^(NSInteger section) {
        NSDictionary *bTmp = [tmpArr objectAtIndex:section];
        NSArray *wdTmpArr = bTmp ? [bTmp objectForKey:@"astronomy"] : nil;
        return wdTmpArr ? [wdTmpArr objectAtIndex:0] : nil;
    };
    
    date = ^(NSInteger section) {
        NSDictionary *wfs = [tmpArr objectAtIndex:section];
        return [wfs objectForKey:@"date"];
    };
    
    weatherDesc = ^(NSInteger section) {
        NSDictionary *bTmp = hourly(section);
        NSArray *wdTmpArr = bTmp ? [bTmp objectForKey:@"weatherDesc"] : nil;
        bTmp = wdTmpArr ? [wdTmpArr objectAtIndex: 0] : nil;
        return bTmp ? [bTmp objectForKey:@"value"] : nil;
    };
    
    maxTemp = ^(NSInteger section) {
        NSDictionary *bTmp = [tmpArr objectAtIndex:section];
        return bTmp ? [bTmp objectForKey:@"maxtempC"] : nil;
    };
    
    minTemp = ^(NSInteger section) {
        NSDictionary *bTmp = [tmpArr objectAtIndex:section];
        return bTmp ? [bTmp objectForKey:@"mintempC"] : nil;
    };
    
    sunrise = ^(NSInteger section) {
        NSDictionary *bTmp = astronomy(section);
        return bTmp ? [bTmp objectForKey:@"sunrise"] : nil;
    };
    
    sunset = ^(NSInteger section) {
        NSDictionary *bTmp = astronomy(section);
        return bTmp ? [bTmp objectForKey:@"sunset"] : nil;
    };
    
    windSpeed = ^(NSInteger section) {
        NSDictionary *bTmp = hourly(section);
        return bTmp ? [bTmp objectForKey:@"windspeedKmph"] : nil;
    };
    
    iconUrl = ^(NSInteger section) {
        NSDictionary *bTmp = hourly(section);
        NSArray *bTmpArr = bTmp ? [bTmp objectForKey:@"weatherIconUrl"] : nil;
        bTmp = bTmpArr ? [bTmpArr objectAtIndex:0] : nil;
        return bTmp ? [bTmp objectForKey:@"value"] : nil;
    };
}*/

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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"detailCity" object:self];
    
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
    
    [[NVNetworkController sharedInstance] getWeatherByQuery:self.city numOfDays: 6 completion:^(NSError *error, NSData *data) {
        if (!error && data) {
            _data = (NSDictionary*)data;
            [self.tableView reloadData];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: [NSString stringWithFormat:@"Error (%ld)", (long)error.code] message:error.description delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:TRUE];
        }
        [_activity stopAnimating];
    }];
    
    _dbCont = [self coreDataInit];
}

- (NSManagedObjectContext*)coreDataInit {
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"WeatherModel" withExtension:@"momd"]];
    
    NSPersistentStoreCoordinator *coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    
    NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"WeatherModel.sqlite"];
    
    NSError *error = nil;
    if (![coord addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error])
        NSLog(@"%@", error);
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:coord];
    
    return context;
}

- (void) saveImage: (UIImage*)image url:(NSString*)url {
    NSManagedObjectContext *context = _dbCont;
    NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:@"Images" inManagedObjectContext:context];
    [obj setValue:url forKey:@"url"];
    [obj setValue:image forKey:@"image"];
    NSError *error = nil;
    if ([context save: &error])
        NSLog(@"%@", error);
}

- (UIImage*) selectImageByUrl: (NSString*)url {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Images"
                                              inManagedObjectContext:_dbCont];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@", url];
    [fetchRequest setPredicate:predicate];
    
    UIImage *img = nil;
    NSError *error;
    NSArray *fetchedObjects = [[_dbCont executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (fetchedObjects == nil) {
        NSLog(@"%@", error);
    }
    else if (fetchedObjects.count > 0) {
        NSManagedObject *obj = fetchedObjects[0];
        img = [obj valueForKey:@"image"];
    }
    
    return img;
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
            if (tmpImage == [NSNull null])
                tmpImage = nil;

            if (!tmpImage) {
                tmpImage = [self selectImageByUrl:imageUrl];
                if (tmpImage)
                    [_images setObject:tmpImage forKey:imageUrl];
            }
            
            if (!tmpImage) {
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
                [[NVNetworkController sharedInstance] getDataByUrl:imageUrl completion:^(NSError *error, NSData *data) {
                    if (!error && data) {
                        UIImage *img = [UIImage imageWithData: data];
                        [self saveImage:img url:imageUrl];
                        
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
