import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lesson_share/models/counter_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const counterKey = 'counter';
  static const counterInfoKey = 'counterInfo';

  int _counter = 0;

  @override
  void initState() {
    _initCounter();
    _printCounterInfo();
    super.initState();
  }

  Future _initCounter() async {
    _counter = await _getCounter();
  }

  Future _printCounterInfo() async {
    final counterInfo = await _getCounterInfo();

    if (counterInfo == null) return;

    print('==========');
    print('value: ${counterInfo.value}');
    print('lastUpdate: ${counterInfo.lastUpdate}');
    print('userName: ${counterInfo.userName}');
    print('==========');
  }

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });

    await _setCounter();
    await _setCounterInfo();
  }

  Future _setCounter() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(counterKey, _counter);
  }

  Future _setCounterInfo() async {
    var prefs = await SharedPreferences.getInstance();

    final counterInfo = CounterInfo(
      value: _counter,
      lastUpdate: DateTime.now(),
      userName: 'Alex',
    );

    prefs.setString(counterInfoKey, json.encode(counterInfo));
  }

  Future<int> _getCounter() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt(counterKey) ?? 0;
  }

  Future<CounterInfo?> _getCounterInfo() async {
    var prefs = await SharedPreferences.getInstance();
    final counterInfo = prefs.getString(counterInfoKey);
    if (counterInfo == null) return null;

    return CounterInfo.fromJson(json.decode(counterInfo));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}