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
  Offset _center = Offset.zero; // 컨테이너의 중심 좌표

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 화면 크기에 따라 중심 좌표 계산
          _center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);

          return GestureDetector(
            onPanUpdate: (details) {
              // 사용자의 현재 터치 위치
              final touchPosition = details.localPosition;

              // 터치 위치에서 중심까지의 벡터 계산
              final vectorToTouch = touchPosition - _center;

              // 회전 각도를 계산
              final angle = atan2(vectorToTouch.dy, vectorToTouch.dx);

              setState(() {
                _rotationAngle = angle; // 회전 각도 업데이트
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
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(50),
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