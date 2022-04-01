import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/widgets/iconic_card_item.dart';
import 'dart:io';

void main() {

  Widget mockCardItem;

  setUpAll(() {
    HttpOverrides.global = null;
    mockCardItem = const MaterialApp(
        home: CardItem(
          itemTitle: 'Test',
          itemInfo: 'Test',
          imageInfo: 'Test',
          placeId: 'Test',
          placeInfo: 'Test'
        )
    );
  });

  testWidgets('CardItem created successfully', (WidgetTester tester) async {
    CardItem testCardItem = const CardItem(
        itemTitle: 'Test',
        itemInfo: 'Test',
        imageInfo: 'Test',
        placeId: 'Test',
        placeInfo: 'Test'
    );
  });

}