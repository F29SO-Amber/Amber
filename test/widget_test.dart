// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:amber/models/post.dart';
import 'package:amber/widgets/custom_form_field.dart';
import 'package:amber/widgets/number_and_label.dart';
import 'package:amber/widgets/post_widget.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/widgets/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:amber/main.dart';

void main() {
  testWidgets('setting item', (WidgetTester tester) async {
    // Build our app and trigger a frame.

    await tester.pumpWidget(const SettingItem(title: "t"));
    final titleFinder = find.text("t");

    expect(titleFinder, findsOneWidget);
  });
  testWidgets('number and label', (WidgetTester tester) async {
    // Build our app and trigger a frame.

    await tester.pumpWidget(const NumberAndLabel(
      label: 'l',
      number: '1',
    ));
    final labelFinder = find.text('l');
    final numberFinder = find.text('1');

    expect(labelFinder, findsOneWidget);
    expect(numberFinder, findsOneWidget);
  });
}
