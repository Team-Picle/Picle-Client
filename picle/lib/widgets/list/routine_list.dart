import 'package:flutter/material.dart';
import 'package:picle/models/routine_model.dart';
import 'package:picle/providers/routine_provider.dart';
import 'package:picle/widgets/add_modal_widget.dart';
import 'package:picle/widgets/default_button.dart';
import 'package:picle/widgets/list/routine_item.dart';
import 'package:provider/provider.dart';

class RoutineList extends StatelessWidget {
  const RoutineList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Column(
          children: [
            Consumer<RoutineProvider>(
              builder: (context, provider, child) {
                List<Routine> previewList = provider.previewList;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  primary: false,
                  itemCount: previewList.length,
                  itemBuilder: (_, index) {
                    Routine routine = previewList[index];
                    return RoutineItem(
                      userId: routine.userId,
                      id: routine.routineId,
                      text: routine.content,
                      isChecked: routine.isCompleted,
                    );
                  },
                );
              },
            ),
            Consumer<RoutineProvider>(
              builder: (context, provider, child) {
                List<Routine> routineList = provider.routineList;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  primary: false,
                  itemCount: routineList.length,
                  itemBuilder: (_, index) {
                    Routine routine = routineList[index];
                    return RoutineItem(
                      userId: routine.userId,
                      id: routine.routineId,
                      text: routine.content,
                      isChecked: routine.isCompleted,
                    );
                  },
                );
              },
            )
          ],
        )),
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
