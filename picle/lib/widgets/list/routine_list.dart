import 'package:flutter/material.dart';
import 'package:picle/widgets/add_modal_widget.dart';
import 'package:picle/widgets/default_button.dart';
import 'package:provider/provider.dart';
import 'package:picle/providers/routine_provider.dart';
import 'package:picle/models/routine_model.dart';
import 'package:picle/widgets/list/list_item.dart';

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
        DefaultButton(
            buttonText: '루틴 등록하기',
            onPressed: () => addBottomModal(
                  context: context,
                  title: '루틴을 입력하세요.',
                  content: '루틴을 인증할 사진을 등록하고'
                      '\n매일 같은 구도로 사진을 촬영해서 인증해보세요!',
                  buttonText: '루틴 등록하기',
                  needImg: true,
                  needDate: true,
                )),
      ],
    );
  }
}
