// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_dont_list/main.dart';
import 'package:to_dont_list/objects/item.dart';
import 'package:to_dont_list/widgets/to_do_items.dart';
import 'package:to_dont_list/objects/course.dart';

void main() {
  test('Item abbreviation should be first letter', () {
    var item = Item(name: "add more todos", course: Course(name: 'Course', color: Color.fromARGB(255, 42, 101, 42)), dueDate: DateTime(2025,12,12) );
    expect(item.abbrev(), "a");
  });

  // Yes, you really need the MaterialApp and Scaffold
  testWidgets('ToDoListItem has a text', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                item: Item(name: "test", course: Course(name: 'Course', color: Color.fromARGB(255, 42, 101, 42)), dueDate: DateTime(2025,12,12)),
                completed: true,
                onListChanged: (Item item, bool completed) {},
                onDeleteItem: (Item item) {}))));
    final textFinder = find.text('test');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(textFinder, findsOneWidget);
  });

  testWidgets('ToDoListItem has a Circle Avatar with abbreviation',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                item: Item(name: "test", course: Course(name: 'Course', color: Color.fromARGB(255, 42, 101, 42)), dueDate: DateTime(2025,12,12)),
                completed: true,
                onListChanged: (Item item, bool completed) {},
                onDeleteItem: (Item item) {}))));
    final abbvFinder = find.text('t');
    final avatarFinder = find.byType(CircleAvatar);

    CircleAvatar circ = tester.firstWidget(avatarFinder);
    Text ctext = circ.child as Text;

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(abbvFinder, findsOneWidget);
    expect(circ.backgroundColor, Colors.black54);
    expect(ctext.data, "t");
  });

  testWidgets('Default ToDoList has one item', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsOneWidget);
  });

  testWidgets('Clicking and Typing adds item to ToDoList', (tester) async {
    Key hwKey = Key('HW');
    Key cnKey = Key('CN');
    
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    expect(find.byKey(hwKey), findsNothing);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump(); // Pump after every action to rebuild the widgets
    expect(find.text("hi"), findsNothing);

    await tester.enterText(find.byKey(hwKey), 'hi');
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    await tester.enterText(find.byKey(cnKey), 'Course');
    await tester.pump();
    expect(find.text('Course'), findsOneWidget);

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsNWidgets(2));
  });
  testWidgets('Clicking and Typing adds course to courseList and can be used by ToDoList', (tester) async {
    Key cnKey = Key('CN');
    Key rKey = Key('r');
    Key gKey = Key('g');
    Key bKey = Key('b');
    Key okKey = Key('OKButton');
    Key hwKey = Key('HW');

    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    expect(find.byKey(cnKey), findsNothing);

    await tester.tap(find.byType(IconButton));
    await tester.pump();
    expect(find.text('hello'), findsNothing);

    await tester.enterText(find.byKey(cnKey), 'hello');
    await tester.pump();
    expect(find.text('hello'), findsOneWidget);

    await tester.enterText(find.byKey(rKey), '150');
    await tester.pump();
    expect(find.text('150'), findsOneWidget);

    await tester.enterText(find.byKey(gKey), '155');
    await tester.pump();
    expect(find.text('155'), findsOneWidget);

    await tester.enterText(find.byKey(bKey), '160');
    await tester.pump();
    expect(find.text('160'), findsOneWidget);

    await tester.tap(find.byKey(okKey));
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.enterText(find.byKey(hwKey), 'yo');
    await tester.pump();
    await tester.enterText(find.byKey(cnKey), 'hello');
    await tester.pump();
    await tester.tap(find.byKey(okKey));
    await tester.pump();

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsNWidgets(2));
  });


}