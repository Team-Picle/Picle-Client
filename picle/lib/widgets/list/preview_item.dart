import 'package:flutter/material.dart';
import 'package:picle/providers/routine_provider.dart';
import 'package:provider/provider.dart';

const imgUrl = '';
const longitude = '';
const latitude = '';

class PreviewItem extends StatelessWidget {
  final int userId;
  final int routineId;
  final String content;
  final String time;

  const PreviewItem({
    super.key,
    required this.userId,
    required this.routineId,
    required this.content,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RoutineProvider>(
      builder: (context, provider, child) {
        return Row(
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
                        userId, routineId, content); // api 연결 시에는 content 삭제
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
                    await provider.finishRoutine(userId, routineId);
                  },
                  icon: const Icon(Icons.more_horiz),
                ))
          ],
        );
      },
    );
  }
}