//
//  SAGooglePlacesTableView.h
//  SAGooglePlacesTableView
//
//  Created by Stephen Asherson on 2013/09/07.
//  Copyright (c) 2013 2bits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<CoreLocation/CoreLocation.h>

@class SPGooglePlacesAutocompletePlace;

typedef void(^GooglePlaceSelectionBlock)(NSString *placeName, CLLocationCoordinate2D location, NSString *searchTerm, NSError* error);
typedef void(^GooglePlaceGeoResolutionStartedBlock)(void);
typedef void(^TextFieldReturnedBlock)(void);

@interface SAGooglePlacesTableView : UITableView <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

// Property specifying whether geo coordinates of the selected address should be resolved.
// Defaults to YES
@property(nonatomic) BOOL resolveSelectedAddress;
@property(copy, nonatomic) GooglePlaceGeoResolutionStartedBlock resolutionStartedBlock; // can be used as a callback when Geo resolution for a selected place has started.

// Location and radius (in meters) properties which can be used to refine the search results.
// Setting a radius biases results to the indicated area but may not completely restrict them.
// Default is unspecified.
@property(nonatomic) CLLocationCoordinate2D location;
@property (nonatomic) CGFloat radius;

// Assign a UITextFieldDelegate to the tableview. This is only applicable if this
// tableview is attached to a UITextField.
// This tableview will relay events from the UITextField to this delegate.
// Currently, only the textFieldDidBeginEditing and textFieldDidEndEditing events
// are relayed.
@property(weak, nonatomic) id<UITextFieldDelegate> textFieldDelegate;

/*
 * Factory methods
 */

/*
 * Creates a stand-alone tableview which is backed by the Google Places API. When
 * using the stand-alone tableview, querys have to executed manually by calling the
 * prepareAndExecuteGooglePlacesQuery: method. This will result in Google places being
 * fetched and subsequently displayed in the tableview.
 */
+(SAGooglePlacesTableView *) createStandAloneWithFrame:(CGRect) frame selectionBlock:(GooglePlaceSelectionBlock) selectionBlock;

/*
 * Creates a tableview which is attached to a UITextField. The tableview will have the same width as
 * the textfield and be positioned just beneath it, using autolayout constraints. Any input into the textfield will automatically
 * result in a query to fetch Google places and subsequently display them in the tableview.
 *
 * parentView: specifies the view to add the TableView to.
 * selectionBlock: the callback block that is called once a place is selected.
 * returnBlock: the callback block that is called when the keyboard attached to the textfield returns.
 */
+(SAGooglePlacesTableView *) createAttachedToTextField:(UITextField *) inputField withHeight:(float) height
    parentView:(UIView *) parentView
    selectionBlock:(GooglePlaceSelectionBlock) selectionBlock returnBlock:(TextFieldReturnedBlock) returnBlock;


/*
 * Prepares a Google Places query according to the properties specified and the provided
 * queryString parameter. Upon successful execution, will display the Google Places results
 * in the tableView.
 */
-(void) prepareAndExecuteGooglePlacesQuery:(NSString *) queryString;

@end
