import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:posdevices/modules/pos/views/pos_activation_view.dart';

void main() {
  testWidgets('POS activation asks for a venue code', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: PosActivationView()));

    expect(find.text('Activate this POS'), findsOneWidget);
    expect(find.text('Continue to menu'), findsOneWidget);
    expect(find.textContaining('COPPERFOX'), findsWidgets);
  });
}
