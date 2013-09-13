//
//  ViewController.h
//  SAGooglePlacesTableView
//
//  Created by Stephen Asherson on 2013/09/07.
//  Copyright (c) 2013 2bits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAGooglePlacesTableView.h"

/*
 * Shows an example of the SAGooglePlacesTableView
 * attached to a UITextField.
 */

@interface ViewController : UIViewController

@property(strong, nonatomic) IBOutlet UITextField *inputField;

@property(strong, nonatomic) IBOutlet UILabel *name;
@property(strong, nonatomic) IBOutlet UILabel *latitude;
@property(strong, nonatomic) IBOutlet UILabel *longitude;

@end
