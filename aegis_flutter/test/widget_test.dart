import 'package:flutter_test/flutter_test.dart';
import 'package:aegis_flutter/app.dart';

void main() {
  testWidgets('Aegis UI rendering smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AegisApp());

    // 1. Verify Splash Screen renders AEGIS title
    expect(find.text('AEGIS'), findsOneWidget);

    // 2. Wait for Splash Screen transition timer to complete
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // 3. Verify Onboarding Screen renders "Welcome to" and "Get Started" button
    expect(find.text('Welcome to'), findsOneWidget);
    final getStartedBtn = find.text('Get Started');
    expect(getStartedBtn, findsOneWidget);
    await tester.ensureVisible(getStartedBtn);
    await tester.pumpAndSettle();

    // 4. Tap "Get Started" and transition to Login/Join Screen
    await tester.tap(getStartedBtn);
    await tester.pumpAndSettle();

    // 5. Verify Login Screen renders "Join the Network" and buttons
    expect(find.text('Join the Network'), findsOneWidget);
    expect(find.text('Continue with Phone'), findsOneWidget);

    // 6. Tap "Continue with Phone" to enter the Main App Shell
    await tester.tap(find.text('Continue with Phone'));
    await tester.pumpAndSettle();

    // 7. Verify Main Shell loads with Radar tab active
    expect(find.text('Radar'), findsOneWidget);
  });
}
