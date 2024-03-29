import 'package:flutter/material.dart';
import 'package:picle/providers/routine_provider.dart';
import 'package:picle/providers/todo_provider.dart';
import 'package:picle/providers/user_provider.dart';
import 'package:picle/widgets/avatar.dart';
import 'package:picle/widgets/calender.dart';
import 'package:picle/widgets/schedule_list.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<RoutineProvider>(
            create: (_) =>
                RoutineProvider(context.read<UserProvider>().user.id),
          ),
          ChangeNotifierProvider<TodoProvider>(
            create: (_) => TodoProvider(),
          ),
        ],
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.77,
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
          ),
        ),
      ),
    );
  }
}
