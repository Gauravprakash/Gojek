# Gojek
An iOS app to show Contacts in list where users can add new contact, delete and make changes to it. Also users can mark favourite, call, message and email to their contacts. .

Getting Started

Install cocoapods and run pod install in the project directory for a quick setup.

pod install

and then run Gojek Demo.xcworkspace in your latest xcode. 

Prerequisites
Mac based system. Xcode Version 10.3+

Design Pattern Used : MVVM

Model-View-ViewModel (MVVM) is a software design pattern that is structured to separate program logic and user interface controls. 
View
View is represented by the UIView or UIViewController objects which should only display prepared data.

ViewModel
ViewModel hides all asynchronous networking code, data preparation code for visual presentation, and code listening for Model changes.

Model
It simply holds the data and has nothing to do with any of the business logic.

Router
Router handles all the routing logic and thus separates this concerns from the View.

Built With

Moya - Network abstraction layer on Alamofire.
Kingfisher - for downloading and caching images from the web
SnapKit - Swift Autolayout DSL
DZNEmptyDataSet - A drop-in UITableView/UICollectionView superclass category for showing empty datasets whenever the view has no content to display
Toast-Swift - A Swift extension that adds toast notifications to the UIView object class.
