import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:picle/widgets/add_modal_widget.dart';
import 'package:picle/widgets/default_button.dart';

DateTime nowDate = DateTime.now();
DateTime? nowTime;
var routine = {};

Future<DateTime?> showDatePickerModal(
    BuildContext context, DateTime initialDate) async {
  DateTime? pickedDate = await showModalBottomSheet<DateTime>(
    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
    context: context,
    builder: (BuildContext builder) {
      DateTime selectedDate = initialDate;
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
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  onDateTimeChanged: (DateTime newDate) {
                    selectedDate = newDate;
                  },
                ),
              ),
            ),
            DefaultButton(
              onPressed: () {
                routine['date'] =
                    '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                Navigator.pop(context, selectedDate);
                nowDate = DateTime.now();
              },
              buttonText: '확인',
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      );
    },
  );

  return pickedDate;
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

class RenderAddDate extends StatefulWidget {
  const RenderAddDate({super.key});

  @override
  State<RenderAddDate> createState() => _RenderAddDateState();
}

class _RenderAddDateState extends State<RenderAddDate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            nowDate = DateTime.now();
            DateTime? pickedDate = await showDatePickerModal(context, nowDate);

            if (pickedDate != null) {
              setState(() {
                selectedDate = pickedDate;
              });
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '시작 날짜',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 13,
        ),
        GestureDetector(
          onTap: () async {
            nowTime = null;
            timePicked = false;
            selectedTime = null;
            DateTime? pickedTime = await showTimePickerModal(context);

            if (pickedTime != null) {
              setState(() {
                selectedTime = pickedTime;
              });
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '루틴 시간',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                timePicked
                    ? '${selectedTime?.hour.toString().padLeft(2, '0')}:${selectedTime?.minute.toString().padLeft(2, '0')}'
                    : '없음',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        renderAddDay(),
      ],
    );
  }
}

Widget renderAddDay() {
  return const DayPicker();
}
