import 'package:flutter_test/flutter_test.dart';
import 'package:pitch_deck/main.dart';

void main() {
  testWidgets('Pitch deck renders', (WidgetTester tester) async {
    await tester.pumpWidget(const PitchDeckApp());
    expect(find.byType(PitchDeckApp), findsOneWidget);
  });
}
