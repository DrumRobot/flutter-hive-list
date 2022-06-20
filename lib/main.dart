import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<int>('values');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final itemController = ItemScrollController();

  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  void _incrementCounter() {
    var values = Hive.box<int>('values');
    var index = values.length - 1;
    var last = index >= 0 ? values.getAt(index) ?? 0 : 0;
    values.add(last + 1);
    itemController.scrollTo(index: index, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ValueListenableBuilder<Box<int>>(
        valueListenable: Hive.box<int>('values').listenable(),
        builder: (BuildContext context, Box<int> values, Widget? child) =>
            ScrollablePositionedList.builder(
          itemScrollController: itemController,
          itemCount: values.length,
          itemBuilder: (context, index) =>
              buildItem(context, values.keyAt(index), values.getAt(index)!),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildItem(context, int key, int value) => GestureDetector(
        key: Key(key.toString()),
        onDoubleTap: () {
          Hive.box<int>('values').delete(key);
        },
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Double tap to delete $value'),
          ));
        },
        child: ListTile(title: Text('Item $value')),
      );
}
