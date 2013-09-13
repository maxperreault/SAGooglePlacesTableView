//
//  ViewController.m
//  SAGooglePlacesTableView
//
//  Created by Stephen Asherson on 2013/09/07.
//  Copyright (c) 2013 2bits. All rights reserved.
//

#import "ViewController.h"
#import "StandAloneViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
         style:UIBarButtonItemStylePlain target:nil action:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
    ViewController* __weak weakSelf = self;
    
    SAGooglePlacesTableView* placesTableView = [SAGooglePlacesTableView createAttachedToTextField:self.inputField withHeight:150.0f
       parentView:self.view
       selectionBlock:^(NSString *placeName, CLLocationCoordinate2D location, NSString *searchTerm, NSError *error)
    {
        // User has selected an address and we have received a result
        if (error)
        {
            NSLog(@"We have an error :/");
            return;
        }
        
        NSLog(@"Places Received...");
        
        // we should have the resolved geo coordinates as well.
        weakSelf.name.text = placeName;
        weakSelf.latitude.text = [NSString stringWithFormat:@"%f", location.latitude];
        weakSelf.longitude.text = [NSString stringWithFormat:@"%f", location.longitude];
    } returnBlock:^{
        
        // Keyboard has returned. Nothing to do here...
    }];

    // We want to resolve selected addresses to geo coordinates
    placesTableView.resolveSelectedAddress = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
