import 'package:cycle_planner/widgets/iconic_places.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

const iconicCollection = "iconic-places";


void main() {

  testWidgets('Iconic Screen created successfully', (WidgetTester tester) async {

    final firestore = FakeFirebaseFirestore();
    
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const Text("Iconic Places"),
        ),
      )
    ));

    await tester.pumpWidget(
    const MaterialApp(
          home:IconicScreen( )
      ),
    );
    Finder title = find.text("Iconic Places");
      expect(title, findsOneWidget);
  });

}