# iMovies

Version 1.0

Build and Runtime Requirements

Xcode 11.0 or later
iOS 13.0 or later

Configuring the Project

Configuring the Xcode project requires a few steps in Xcode to get up and running with iCloud capabilities.

1. Ensure you running XCode of minimal version 11.0 in order to run it on iOS 13 simulator or device
2. Configure each Mac and iOS device you plan to test . Create or use an existing Apple ID account 
3.Change the Bundle Identifier. if needed
4.Ensure Automatic is chosen for the Provisioning Profile setting in the Code Signing section of Target > Build Settings for the following Targets:
5.Ensure iOS Developer is chosen for the Code Signing Identity setting in the Code Signing section of Target > Build Settings for the following Targets:


                                    iMovies2
                                    iMovies2Tests


6. Run pod install command in the Terminal in folder containing xcworkspace file

About iMovies

Lister is a Cocoa Touch productivity moview project for iOS . In this simple application, the user can view categories, populars films and  their details including trailers.


Note: iMovies supports Portrait orientation only
All the graphycs works used in iMovies taken from http://www.iconarchive.com

Written in Swift

iMovies written completely in Swift. 

Application Architecture

The iMovies 2.0 project includes iOS app targets, iOS  app extensions, and 3d party gramework, e.g Alamofire, YouTube , TheMovieDB and so on


Swift Features

The iMovie using the following features of Swift:

Enumerations

iMovies used to have many enums of various types for usage acroos the application. Those that used across the project store in Constants file

String Constants

Constants are defined using structs and static members to avoid keeping constants in the global namespace. 
One example is segue identifiers constants. Those  allow for better organization of manage segue transaction in project.

Extensions on Types at Different Layers of a Project

The deg2rad() function is defined in Double type extension It is used in calculaying the angle used in IMGenresCollectionViewLayout subclass of UICollectionViewFlowLayout

Codable  structs

The structs whih conforms to Codable protocols used to parse JSON automatically using JSONDecoder object for all network requests

Unit Tests

Lister has unit tests written for the iMovies network request. 
These tests are in the iMovies2Tests group. 
To run the unit tests, select iMovies2 scheme in the Scheme menu. Then hold the Run button down and select the "Test" option, or press Command+u to run the tests.


Known issues

Localization not working. Fixing in next version
