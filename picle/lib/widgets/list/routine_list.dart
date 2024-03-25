import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picle/models/routine_model.dart';
import 'package:picle/providers/date_provider.dart';
import 'package:picle/providers/image_provider.dart';
import 'package:picle/providers/routine_provider.dart';
import 'package:picle/widgets/default_button.dart';
import 'package:picle/widgets/list/preview_item.dart';
import 'package:picle/widgets/list/routine_item.dart';
import 'package:provider/provider.dart';

const cloudName = 'dqhllkoz8';
final picker = ImagePicker();
String routineContent = '';
Set<String> selectedDays = {};
List<String> dayList = [];
DateTime selectedDate = DateTime.now();
DateTime? selectedTime;
bool timePicked = false;
String imgUrl = '';
XFile? image;
bool destinationPicked = false;
String destinationLongitude = '126.9595';
String destinationLatitude = '37.549';
int routineId = 100;
String startRepeatDate =
    '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
String time = '';

class RoutineList extends StatelessWidget {
  const RoutineList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Consumer<RoutineProvider>(
          builder: (context, provider, child) {
            List<dynamic> combinedList = [
              ...provider.uncheckRoutineList,
              ...provider.checkRoutineList,
              ...provider.previewList,
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
                          routineId: item.routineId,
                          content: item.content,
                          isChecked: item.isCompleted,
                          time: item.time,
                        )
                      : PreviewItem(
                          userId: item.userId,
                          routineId: item.routineId,
                          content: item.content,
                          time: item.time,
                        );
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: listItem,
                  );
                });
          },
        )),
        DefaultButton(
            buttonText: '루틴 등록하기',
            onPressed: () async {
              await addBottomModal(
                context: context,
                title: '루틴을 입력하세요.',
                content: '루틴을 인증할 사진을 등록하고'
                    '\n매일 같은 구도로 사진을 촬영해서 인증해보세요!',
                buttonText: '루틴 등록하기',
                needImg: true,
                needDate: true,
              );
              context.read<RoutineProvider>().registerRoutine(
                    content: routineContent,
                    imgUrl:
                        'https://res.cloudinary.com/dqhllkoz8/image/upload/v1710138018/test/zphkge2wdfvswud8nmti.jpg',
                    time: time,
                    startRepeatDate: startRepeatDate,
                    repeatDays: dayList,
                    destinationLongitude: destinationLongitude,
                    destinationLatitude: destinationLatitude,
                    date: context.read<DateProvider>().getDate(),
                  );
            }

            //     () {
            //   context.read<RoutineProvider>().registerRoutine(
            //         content: '푸시 알림 테스트3 🙈',
            //         imgUrl:
            //             'https://res.cloudinary.com/dqhllkoz8/image/upload/v1710138018/test/zphkge2wdfvswud8nmti.jpg',
            //         time: '04:55:00',
            //         startRepeatDate: '2024-03-01',
            //         repeatDays: ['SATURDAY', 'SUNDAY'],
            //         destinationLongitude: '37.467092',
            //         destinationLatitude: '126.923802',
            //         date: context.read<DateProvider>().getDate(),
            //       );
            // },
            ),
      ],
    );
  }
}

Future<void> addBottomModal({
  required BuildContext context,
  required String title,
  required String content,
  required String buttonText,
  required bool needImg,
  required bool needDate,
}) async {
  TextEditingController titleController = TextEditingController();

  titleController.text = title;
  selectedDays = {};
  image = null;

  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, setState) {
        // 화면 높이에 따라 조절
        double screenHeight = MediaQuery.of(context).size.height;
        double bottomSheetHeight = screenHeight * 0.35;

        if (image != null) {
          bottomSheetHeight = screenHeight * 0.8;
        } else if (needDate) {
          bottomSheetHeight = needImg ? screenHeight * 0.7 : screenHeight * 0.4;
        }

        Widget renderEmpty() {
          return Container();
        }

        Widget renderAddImg() {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const GoogleMapsWidget(), // GoogleMapsWidget으로 이동
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 4),
                    SvgPicture.asset('lib/images/gps_icon.svg'),
                    const SizedBox(width: 16),
                    const Text(
                      '위치 등록',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    // const SizedBox(width: 20),
                    // if (destinationPicked == true) // 사용자의 위치가 등록된 경우
                    //   Text(
                    //     '위도: ${routine.destinationLatitude.toStringAsFixed(4)}, 경도: ${routine.destinationLongitude.toStringAsFixed(4)}',
                    //     style: const TextStyle(
                    //       fontSize: 12,
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          image = null;
                        },
                        child: Center(
                          child: GestureDetector(
                            onTap: () {},
                            child: CupertinoAlertDialog(
                              title: const Text(
                                '이미지 등록',
                                style: TextStyle(fontSize: 18),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 10),
                                  CupertinoDialogAction(
                                    child: const Text('갤러리에서 선택'),
                                    onPressed: () async {
                                      try {
                                        final selectedImage =
                                            await picker.pickImage(
                                                source: ImageSource.gallery);
                                        setState(() {
                                          image = selectedImage;
                                        });
                                        Navigator.pop(context);
                                      } catch (e) {
                                        print(
                                            'Error occurred while picking image: $e');
                                      }
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text('카메라 실행'),
                                    onPressed: () async {
                                      try {
                                        final selectedImage =
                                            await picker.pickImage(
                                                source: ImageSource.camera);
                                        setState(() {
                                          image = selectedImage;
                                        });
                                        Navigator.pop(context);
                                      } catch (e) {
                                        print(
                                            'Error occurred while picking image: $e');
                                      }
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text(
                                      '취소',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      image = null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('lib/images/picture_icon.svg'),
                    const SizedBox(width: 12),
                    const Text(
                      '이미지 등록',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return SizedBox(
          height: bottomSheetHeight,
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('lib/images/home_indicator.svg'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: titleController,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    content,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (image != null)
                    Image.file(
                      File(image!.path),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(height: 20),
                  needDate ? (const RenderAddDate()) : renderEmpty(),
                  const SizedBox(height: 5),
                  needImg ? renderAddImg() : renderEmpty(),
                  const SizedBox(height: 30),
                  DefaultButton(
                    onPressed: () async {
                      var publicId =
                          await uploadImage(image, routineId.toString());
                      imgUrl =
                          'https://res.cloudinary.com/$cloudName/image/upload/$publicId.jpg';
                      dayList = selectedDays.toList();
                      routineContent = titleController.text;
                      setState(() {
                        selectedDays = {};
                        selectedDate = DateTime.now();
                        selectedTime = DateTime.now();
                        timePicked = false;
                        image = null;
                      });

                      Navigator.pop(context);
                      print(imgUrl);
                    },
                    buttonText: buttonText,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

class GoogleMapsWidget extends StatefulWidget {
  const GoogleMapsWidget({super.key});

  @override
  _GoogleMapsWidgetState createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
  late GoogleMapController mapController;
  LatLng? currentLocation;
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
      ),
      body: (currentLocation != null)
          ? GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: currentLocation!,
                zoom: 16.0,
              ),
              onTap: _onMapTap,
              markers: Set.of((selectedLocation != null)
                  ? [
                      Marker(
                        markerId: const MarkerId('selected-location'),
                        position: selectedLocation!,
                      ),
                    ]
                  : []),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectedLocation != null) {
            print(
                '선택된 위치: 위도 ${selectedLocation!.latitude}, 경도 ${selectedLocation!.longitude}');
            setState(() {
              destinationLatitude = selectedLocation!.latitude.toString();
              destinationLongitude = selectedLocation!.longitude.toString();
              destinationPicked = true;
            });
            Navigator.pop(context);
          } else {
            print('위치를 먼저 선택해주세요.');
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      selectedLocation = latLng;
    });
  }

  void _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          print('Location permission denied.');
          currentLocation = const LatLng(37.545605, 126.963605);
        });
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting current location: $e');
      setState(() {
        currentLocation = const LatLng(37.545605, 126.963605); // 명신관으로 기본 위치 설정
      });
    }
  }
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
                startRepeatDate =
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
                      time =
                          '${selectedTime?.hour.toString().padLeft(2, '0')}:${selectedTime?.minute.toString().padLeft(2, '0')}:${selectedTime?.second.toString().padLeft(2, '0')}';
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
