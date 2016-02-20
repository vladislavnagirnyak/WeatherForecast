//
//  CitiesViewController.h
//  App
//
//  Created by Влад Нагирняк on 10.11.15.
//  Copyright (c) 2015 Влад Нагирняк. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OnSelectCityBlock)(NSString*);

@interface CitiesViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property(readwrite, copy) OnSelectCityBlock OnSelectCity;

- (instancetype) initWithoutSelected: (NSArray*) selected NS_DESIGNATED_INITIALIZER;

@end
