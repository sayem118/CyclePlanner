import 'package:cycle_planner/processes/application_processes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/widgets/iconic_card_item.dart';
import 'package:provider/provider.dart';

void main() {

  // const MethodChannel('flutter.baseflow.com/geolocator')
  //     .setMockMethodCallHandler((MethodCall methodCall) async {
  //   if (methodCall.method == "initializeApp") {
  //     /// Internally initializes core if it is not yet ready.
  //     @override
  //     Future<FirebaseAppPlatform> initializeApp({
  //       String? name,
  //       FirebaseOptions? options,
  //     }) async {
  //       // Ensure that core has been initialized on the first usage of
  //       // initializeApp
  //       if (!isCoreInitialized) {
  //         await _initializeCore();
  //       }
  //
  //       // If no name is provided, attempt to get the default Firebase app instance.
  //       // If no instance is available, the user has not set up Firebase correctly for
  //       // their platform.
  //       if (name == null || name == defaultFirebaseAppName) {
  //         MethodChannelFirebaseApp? defaultApp =
  //         appInstances[defaultFirebaseAppName];
  //
  //         // If options are present & no default app has been setup, the user is
  //         // trying to initialize default from dart
  //         if (defaultApp == null && options != null) {
  //           _initializeFirebaseAppFromMap((await channel.invokeMapMethod(
  //             'Firebase#initializeApp',
  //             <String, dynamic>{
  //               'appName': defaultFirebaseAppName,
  //               'options': options.asMap
  //             },
  //           ))!);
  //           defaultApp = appInstances[defaultFirebaseAppName];
  //         }
  //
  //         // If there is no native default app and the user didnt provide options to
  //         // create one, throw.
  //         if (defaultApp == null && options == null) {
  //           throw coreNotInitialized();
  //         }
  //
  //         // If there is a native default app and the user provided options do a soft
  //         // check to see if options are roughly identical (so we don't unnecessarily
  //         // throw on minor differences such as platform specific keys missing
  //         // e.g. hot reloads/restarts).
  //         if (defaultApp != null && options != null) {
  //           if (options.apiKey != defaultApp.options.apiKey ||
  //               (options.databaseURL != null &&
  //                   options.databaseURL != defaultApp.options.databaseURL) ||
  //               (options.storageBucket != null &&
  //                   options.storageBucket != defaultApp.options.storageBucket)) {
  //             // Options are different; throw.
  //             throw duplicateApp(defaultFirebaseAppName);
  //           }
  //           // Options are roughly the same; so we'll return the existing app.
  //         }
  //
  //         return appInstances[defaultFirebaseAppName]!;
  //       }
  //   }
  //   return Firebase.initializeApp();
  // });


  late Widget mockCardItem;

  setUp(() async {
    //WidgetsFlutterBinding.ensureInitialized();
    //await Firebase.initializeApp(name: "Cycle Planner");
    //Firebase.initializeApp(name: 'Cycle Planner', options: )
    
    mockCardItem =  ChangeNotifierProvider<ApplicationProcesses>(
      create: (context) => ApplicationProcesses(),
      child: const MaterialApp(
          home: CardItem(
                  itemTitle: 'Test',
                  itemInfo: 'Test',
                  imageInfo: 'Test',
                  placeId: 'Test',
                  placeInfo: 'Test'
          )
      )
    );
  });

  testWidgets('CardItem created successfully', (WidgetTester tester) async {
    //Test Card Item object
    CardItem testCardItem = const CardItem(
        itemTitle: 'Test',
        itemInfo: 'Test',
        imageInfo: 'Test',
        placeId: 'Test',
        placeInfo: 'Test'
    );
  });

  testWidgets('contains child Card', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(mockCardItem);

    final cardItem = find.byType(Card);

    // Search for the Card in the tree and verify it exists.
    expect(cardItem, findsOneWidget);
  });

  //testWidgets('Testing the Future addToFavourite()', (WidgetTester tester) async {});

  testWidgets('Tests for padding within Container', (WidgetTester tester) async {
    const childWidget = Padding(padding: EdgeInsets.all(8));

    // Provide the padding to the Container.
    await tester.pumpWidget(Container(child: childWidget));

    // Search for the padding in the tree and verify it exists.
    expect(find.byWidget(childWidget), findsOneWidget);
  });

}