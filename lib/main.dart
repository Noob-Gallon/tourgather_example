// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:tourgather/essential/essential.dart';
import 'package:tourgather/screens/main_screen.dart';

void main() {
  runApp(const TourGather());
}

class TourGather extends StatelessWidget {
  const TourGather({super.key});

  @override
  Widget build(BuildContext context) {
    // 화면의 크기를 설정, essential data class에 저장한다.
    essential.setScreenSize(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    );

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
