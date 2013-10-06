//
//  SAGooglePlacesTableView.m
//  SAGooglePlacesTableView
//
//  Created by Stephen Asherson on 2013/09/07.
//  Copyright (c) 2013 2bits. All rights reserved.
//

#import "SAGooglePlacesTableView.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"

// The margin between the TextField and the tableview.
#define kTopMargin 5.0

@interface SAGooglePlacesTableView ()
{
}

@property(copy, nonatomic) TextFieldReturnedBlock returnBlock;
@property(copy, nonatomic) GooglePlaceSelectionBlock selectionBlock;
@property(strong, nonatomic) NSArray *googlePlaces;
@property(strong, nonatomic) UITextField *inputField;
@property(strong, nonatomic) SPGooglePlacesAutocompleteQuery *googlePlacesQuery;
@property(strong, nonatomic) NSString *lastQueryString;

@end

@implementation SAGooglePlacesTableView


+(SAGooglePlacesTableView *) createStandAloneWithFrame:(CGRect) frame selectionBlock:(GooglePlaceSelectionBlock) selectionBlock
{
    SAGooglePlacesTableView *tableView = [[SAGooglePlacesTableView alloc ]initWithFrame:frame];
    
    // setup the tableview
    tableView.delegate = tableView;
    tableView.dataSource = tableView;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.lastQueryString = nil;
    tableView.selectionBlock = selectionBlock;
    
    // defaults
    tableView.resolveSelectedAddress = YES;   
    
    return tableView;
}

+(SAGooglePlacesTableView *) createAttachedToTextField:(UITextField *) inputField withHeight:(float) height
    parentView:(UIView *) parentView
    selectionBlock:(GooglePlaceSelectionBlock) selectionBlock returnBlock:(TextFieldReturnedBlock) returnBlock;
{
    if (inputField == nil)
    {
        return nil;
    }
    
    if (parentView == nil)
    {
        return nil;
    }
    
    // The frame we use here doesn't matter as we add auto-layout constraints below.
    SAGooglePlacesTableView *tableView = [[SAGooglePlacesTableView alloc ]initWithFrame:inputField.frame];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    tableView.delegate = tableView;
    tableView.dataSource = tableView;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.lastQueryString = nil;
    tableView.inputField = inputField;
    tableView.selectionBlock = selectionBlock;
    tableView.returnBlock = returnBlock;
    
    // defaults for properties
    tableView.hidden = YES;
    tableView.resolveSelectedAddress = YES;
    
    [parentView addSubview:tableView];
    
    // Add constraint to textfield. The tableview will be the same width
    // as the textfield, and be positioned just beneath it.
    NSLayoutConstraint *tableViewYConstraint = [NSLayoutConstraint
       constraintWithItem:tableView
       attribute:NSLayoutAttributeTop
       relatedBy:NSLayoutRelationEqual
       toItem:inputField
       attribute:NSLayoutAttributeBottom
       multiplier:1.0f
       constant:5.0f];
    
    NSLayoutConstraint *tableViewWidthConstraint = [NSLayoutConstraint
       constraintWithItem:tableView
       attribute:NSLayoutAttributeWidth
       relatedBy:NSLayoutRelationEqual
       toItem:inputField
       attribute:NSLayoutAttributeWidth
       multiplier:1.0f
       constant:0];
    
    NSLayoutConstraint *tableViewHeightConstraint = [NSLayoutConstraint
       constraintWithItem:tableView
       attribute:NSLayoutAttributeHeight
       relatedBy:NSLayoutRelationEqual
       toItem:nil
       attribute:NSLayoutAttributeNotAnAttribute
       multiplier:1.0f
       constant:height];
    
    NSLayoutConstraint *tableViewXConstraint = [NSLayoutConstraint
         constraintWithItem:tableView
         attribute:NSLayoutAttributeLeft
         relatedBy:NSLayoutRelationEqual
         toItem:inputField
         attribute:NSLayoutAttributeLeft
         multiplier:1.0f
         constant:0.0f];

    
    [parentView addConstraint:tableViewYConstraint];
    [parentView addConstraint:tableViewWidthConstraint];
    [parentView addConstraint:tableViewHeightConstraint];
    [parentView addConstraint:tableViewXConstraint];
    
    [inputField addTarget:tableView action:@selector(inputFieldDidChange:) forControlEvents:UIControlEventAllEditingEvents];
    inputField.delegate = tableView;
    
    return tableView;
}

-(void) prepareAndExecuteGooglePlacesQuery:(NSString *) queryString;
{    
    if ([queryString isEqualToString:@""])
    {
        self.googlePlaces = nil;
        [self reloadData];
        return;
    }
    
    if ([queryString isEqualToString:self.lastQueryString])
    {
        return;
    }
    
    self.lastQueryString = queryString;
    
    if (self.googlePlacesQuery == nil)
    {
        self.googlePlacesQuery = [SPGooglePlacesAutocompleteQuery query];
    }
    
    self.googlePlacesQuery.location = self.location;
    self.googlePlacesQuery.radius = self.radius;
    self.googlePlacesQuery.language = @"en";
    self.googlePlacesQuery.types = SPPlaceTypeEstablishment;
    self.googlePlacesQuery.input = queryString;
       
    SAGooglePlacesTableView * __weak weakSelf = self;
    [self.googlePlacesQuery fetchPlaces:^(NSArray *places, NSError *error)
    {
        if (error != nil)
        {
            if (_selectionBlock != nil)
            {
                _selectionBlock(nil, kCLLocationCoordinate2DInvalid, queryString, error);
            }
            
            return;
        }
        
        self.googlePlaces = places;
        [weakSelf reloadData];
    }];
}

#pragma mark UITableViewDataSource methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.googlePlaces == nil)
    {
        return 0;
    }
    
    return [self.googlePlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"GPReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
    }
    
    SPGooglePlacesAutocompletePlace *place = [self.googlePlaces objectAtIndex:indexPath.row];
    cell.textLabel.text = place.name;
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.inputField resignFirstResponder];
    
    SPGooglePlacesAutocompletePlace *place = [self.googlePlaces objectAtIndex:indexPath.row];
    
    if (_selectionBlock != nil)
    {
        // Check if we need to resolve the selected place.
        if (self.resolveSelectedAddress)
        {
            // if there is a Geo resolution starting callback, call it now
            if (self.resolutionStartedBlock != nil)
            {
                self.resolutionStartedBlock();
            }
            
            [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error)
            {
                _selectionBlock(place.name , placemark.location.coordinate, self.inputField.text, nil);
            }];
        }
        else 
        {
            _selectionBlock(place.name , kCLLocationCoordinate2DInvalid, self.inputField.text, nil);
        }
    }
    
    // Update the input field to reflect the selected places' name.
    self.inputField.text = place.name;
}

#pragma mark UITextField methods


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.hidden = NO;
    
    if (self.textFieldDelegate != nil && [self.textFieldDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
    {
        [self.textFieldDelegate textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.hidden = YES;
    
    if (self.textFieldDelegate != nil && [self.textFieldDelegate respondsToSelector:@selector(textFieldDidEndEditing:)])
    {
        [self.textFieldDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (self.returnBlock != nil)
    {
        self.returnBlock();
    }
    
    return YES;
}

-(void) inputFieldDidChange:(id) sender
{
    [self prepareAndExecuteGooglePlacesQuery:self.inputField.text];
}

@end
