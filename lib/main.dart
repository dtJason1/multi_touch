import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  return runApp(GaugeApp());
}

/// Represents the GaugeApp class
class GaugeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radial Gauge Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}



class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _rotationAngle = 0.0; // 현재 회전 각도
  double _startAngle = 0.0; // 터치 시작 시 각도
  Offset _center = Offset.zero; // 컨테이너의 중심 좌표

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 화면 크기에 따라 중심 좌표 계산
          _center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);

          return GestureDetector(
            onPanStart: (details) {
              // 터치 시작 위치에서 각도를 계산
              final touchPosition = details.localPosition;
              final vectorToTouch = touchPosition - _center;
              _startAngle = atan2(vectorToTouch.dy, vectorToTouch.dx) - _rotationAngle;
            },
            onPanUpdate: (details) {
              // 드래그 중일 때의 터치 위치에서 각도 계산
              final touchPosition = details.localPosition;
              final vectorToTouch = touchPosition - _center;
              final angle = atan2(vectorToTouch.dy, vectorToTouch.dx);

              setState(() {
                _rotationAngle = angle - _startAngle; // 오프셋을 적용하여 회전 각도 설정
              });
            },
            child: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              color: Colors.black,
              child: Center(
                child: Transform.rotate(
                  angle: _rotationAngle, // 회전 적용
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 원형 컨테이너
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(300),
                        ),
                      ),
                      // 표시를 위한 상단 부분
                      Positioned(
                        top: 10, // 컨테이너의 상단 중앙
                        child: Container(
                          width: 10,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
