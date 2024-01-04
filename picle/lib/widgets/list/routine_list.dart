import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:picle/providers/routine_provider.dart';
import 'package:picle/models/routine_model.dart';
import 'package:picle/widgets/list/list_item.dart';
import 'package:picle/widgets/button.dart';

class RoutineList extends StatelessWidget {
  const RoutineList({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<RoutineProvider>().fetchRoutineList();
    List<Routine> routineList = context.watch<RoutineProvider>().routineList;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            primary: false,
            itemCount: routineList.length,
            itemBuilder: (_, index) {
              Routine routine = routineList[index];
              return ListItem(
                text: routine.content,
                isChecked: routine.completed,
              );
            },
          ),
        ),
        const Button(text: '루틴 등록하기'),
      ],
    );
  }
}