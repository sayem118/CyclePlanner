import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/main.dart';
import 'package:cycle_planner/widgets/iconic_card_item.dart';

void main() {

  //Mock Iconic Card Item
  // CardItem testCard = const CardItem(itemTitle: 'Test', itemInfo: 'Test', imageInfo: 'Test'
  //     , placeId: 'Test', placeInfo: 'Test');

  testWidgets('Card Item created successfully', (WidgetTester tester) async {
    CardItem testCard = const CardItem(itemTitle: 'Test', itemInfo: 'Test', imageInfo: 'Test'
        , placeId: 'Test', placeInfo: 'Test');

    // await tester.pumpWidget(const CardItem(itemTitle: 'Test', itemInfo: 'Test', imageInfo: 'Test'
    //     , placeId: 'Test', placeInfo: 'Test'));
    //
    // expect(find.text('Test'), findsOneWidget);
  });

}