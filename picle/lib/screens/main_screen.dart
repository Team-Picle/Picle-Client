import 'package:flutter/material.dart';
import 'package:picle/widgets/avatar.dart';
import 'package:picle/widgets/calender.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Avatar(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Calendar(),
          ),
        ],
      );
    );
  }
}
