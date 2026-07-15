import 'package:flutter_test/flutter_test.dart';
import 'package:aegis_flutter/app.dart';

void main() {
  testWidgets('Aegis UI rendering smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AegisApp());

    // Verify that our AEGIS application header title renders on home radar screen
    expect(find.text('AEGIS'), findsOneWidget);
    
    // Verify that the bottom navigation bar has radar tab selected
    expect(find.text('Radar'), findsOneWidget);
  });
}
