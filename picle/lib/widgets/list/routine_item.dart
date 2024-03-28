import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picle/providers/date_provider.dart';
import 'package:picle/providers/image_provider.dart';
import 'package:picle/providers/routine_provider.dart';
import 'package:picle/widgets/default_button.dart';
import 'package:picle/widgets/routine_time.dart';
import 'package:provider/provider.dart';

const longitude = '';
const latitude = '';
XFile? image;
final picker = ImagePicker();
const cloudName = 'dqhllkoz8';
LatLng? currentLocation;
String imgUrl = '';
bool disabled = true;

class RoutineItem extends StatefulWidget {
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
  State<RoutineItem> createState() => _RoutineItemState();
}

class _RoutineItemState extends State<RoutineItem> {
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
                      value: widget.isChecked,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.green,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      activeColor: const Color(0xFF54C29B),
                      onChanged: (value) {
                        image = null;
                        imgUrl = '';
                        if (value == true) {
                          showModalBottomSheet(
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (BuildContext context) => StatefulBuilder(
                              builder: (BuildContext context, setState) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        SvgPicture.asset(
                                            'lib/images/home_indicator.svg'),
                                        const SizedBox(height: 15),
                                        Text(
                                          widget.content,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 25,
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
                                        GestureDetector(
                                          onTap: () async {
                                            try {
                                              LocationPermission permission =
                                                  await Geolocator
                                                      .requestPermission();
                                              if (permission ==
                                                  LocationPermission.denied) {
                                                setState(() {
                                                  print(
                                                      'Location permission denied.');
                                                  currentLocation =
                                                      const LatLng(-37.545605,
                                                          -126.963605);
                                                });
                                              }
                                              Position position =
                                                  await Geolocator
                                                      .getCurrentPosition(
                                                          desiredAccuracy:
                                                              LocationAccuracy
                                                                  .high);
                                              setState(() {
                                                currentLocation = LatLng(
                                                    position.latitude,
                                                    position.longitude);
                                              });
                                            } catch (e) {
                                              print(
                                                  'Error getting current location: $e');
                                              setState(() {
                                                currentLocation = const LatLng(
                                                    -37.545605,
                                                    -126.963605); // 명신관으로 기본 위치 설정
                                              });
                                            }
                                            showDialog(
                                              context: context,
                                              barrierDismissible:
                                                  true, // 뒷배경을 터치하여 다이얼로그를 닫을 수 있도록 설정
                                              builder: (BuildContext context) {
                                                return CupertinoAlertDialog(
                                                  title: const Text(
                                                    '이미지 등록',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const SizedBox(
                                                          height: 10),
                                                      CupertinoDialogAction(
                                                        child: const Text(
                                                            '카메라 실행'),
                                                        onPressed: () async {
                                                          try {
                                                            final selectedImage =
                                                                await picker
                                                                    .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .camera,
                                                            );
                                                            setState(() {
                                                              image =
                                                                  selectedImage;
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                            // var publicId =
                                                            //     await uploadImage(
                                                            //   image,
                                                            //   widget.routineId
                                                            //       .toString(),
                                                            // );
                                                            // imgUrl =
                                                            //     'https://res.cloudinary.com/$cloudName/image/upload/$publicId.jpg';
                                                            print(
                                                                '카메라: $imgUrl');
                                                          } catch (e) {
                                                            print(
                                                                'Error occurred while picking image: $e');
                                                          }
                                                        },
                                                      ),
                                                      CupertinoDialogAction(
                                                        child: const Text(
                                                          '취소',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                  'lib/images/picture_icon.svg'),
                                              const SizedBox(width: 12),
                                              const Text(
                                                '이미지 등록',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              if (image != null)
                                                const Icon(
                                                  Icons.check,
                                                  color: Color(0xFF54C29B),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            const SizedBox(height: 20),
                                            DefaultButton(
                                              onPressed: () async {
                                                var publicId =
                                                    await uploadImage(
                                                  image,
                                                  widget.routineId.toString(),
                                                );

                                                if (image != null) {
                                                  imgUrl =
                                                      'https://res.cloudinary.com/$cloudName/image/upload/$publicId.jpg';
                                                }
                                                print("루틴 인증:  $imgUrl");
                                                await provider.verifyRoutine(
                                                  userId: widget.userId,
                                                  routineId: widget.routineId,
                                                  imgUrl: imgUrl,
                                                  longitude:
                                                      currentLocation != null
                                                          ? currentLocation!
                                                              .longitude
                                                          : '',
                                                  latitude:
                                                      currentLocation != null
                                                          ? currentLocation!
                                                              .latitude
                                                          : '',
                                                  date: date,
                                                );
                                                Navigator.pop(context);
                                              },
                                              buttonText: '루틴 인증하기',
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
                          ).then((_) {
                            image = null;
                            imgUrl = '';
                            currentLocation = null;
                          });
                        } else {
                          // 체크 해제 시 isChecked 업데이트
                        }
                      }),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.content,
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
                  onPressed: () async => showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context,
                    builder: (BuildContext context2) => StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                        await provider.deleteRoutine(
                                          userId: widget.userId,
                                          routineId: widget.routineId,
                                          date: date,
                                        );
                                        Navigator.pop(context2);
                                      },
                                      buttonText: '삭제하기',
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
                  icon: const Icon(Icons.more_horiz),
                ),
              )
            ],
          ),
          if (widget.time != null) RoutineTime(time: widget.time!)
        ]);
      },
    );
  }
}
