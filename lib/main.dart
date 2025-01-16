import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Two-Finger Swipe Detection',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SwipeScreen(),
    );
  }
}

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({Key? key}) : super(key: key);

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  String swipeDirection = "No Swipe Detected";
  Offset firstFingerPosition = Offset.zero;
  Offset secondFingerPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Two-Finger Swipe Detection"),
      ),
      body: RawGestureDetector(
        gestures: {
          MultiTouchGestureRecognizer: GestureRecognizerFactoryWithHandlers<
              MultiTouchGestureRecognizer>(
                () => MultiTouchGestureRecognizer(),
                (MultiTouchGestureRecognizer instance) {
              instance.onUpdate = (positions) {
                if (positions.length == 2) {
                  firstFingerPosition = positions[0];
                  secondFingerPosition = positions[1];

                  final deltaX = secondFingerPosition.dx - firstFingerPosition.dx;
                  final deltaY = secondFingerPosition.dy - firstFingerPosition.dy;

                  setState(() {
                    if (deltaY.abs() > deltaX.abs()) {
                      swipeDirection =
                      deltaY > 0 ? "Two-Finger Swipe Down" : "Two-Finger Swipe Up";
                    } else {
                      swipeDirection =
                      deltaX > 0 ? "Two-Finger Swipe Right" : "Two-Finger Swipe Left";
                    }
                  });
                }
              };

              instance.onEnd = () {
                setState(() {
                  swipeDirection = "No Swipe Detected";
                });
              };
            },
          ),
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                swipeDirection,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                height: 300,
                width: 300,
                color: Colors.grey[300],
                child: Center(
                  child: const Text(
                    "Use Two Fingers to Swipe",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MultiTouchGestureRecognizer extends OneSequenceGestureRecognizer {
  Function(List<Offset>)? onUpdate;
  Function? onEnd;
  final Map<int, Offset> activeTouches = {};

  @override
  void addAllowedPointer(PointerEvent event) {
    startTrackingPointer(event.pointer);
    activeTouches[event.pointer] = event.position;
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent) {
      activeTouches[event.pointer] = event.position;
      if (onUpdate != null) {
        onUpdate!(activeTouches.values.toList());
      }
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      activeTouches.remove(event.pointer);
      if (activeTouches.isEmpty && onEnd != null) {
        onEnd!();
      }
    }
  }

  @override
  String get debugDescription => 'MultiTouchGestureRecognizer';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}
