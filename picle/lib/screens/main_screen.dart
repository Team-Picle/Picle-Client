import 'package:flutter/material.dart';
import 'package:picle/providers/routine_provider.dart';
import 'package:picle/providers/todo_provider.dart';
import 'package:picle/widgets/avatar.dart';
import 'package:picle/widgets/calender.dart';
import 'package:picle/widgets/schedule_list.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<TodoProvider>(
              create: (_) => TodoProvider(),
            ),
            ChangeNotifierProvider<RoutineProvider>(
              create: (_) => RoutineProvider(),
            ),
          ],
          builder: (context, child) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Column(
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
                  ScheduleList(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
