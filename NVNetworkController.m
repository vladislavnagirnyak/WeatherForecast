//
//  GDNetworkController.m
//  App
//
//  Created by Влад Нагирняк on 18.11.15.
//  Copyright (c) 2015 Влад Нагирняк. All rights reserved.
//

#import "NVNetworkController.h"

NSString * const g_URL = @"https://api.worldweatheronline.com/free/v2/weather.ashx";
NSString * const g_Key = @"c4b2ec4188e24e488a9abbbcdf2ca";

@implementation NVNetworkController

- (void) getWeatherByQuery: (NSString*) query numOfDays: (NSInteger)numOfDays completion: (void(^)(NSError *error, id responseObject))completion{
    NSString *url = [NSString stringWithFormat:@"%@?q=%@&format=json&num_of_days=%ld&key=%@&fp=24", g_URL, query, (long)numOfDays, g_Key];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self getDataByUrl:url completion:^(NSError *error, NSData *data) {
        if (completion) {
            id responseObject = nil;
            if (!error && data)
                responseObject = [NSJSONSerialization JSONObjectWithData: data options: 0 error: &error];
            
            completion(error, responseObject);
        }
    }];
}

- (void) getDataByUrl: (NSString*) url completion: (void(^)(NSError *error, NSData *data)) completion {
    /*dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSError *error = nil;
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: url] options:0 error:&error];
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(error, data);
                });
            }
        });
    });*/
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url]
                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             completion(error, data);
                                         });
                                 }] resume];
}

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

@end
