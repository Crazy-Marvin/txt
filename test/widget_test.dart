import 'package:flutter_test/flutter_test.dart';
import 'package:txt/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(App());

    expect(find.text('txt'), findsWidgets);
    expect(find.text('draft'), findsNothing);
  });
}
