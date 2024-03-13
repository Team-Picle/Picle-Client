import 'package:flutter/material.dart';
import 'package:picle/providers/routine_provider.dart';
import 'package:provider/provider.dart';

const imgUrl = '';
const longitude = '';
const latitude = '';

class RoutineItem extends StatelessWidget {
  final int userId;
  final int routineId;
  final String text;
  final bool isChecked;

  const RoutineItem({
    super.key,
    required this.userId,
    required this.routineId,
    required this.text,
    required this.isChecked,
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
              child: Transform.scale(
                scale: 1.2,
                child: Checkbox(
                    semanticLabel: '테스트',
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    value: isChecked,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.green,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    activeColor: const Color(0xFF54C29B),
                    onChanged: (value) {
                      if (value == true) {
                        provider.verifyRoutine(
                            userId, routineId, imgUrl, longitude, latitude);
                      }
                    }),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
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
                  await provider.deleteRoutine(userId, routineId);
                },
                icon: const Icon(Icons.more_horiz),
              ),
            )
          ],
        );
      },
    );
  }
}
