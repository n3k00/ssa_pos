import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/shared/widgets/app_state_views.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('AppLoadingView shows progress and message', (tester) async {
    await tester.pumpWidget(_wrap(const AppLoadingView()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text(AppStrings.loading), findsOneWidget);
  });

  testWidgets('AppErrorView shows retry button and invokes callback', (tester) async {
    var retried = false;

    await tester.pumpWidget(
      _wrap(
        AppErrorView(
          message: 'Failed to load',
          onRetry: () => retried = true,
        ),
      ),
    );

    expect(find.text('Failed to load'), findsOneWidget);
    expect(find.text(AppStrings.retry), findsOneWidget);

    await tester.tap(find.text(AppStrings.retry));
    await tester.pump();

    expect(retried, isTrue);
  });

  testWidgets('AppEmptyView shows default empty message', (tester) async {
    await tester.pumpWidget(_wrap(const AppEmptyView()));

    expect(find.text(AppStrings.noData), findsOneWidget);
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
  });
}
