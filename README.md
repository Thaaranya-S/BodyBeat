# Table of Contents
1. [Description](#description)
2. [Getting started](#getting-started)
3. [Usage](#usage)
4. [Arhitecture](#arhitecture)
5. [Structure](#structure)
6. [Dependencies](#dependencies)
7. [Design](#design)
8. [Animation](#animation)

# BodyBeats
A iOS application that helps to track the Health metrics and its history.

# Description
<p>BodyBeats will getting the persmission from user to get health metrics.<br>
User need to login with Username and password also allowed to signIn with Apple.<br> 
Once the user gave the access for tracking the health metrics, can see the steps count, Running time, calories burned, Soccer, Kickboxing, stair, backetball played time.

# Getting started
<p>
1. Make sure you have the Xcode version 14.0 or above installed on your computer.<br>
2. Download the  BodyBeats project files from the repository.<br>
3. Open the project files in Xcode.<br>
4. Review the code and make sure you understand what it does.<br>
5. Run the active scheme.<br>

# Usage
In order to see the health metrics and to track your daily physical activies, you must install the BodyBeats application.

# Architecture
* SkyScan project is implemented using the both <strong>Model-View-ViewModel (MVC)</strong>
* Home module is implemented using the <strong>Model-View-ViewModel (MVC)</strong> architecture pattern.
* Model has any necessary data or business logic needed to generate weather and locaiton.
* View is responsible for displaying the weather and response to the user, user input or interactions.
* ViewModel handles Data Presentation, State Management, Data Binding.


# Structure 
* "Module": The source code files for a specific module. Files within a module folder are organized into subfolders.
* "Login": The source code of login and storyboard it holds
* "Home": The source code files for a specific module. It holds the MVVM structured Home screen files.
* "Chart": It holds the second screen that have steps count history
* "Manager": It holds the all records and Healthkit data and functions
* "Reusable": It holds the resuable view of each cards that displayed in homescreen

# Dependencies
[CocoaPods](https://cocoapods.org) is used as a dependency manager.
List of dependencies: 
* Permissions - The details will only vissible if the user allows the permission to track the Health metrics
* Apple SignIn - The App will allow the user to login with apple account
* Lottie Animation - Package dependency

# Design 
* Design tool user for BodyBeats [Dribbble]
* All of the design is and must be only in one tool and currently it is Dribbble.<br>
* Colors in the Dribbble must have same name as colors in Xcode project.<br> 
* Basic UI elements are defined.

# Animation
[Lottie Animation](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app) 
* Open-source animation file format that is widely used for adding high-quality animations
  
//Important Note:
* Login screen is created with UIKit and storyboard
* Remaining screens are created with SwiftUI.

