import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_click/safe_click.dart';

void main() {
  testWidgets('SafeClick prevents double taps', (tester) async {
    int tapCount = 0;

    // Build SafeClick widget
    await tester.pumpWidget(
      MaterialApp(
        home: SafeClick(
          cooldown: const Duration(milliseconds: 500),
          onTap: () => tapCount++,
          child: const Text('Tap Me'),
        ),
      ),
    );

    // First tap
    await tester.tap(find.text('Tap Me'));
    await tester.pump(); // advance a frame
    expect(tapCount, 1); // first tap counted

    // Second tap (should be ignored because cooldown)
    await tester.tap(find.text('Tap Me'));
    await tester.pump(); // advance a frame
    expect(tapCount, 1); // still 1, cooldown works

    // Wait for cooldown to finish
    await tester.pump(const Duration(milliseconds: 500));

    // Tap again after cooldown
    await tester.tap(find.text('Tap Me'));
    await tester.pump();
    expect(tapCount, 2); // tap after cooldown works
  });
}
