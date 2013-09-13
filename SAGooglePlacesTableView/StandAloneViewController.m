//
//  StandAloneViewController.m
//  SAGooglePlacesTableView
//
//  Created by Stephen Asherson on 2013/09/13.
//  Copyright (c) 2013 2bits. All rights reserved.
//

#import "StandAloneViewController.h"
#import "SAGooglePlacesTableView.h"

@interface StandAloneViewController ()

@property(strong, nonatomic) SAGooglePlacesTableView *googlePlaceTableView;

@end

@implementation StandAloneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create a stand-alone SAGooglePlacesTableView
    self.googlePlaceTableView = [SAGooglePlacesTableView createStandAloneWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) selectionBlock:^(NSString *placeName, CLLocationCoordinate2D location, NSString *searchTerm, NSError *error)
    {
        // User has selected an address and we have received a result
        if (error)
        {
            NSLog(@"We have an error :/");
            return;
        }
        
        NSLog(@"Places Received...");
    }];
    
    [self.view addSubview:self.googlePlaceTableView];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // We will manually execute a query against the tableview
    [self.googlePlaceTableView prepareAndExecuteGooglePlacesQuery:@"Table Mountain, Cape Town"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
