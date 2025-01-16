import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
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
  int _counter = 0;
  TouchCallbacks touchCallbacks = TouchCallbacks();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(touchCallbacks.taps.length.toString()),
      ),
      body: Stack(
        children: [
          Positioned(
            left: touchCallbacks.taps.length == 3
                ? touchCallbacks.taps.first.offset.dx
                : 200,
            top: touchCallbacks.taps.length == 3
                ? touchCallbacks.taps.first.offset.dy
                : 200,
            child: Container(
              height: 100,
              width: 100,
              color: Colors.red,
            ),
          ),
          RawGestureDetector(
            gestures: <Type, GestureRecognizerFactory>{
              ImmediateMultiDragGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<
                  ImmediateMultiDragGestureRecognizer>(
                      () => ImmediateMultiDragGestureRecognizer(),
                      (ImmediateMultiDragGestureRecognizer instance) {
                    instance.onStart = (Offset offset) {
                      setState(() {
                        _counter++;
                        touchCallbacks.touchBegan(TouchData(_counter, offset));
                      });
                      return ItemDrag((details, tId) {
                        setState(() {
                          touchCallbacks
                              .touchMoved(TouchData(tId, details.globalPosition));
                        });
                      }, (details, tId) {
                        touchCallbacks
                            .touchEnded(TouchData(tId, const Offset(0, 0)));
                      }, (tId) {
                        touchCallbacks
                            .touchCanceled(TouchData(tId, const Offset(0, 0)));
                      }, _counter);
                    };
                  }),
            },
          ),
        ],
      ),
    );
  }
}

/// Just saving the taps information here
class TouchCallbacks {
  List<TouchData> taps = []; //list that holds ongoing taps or drags
  void touchBegan(TouchData touch) {
    taps.add(touch);
    //touch began code here
  }

  void touchMoved(TouchData touch) {
    for (int i = 0; i < taps.length; i++) {
      if (taps[i].touchId == touch.touchId) {
        taps[i] = touch;
        break;
      }
    }
    //touch moved code here
  }

  void touchCanceled(TouchData touch) {
    //touch canceled code here
    taps.removeWhere((element) => element.touchId == touch.touchId);
  }

  void touchEnded(TouchData touch) {
    //touch ended code here
    taps.removeWhere((element) => element.touchId == touch.touchId);
  }
}

///Every touch point must have the touch id, here touch id will be every offset on the screen
///until finger has not left i.e., until drag doesn't end.
class TouchData {
  final int touchId;
  final Offset offset;

  TouchData(this.touchId, this.offset);
}

class ItemDrag extends Drag {
  final Function onUpdate;
  final Function onEnd;
  final Function onCancel;
  final int touchId;

  ItemDrag(this.onUpdate, this.onEnd, this.onCancel, this.touchId);

  @override
  void update(DragUpdateDetails details) {
    super.update(details);
    onUpdate(details, touchId);
  }

  @override
  void end(DragEndDetails details) {
    super.end(details);
    onEnd(details, touchId);
  }

  @override
  void cancel() {
    super.cancel();
    onCancel(touchId);
  }
}