import 'package:cycle_planner/processes/application_processes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/widgets/iconic_card_item.dart';
import 'package:provider/provider.dart';

void main() {
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