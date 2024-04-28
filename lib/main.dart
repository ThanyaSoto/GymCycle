import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'GymCycle'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:content()

      ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  Widget content() {
    return Column(
      children: [
        Text("123"),
        Container(
          child: TableCalendar(
              headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
              focusedDay: DateTime.now(),
              firstDay: DateTime.utc(2023,10,10),
              lastDay: DateTime.utc(2024,10,10)),
        )
      ],
    );
  }
}
