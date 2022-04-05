import 'dart:io';
import 'package:cycle_planner/models/place_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cycle_planner/widgets/search_page.dart';
import 'package:provider/provider.dart';
import 'package:cycle_planner/processes/application_processes.dart';
import 'searchPageTemplate.dart';

void main() {
  late var searchPage;

  setUp(() {
    HttpOverrides.global = null;
    searchPage = ChangeNotifierProvider<ApplicationProcesses>(
      create: (context) => ApplicationProcesses(),
      child: DelegatePage(delegate: SearchPage())
    );
  });

  group('Search page -', () {

    testWidgets('Search delegate loads', (WidgetTester tester) async {
      await tester.pumpWidget(searchPage);

      await tester.tap(find.byTooltip('Search'));

      await tester.pump();

      await tester.pump(const Duration(milliseconds: 300));

      SearchPage().query = 'test';

      await tester.pumpAndSettle();
    });

    testWidgets('Search bar loads', (WidgetTester tester) async {
      await tester.pumpWidget(searchPage);

      await tester.tap(find.byTooltip('Search'));

      await tester.pump();

      await tester.pump(const Duration(milliseconds: 300));

      SearchPage().query = 'test';

      final TextField textField = tester.widget<TextField>(find.byType(TextField));

      expect(
        textField.controller!.selection,
        TextSelection(
          baseOffset: SearchPage().query.length,
          extentOffset: SearchPage().query.length,
        ),
      );
    });

    testWidgets('close search page and return query result', (WidgetTester tester) async {
      final List<String> selectedResults = <String>[];

      await tester.pumpWidget(
        ChangeNotifierProvider<ApplicationProcesses>(
          create: (context) => ApplicationProcesses(),
          child: DelegatePage(delegate: SearchPage(), results: selectedResults,)
        )
      );

      await tester.tap(find.byTooltip('Search'));

      await tester.pumpAndSettle();

      expect(selectedResults, hasLength(0));

      final TextField textField = tester.widget(find.byType(TextField));
      textField.controller?.value = TextEditingValue(text: 'Query result');
      expect(textField.focusNode!.hasFocus, isTrue);

      // Close search
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('HomeBody'), findsOneWidget);
      expect(find.text('HomeTitle'), findsOneWidget);
      expect(find.text('Suggestions'), findsNothing);
      expect(selectedResults, <String>['Query result']);
    });
  });
}