import 'package:flutter/material.dart';
import 'package:productivity_timer/settings.dart';
import 'package:productivity_timer/timermodel.dart';
import 'package:productivity_timer/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import './timer.dart';
import './settings.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: TimerHomePage(),
    );
  }
}

class TimerHomePage extends StatelessWidget {
  // const TimerHomePage({super.key});
  final double defaultPadding = 5.0;
  final CountDownTimer timer = CountDownTimer();

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem<String>> menuItems = <PopupMenuItem<String>>[];
    menuItems.add(PopupMenuItem(child: Text('Settings'), value: 'Settings'));
    timer.startWork();
    return Scaffold(
      appBar: AppBar(
        title: Text('My Work Timer'),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return menuItems.toList();
            },
            onSelected: (s) {
              if (s == 'Settings') {
                goToSettings(context);
              }
            },
          ),
        ],
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final double availableWidth = constraints.maxWidth;
        return Column(
          children: [
            Row(
              children: [
                Padding(padding: EdgeInsets.all(defaultPadding)),
                Expanded(
                    child: ProductivityButton(
                  color: Color(0xff009688),
                  text: "Work",
                  onPressed: () => timer.startWork(),
                  size: 0,
                )),
                Padding(padding: EdgeInsets.all(defaultPadding)),
                Expanded(
                    child: ProductivityButton(
                  color: Color(0xff607D8B),
                  text: "Short Break",
                  onPressed: () => timer.startBreak(true),
                  size: 0,
                )),
                Padding(padding: EdgeInsets.all(defaultPadding)),
                Expanded(
                    child: ProductivityButton(
                  color: Color(0xff455A64),
                  text: "Long Break",
                  onPressed: () => timer.startBreak(false),
                  size: 0,
                )),
                Padding(padding: EdgeInsets.all(defaultPadding)),
              ],
            ),
            Expanded(
                child: StreamBuilder(
              initialData: '00.00',
              stream: timer.stream(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                TimerModel timer = (snapshot.data == '00.00')
                    ? TimerModel('00.00', 1)
                    : snapshot.data;
                return Expanded(
                    child: CircularPercentIndicator(
                  radius: availableWidth / 2,
                  lineWidth: 10.0,
                  percent: (timer.percent == null) ? 1 : timer.percent,
                  center: Text((timer.time == null) ? '00:00' : timer.time,
                      style: Theme.of(context).textTheme.headline4),
                  progressColor: Color(0xff009688),
                ));
              },
            )),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
                Expanded(
                    child: ProductivityButton(
                  color: Color.fromARGB(255, 129, 21, 42),
                  text: "Stop",
                  onPressed: () => timer.stopTimer(),
                  size: 0,
                )),
                Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
                Expanded(
                    child: ProductivityButton(
                  color: Color.fromARGB(255, 255, 100, 177),
                  text: "Restart",
                  onPressed: () => timer.startTimer(),
                  size: 0,
                )),
                Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
              ],
            )
          ],
        );
      }),
    );
  }
}

void emptyMethod() {}
void goToSettings(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => SettingsScreen()));
}
