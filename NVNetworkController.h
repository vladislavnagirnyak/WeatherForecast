//
//  GDNetworkController.h
//  App
//
//  Created by Влад Нагирняк on 18.11.15.
//  Copyright (c) 2015 Влад Нагирняк. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NVNetworkController : NSObject

- (void) getWeatherByQuery: (NSString*) query numOfDays: (NSInteger)numOfDays completion: (void(^)(NSError *error, id responseObject))completion;
- (void) getDataByUrl: (NSString*) url completion: (void(^)(NSError *error, NSData *data)) completion;

+ (instancetype) sharedInstance;

@end
