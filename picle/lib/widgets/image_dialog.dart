import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> showImageSourceDialog(BuildContext context) async {
  final picker = ImagePicker();
  XFile? image;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.pop(context);
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
                        Navigator.pop(context);
                        image =
                            await picker.pickImage(source: ImageSource.gallery);
                        Navigator.pop(context, image);
                      } catch (e) {
                        print('Error occurred while picking image: $e');
                      }
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text('카메라 실행'),
                    onPressed: () async {
                      try {
                        Navigator.pop(context);
                        image =
                            await picker.pickImage(source: ImageSource.camera);
                        Navigator.pop(context);
                      } catch (e) {
                        print('Error occurred while picking image: $e');
                      }
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text(
                      '취소',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      Navigator.pop(context, null);
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
  return image;
}
