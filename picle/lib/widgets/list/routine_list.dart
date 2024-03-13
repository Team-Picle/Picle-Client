import 'package:flutter/material.dart';
import 'package:picle/models/routine_model.dart';
import 'package:picle/providers/routine_provider.dart';
import 'package:picle/widgets/add_modal_widget.dart';
import 'package:picle/widgets/default_button.dart';
import 'package:picle/widgets/list/preview_item.dart';
import 'package:picle/widgets/list/routine_item.dart';
import 'package:provider/provider.dart';

class RoutineList extends StatelessWidget {
  const RoutineList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child:
            Consumer<RoutineProvider>(builder: (context, provider1, child) {
          return Consumer<RoutineProvider>(
              builder: (context, provider2, child) {
            List<dynamic> combinedList = [
              ...provider1.previewList,
              ...provider2.routineList
            ];

            return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                primary: false,
                itemCount: combinedList.length,
                itemBuilder: (_, index) {
                  dynamic item = combinedList[index];
                  dynamic listItem = item is Routine
                      ? RoutineItem(
                          userId: item.userId,
                          id: item.routineId,
                          text: item.content,
                          isChecked: item.isCompleted,
                        )
                      : PreviewItem(
                          userId: item.userId,
                          id: item.routineId,
                          text: item.content,
                        );
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: listItem,
                  );
                });
          });
        })),
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
