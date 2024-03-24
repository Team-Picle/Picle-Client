import 'package:flutter/material.dart';
import 'package:picle/providers/date_provider.dart';
import 'package:picle/providers/routine_provider.dart';
import 'package:picle/widgets/routine_time.dart';
import 'package:provider/provider.dart';

const imgUrl = '';
const longitude = '';
const latitude = '';

class RoutineItem extends StatelessWidget {
  final int userId;
  final int routineId;
  final String content;
  final bool isChecked;
  final String? time;

  const RoutineItem({
    super.key,
    required this.userId,
    required this.routineId,
    required this.content,
    required this.isChecked,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RoutineProvider>(
      builder: (context, provider, child) {
        String date = Provider.of<DateProvider>(context).getDate();

        return Column(children: [
          Row(
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
                            userId: userId,
                            routineId: routineId,
                            imgUrl:
                                'https://res.cloudinary.com/dqhllkoz8/image/upload/v1710137987/test/asppn6jnlitfhgdmwdm5.jpg',
                            longitude: '38.01',
                            latitude: '129.900001',
                            date: date,
                          );
                        }
                      }),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 17,
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
                    await provider.deleteRoutine(
                      userId: userId,
                      routineId: routineId,
                      date: date,
                    );
                  },
                  icon: const Icon(Icons.more_horiz),
                ),
              )
            ],
          ),
          if (time != null) RoutineTime(time: time!)
        ]);
      },
    );
  }
}
