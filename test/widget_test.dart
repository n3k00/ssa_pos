import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ssa/app/app.dart';
import 'package:ssa/app/constants/app_strings.dart';

void main() {
  testWidgets('App boots with launch screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: SsaApp()));

    expect(find.text(AppStrings.launchStarting), findsOneWidget);
    expect(find.text(AppStrings.appName), findsOneWidget);
  });
}
