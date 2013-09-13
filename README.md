SAGooglePlacesTableView
=======================

SAGooglePlacesTableView is a `UITableView` control that is backed by the Google Places API. The
control provides an easy way to fetch results from Google Places and display them within a 
`UITableView`.

This project depends on the [SPGooglePlacesAutocomplete](https://github.com/spoletto/SPGooglePlacesAutocomplete)
project. The SPGooglePlacesAutocomplete project is a wrapper library for the Google Places API and this project
includes it as a GIT module. For ease of use, this readme includes some instructions taken directly from
the SPGooglePlacesAutocomplete project.

Installation
-----

1. Link your project against the CoreLocation framework.
2. Copy the following files to your project:
    * SPGooglePlacesAutocompleteUtilities.h/.m
    * SPGooglePlacesAutocompleteQuery.h/.m
    * SPGooglePlacesPlaceDetailQuery.h/.m
    * SPGooglePlacesAutocompletePlace.h/.m
    * SAGooglePlacesTableView.h/.m
3. Open SPGooglePlacesAutocompleteUtilities.h and replace `kGoogleAPIKey` with your Google API key. You can find your API key in the [Google APIs Console](https://code.google.com/apis/console).

Usage
-----

The tableview controls operates in two modes:

1) As a stand-alone tableview. In this mode, the tableview can be created using the following
factory method:

```
createStandAloneWithFrame:selectionBlock:
```

Queries in this modes need to be executed manually against the tableview instance, as follows:

```
[self.googlePlaceTableView prepareAndExecuteGooglePlacesQuery:@"Table Mountain, Cape Town"];
```

![Stand-Alone Tableview](https://github.com/StephenAsherson/SAGooglePlacesTableView/raw/master/Screenshots/StandAloneExample.png)

2) As a tableview that is attached to a `UITextField`. In this mode, input entered into the textfield
is automatically used in a query to fetch Google Places, with the results subsequently displayed in
a drop-down tableview beneath the textfield. A tableview in this mode can be constructed using the following factory method:

```
createAttachedToTextField:withHeight:parentView:selectionBlock:returnBlock
```

![UITextField Tableview](https://github.com/StephenAsherson/SAGooglePlacesTableView/raw/master/Screenshots/TextFieldExample.png)
![UITextField Tableview](https://github.com/StephenAsherson/SAGooglePlacesTableView/raw/master/Screenshots/TextFieldExample2.png)

For more information on the parameters mentioned above and the properties that can be configured
for the tableview, please view the `SAGooglePlacesTableView.h` header file comments.

Known Limitations
-----

- Currently the tableview is not very customizable in terms of its appearance. The font and colours used
in the list are hard-coded within the SAGooglePlacesTableView.m source file.
- When attaching the tableview to a `UITextField`, the tableview takes over as the `UITextFieldDelegate` to the
`UITextField`. As a result, if another `UITextFieldDelegate` is required for the textfield, a work-around will be
needed.

Sample Code
-----

The project contains sample code of the SAGooglePlacesTableView control operating in
both modes.

Requirements
-----
- iOS 6 or later
- iOS ARC (Automatic Reference Counting)

Disclaimer
-----

This project has been created for a specific purpose, and as a result it may not function correctly for all cases.
However, feel free to take the code and make changes if needed.

Who Made It?
-----

Stephen Asherson [http://www.stephenasherson.com]
