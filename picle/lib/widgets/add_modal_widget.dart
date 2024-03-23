import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picle/models/routine_model.dart';
import 'package:picle/providers/image_provider.dart';
import 'package:picle/widgets/date_picker.dart';
import 'package:picle/widgets/default_button.dart';
// import 'package:picle/widgets/gps_picker.dart';

const cloudName = 'dqhllkoz8';
final picker = ImagePicker();
Set<String> selectedDays = {};
DateTime selectedDate = DateTime.now();
DateTime? selectedTime;
bool timePicked = false;
String imgUrl = '';
XFile? image;
bool destinationPicked = false;
// routine provider 구조를 잘 모르겠어서 일단 객체로 구현함..
Routine routine = Routine(
  routineIdentifier: 1,
  userId: 111,
  routineId: 1,
  content: '',
  date:
      '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
  time:
      '${selectedTime?.hour.toString().padLeft(2, '0')}:${selectedTime?.minute.toString().padLeft(2, '0')}',
  startRepeatDate: '2024-01-01',
  // repeatDays: ["FRIDAY", "TUESDAY", "WEDNESDAY", "MONDAY", "THURSDAY"],
  destinationLongitude: 126.9595,
  destinationLatitude: 37.549,
  registrationImgUrl: imgUrl,
  isCompleted: false,
  isPreview: false,
);

void addBottomModal({
  required BuildContext context,
  required String title,
  required String content,
  required String buttonText,
  required bool needImg,
  required bool needDate,
}) {
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
                      setState(() {
                        selectedDays = {};
                        selectedDate = DateTime.now();
                        selectedTime = DateTime.now();
                        timePicked = false;
                        image = null;
                      });
                      var publicId = await uploadImage(
                          image, routine.routineId.toString());
                      imgUrl =
                          'https://res.cloudinary.com/$cloudName/image/upload/$publicId.jpg';
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
              routine.destinationLatitude = selectedLocation!.latitude;
              routine.destinationLongitude = selectedLocation!.longitude;
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
