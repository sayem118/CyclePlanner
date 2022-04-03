import 'package:cycle_planner/processes/application_processes.dart';
import 'package:cycle_planner/widgets/iconic_places.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/widgets/iconic_card_item.dart';
import 'dart:io';

import 'package:provider/provider.dart';

  void main() {
    late Widget cardItem;

    var itemTitle;
    var itemInfo;
    var imageInfo;
    var placeId;
    var placeInfo;

    Widget mockCardItem;

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
  }