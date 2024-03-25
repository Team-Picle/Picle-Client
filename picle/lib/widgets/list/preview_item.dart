import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:picle/providers/date_provider.dart';
import 'package:picle/providers/routine_provider.dart';
import 'package:picle/widgets/date_picker.dart';
import 'package:picle/widgets/default_button.dart';
import 'package:picle/widgets/routine_time.dart';
import 'package:provider/provider.dart';

const imgUrl = '';
const longitude = '';
const latitude = '';

DateTime nowDate = DateTime.now();
DateTime? nowTime;
Set<String> selectedDays = {};
DateTime selectedDate = DateTime.now();
DateTime? selectedTime;
bool timePicked = false;
bool destinationPicked = false;

class PreviewItem extends StatelessWidget {
  final int userId;
  final int routineId;
  final String content;
  String? time;

  PreviewItem({
    super.key,
    required this.userId,
    required this.routineId,
    required this.content,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    String date = Provider.of<DateProvider>(context).getDate();
    TextEditingController titleController = TextEditingController();
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

                    onPressed: () async => showModalBottomSheet(
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (BuildContext context2) => StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SvgPicture.asset(
                                      'lib/images/home_indicator.svg'),
                                  const SizedBox(height: 15),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      DefaultButton(
                                        onPressed: () async {
                                          titleController.text = content;
                                          showModalBottomSheet(
                                            backgroundColor: Colors.white,
                                            context: context,
                                            builder: (BuildContext context) =>
                                                StatefulBuilder(
                                              builder: (BuildContext context,
                                                  setState) {
                                                return SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.38,
                                                  child: SingleChildScrollView(
                                                    child: Container(
                                                      width: double.infinity,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 32),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  30),
                                                          topRight:
                                                              Radius.circular(
                                                                  30),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SvgPicture.asset(
                                                              'lib/images/home_indicator.svg'),
                                                          const SizedBox(
                                                              height: 10),
                                                          Text(
                                                            content,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 25,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          // Row(
                                                          //   crossAxisAlignment:
                                                          //       CrossAxisAlignment
                                                          //           .start,
                                                          //   children: [
                                                          //     const Text(
                                                          //       '시작 날짜',
                                                          //       style:
                                                          //           TextStyle(
                                                          //         fontWeight:
                                                          //             FontWeight
                                                          //                 .w600,
                                                          //         fontSize: 16,
                                                          //       ),
                                                          //     ),
                                                          //     const SizedBox(
                                                          //         width: 16),
                                                          //     Text(
                                                          //       '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                                                          //       style:
                                                          //           const TextStyle(
                                                          //         fontWeight:
                                                          //             FontWeight
                                                          //                 .w500,
                                                          //         fontSize: 16,
                                                          //       ),
                                                          //     ),
                                                          //   ],
                                                          // ),
                                                          const SizedBox(
                                                              height: 10),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              nowTime = null;
                                                              timePicked =
                                                                  time != null
                                                                      ? true
                                                                      : false;
                                                              DateFormat
                                                                  format =
                                                                  DateFormat(
                                                                      'HH:mm');
                                                              selectedTime =
                                                                  format.parse(
                                                                      time!);
                                                              DateTime?
                                                                  pickedTime =
                                                                  await showTimePickerModal(
                                                                      context);

                                                              if (pickedTime !=
                                                                  null) {
                                                                setState(() {
                                                                  DateFormat
                                                                      timeFormat =
                                                                      DateFormat(
                                                                          'HH:mm');
                                                                  time = timeFormat
                                                                      .format(
                                                                          pickedTime);
                                                                });
                                                              }
                                                            },
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Text(
                                                                  '루틴 시간',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 16),
                                                                Text(
                                                                  timePicked
                                                                      ? '$time'
                                                                      : '없음',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          const DayPicker(),
                                                          const SizedBox(
                                                              height: 20),
                                                          DefaultButton(
                                                            onPressed:
                                                                () async {
                                                              setState(() {});
                                                              await provider
                                                                  .updatePreview(
                                                                userId: userId,
                                                                routineId:
                                                                    routineId,
                                                                time: time,
                                                                repeatDays:
                                                                    selectedDays
                                                                        .toList(),
                                                                date: date,
                                                              );
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  context2);
                                                            },
                                                            buttonText:
                                                                '루틴 수정하기',
                                                          ),
                                                          const SizedBox(
                                                              height: 20),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        buttonText: '수정하기',
                                      ),
                                      const SizedBox(height: 20),
                                      DefaultButton(
                                        onPressed: () async {
                                          await provider.finishRoutine(
                                            userId,
                                            routineId,
                                          );
                                          Navigator.pop(context2);
                                        },
                                        buttonText: '종료하기',
                                      ),
                                      const SizedBox(height: 40),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // onPressed: () async {
                    //   await provider.finishRoutine(userId, routineId);
                    // await provider.updatePreview(
                    //   userId: userId,
                    //   routineId: routineId,
                    //   time: '14:30:00',
                    //   repeatDays: ['TUESDAY', 'THURSDAY', 'FRIDAY'],
                    //   date: date,
                    // );
                    // },
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

Future<DateTime?> showTimePickerModal(BuildContext context) async {
  DateTime? pickedTime = await showModalBottomSheet<DateTime>(
    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
    context: context,
    builder: (BuildContext builder) {
      DateTime? selectedTime;
      double screenHeight = MediaQuery.of(context).size.height;
      double bottomSheetHeight = screenHeight * 0.4;

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            SvgPicture.asset('lib/images/home_indicator.svg'),
            SizedBox(
              height: bottomSheetHeight,
              child: GestureDetector(
                onTap: () {}, // 모달창 바깥을 터치해도 닫히지 않도록 빈 GestureDetector 추가
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: null,
                  onDateTimeChanged: (DateTime? newTime) {
                    selectedTime = newTime;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      nowTime = null;
                      selectedTime = null;
                      timePicked = false;
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0XFFEDEEF0),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF333333),
                      ),
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(140, 48)),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        // Pressed 상태일 때의 overlay color 지정
                        if (states.contains(MaterialState.pressed)) {
                          return const Color.fromARGB(40, 84, 194, 106);
                        }
                        // 기본 overlay color 지정
                        return Colors.transparent;
                      }),
                      elevation: const MaterialStatePropertyAll(0),
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      routine['time'] =
                          '${selectedTime?.hour.toString().padLeft(2, '0')}:${selectedTime?.minute.toString().padLeft(2, '0')}';
                      Navigator.pop(context, selectedTime);
                      timePicked = true;
                      selectedTime = null;
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF54C29B),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        const Color(0XFFEDEEF0),
                      ),
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(140, 48)),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const Color.fromARGB(40, 255, 255, 255);
                        }
                        return Colors.transparent;
                      }),
                      elevation: const MaterialStatePropertyAll(0),
                    ),
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      );
    },
  );

  return pickedTime;
}

class DayPicker extends StatefulWidget {
  const DayPicker({Key? key}) : super(key: key);

  @override
  State<DayPicker> createState() => _DayPickerState();
}

class _DayPickerState extends State<DayPicker> {
  List<bool> isSelected = List.generate(7, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                isSelected[index] = !isSelected[index]; // 버튼을 누를 때마다 선택 여부를 토글
                if (isSelected[index]) {
                  selectedDays.add(getDayFullName(index)); // 선택된 경우, 리스트에 추가
                } else {
                  selectedDays
                      .remove(getDayFullName(index)); // 선택 해제된 경우, 리스트에서 제거
                }
              });
            },
            child: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: isSelected[index]
                    ? const Color(0xFF54C29B)
                    : const Color(0xFFEDEEF0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  getDayName(index),
                  style: TextStyle(
                    color: isSelected[index] ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  String getDayName(int index) {
    switch (index) {
      case 0:
        return '월';
      case 1:
        return '화';
      case 2:
        return '수';
      case 3:
        return '목';
      case 4:
        return '금';
      case 5:
        return '토';
      case 6:
        return '일';
      default:
        return '';
    }
  }

  String getDayFullName(int index) {
    switch (index) {
      case 0:
        return 'MONDAY';
      case 1:
        return 'TUESDAY';
      case 2:
        return 'WEDNESDAY';
      case 3:
        return 'THURSDAY';
      case 4:
        return 'FRIDAY';
      case 5:
        return 'SATURDAY';
      case 6:
        return 'SUNDAY';
      default:
        return '';
    }
  }
}
