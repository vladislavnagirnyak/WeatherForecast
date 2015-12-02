//
//  DetailsViewController.h
//  App
//
//  Created by Влад Нагирняк on 15.11.15.
//  Copyright (c) 2015 Влад Нагирняк. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DetailsViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property NSString *city;

@end

@interface GDItem : NSManagedObject

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) UIImage *image;

@end
