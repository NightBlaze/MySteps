# MySteps

Small case study assignment.

## Contents

- [Specification](#specification)
- [Description](#description)

## Specification

The app should query Apple Health for the Steps category for the current month and then:

- Plot a line chart depicting the steps. (x-axis day of month / y-axis step count/per day)
- Display all the achievements earned for the current month based on the total sum of steps taken for the current month. (i.e. If the user has walked 0-9999 steps show the “No achievements” state, if the user has walked 10k show the first badge, if the user has walked 20k show the first and second badge etc. )
- The y-axis of the chart should start from zero and adjust dynamically depending on the total amount of steps returned by Apple Health for the current month.

The achievements view is scrollable horizontally and the entire view should be scrollable vertically.

All strings should be marked as localisable and the UI elements should expand and contract to accommodate larger or smaller strings, depending on the hypothetical translation

### Project configuration

- The app should be developed in Swift
- The deployment target is iOS 13 - iPhone only
- The supported interface orientations for the app should be Portrait Only
- The app should run properly on all available iPhone size classes (no iPad version)

### Data & Backend

- The chart should display the total number of steps for each of the current month - displayed data should adapt when day changes
- The app should ask for permission to access the user’s “Steps” Apple Health category.
- The total number of steps for each day should be also stored locally in the app, using a Core Data Persistent store (a local cache).
- The data for the chart should be retrieved directly from HealthKit every time the app is launched.
- The data for the achievements view should be retrieved from the local cache.

### Additional requirements from the author

- Create not just a test case but create (almost) production ready application
- The app should be prepared for unit testing as much as possible

## Description

### Introduction

Software development is always a decision making:

- create a new screen fast or with good architecture?
- pay technical debt now or in the future?
- write highly abstract code or simple one which will be clear to everyone?
- should I use a third-party library and probably bring vendor lock into a project or should I spend time and implement some functionality myself?

And the most interesting thing is that there is no correct answer. All decisions have cons and pros.

My implementation also has its own drawbacks and advantages. The main decision which I made was "What quality of the application I want to reach?". Quality and time spent always go together. And I've decided "Ok. I'll spend more time but will get better quality".

All of this was created completely from scratch.

### Project structure

The structure is pretty straightforward and names of groups are self-explanatory:

- `Application` contains all application related classes
- `Components` contains reusable UI components. These components can be simple buttons or fully functional modules
  - `AchievementBadge` is reusable view for achievement badge. It used in cells and as separate 'no achievement' view
  - `Achievements` is reusable scrollable list of achievements
  - `Base` just a base class for creating xib-based views
  - `Chart` is reusable chart view for showing monthly steps information and chart
  - `UserBar` is reusable user information bar
- `DataLayer` holds
  - data access objects (`NSManagedObject`s in this case)
  - class for accessing to DAOs (`LocalPersistentStore`)
  - class for accessing HelthKit i.e. I treat HealthKit like any other store and `import HealthKit` is not distributed across the app. Thus the application uses abstraction over HealthKit and not HealthKit directly.
- `Design` contains all information about design :) It a little bit verbose in the app (we don't need all these colors). I just showed the idea
- `Extensions` is just extensions
- `Factories` contains all factories. Tha main manufacture of objects is here. Also `Swinject` abststracted only on this layer
- `Providers` are data providers. They know from where and how to get a data and provides it to other classes
- `Resources` just holds all application related resources (images, localizable strings, etc.)
- `Router` contains Router(s) which implements different navigation scenarios. In the app only changes window root view controller
- `Storyboards` holds all storyboards
- `SupportingFiles` is just plists, entitlements, etc.
- `Synchronizers` implements logic of synchronization data from external resources. In the app external resource is HealthKit. Main responsobility of Synchronizers do their work (synchronization) by some events (in our case by event of launching the application).
- `ViewControllers` contains all View Controllers. All of them implements VIP architecture.

### Architecture

I've decided to use `VIP` architecture because it has no such overhead like `VIPER` or `Clean Swift` but at the same time it has almost all advantages of the previous ones.

Building blocks of `VIP` are:

- `View` (in our case `UIViewController` or `UIView`). It manipulates all the views and knows *how* they should looks like. `View` communicates with `Interactor`
- `Interactor` holds all `View` related business logic and communicates with `Presenter`
- `Presenter` is preparing received from `Interactor` data for `View`. In other words it knows *what* to show.

So let's take a look at the VIP modules.

- **AppStart**
  - we should show custom UIViewController ASAP and not to perform long operation in `applicationDidFinishLaunching`. The main responsobility of this module is initializing of all core subsystems of the application
  - `Interactor` receives as dependencies `HealthKitStoreInitializer`, `LocalPersistentStoreInitializer` and `StepsSynchronizer` to initialize these subsystems
  - `View` receives as a dependency `Router` to switch to main screen after the initialization will be finished
- **Achievements**
  - small VIP module for showing Achievements
- **Home**
  - module that shows reusable views
  - receives dependencies and pass them to views

### Further steps

As any other application in the world this one has a technical debt too and many places can be improved. For example, using VIP here is a little bit overengineering but the main idea of this test assignment is to show how I'll implement hypotetical production application. Of course every programing issue can be implemented in different ways. No one can answer which way is better.

### Info

- I use `Charts` pod pointed to a specific branch and the branch can be changed with time. Also the branch in beta state and it brings some warning in the projects. In project's code there are no warnings
- If you are wonder why I "overuse" setting of background color then just turn on "Color Blended Layer" in menu of simulator. This simple trick increases performance a lot
