import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:grocery_voice_app/main.dart';

void main() {
  testWidgets('App launches and shows the Grocery List tab', (tester) async {
    await tester.pumpWidget(const GroceryVoiceApp());
    await tester.pumpAndSettle();

    expect(find.text('Grocery List'), findsOneWidget);
    expect(find.text('Your grocery list is empty.'), findsOneWidget);
    expect(find.byIcon(Icons.mic_none), findsOneWidget);
  });

  testWidgets('Switching to Cooking Notes tab shows its empty state', (
    tester,
  ) async {
    await tester.pumpWidget(const GroceryVoiceApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();

    expect(find.text('Cooking Notes'), findsOneWidget);
    expect(find.text('No cooking notes yet.'), findsOneWidget);
  });
}
