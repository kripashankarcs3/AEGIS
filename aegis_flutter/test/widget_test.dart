import 'package:flutter_test/flutter_test.dart';
import 'package:aegis_flutter/app.dart';

void main() {
  testWidgets('Aegis UI rendering smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AegisApp());

    // 1. Verify Splash Screen renders AEGIS title
    expect(find.text('AEGIS'), findsOneWidget);

    // 2. Wait for Splash Screen transition timer and fade animation to complete
    await tester.pump(const Duration(milliseconds: 3500));
    await tester.pump(const Duration(milliseconds: 800));

    // 3. Verify Onboarding Screen renders "Welcome to" and "Get Started" button
    expect(find.text('Welcome to'), findsOneWidget);
    final getStartedBtn = find.text('Get Started');
    expect(getStartedBtn, findsOneWidget);
    
    // Ensure "Get Started" button is visible and fully scrolled into view
    await tester.ensureVisible(getStartedBtn);
    await tester.pump(const Duration(milliseconds: 100));

    // 4. Tap "Get Started" and transition to Login/Join Screen (slide transit is 500ms)
    await tester.tap(getStartedBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // 5. Verify Login Screen renders "Join the Network" and buttons
    expect(find.text('Join the Network'), findsOneWidget);
    expect(find.text('Continue with Phone'), findsOneWidget);

    // 6. Tap "Continue with Phone" to enter the Main App Shell (fade transit is 600ms)
    await tester.tap(find.text('Continue with Phone'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));

    // 7. Verify Main Shell loads with Radar tab active
    expect(find.text('Radar'), findsOneWidget);
  });
}
