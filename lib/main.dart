import 'package:flutter/material.dart';
import 'package:touch_indicator/touch_indicator.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: (context, child) => TouchIndicator(child: child!, forceInReleaseMode: true,),
      home: TouchIndicator(
        // forceInReleaseMode: true,
        // enabled: true,
        // indicatorSize: 80,
        // indicatorColor: Colors.deepOrange,
        child: MyHomePage(
          title: 'Flutter Demo Home Page',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child:  Column(
          children: [
            PinchZoom(
              child: Image.network('https://placekitten.com/640/360'),
              maxScale: 2.5,
              onZoomStart: (){print('Start zooming cat');},
              onZoomEnd: (){print('Stop zooming cat');},
            ),
            PinchZoom(
              child: Image.network('https://placedog.net/640/360'),
              maxScale: 2.5,
              onZoomStart: (){print('Start zooming dog');},
              onZoomEnd: (){print('Stop zooming dog');},
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