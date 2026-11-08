
import 'package:flutter_test/flutter_test.dart';
import 'package:bacayuk/main.dart';

void main() {
  testWidgets('BacaYuk app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BacaYukApp());

    expect(find.text('Halo, Pembaca! 👋'), findsOneWidget);
    expect(find.text('Aktivitas Membacamu'), findsOneWidget);
  });
}
