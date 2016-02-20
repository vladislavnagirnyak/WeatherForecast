//
//  NVMapController.m
//  App
//
//  Created by Влад Нагирняк on 23.12.15.
//  Copyright © 2015 Влад Нагирняк. All rights reserved.
//

#import "NVMapController.h"
#import <MapKit/MapKit.h>
#import "NVNetworkController.h"
#import "DetailsViewController.h"

@interface NVMapController () <UIGestureRecognizerDelegate> {
    CLLocationCoordinate2D _coords;
}

@property (weak, nonatomic) IBOutlet MKMapView *_mapView;

@end

@implementation NVMapController

- (void)onQuerySet:(NSNotification*)notify {
    DetailsViewController *details = notify.object;
    if (details) {
        details.city = [NSString stringWithFormat:@"Longitude %.4f/Latitude %.4f", _coords.longitude, _coords.latitude];
    }
}

- (void)longPressed:(UILongPressGestureRecognizer *)longPress {
    CGPoint location = [longPress locationInView:self.view];
    if (longPress.state == UIGestureRecognizerStateBegan) {
        _coords = [self._mapView convertPoint:location toCoordinateFromView:self._mapView];
        [self performSegueWithIdentifier:@"MapToDetailsSegue" sender:self];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPress.delegate = self;
    [self._mapView addGestureRecognizer:longPress];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onQuerySet:) name:@"detailCity" object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
