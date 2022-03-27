# cycle_planner

A new Flutter project.

## Getting Started

Below you should find a explanation on setting up the enviroment used for development.
It is assumed that the user will be using windows.

- [install flutter](https://docs.flutter.dev/get-started/install/windows)
- [install the Dart SDK](https://dart.dev/get-dart)
- follow the guides in the link above to set a path to flutter 
- [install android studio](https://developer.android.com/studio?gclid=Cj0KCQjw8_qRBhCXARIsAE2AtRa7LGSD9FUxxvDsSc33-ayBK8-1W4qb7OsO9FQ3kzBFJVhTsAef0yEaAuA7EALw_wcB&gclsrc=aw.ds)
- This step may not be necessary but go to File -> project structure -> project -> project SDK and select API 32
- go to the device manager and create a new device, the emulator used in development was the pixel 4 using android API 32 and on advanced settings was set to have an internal storage of at least 5GB
- on the top of android studio open up the device you've just set up this will allow it to run the code
- after setting up the enviroment run 'flutter pub get' in order to retreive all the packages used 
- to run tests there are 3 separate test folders the commands are as follows:
- flutter test
- flutter test integration_test
- flutter test test_driver
- a HTML coverage report can be found in the coverage folder 
- in order to run the app you can either type flutter run in the terminal or simple click the green play button on top of the android studio navbar
