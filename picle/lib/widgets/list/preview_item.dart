import 'package:flutter/material.dart';
import 'package:picle/providers/date_provider.dart';
import 'package:picle/providers/routine_provider.dart';
import 'package:picle/widgets/routine_time.dart';
import 'package:provider/provider.dart';

const imgUrl = '';
const longitude = '';
const latitude = '';

class PreviewItem extends StatelessWidget {
  final int userId;
  final int routineId;
  final String content;
  final String? time;

  const PreviewItem({
    super.key,
    required this.userId,
    required this.routineId,
    required this.content,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    String date = Provider.of<DateProvider>(context).getDate();

    return Consumer<RoutineProvider>(
      builder: (context, provider, child) {
        return Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 24,
                child: IconButton(
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      await provider.addRoutine(
                        userId: userId,
                        routineId: routineId,
                        date: date,
                        time: time,
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.grey,
                    )),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                  width: 24,
                  child: IconButton(
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      // await provider.finishRoutine(userId, routineId);
                      await provider.updatePreview(
                        userId: userId,
                        routineId: routineId,
                        time: '00:30:00',
                        repeatDays: [
                          'MONDAY',
                          'TUESDAY',
                          'WEDNESDAY',
                          'THURSDAY',
                          'FRIDAY'
                        ],
                        date: date,
                      );
                    },
                    icon: const Icon(Icons.more_horiz),
                  ))
            ],
          ),
          if (time != null) RoutineTime(time: time!, color: Colors.grey)
        ]);
      },
    );
  }
}
