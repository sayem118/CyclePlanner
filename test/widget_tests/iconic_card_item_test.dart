import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/widgets/iconic_places.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/widgets/iconic_card_item.dart';
import 'package:provider/provider.dart';


  void main() {
    late Widget cardItem;

    var itemTitle;
    var itemInfo;
    var imageInfo;
    var placeId;
    var placeInfo;

    Widget mockCardItem;

    group('Iconic card -', (){
      setUp(() {
        List<dynamic> cardItemsList = [
          [
            itemTitle = 'Test1',
            itemInfo =  'Test1',
            imageInfo = 'Test1',
            placeId =   'Test1',
            placeInfo = 'Test1',
          ],

          [
            itemTitle = 'Test2',
            itemInfo=  'Test2',
            imageInfo='Test2',
            placeId=  'Test2',
            placeInfo='Test2',
          ]

        ];
        cardItem =  ChangeNotifierProvider<ApplicationProcesses>(
          create: (context) => ApplicationProcesses(),
          child: MaterialApp(
              title: 'Cycle Planner',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home:  Scaffold(
                  body: ListView.builder(
                      itemCount: cardItemsList.length,
                      itemBuilder: (context, index) {
                        String itemTitle = cardItemsList [index] [0] ;
                        String itemInfo =  cardItemsList [index] [1];
                        String placeInfo =  cardItemsList [index] [2];
                        String imageInfo =  cardItemsList [index] [3];
                        String placeId =  cardItemsList [index] [4];

                        return CardItem(itemTitle: itemTitle, itemInfo: itemInfo, imageInfo: imageInfo, placeId: placeId, placeInfo: placeInfo );
                      })
                // body: Column(
                //   children: const [
                //     Text('testing'),
                //     CardItem(
                //       itemTitle: 'Test',
                //       itemInfo: 'Test',
                //       imageInfo: 'Test',
                //       placeId: 'Test',
                //       placeInfo: 'Test',
                //     ),
                //   ],
                // ),
              )
          ),
        );
      });

      testWidgets(
          'Testing for widgets created using key', (WidgetTester tester) async {
        // Define the test key.
        const testKey = Key('K');

        // Build a MaterialApp with the testKey.
        await tester.pumpWidget(MaterialApp(key: testKey, home: Container()));

        // Find the MaterialApp widget using the testKey.
        expect(find.byKey(testKey), findsOneWidget);
      });


      testWidgets('CardItem created successfully', (WidgetTester tester) async {
        await tester.pumpWidget(cardItem);
        expect(true, true);
      });


      testWidgets('find a container', (WidgetTester tester) async {
        var container = find.byType(Container);
        await tester.pumpWidget(cardItem);
        await tester.pumpAndSettle();
        expect(container, findsOneWidget);
      });

      testWidgets('CardItem created successfully', (WidgetTester tester) async {
        CardItem testCardItem = const CardItem(
          itemTitle: 'Test',
          itemInfo: 'Test',
          imageInfo: 'Test',
          placeId: 'Test',
          placeInfo: 'Test',
        );
      });
    });

  }
// void main() {
//   late Widget mockCardItem;
//
//   setUp(() async {
//     //WidgetsFlutterBinding.ensureInitialized();
//     //await Firebase.initializeApp(name: "Cycle Planner");
//     //Firebase.initializeApp(name: 'Cycle Planner', options: )
//
//     mockCardItem =  ChangeNotifierProvider<ApplicationProcesses>(
//       create: (context) => ApplicationProcesses(),
//       child: const MaterialApp(
//           home: Scaffold (
//               body: CardItem(
//                   itemTitle: 'Test',
//                   itemInfo: 'Test',
//                   imageInfo: 'Test',
//                   placeId: 'Test',
//                   placeInfo: 'Test'
//               )
//           )
//       )
//     );
//   });
//
//   testWidgets('CardItem created successfully', (WidgetTester tester) async {
//     //Test Card Item object
//     CardItem testCardItem = const CardItem(
//         itemTitle: 'Test',
//         itemInfo: 'Test',
//         imageInfo: 'Test',
//         placeId: 'Test',
//         placeInfo: 'Test'
//     );
//   });
//
//   testWidgets('contains child Card', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(mockCardItem);
//
//     final cardItem = find.byType(Card);
//
//     // Search for the Card in the tree and verify it exists.
//     expect(cardItem, findsOneWidget);
//   });
//
//   //testWidgets('Testing the Future addToFavourite()', (WidgetTester tester) async {});
//
//   testWidgets('Tests for padding within Container', (WidgetTester tester) async {
//     const childWidget = Padding(padding: EdgeInsets.all(8));
//
//     // Provide the padding to the Container.
//     await tester.pumpWidget(Container(child: childWidget));
//
//     // Search for the padding in the tree and verify it exists.
//     expect(find.byWidget(childWidget), findsOneWidget);
//   });
//
// }
