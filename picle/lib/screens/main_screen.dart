import 'package:flutter/material.dart';
import 'package:picle/widgets/avatar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Avatar(),
      ),
    );
  }
}
