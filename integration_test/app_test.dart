import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cycle_planner/main.dart' as app;
import 'package:cycle_planner/processes/application_processes.dart';


void main() {
  group('App Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets("full app test", (tester) async {
      app.main();
      await tester.pumpAndSettle();
      var searchLocationField = find.byKey(const Key("Search Location"));
      var startRouteButton = find.byType(ElevatedButton);

      String result = "five guys";
      await tester.enterText(searchLocationField, ApplicationProcesses().searchPlaces(result).toString());
      await tester.pumpAndSettle();
      await tester.tap(startRouteButton);
      await tester.pumpAndSettle();
    });
  });
}
