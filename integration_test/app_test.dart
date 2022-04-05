import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cycle_planner/main.dart' as app;
import 'package:firebase_core/firebase_core.dart';

void main() {
  group('App Test', () {

    // IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    // testWidgets("full app test", (tester) async {
    //   app.main();
    //   await tester.pumpAndSettle();
    //   var searchLocationField = find.byKey(const Key("Search Location"));
    //   var startRouteButton = find.byType(ElevatedButton);
    //
    //   String result = "five guys";
    //   await tester.enterText(searchLocationField, ApplicationProcesses().searchPlaces(result).toString());
    //   await tester.pumpAndSettle();
    //   await tester.tap(startRouteButton);
    //   await tester.pumpAndSettle();
    // });

    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Navbar Integration Tests', (WidgetTester tester) async {

      await Firebase.initializeApp();

      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byKey(const Key('LogInButton')), findsOneWidget);

      await tester.enterText(find.byKey(const ValueKey('emailLogInField')), 'test123@test.com');
      await tester.enterText(find.byKey(const ValueKey('passwordLogInField')), 'test123');
      await tester.tap(find.byKey(const ValueKey('LogInButton')));


      await Future<void>.delayed(const Duration(seconds: 10));
      await tester.pumpAndSettle();

      // await tester.tap(find.text('WHILE USING THE APP'));

      // expect(find.byType(BottomNavBar), findsOneWidget);


    });

  });
}
